package NLLC::Schema::DB::Activity;

use strict;
use warnings;

use base 'DBIx::Class';

NLLC::Schema::DB::Activity->load_components("Core");
NLLC::Schema::DB::Activity->table("activity");
NLLC::Schema::DB::Activity->add_columns(
  "activity_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "name",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "session_id",
  {
    data_type => "INT",
    default_value => undef,
    is_nullable => 1,
    size => 11,
  },
  "daystimes",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "neworder",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "description",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "family_id",
  {
    data_type => "INT",
    default_value => undef,
    is_nullable => 1,
    size => 11,
  },
  "leadname",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "leadbio",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "leadphone",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "leademail",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "locreq",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "actualloc",
  { data_type => "SET", default_value => undef, is_nullable => 1, size => 66 },
  "childreq",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "min",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "max",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "sessions",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "progtime",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "startdate",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 24,
  },
  "enddate",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 24,
  },
  "onesession",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "matsfee",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "material",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "suggprep",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "support",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "addsection",
  {
     data_type => "VARCHAR",
     default_value => undef,
     is_nullable => 1,
     size => 255,
  },
  "active",
  { data_type => "TINYINT", default_value => 0, is_nullable => 0, size => 4 },
  "current",
  { data_type => "TINYINT",
    default_value => undef,
    is_nullable => 1,
    size => 4,
  },
);
NLLC::Schema::DB::Activity->set_primary_key("activity_id");

NLLC::Schema::DB::Activity->belongs_to("family", "NLLC::Schema::DB::Family", {'foreign.family_id' => 'self.family_id'});
NLLC::Schema::DB::Activity->has_many("activity_children", "NLLC::Schema::DB::ChildActivity", {'foreign.activity_id' => 'self.activity_id'}); 
NLLC::Schema::DB::Activity->many_to_many("children", "activity_children", "child_id");
NLLC::Schema::DB::Activity->has_many('events', "NLLC::Schema::DB::Event", {'foreign.activity_id' => 'self.activity_id'});

1;
