package NLLC::Schema::DB::Cart;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("cart");
__PACKAGE__->add_columns(
  "id",
  { 
    data_type => "INT", 
    default_value => "", 
    is_nullable => 0, 
    size => 11,
    is_auto_increment => 1,
  },
  "activity_id",
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
);

NLLC::Schema::DB::Cart->set_primary_key("id");
NLLC::Schema::DB::Cart->add_unique_constraint( 'act_fam' => ['activity_id',  'family_id']);
NLLC::Schema::DB::Cart->belongs_to("activity", "NLLC::Schema::DB::Activity", {'foreign.activity_id' => 'self.activity_id'});

1;
