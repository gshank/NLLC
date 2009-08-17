package ICal::Calendar;

use Moose;
use Moose::Util::TypeConstraints;
use MooseX::AttributeHelpers;


has 'events' => ( 
   metaclass => 'Collection::Array', 
   isa => 'ArrayRef[Str]', 
   is => 'rw',
   default => sub { [] },
#   auto_deref => 1,
   provides => { 'push' => 'add_events'}
   );

has 'name' => ( isa => 'Str', is => 'rw' );

has 'todos' => (isa => 'ArrayRef[Str]', is => 'ro' );

has 'timezone' => ( isa => 'Str', is => 'rw',
       default => \&default_timezone, ); 

has 'prodid' => ( isa => 'Str', is => 'rw' );

has 'version' => ( isa => 'Str', is => 'ro', 
     default => sub { '2.0' } );


sub as_string
{
   my ( $self ) = @_;
   my $string;
   $string .= $self->header; 
   foreach my $event( @{$self->events} )
   {
      $string .= $event;
   }

   $string .= $self->footer;
   return $string;
}


sub header
{
   my ( $self ) = @_;
   my $header = "BEGIN:VCALENDAR\n";
   $header .= "PRODID:-//nllchs.org/ICal_Calendar\n";
   $header .= "VERSION:2.0\n";
   $header .= "CALSCALE:GREGORIAN\n";
   $header .= "X-WR-CALNAME:";
   $header .= $self->name ? $self->name : "NLLC";
   $header .= "\n";
   $header .= "X-WR-TIMEZONE:America/New_York\n";
   $header .= $self->timezone;
   return $header;
}

ICal::Calendar->meta->make_immutable;

sub footer
{
   my $footer = "END:VCALENDAR\n";
   return $footer;
}

sub default_timezone
{
   my $timezone = "BEGIN:VTIMEZONE\n";
   $timezone .= "TZID:/nllchs.org/America/New_York\n";
   $timezone .= "X-LIC-LOCATION:America/New_York\n";
   $timezone .= "BEGIN:DAYLIGHT\n";
   $timezone .= "TZOFFSETFROM:-0500\n";
   $timezone .= "TZOFFSETTO:-0400\n";
   $timezone .= "TZNAME:EDT\n";
   $timezone .= "DTSTART:19700308T020000\n";
   $timezone .= "RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=2SU;BYMONTH=3\n";
   $timezone .= "END:DAYLIGHT\n";
   $timezone .= "BEGIN:STANDARD\n";
   $timezone .= "TZOFFSETFROM:-0400\n";
   $timezone .= "TZOFFSETTO:-0500\n";
   $timezone .= "TZNAME:EST\n";
   $timezone .= "DTSTART:19701101T020000\n";
   $timezone .= "RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=1SU;BYMONTH=11\n";
   $timezone .= "END:STANDARD\n";
   $timezone .= "END:VTIMEZONE\n";
   return $timezone;
}

1;

=head1 NAME

ICal::Calendar -- Class to create iCalendar files 

=head1 SYNOPSIS


=head1 DESCRIPTION


Version: $Id$

=cut

