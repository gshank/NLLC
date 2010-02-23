package NLLC::Schema::Result::Member;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("member");
__PACKAGE__->add_columns(
  "family_id",
  { data_type => "INT", default_value => 0, is_nullable => 0, size => 11 },
  "session_id",
  { data_type => "INT", default_value => 0, is_nullable => 0, size => 11 },
);
__PACKAGE__->set_primary_key("family_id", "session_id");


1;
