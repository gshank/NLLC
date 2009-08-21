package NLLC::Controller::Member;

use strict;
use warnings;
use base 'NLLC::Controller::Member::Base';

=head1 NAME

NLLC::Controller::Member - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut


sub index : Path("") Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{template} = 'member/index.tt';
    my $family = $c->model('DB::Family')->find($c->user->id);
    $c->stash->{family} = $family;
    my $current_activities = $c->model('DB::Activity')->search({session_id => $c->stash->{new_session}, family_id => $c->user->id});
    $c->stash(current_activities => $current_activities);
    my $current_contributions = $c->model('DB::Contribution')->search({session_id => $c->stash->{new_session}, family_id => $c->user->id});
    $c->stash(current_contributions => $current_contributions);

}

sub view_activity : Local
{
    my ( $self, $c, $activity_id ) = @_;
    my $activity = $c->model('DB::Activity')->find($activity_id);
    $c->stash->{activity} = $activity;
    $c->stash->{template} = 'member/view_activity.tt';
}

sub proposal : Local
{
    my ( $self, $c, $id) = @_;
 
   if ($id)
   {
      my $proposal = $c->model('DB::Activity')->find( $id);
      unless( $proposal && $proposal->family_id eq $c->user->id )
      {
          $c->flash->{message} = "Not a valid proposal";
          $c->res->redirect($c->uri_for(''));  
          $c->detach;
      }
   }
    $c->stash->{template} = 'member/proposal.tt';
    my $validated = $c->update_from_form($id, 'Activity');
    return if !$validated;

    # form validated. Display...
    $c->flash->{message} = 'Proposal saved';
    $c->res->redirect( $c->uri_for(''));
    $c->detach;
}

sub old_activities : Local
{
   my ( $self, $c) = @_;
} 

sub delete_proposal : Local
{
   my ( $self, $c, $id ) = @_;
   my $proposal = $c->model('DB::Activity')->find($id);
   unless( $proposal && $proposal->family_id eq $c->user->id )
   {
       $c->flash->{message} = "Not a valid propossal";
       $c->res->redirect($c->uri_for(''));  
       $c->detach;
   }
   $proposal->delete;
   $c->flash->{message} = "Proposal deleted";
   $c->res->redirect($c->uri_for(''));  
   $c->detach;
}

sub view : Local {
   my ( $self, $c ) = @_;
   my $family = $c->model('DB::Family')->find($c->user->id);
   $c->stash->{family} = $family;
}

sub edit : Local
{
    my ( $self, $c ) = @_;
    
    my $family = $c->model('DB::Family')->find($c->user->id);
    $c->stash->{family} = $family;
    $c->stash->{template} = 'member/edit.tt';
    my $validated = $c->update_from_form($family, 'Family');
    return if !$validated;

    # form validated. Display...
    $c->flash->{message} = 'Member information saved';
    $c->res->redirect( $c->uri_for('view'));
}

sub edit_child : Local
{
   my ( $self, $c, $child_id ) = @_;

   my $family = $c->model('DB::Family')->find($c->user->id);
   my $child = $c->model('DB::Child')->find($child_id);
   unless ($child && $child->family_id == $family->family_id)
   {
      $c->flash->{message} = 'Incorrect child';
      $c->res->redirect('');
      $c->detach;
   }
   $c->stash->{template} = 'member/edit_child.tt';
   my $validated = $c->update_from_form($child, 'Child');
   return if !$validated;

   # form validated
   $c->flash->{message} = "Child saved";
   $c->res->redirect($c->uri_for('view')); 
   $c->detach;
}

sub add_child : Local
{
    my ( $self, $c ) = @_;

    my $family_id = $c->user->id; 
    my $family = $c->model('DB::Family')->find($family_id);
    
    $c->stash->{family_id} = $family_id;
    $c->stash->{template} = 'member/add_child.tt';
    my $validated = $c->update_from_form(undef, 'Child');
    return if !$validated;

    my $child = $c->stash->{form}->{item};
    $child->update({family_id => $family_id});
    # form validated
    $c->flash->{message} = "Child added";
    $c->res->redirect($c->uri_for('view')); 
    $c->detach;
}

sub list : Local
{
   my ( $self, $c ) = @_;
   my $families = $c->model('DB::Family')->search({active => 1},
       {'order_by' => 'last_name1'});
   $c->stash->{families} = $families;

}

sub contribution : Local
{
   my ( $self, $c, $contribution_id ) = @_;

   my $contribution;
   if ($contribution_id)
   {
      $contribution = $c->model('DB::Contribution')->find({id => $contribution_id});
      unless( $contribution && $contribution->family_id eq $c->user->id )
      {
          $c->flash->{message} = "Not a valid contribution";
          $c->res->redirect($c->uri_for(''));  
          $c->detach;
      }
   }
   $c->stash( template => 'member/contribution.tt' );
   $c->stash( family_id => $c->user->id );
   my $validated = $c->update_from_form($contribution, 'Contribution'); 
   return if !$validated;
   # form validated
   $c->flash->{message} = "Contribution saved";
   $c->res->redirect($c->uri_for('')); 
   $c->detach;
}

sub delete_contribution : Local
{
   my ( $self, $c, $contribution_id ) = @_;
   my $contribution = $c->model('DB::Contribution')->find($contribution_id);
   unless( $contribution && $contribution->family_id eq $c->user->id )
   {
       $c->flash->{message} = "Not a valid contribution";
       $c->res->redirect($c->uri_for(''));  
       $c->detach;
   }
   $contribution->delete;
   $c->flash->{message} = "Contribution deleted";
   $c->res->redirect($c->uri_for(''));  
   $c->detach;

}

sub my_calendar : Local
{
   my ( $self, $c, $family_id ) = @_;

   # Get current session activities 
   my $curr_child_activities = $c->model('DB::Child')->
      search( {"me.family_id" => $c->user->id})->
      search_related('child_activities', 
          {"child_activities.session_id" => $c->stash->{session},
           "child_activities.enrolled" => 1 });
   unless ($curr_child_activities->count > 0)
   {
      $c->stash->{message} = "Calendar only available after enrolling in activities";
      $c->res->redirect('enroll');
      $c->detach;
   }
   my $events = $curr_child_activities->search_related('activity')->
      search_related('events', {}, { distinct => 1});

   my $username = $c->user->username;
   my $session = $c->model('DB::Session')->find($c->stash->{session});
   my $ical_name = $username . "_" . $session->year . "_" . $session->season;
   my $ical = ICal::Calendar->new;
   $ical->name($ical_name);
   if ( $events->count > 0 ) # create activity calendar
   {
      while (my $event = $events->next)
      {
         $ical->add_events($event->ical) if $event->ical;
      }
   }

   my $calendar_string = $ical->as_string;
   my $cal_dir = "/home/gshank/nllchs.org/icalendar/calendars/$username";
   unless ( -e $cal_dir ) 
   {
      mkdir($cal_dir);
   }
   my $filename = "$cal_dir/$ical_name.ics";
   open my $fh, '>', $filename or die "Unable to open $filename: $!";
   print {$fh} $calendar_string;
   close $fh;
  # Assuming that John and Mary have successfully published their 
  # calendars, they can access them via the URLs: 
  # http://example.com/phpicalendar?cpath=John and 
  # http://example.com/phpicalendar?cpath=Mary respectively. 
   $c->res->redirect( $c->uri_for('/icalendar', 'index.php', 
         {cpath => $username, "cal\[\]" => $ical_name})); 
   $c->detach;

}

sub planning : Local
{
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'member/planning.tt';
}

sub timeline : Local
{
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'member/timeline.tt';
}

sub paid_instructor : Local
{
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'member/paid_instructor.tt';
}

sub leaders : Local
{
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'member/leaders.tt';
}

sub contacts : Local
{
   my ( $self, $c ) = @_;
   $c->stash( template => 'member/contacts.tt' );

}

=head1 AUTHOR

Gerda Shank

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
