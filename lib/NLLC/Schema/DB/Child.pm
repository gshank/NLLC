package NLLC::Schema::DB::Child;

use strict;
use warnings;

use base 'DBIx::Class';

NLLC::Schema::DB::Child->load_components("Core");
NLLC::Schema::DB::Child->table("child");
NLLC::Schema::DB::Child->add_columns(
  "child_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "family_id",
  { data_type => "INT", default_value => 0, is_nullable => 0, size => 11 },
  "firstname",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "lastname",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "birthday",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 7 },
  "gender",
  { data_type => "ENUM",
    default_value => 'm',
    is_nullable => 0,
  },
  "active",
  { data_type => "TINYINT", default_value => 1, is_nullable => 0, size => 3 },
);
NLLC::Schema::DB::Child->set_primary_key("child_id");
NLLC::Schema::DB::Child->belongs_to("family", "NLLC::Schema::DB::Family", {'foreign.family_id' => 'self.family_id'});
NLLC::Schema::DB::Child->has_many("child_activities", "NLLC::Schema::DB::ChildActivity", 'child_id');
NLLC::Schema::DB::Child->many_to_many("activities", "child_activities", "activity");
#NLLC::Schema::DB::Child->many_to_many("current_activities", "child_activities", "current_activity");

sub current_activities
{
    my ( $self ) = @_;
    my $current_activities = $self->search_related('child_activities')->search_related('activity', {current => 1});
    return $current_activities;
}

1;
