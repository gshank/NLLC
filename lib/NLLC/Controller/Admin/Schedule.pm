package NLLC::Controller::Admin::Schedule;
use Moose;
BEGIN { extends 'NLLC::Controller::Admin::Base'; }
use NLLC::Form::Event;
use Data::ICal;
use ICal::Event;
use ICal::Calendar;

use Text::vFile::asData;

sub index : Path Args(0)
{
    my ( $self, $c ) = @_;

    $c->stash->{template} = 'admin/schedule/index.tt';
}


sub event_list : Local
{
   my ( $self, $c ) = @_;

    $c->stash->{events} = $c->model('DB::Event')->search(
       {session_id => [$c->stash->{new_session}, $c->stash->{session}],
        activity_id => { '=', undef}},
       { order_by => ['dtstart'] });
    $c->stash->{template} = 'admin/schedule/list.tt';
}


sub activity_list : Local
{
   my ( $self, $c, $session ) = @_;

   $session ||= $c->stash->{new_session};
   my $activities = $c->model('DB::Activity')->search({session_id => $session});
   $c->stash( activities => $activities );
   $c->stash( template => 'admin/schedule/activity_list.tt' );

}


sub event : Local 
{
   my ( $self, $c, $event_id, $activity_id ) = @_;

   my $event;
   if( $event_id ne 'new' ) {
       $event = $c->model('DB')->resultset('Event')->find($event_id);
   }
   my $activity = $c->model('DB::Activity')->find($activity_id) if $activity_id;
   my $form_args = { item => $event, 
                     schema => $c->model('DB')->schema,
                     params => $c->req->params,
                     activity => $activity,
                     session_id => $c->stash->{new_session},
   };
   $form_args->{init_object} = { summary => $activity->name,
       description => $c->uri_for('/member', 'view_activity', $activity->activity_id ) }
       if( !$event && $activity );
   my $form = NLLC::Form::Event->new;
   $form->process( %$form_args );
   $c->stash( activity => $activity, 
              javascripts => ['event.js', 'jquery-ui.js'],
              css => 'jquery-ui.css',
              template => 'admin/schedule/event.tt',
              form => $form );
   return unless $form->validated;

   if ( $activity ) 
   { 
      $c->res->redirect($c->uri_for('activity_list', $activity->session_id));
      $c->detach;
   }
   else 
   { 
      $c->res->redirect($c->uri_for('event_list'));
      $c->detach; 
   }
}

sub delete_event : Local
{
   my ( $self, $c, $event_id, $activity_id ) = @_;

   my $event = $c->model('DB::Event')->find($event_id);
   $event->delete;
   if ($activity_id)
      { $c->res->redirect($c->uri_for('activity_list')); }
   else
      { $c->res->redirect($c->uri_for('event_list')); }
   $c->detach;
}

sub update_calendars : Local
{
   my ( $self, $c ) = @_;

   # Get current session activities 
   my $session = $c->stash->{session};
   my $new_session = $c->stash->{new_session};
   $self->create_activity_calendar($c, $session);
   $self->create_activity_calendar($c, $new_session)
         if $session != $new_session; 

   my $events = $c->model('DB::Event')->search({calendar => 'Admin'});
   if ( $events->count > 0 ) # create Admin calendar
   {
      my $ical = ICal::Calendar->new;
      $ical->name("NLLC_Admin");
      while (my $event = $events->next)
      {
         $ical->add_events($event->ical);
      }

      my $calendar_string = $ical->as_string;
      my $filename = "/home/gshank/nllchs.org/icalendar/calendars/NLLC_Admin.ics";
      open my $fh, '>', $filename or die "Unable to open $filename: $!";
      print {$fh} $calendar_string;
      close $fh;
   }

   $events = $c->model('DB::Event')->search({calendar => 'Schedule'});
   if ( $events->count > 0 ) # create schedule calendar
   {
      my $ical = ICal::Calendar->new;
      $ical->name("NLLC_Schedule"); 
      while (my $event = $events->next)
      {
         $ical->add_events($event->ical);
      }

      my $calendar_string = $ical->as_string;
      my $filename = "/home/gshank/nllchs.org/icalendar/calendars/NLLC_Schedule.ics";
      open my $fh, '>', $filename or die "Unable to open $filename: $!";
      print {$fh} $calendar_string;
      close $fh;
   }

   $c->flash( message => 'Calendars updated');
   $c->res->redirect($c->uri_for(''));
   $c->detach;
}

sub create_activity_calendar
{
   my ( $self, $c, $session_id ) = @_;

   my $session = $c->model('DB::Session')->find($session_id);

   my $events = $c->model('DB::Event')->search(
       {session_id => $session_id, 
        activity_id => {'!=', undef}});
   return unless $events->count > 0;

   my $ical_name = "NLLC_" . $session->year . "_" . $session->season;
   my $ical = ICal::Calendar->new;
   $ical->name($ical_name);
   while (my $event = $events->next)
   {
      $ical->add_events($event->ical);
   }

   my $calendar_string = $ical->as_string;
   my $filename = "/home/gshank/nllchs.org/icalendar/calendars/$ical_name.ics";
   open my $fh, '>', $filename or die "Unable to open $filename: $!";
   print {$fh} $calendar_string;
   close $fh;

}

1;
