package NLLC::Schema::Result::Payment;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("payment");
__PACKAGE__->add_columns(
  "payment_id",
  {
    data_type => "INT",
    default_value => undef,
    is_auto_increment => 1,
    is_nullable => 0,
    size => 11,
  },
  "session_id",
  { 
    data_type => "INT", 
    default_value => undef, 
    is_nullable => 1, 
    size => 11 
  },
  "family_id",
  { 
    data_type => "INT", 
    default_value => undef, 
    is_nullable => 1, 
    size => 11 
  },
  "date",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 12,
  },
  "amount",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 12,
  },
  "comment",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
);
NLLC::Schema::Result::Payment->set_primary_key("payment_id");
NLLC::Schema::Result::Payment->belongs_to("family", "NLLC::Schema::Result::Family", {'foreign.family_id' => 'self.family_id'});

1;
