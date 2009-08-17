package NLLC::Controller::Admin::Family;

use strict;
use warnings;
use base 'NLLC::Controller::Admin::Base';

=head1 NAME

NLLC::Controller::Family - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut


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

    $c->stash->{template} = 'admin/family/edit.tt';
    my $validated = $c->update_from_form($family_id, 'Family');
    return if !$validated;

    # form validated. Display...
    $c->flash->{message} = 'Family saved';
    $c->res->redirect( $c->uri_for('view', $family_id));
}

sub add : Local
{
    my ( $self, $c ) = @_;

    $c->stash->{template} = 'admin/family/add.tt';
    my $validated = $c->update_from_form(undef, 'Family');
    return if !$validated;

    # form validated. Display...
    my $family_id = $c->stash->{form}{item}->family_id;
    $c->flash->{message} = 'Family saved';
    $c->res->redirect( $c->uri_for('view', $family_id));
}
sub edit_child : Local
{
    my ( $self, $c, $child_id ) = @_;

    $c->stash->{template} = 'admin/family/edit_child.tt';
    my $validated = $c->update_from_form($child_id, 'Child');
    return if !$validated;

    my $child = $c->stash->{form}->{item};
    # form validated
    $c->flash->{message} = "Child saved";
    $c->res->redirect($c->uri_for('view', $child->family_id)); 
    $c->detach;
}

sub add_child : Local
{
    my ( $self, $c, $family_id ) = @_;
    
    my $family = $c->model('DB::Family')->find($family_id);
    
    $c->stash->{family_id} = $family_id;
    $c->stash->{template} = 'admin/family/add_child.tt';
    my $validated = $c->update_from_form(undef, 'Child');
    return if !$validated;

    my $child = $c->stash->{form}->{item};
    $child->update({family_id => $family_id});
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
