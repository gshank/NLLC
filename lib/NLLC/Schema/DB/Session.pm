package NLLC::Schema::DB::Session;

use strict;
use warnings;

use base 'DBIx::Class';

NLLC::Schema::DB::Session->load_components("Core");
NLLC::Schema::DB::Session->table("session");
NLLC::Schema::DB::Session->add_columns(
  "session_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "year",
  { data_type => "YEAR", default_value => "0000", is_nullable => 0, size => 4 },
  "session_num",
  { data_type => "INT", default_value => 0, is_nullable => 0, size => 10 },
  "season",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 12 },
  "label",
  { data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => "24",
   },
);
NLLC::Schema::DB::Session->set_primary_key("session_id");
NLLC::Schema::DB::Session->has_many("members", "NLLC::Schema::DB::Member", 'session_id' );
NLLC::Schema::DB::Session->has_many("activities", "NLLC::Schema::DB::Activity", 'session_id');



1;
