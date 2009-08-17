package ICal::Event;

use Moose;
use Moose::Util::TypeConstraints;
use ICal::Types;
use ICal::RRule;

has 'location' => ( isa => 'Str|Undef', is => 'rw' );
has 'dtstart' => ( isa => 'DateTime', is => 'rw', required => 1 );
has 'dtend' => ( isa => 'DateTime', is => 'rw' );
has 'duration' => ( isa => 'DTDuration|Undef', is => 'rw' );
has 'summary' => ( isa => 'Str', is => 'rw', required => 1 );
has 'rrule' => ( isa => 'ICal::RRule|Undef', is => 'rw' );
has 'created' => ( isa => 'DateTime', is => 'rw' );
has 'last_modified' => ( isa => 'DateTime', is => 'rw' );
has 'uid' => ( isa => 'Str', is => 'rw' );
has 'description' => ( isa => 'Str|Undef', is => 'rw' );
has 'dtstamp' => ( isa => 'DateTime', is => 'rw' );

ICal::Event->meta->make_immutable;

sub BUILD
{
   my ( $self, $params ) = @_;

   # Clone the dtstart and add a duration
   # if dtend not specified.
   unless ($self->dtend)
   {
      my $dtend  = $self->dtstart->clone;
      if ($self->duration)
         { $dtend->add_duration($self->duration);}
      else # assume for now that no duration means all day
         { $dtend->add( days => 1 ); }
      $self->dtend( $dtend );
   }

}

sub as_string
{
   my ( $self ) = @_;
   my $string = "BEGIN:VEVENT\n";

   $string .= "CREATED:" . $self->created_str . "\n" if $self->created;
   $string .= "LAST-MODIFIED:" . $self->last_modified_str . "\n"
               if $self->last_modified;
   $string .= "DTSTAMP:" . $self->dtstamp_str . "\n" if $self->dtstamp;
   $string .= "UID:" . $self->uid . "\n" if $self->uid;
   $string .= "SUMMARY:" . $self->summary . "\n" if $self->summary;
   $string .= "DESCRIPTION:" . $self->description . "\n" if $self->description;
   $string .= "RRULE:" . $self->rrule_str . "\n" if $self->rrule;
   $string .= "DTSTART:" . $self->dtstart_str . "\n";
   if ( $self->duration )
   { $string .= "DURATION:" . $self->duration_str; }
   elsif ( $self->dtend )
   { $string .= "DTEND:" . $self->dtend_str; }
   $string .= "\n";
   $string .= "LOCATION:" . $self->location ."\n" if $self->location;

   $string .= "END:VEVENT\n";
   return $string;
}

sub as_english
{
   my ( $self ) = @_;
   my $engl;
   my $dt = $self->dtstart;
   my $end = $self->dtend;
   if ($self->rrule )
   {
      my $rrule = $self->rrule;
      $engl .= "Occurs every ";
      if ( $rrule->interval > 1 )
      { 
         (my $unit = $rrule->freq ) =~ s/ly//g;
         $engl .= $rrule->interval . " " . $unit . "s on ";
      }
      if ($rrule->freq eq 'daily')
      {
         $engl .= "day, starting " . $dt->day_name . " "; 
      }
      elsif ($rrule->freq eq 'weekly')
      {
         $engl .= $dt->day_name . " starting ";
      }
      # either 'until' or 'count'
      $engl .= $dt->mdy('/') . " ";
      if( $rrule->count )
      {
         $engl .= "for ";
         $engl .= $rrule->count . " times ";
      }
      elsif( $rrule->until )
      {
         $engl .= "until ";
         $engl .= $rrule->until->mdy('/') . " ";
      }
      unless ($dt->hour == 0) # Don't give times for all day events
      {
         $engl .= "from " . $dt->strftime("%I:%M %p");
         $engl .= " to " . $end->strftime("%I:%M %p");
      }
   }
   else
   {
      $engl .= "On " . $dt->day_name . ", " . $dt->mdy('/');
      unless ( $dt->hour == 0 ) # no duration for all day event
      {
         $engl .= " from " . $dt->strftime("%I:%M %p");
         $engl .= " to " . $end->strftime("%I:%M %p");
      }
   }
   return $engl;
}

sub die_event
{
   my $self = shift;
   my $event = Data::ICal::Entry::Event->new();
   my %properties = ( 
      dtstart => $self->dtstart_str,
      dtend => $self->dtend_str,
      summary => $self->summary,
      rrule => $self->rrule_str,
      created => $self->created_str,
      description => $self->description,
      dtstamp => $self->dtstamp_str,
      location => $self->location,
    );
   foreach my $key (keys %properties)
   {
      delete $properties{$key} unless $properties{$key};
   }
   $event->add_properties(%properties);
   return $event;
}

sub dtstart_str
{
   my $self = shift;
   return DateTime::Format::ICal->format_datetime($self->dtstart)
       if $self->dtstart;
}

sub dtend_str
{
   my $self = shift;
   return DateTime::Format::ICal->format_datetime($self->dtend)
       if $self->dtend;
}

sub created_str
{
   my $self = shift;
   return DateTime::Format::ICal->format_datetime($self->created)
       if $self->created;
}

sub last_modified_str
{
   my $self = shift;
   return DateTime::Format::ICal->format_datetime($self->last_modified)
       if $self->last_modified;
}

sub dtstamp_str
{
   my $self = shift;
   return DateTime::Format::ICal->format_datetime($self->dtstamp)
       if $self->dtstamp;
}

sub duration_str
{
   my $self = shift;
   return unless $self->duration;
   my $string = DateTime::Format::ICal->format_duration($self->duration);
   $string =~ s/\+//g;  # although starting with a "+" is legal, it doesn't
                       # seem to be well supported--neither Sunbird nor
                       # phpICalendar accept it
   return $string;
}

sub rrule_str
{
   my $self = shift;
   return $self->rrule->as_string if $self->rrule;
}


1;

=head1 NAME

ICal::Event -- Wrapper class for creating iCalendar events

=head1 SYNOPSIS


=head1 DESCRIPTION


Version: $Id$

=cut

