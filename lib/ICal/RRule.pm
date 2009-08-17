package ICal::RRule;

use Moose;
use Moose::Util::TypeConstraints;
use ICal::Types;

has 'freq' => ( isa => 'Str', is => 'rw',
     required => 1);
has 'until' => ( isa => 'DateTime|Undef', is => 'rw' );
has 'interval' => ( isa => 'Int', is => 'rw', 
     default => sub { 1 });
has 'by' => ( isa => 'Str', is => 'rw' );
has 'count' => ( isa => 'Int|Undef', is => 'rw' );
has 'dtstart' => ( isa => 'DateTime', is => 'rw',
     required => 1,);

ICal::RRule->meta->make_immutable;

sub BUILD
{
   my ( $self, $params) = @_;

   if ($self->freq eq 'weekly')
   {
      my $weekday = $self->dtstart->day_name; 
      $weekday = substr($weekday, 0, 2);
      $self->by("DAY=$weekday");
   } 
   # also monthly, yearly....

}

sub build_dtstart
{
   my $self = shift;
   # for weekly freq

}

sub freq_str
{
   my $self = shift;
   my $freq = $self->freq;
   return "\UFREQ=$freq\;" if $freq;
}

sub until_str
{
   my $self = shift;
   my $until = DateTime::Format::ICal->format_datetime($self->until) if $self->until;
   return "\UUNTIL=$until\;" if $until;
}

sub interval_str
{
   my $self = shift;
   my $interval = $self->interval;
   return "\UINTERVAL=$interval\;" if $interval;
}

sub count_str
{
   my $self = shift;
   my $count = $self->count;
   return "\UCOUNT=$count\;" if $count;
}
sub by_str
{
   my $self = shift;
   my $by = $self->by;
   return "\UBY$by" if $by;
}

sub as_string
{
   my ( $self ) = @_;

   my $rrule_string;
   $rrule_string .= $self->freq_str if $self->freq;
   # one of either count or until
   if ( $self->count )
   { $rrule_string .= $self->count_str; }
   elsif ( $self->until )
   { $rrule_string .= $self->until_str; }

   $rrule_string .= $self->interval_str if $self->interval;
   $rrule_string .= $self->by_str if $self->by;
   return $rrule_string;
}


1;

=head1 NAME

ICal::RRule -- Wrapper class for creating iCalendar recurrence rules

=head1 SYNOPSIS


=head1 DESCRIPTION


Version: $Id$

=cut

