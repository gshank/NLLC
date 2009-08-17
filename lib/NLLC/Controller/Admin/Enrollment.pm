package NLLC::Controller::Admin::Enrollment;
use strict;
use warnings;
use base 'NLLC::Controller::Admin::Base';

sub auto : Private
{
   my ( $self, $c ) = @_;

   if ( $c->stash->{enrollment} eq 'open' &&
        !$c->check_user_roles('enrollment') )
   {
      $c->flash->{message} = 'Not authorized';
      $c->res->redirect( $c->uri_for('/admin') );
      $c->detach;
      return 0;
   }
   return 1;
}

sub index : Path Args
{
  my ( $self, $c ) = @_;

  $c->stash->{template} = 'admin/enrollment/index.tt';
}

sub list : Local
{
    my ( $self, $c ) = @_;

    my $session = $c->stash->{new_session};
    my $activities = $c->model('DB::Event')->search(
        {"me.session_id" => $session,
         "me.activity_id" => { '!=', undef} },
        { order_by => ['weekday', 'hour'] })->
        search_related('activity', {}, { distinct => 1, prefetch => 'activity_children'});
    $c->stash->{activities} = $activities;
    # make hash of children names and number of activities
    # to avoid lots of db queries
    my $db_children = $c->model('DB::ChildActivity')->search(
       { "session_id" => $session })->search_related( 'child',
       {}, { distinct => 1 });
    my %children;
    while (my $child = $db_children->next)
    {
       $children{$child->child_id}{name} = $child->firstname . " " . $child->lastname;
       $children{$child->child_id}{birthday} = $child->birthday;
       $children{$child->child_id}{num_activities} = $child->search_related('child_activities', {session_id => $session})->count;
    }
    $c->stash->{children} = \%children;

#    $c->stash->{javascript} = 'enroll_list.js';
    $c->stash->{template} = 'admin/enrollment/list.tt';
}

sub waitlist : Local
{
    my ( $self, $c, $activity_id, $child_id ) = @_;
    
    $c->model('DB::ChildActivity')->find({activity_id => $activity_id,
             child_id => $child_id}, { key => 'primary'})->update({enrolled => 2});
    $c->res->redirect($c->uri_for('list'));
    $c->detach;
}

sub waitlist_js : Local
{
    my ( $self, $c, $activity_id, $child_id ) = @_;
    
    $c->model('DB::ChildActivity')->find({activity_id => $activity_id,
             child_id => $child_id}, { key => 'primary'})->update({enrolled => 2});
}

sub enroll : Local
{
    my ( $self, $c, $activity_id, $child_id ) = @_;
    
    $c->model('DB::ChildActivity')->find({activity_id => $activity_id,
             child_id => $child_id}, { key => 'primary'})->update({enrolled => 1});
    $c->res->redirect($c->uri_for('list'));
    $c->detach;
}

sub enroll_js : Local
{
    my ( $self, $c, $activity_id, $child_id ) = @_;
    
    $c->model('DB::ChildActivity')->find({activity_id => $activity_id,
             child_id => $child_id}, { key => 'primary'})->update({enrolled => 1});
    return 1; 
}

sub remove : Local
{
    my ( $self, $c, $activity_id, $child_id ) = @_;
    
    my $child_activity = $c->model('DB::ChildActivity')->find(
         {activity_id => $activity_id,
          child_id => $child_id}, { key => 'primary'});
    $child_activity->delete;
    
    $c->flash->{message} = "Child removed from activity";
    $c->res->redirect($c->uri_for('list'));
    $c->detach;

}

sub remove_js : Local
{
    my ( $self, $c, $activity_id, $child_id ) = @_;
    
    my $child_activity = $c->model('DB::ChildActivity')->find(
         {activity_id => $activity_id,
          child_id => $child_id}, { key => 'primary'});
    $child_activity->delete;
}

sub family_enroll_list : Local
{
   my ( $self, $c ) = @_;

   my $families = $c->model('DB::Family')->search({active => 1}, {order_by => ['last_name1']});
   $c->stash->{families} = $families;
   $c->stash->{template} = 'admin/enrollment/family_enroll_list.tt';

}
1;
