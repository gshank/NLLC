package NLLC::Schema::DB::ChildActivity;

use strict;
use warnings;

use base 'DBIx::Class';

NLLC::Schema::DB::ChildActivity->load_components("Core");
NLLC::Schema::DB::ChildActivity->table("child_activity");
NLLC::Schema::DB::ChildActivity->add_columns(
  "child_id",
  { data_type => "INT", 
    default_value => 0, 
    is_nullable => 0, 
    size => 11 },
  "activity_id",
  { data_type => "INT", 
    default_value => 0, 
    is_nullable => 0, 
    size => 11 },
  "session_id",
  { data_type => "INT",
    default_value => undef,
    is_nullable => 1,
    size => 11 },
  "interest",
  { data_type => "INT", 
    default_value => 0, 
    is_nullable => 1, 
    size => 11 },
  # enrolled = 1, waitlist = 2
  "enrolled",
  { data_type => "INT",
    default_value => 1,
    is_nullable => 1,
    size => 11
  },
);

NLLC::Schema::DB::ChildActivity->set_primary_key('child_id', 'activity_id');
NLLC::Schema::DB::ChildActivity->add_unique_constraint('act_child' => ['activity_id', 'child_id']);
NLLC::Schema::DB::ChildActivity->belongs_to('child', 'NLLC::Schema::DB::Child', 'child_id'); 
NLLC::Schema::DB::ChildActivity->belongs_to('activity', 'NLLC::Schema::DB::Activity', {'foreign.activity_id' => 'self.activity_id'}); 

NLLC::Schema::DB::ChildActivity->belongs_to('current_activity', 
    'NLLC::Schema::DB::Activity', 
    {'foreign.activity_id' => 'self.activity_id'}, {'foreign.current' => 1});

1;
