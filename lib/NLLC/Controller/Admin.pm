package NLLC::Controller::Admin;

use Moose;
BEGIN { extends 'NLLC::Controller::Admin::Base'; }

=head1 NAME

NLLC::Controller::Admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

use NLLC::Form::Contribution;
has 'form' => ( is => 'ro', isa => 'NLLC::Form::Contribution', lazy => 1,
    default => sub { NLLC::Form::Contribution->new } );

sub index : Path('') Args(0) 
{
   my ( $self, $c ) = @_;

   $c->stash->{template} = 'admin/index.tt'; 
}

sub control : Local 
{
   my ( $self, $c ) = @_;
   # The proposals, registration, and session variables are set in the base class
}

sub update_session : Local
{
   my ( $self, $c ) = @_;

   my $current_session = $c->model('DB::State')->find(1);
   $current_session->update({value => $current_session->value + 1});
   if ($current_session->value > $c->stash->{new_session})
   {
      $c->model('DB::State')->find(4)->update({value => $current_session->value});
   }
   $c->model('DB::Activity')->search({current => 1})->update({current => undef});
   $c->flash(message => 'Current session changed');
   $c->res->redirect('control');
   $c->detach;
}

sub update_next_session : Local
{
   my ( $self, $c ) = @_;

   my $next_session = $c->model('DB::State')->find(4);
   $next_session->update({value => $next_session->value + 1});
   $c->flash(message => 'Next session changed');
   $c->res->redirect('control');
   $c->detach;
}

sub open_proposals : Local
{
   my ( $self, $c ) = @_;
   $c->model('DB::State')->find(2)->update({value => 'open'});
   $c->flash(message => 'Proposals open for submission');
   $c->res->redirect('control');
   $c->detach;
}

sub close_proposals : Local
{
   my ( $self, $c ) = @_;
   $c->model('DB::State')->find(2)->update({value => 'closed'});
   $c->flash(message => 'Proposals closed for submission');
   $c->res->redirect('control');
   $c->detach;
}

sub open_enrollment : Local
{
   my ( $self, $c ) = @_;
   $c->model('DB::State')->find(3)->update({value => 'open'});
   $c->flash(message => 'Enrollment opened');
   $c->res->redirect('control');
   $c->detach;
}

sub close_enrollment : Local
{
   my ( $self, $c ) = @_;
   $c->model('DB::State')->find(3)->update({value => 'closed'});
   $c->model('DB::Cart')->delete;
   $c->flash(message => 'Enrollment closed');
   $c->res->redirect('control');
   $c->detach;
}

sub contributions : Local
{
   my ( $self, $c ) = @_;

   my $contrib_sessions = $c->model('DB::Contribution')->search({},
       { select => ['session_id'], distinct => 1 }); 
}

sub contribution_list : Local
{
   my ( $self, $c, $session_id ) = @_;

   $session_id ||= $c->stash->{new_session};
   $c->stash( this_session => $c->model('DB::Session')->find($session_id) );
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

   # families providing an alternate contribution
   my @families_wc = $c->model('DB::Contribution')->
      search({'me.session_id' => $session_id})->
      search_related('family', undef, 
                     {distinct => ['family_id'],
                      order_by => 'last_name1'})->all;
   foreach (@families_wc)
   {
      delete $families_wo{$_->family_id} if $_->family_id;
   }
   # families providing an activity
   my @families_wa = $c->model('DB::Activity')->
      search({'me.session_id' => $session_id})->
      search_related('family', undef, 
                     {distinct => ['family_id'],
                      order_by => 'last_name1'})->all;
             
   foreach (@families_wa)
   {
      delete $families_wo{$_->family_id} if $_->family_id;
   }
   # turn hash of families_wo into a sorted array
   my @families_wo = sort { $a->{last_name1} cmp $b->{last_name1} } values %families_wo;
   $c->stash->{families_wo} = \@families_wo; 
   $c->stash->{families_wa} = \@families_wa;
   $c->stash->{families_wc} = \@families_wc;

}

sub contribution : Local
{
   my ( $self, $c, $family_id, $contribution_id ) = @_;

   my $contribution;
   if ($contribution_id)
   {
      $contribution = $c->model('DB::Contribution')->find({id => $contribution_id});
   }
   $c->stash->{family} = $c->model('DB::Family')->find($family_id);
   $self->form->process( item => $contribution );
   $c->stash( template => 'admin/contribution.tt', family_id => $family_id,
              form => $self->form, fillinform => $self->form->fif );
   return unless $self->form->validated;
   # form validated
   $c->flash->{message} = "Contribution saved";
   $c->res->redirect($c->uri_for('contributions')); 
   $c->detach;

}

=head1 AUTHOR

Gerda Shank

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
