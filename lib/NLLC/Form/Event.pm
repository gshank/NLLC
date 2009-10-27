package NLLC::Form::Event;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

use ICal::RRule;
use ICal::Event;
use DateTime::Duration;
use DateTime::Format::Strptime;

has '+item_class' => ( default => 'Event' );
has '+field_name_space' => ( default => 'NLLC::Form::Field' );

has_field 'summary';
has_field 'location';
has_field 'category' => ( type  => 'Select' );
has_field 'calendar' => ( type  => 'Select' );
has_field 'dtstart_mdy' => (
               type => '+DateMDY',
               noupdate => 1,
               required => 1,
            );
has_field 'dtstart_time' => (
               type => '+Time',
               noupdate => 1,
               );
has_field 'dtstart_allday' => (
               type => 'Checkbox',
               noupdate => 1,
               );
has_field 'dtstart' => ( type =>  '+DateTime' );
has_field 'duration' => ( type  => '+Duration' );
#has_field 'duration' => ( type => 'Duration' );
#has_field 'duration.hours' => ( type => 'Integer', range_start => 0, range_end => 8 );
#has_field 'duration.minutes' => ( type => 'Integer', range_start => 0, range_end => 69 ); 
has_field 'until_mdy' => (
               type => '+DateMDY', 
               noupdate => 1,
               );
has_field 'freq' => ( type  => 'Select' );
has_field 'count' => ( type => 'Integer' );
has_field 'description';

sub options_category
{
    return [
        "Academic" => "Academic",
        "Play" => "Play",
        "Field trip" => "Field trip",
        "Social" => "Social",
        "Meeting" => "Meeting",
        "Board meeting" => "Board meeting",
        "Committee" => "Committee",
    ];
}

sub options_calendar
{
    return [
        "Activities" => "Activities",
        "Schedule" => "Schedule",
        "Admin" => "Admin",
    ];
}

sub options_freq
{
    return [
        "" => "Does not repeat",
        "daily" => "Daily",
        "weekly" => "Weekly",
        "biweekly" => "Bi-weekly",
#        "monthly" => "Monthly",
#        "yearly" => "Yearly",
    ]; 
} 

sub validate
{
   my $self = shift;
   if ($self->field('count')->value && $self->field('until_mdy')->value)
   {
      $self->field('until_mdy')->add_error('Do not enter both a count and an un\'until\' date');
   }
   if ( $self->field('dtstart_allday')->value &&
        $self->field('dtstart_time')->value)
   {
      $self->field('dtstart_allday')->add_error(
         'Do not enter a time if you have selected \'all day\'');
   }
   if ( !$self->field('dtstart_allday')->value &&
        !$self->field('dtstart_time')->value)
   {
      $self->field('dtstart_time')->add_error('Start time is required');
   } 
   if ( $self->field('freq')->value && 
        !($self->field('count')->value || $self->field('until_mdy')->value  )) 
   {
      $self->field('count')->add_error(
         'For repeating events you must enter either a count or an \'until\' date');
   }
   return;
}

sub update_model
{
   my ( $self ) = @_;
   $self->SUPER::update_model(@_);

   my $event = $self->{item};

   # create dtstart DateTime out of dtstart_mdy and dtstart_time
   my $allday = $self->field('dtstart_allday')->value;
   my $dt;
   if ($allday)
   {
      my $dt_string = $self->field('dtstart_mdy')->value;
      my $strp = DateTime::Format::Strptime->new( pattern => "%m/%d/%Y");
      $dt =  $strp->parse_datetime( $dt_string ); 
   }
   else # not all day event
   {
      my $dt_string = $self->field('dtstart_mdy')->value;
      $dt_string .= ' ' . $self->field('dtstart_time')->value 
            unless $self->field('dtstart_allday')->value;
      my $strp = DateTime::Format::Strptime->new( pattern => "%m/%d/%Y %I:%M %p");
      $dt =  $strp->parse_datetime( $dt_string ); 
   }

   $event->dtstart( $dt );
   $event->update({weekday => $dt->day_of_week,
                      month   => $dt->month,
                      day     => $dt->day,
                      year    => $dt->year,
                      hour    => $dt->strftime("%H%M")});
  
   # create duration from duration string for event
   my $dt_duration = $event->duration;
   my $duration;
   if ($dt_duration)
   {
      $dt_duration =~ s/\:/\,/g;
      my %duration_hash = split(',', $dt_duration);
      $duration = DateTime::Duration->new(%duration_hash);
   }
   if ( $self->field('until_mdy')->value && $dt_duration )
   {
      my $until;
      if( $dt_duration)
      {
         # create until DateTime out of until_mdy and duration 
         $until = DateTime::Format::Strptime->new( pattern => "%m/%d/%Y %I:%M %p" )->
           parse_datetime( 
              $self->field('until_mdy')->value . " " . 
              $self->field('dtstart_time')->value ); 
         $until->add_duration($duration);
      }
      else # all day event
      {
         $until = DateTime::Format::Strptime->new( pattern => "%m/%d/%Y" )->
           parse_datetime( $self->field('until_mdy')->value );
      }
      $event->until($until);
   }
   # create repeat rule (rrule) for event
   my $freq = $event->freq;
   my $rrule;
   if ($freq)
   {
      my $interval = 1;
      if ( $freq eq 'biweekly' )
      {
         $freq = 'weekly';
         $interval = 2;
      }
      $rrule = ICal::RRule->new(freq => $freq, 
                                count => $event->count,
                                until => $event->until,
                                interval => $interval,
                                dtstart => $event->dtstart);
   }

   # create event
   my $ical_event = ICal::Event->new(
       dtstart => $event->dtstart,
       duration => $duration,
       rrule => $rrule,
       summary => $event->summary, 
       description => $event->description, 
       location => $event->location, 
   );
   
   # put event & english strings into db
   $event->update({ical => $ical_event->as_string, as_string => $ical_event->as_english});

}


1;
