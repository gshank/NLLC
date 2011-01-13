package NLLC::Controller::Admin::Family;

BEGIN {
   use Moose;
   extends 'NLLC::Controller::Admin::Base';
}
use NLLC::Form::Family;
use NLLC::Form::Child;
use Data::Dumper;

=head1 NAME

NLLC::Controller::Family - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

has 'family_form' => ( is => 'ro', isa => 'NLLC::Form::Family', lazy => 1,
  default => sub { NLLC::Form::Family->new } );
has 'child_form' => ( is => 'ro', isa => 'NLLC::Form::Child', lazy => 1,
  default => sub { NLLC::Form::Child->new } );

sub index : Private {
    my ( $self, $c ) = @_;

    $c->response->body('Matched NLLC::Controller::Family in Family.');
}

sub list : Local
{
    my ( $self, $c, $all ) = @_;

    my $families = $c->model('DB::Family')->search({}, {'order_by' => 'last_name1'});;
    unless (defined $all && $all eq 'all')
    {
        $families = $families->search({"me.active" => 1});
    }
    $c->stash->{num_families} = $families->count;
    $c->stash->{num_children} = $families->search_related('children')->count;
    $c->stash->{families} = $families;
    $c->stash->{template} = 'admin/family/list.tt';

}

sub view : Local
{
   my ( $self, $c, $family_id ) = @_;
   my $family = $c->model('DB::Family')->find($family_id);
   $c->stash->{family} = $family;

}

sub edit : Local
{
    my ( $self, $c, $family_id ) = @_;

    $self->family_form->process(item_id => $family_id, schema => $c->model('DB')->schema,
       params => $c->req->params ); 
    $c->stash( template => 'admin/family/edit.tt', form => $self->family_form,
      fillinform => $self->family_form->fif  );
    return unless $self->family_form->validated;

    # form validated. Display...
    $c->flash->{message} = 'Family saved';
    $c->res->redirect( $c->uri_for('view', $family_id));
}

sub add : Local
{
    my ( $self, $c ) = @_;

    $self->family_form->process( schema => $c->model('DB')->schema, item_id => undef,
       params => $c->req->params ); 
    
    $c->stash( template => 'admin/family/add.tt', form => $self->family_form,
       fillinform => $self->family_form->fif );
    if( $self->family_form->validated ) {
       $c->log->warn('family_form validated. params = ' . Dumper($c->req->params) );
    }
    else {
       $c->log->warn('family_form did not validate. params = ' . Dumper($c->req->params) );
       return;
    }

    # form validated. Display...
    my $family_id = $self->family_form->item_id;
    $c->flash->{message} = 'Family saved';
    $c->res->redirect( $c->uri_for('view', $family_id));
}
sub edit_child : Local
{
    my ( $self, $c, $child_id ) = @_;

    $self->child_form->process( item_id => $child_id, schema => $c->model('DB')->schema,
       params => $c->req->params ); 
    $c->stash( template => 'admin/family/edit_child.tt', form => $self->child_form,
       fillinform => $self->child_form->fif );
    return unless $self->child_form->validated;

    my $child = $self->child_form->item;
    # form validated
    $c->flash->{message} = "Child saved";
    $c->res->redirect($c->uri_for('view', $child->family_id)); 
    $c->detach;
}

sub add_child : Local
{
    my ( $self, $c, $family_id ) = @_;
    
    my $family = $c->model('DB::Family')->find($family_id);
    my $child = $c->model('DB::Child')->new_result( { family_id => $family->id } );
    $self->child_form->process( item => $child, 
       params => $c->req->params ); 
    $c->stash( template => 'admin/family/add_child.tt', form => $self->child_form,
      family_id => $family_id, fillinform => $self->child_form->fif );
    return unless $self->child_form->validated;

    # form validated
    $c->flash->{message} = "Child added";
    $c->res->redirect($c->uri_for('view', $family_id)); 
    $c->detach;
}


=head1 AUTHOR

Gerda Shank

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
