package NLLC::Schema::Result::Telephone;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("telephone");
__PACKAGE__->add_columns(
  "telephone_id",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
    size => 10,
  },
  "family_id",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "number",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 32 },
  "type",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 12 },
);
__PACKAGE__->set_primary_key("telephone_id");


1;
