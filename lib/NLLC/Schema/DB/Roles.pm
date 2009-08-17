package NLLC::Schema::DB::Roles;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("roles");
__PACKAGE__->add_columns(
  "role_id",
  { data_type => "INT", default_value => "", is_nullable => 0, size => 11 },
  "role",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
);
__PACKAGE__->set_primary_key("role_id");

NLLC::Schema::DB::Roles->has_many(user_roles => 'NLLC::Schema::DB::UserRoles', 'role_id');

1;
