package NLLC::Schema::Result::ChildActivity;

use strict;
use warnings;

use base 'DBIx::Class';

NLLC::Schema::Result::ChildActivity->load_components("Core");
NLLC::Schema::Result::ChildActivity->table("child_activity");
NLLC::Schema::Result::ChildActivity->add_columns(
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

NLLC::Schema::Result::ChildActivity->set_primary_key('child_id', 'activity_id');
NLLC::Schema::Result::ChildActivity->add_unique_constraint('act_child' => ['activity_id', 'child_id']);
NLLC::Schema::Result::ChildActivity->belongs_to('child', 'NLLC::Schema::Result::Child', 'child_id'); 
NLLC::Schema::Result::ChildActivity->belongs_to('activity', 'NLLC::Schema::Result::Activity', {'foreign.activity_id' => 'self.activity_id'}); 

NLLC::Schema::Result::ChildActivity->belongs_to('current_activity', 
    'NLLC::Schema::Result::Activity', 
    {'foreign.activity_id' => 'self.activity_id'}, {'foreign.current' => 1});

1;
