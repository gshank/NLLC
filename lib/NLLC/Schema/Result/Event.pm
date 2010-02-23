package NLLC::Schema::Result::Event;

use Moose;

use base 'DBIx::Class';

has 'dtstart_mdy' => (isa => 'Str', is => 'ro', lazy => 1,
      builder => '_build_dtstart_mdy');
sub _build_dtstart_mdy { return shift->dtstart->mdy('/') }
has 'dtstart_time' => (isa => 'Str|Undef', is => 'ro', lazy => 1,
      builder => '_build_dtstart_time');
sub _build_dtstart_time 
{ 
   my $self = shift;
   return if $self->dtstart->hour == 0;
   return $self->dtstart->strftime("%I:%M %p");
}
has 'dtstart_allday' => (isa => 'Str', is => 'ro', 
      lazy => 1, builder => '_build_dtstart_allday');
sub _build_dtstart_allday { return shift->duration ? 0 : 1 }
has 'until_mdy' => (isa => 'Str|Undef', is => 'ro', lazy => 1,
      builder => '_build_until_mdy');
sub _build_until_mdy 
{ 
   my $self = shift;
   return unless $self->until;
   return $self->until->mdy('/') 
}


# InflateColumn must come before "Core"
__PACKAGE__->load_components('InflateColumn::DateTime', "Core");
__PACKAGE__->table("event");
__PACKAGE__->add_columns(
  "event_id",
  {
    data_type => "INT",
    default_value => undef,
    is_auto_increment => 1,
    is_nullable => 0,
    size => 11,
  },
  "weekday",
  { data_type => "TINYINT", default_value => undef, is_nullable => 1, size => 4 },
  "month",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 6,
  },
  "day",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 6,
  },
  "year",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "hour",
  {
     data_type => "SMALLINT",
     default_value => undef,
     is_nullable => 1,
     size => 6,
  },
  "duration",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 12,
  },
  "freq",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 12,
  },
  "count",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 6,
  },
  "ical",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "activity_id",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "session_id",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "dtstart",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "dtend",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "until",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "summary",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "description",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "location",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "category",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 24,
  },
  "calendar",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 24,
  },
  "as_string",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  
);
NLLC::Schema::Result::Event->set_primary_key("event_id");

NLLC::Schema::Result::Event->belongs_to("activity", "NLLC::Schema::Result::Activity", {'foreign.activity_id' => 'self.activity_id'});

1;
