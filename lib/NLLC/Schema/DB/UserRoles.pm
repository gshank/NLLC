package NLLC::Schema::DB::UserRoles;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("user_roles");
__PACKAGE__->add_columns(
  "family_id",
  { data_type => "INT", default_value => 0, is_nullable => 0, size => 11 },
  "role_id",
  { data_type => "INT", default_value => 0, is_nullable => 0, size => 11 },
);
__PACKAGE__->set_primary_key("family_id", "role_id");

NLLC::Schema::DB::UserRoles->belongs_to(user => 'NLLC::Schema::DB::Family', 'family_id');
NLLC::Schema::DB::UserRoles->belongs_to(role => 'NLLC::Schema::DB::Roles', 'role_id');

1;
