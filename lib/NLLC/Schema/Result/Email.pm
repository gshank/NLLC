package NLLC::Schema::Result::Email;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("email");
__PACKAGE__->add_columns(
  "email_id",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 64 },
  "fk_family_id",
  { data_type => "INT", default_value => "", is_nullable => 0, size => 11 },
  "email",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
);


1;
