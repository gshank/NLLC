package NLLC::Controller::Admin::Activity;

use strict;
use warnings;
use base 'NLLC::Controller::Admin::Base';

=head1 NAME

NLLC::Controller::Admin::Activity - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index : Path('') Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched NLLC::Controller::Activity in Activity.');
}

sub edit : Local
{
    my ( $self, $c, $id) = @_;

    $c->stash->{template} = 'admin/activity/proposal.tt';
    my $validated = $c->update_from_form($id, 'Activity');
    return if !$validated;

    # form validated. Display...
    $c->flash->{message} = 'Activity saved';
    $c->res->redirect( $c->uri_for('list'));
}

sub list : Local
{
    my ( $self, $c ) = @_;

    $c->stash->{activities} = $c->model('DB::Activity')->search(
       {session_id => $c->stash->{new_session}}, 
       {order_by => 'activity_id'});
    $c->stash->{template} = 'admin/activity/list.tt';
}

sub delete : Local
{
   my ( $self, $c, $activity_id ) = @_;
   my $activity = $c->model('DB::Activity')->find($activity_id);
   $activity->delete if $activity;
   $c->res->redirect( $c->uri_for('list') );
   $c->detach;
}

sub view : Local
{
    my ( $self, $c ) = @_;
    my $activities = $c->model('DB::Activity')->search(
       {session_id => $c->stash->{new_session}}, 
       {order_by => 'name'});
    $c->stash( activities => $activities,
               javascript => 'layouts/enroll_js.tt',
               template => 'admin/activity/view.tt' );
}

=head1 AUTHOR

Gerda Shank

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
