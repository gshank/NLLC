package NLLC::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

NLLC::Controller::Root - Root Controller for NLLC

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 default

=cut

sub auto : Private
{ 
   my ( $self, $c ) = @_;

   $c->log_user_req($c);
   return 1;
}

sub default : Path
{
   my ( $self, $c ) = @_;
   $c->res->status(404);
   $c->stash->{template} = '404.tt';
}

sub index : Local {
    my ( $self, $c ) = @_;

	$c->stash->{template} = 'index.tt';
}

=po

sub icalendar : Local
{
   my ( $self, $c ) = @_;
   $c->res->redirect($c->uri_for('/icalendar/index.php'));
   $c->detach;
}

=cut

sub events : Local {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'events.tt';
}

sub about : Local
{
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'about.tt';
}

sub contact : Local
{
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'contact.tt';
}

sub membership : Local
{
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'membership.tt';
}

sub policies : Local
{
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'policies.tt';
}

sub calendar : Local
{
    my ( $self, $c ) = @_;
    $c->stash->{nowrapper} = 1;
    $c->stash->{template} = 'calendar.tt';
}

sub program_list : Local
{
    my ( $self, $c, $session_id ) = @_;
    $session_id = $c->model('DB::State')->search({name => 'current_session'})->first->value unless $session_id; 
    my $activities = $c->model('DB::Activity')->search({session_id => $session_id}); 
    my $session_label = $c->model('DB::Session')->find($session_id)->label;
    
    $c->stash->{activities} = $activities;
    $c->stash->{session_label} = $session_label;
}

=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Gerda Shank

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
