package NLLC::Controller::Admin::Payment;

BEGIN {
   use Moose;
   extends 'NLLC::Controller::Admin::Base';
}
use NLLC::Form::Payment;

=head1 NAME

NLLC::Controller::Admin::Payment - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

has 'form' => ( is => 'ro', isa => 'NLLC::Form::Payment', lazy => 1,
   default => sub { NLLC::Form::Payment->new } );

sub auto : Private
{
   my ( $self, $c ) = @_;

   
   unless ( $c->check_user_roles('payment') )
   {
      $c->flash->{message} = 'Not authorized';
      $c->res->redirect( $c->uri_for('/admin') );
      $c->detach;
      return 0;
   }
}

sub index : Path
{
   my ( $self, $c ) = @_;

   $c->stash(template => 'admin/payment/index.tt');
}

sub list : Local
{
   my ( $self, $c, $session_id ) = @_;

   # try: having => \"COUNT(a_b.a_id) = 0"
   my @families = $c->model('DB::Family')->
       search({ active => 1 }, 
              { 'order_by' => 'me.last_name1',
                columns => ['family_id', 'first_name1', 'last_name1',
                            'first_name2', 'last_name2', 'email']
               });
   my %families_wo;
   foreach (@families)
   {
      $families_wo{$_->family_id} = {$_->get_columns};
   }

   # families who have a payment entered for this session 
   my @families_wp = $c->model('DB::Payment')->
      search({'me.session_id' => $session_id})->
      search_related('family', undef, 
                     {distinct => ['family_id'],
                      order_by => 'last_name1'})->all;
   foreach (@families_wp)
   {
      delete $families_wo{$_->family_id} if $_->family_id;
   }

   # turn hash of families_wo into a sorted array
   my @families_wo = sort { $a->{last_name1} cmp $b->{last_name1} } values %families_wo;
   $c->stash( families_wo => \@families_wo, 
              families_wp => \@families_wp,
              this_session_id => $session_id,
              template => 'admin/payment/list.tt');
}

sub edit : Local
{
   my ( $self, $c, $family_id, $session_id, $payment_id ) = @_;

   $c->stash(family_id => $family_id, this_session_id => $session_id);
   $c->stash(family => $c->model('DB::Family')->find($family_id) );

   my $payment;
   $payment = $c->model('DB::Payment')->find($payment_id) if $payment_id;
   
   $self->form->process( item => $payment, params => $c->req->params); 
   $c->stash(template => 'admin/payment/form.tt', form => $self->form,
      fillinform => $self->form );
   return unless $self->form->validated;
   # set session if not already set
   $payment = $self->form->item;
   $payment->update( { session_id => $session_id} ) 
         unless $payment->session_id;

   # form validated
   # removing form from stash because sometimes it seems to be leftover
   delete $c->stash->{form};
   $c->flash->{message} = "Payment saved";
   $c->res->redirect($c->uri_for('list', $session_id)); 
   $c->detach;
}

sub delete : Local
{
   my ( $self, $c, $session_id, $payment_id ) = @_;
   my $payment = $c->model('DB::Payment')->find($payment_id);
   $payment->delete if $payment;
   $c->flash->{message} = "Payment deleted";
   $c->res->redirect($c->uri_for('list', $session_id)); 
   $c->detach;
}

1;
