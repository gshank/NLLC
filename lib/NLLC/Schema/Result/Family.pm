package NLLC::Schema::Result::Family;

use strict;
use warnings;

use base 'DBIx::Class';

NLLC::Schema::Result::Family->load_components("Core");
NLLC::Schema::Result::Family->table("family");
NLLC::Schema::Result::Family->add_columns(
  "family_id",
  { 
    data_type => "INT", 
    default_value => undef, 
    is_nullable => 0, 
    size => 11 },
  "username",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 24,
  },
  "password",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "first_name1",
  { 
    data_type => "VARCHAR", 
    default_value => undef, 
    is_nullable => 1, 
    size => 24 
  },
  "last_name1",
  { 
    data_type => "VARCHAR", 
    default_value => undef, 
    is_nullable => 1, 
    size => 24 
  },
  "first_name2",
  { 
    data_type => "VARCHAR", 
    default_value => undef, 
    is_nullable => 1, 
    size => 24 
  },
  "last_name2",
  { 
    data_type => "VARCHAR", 
    default_value => undef, 
    is_nullable => 1, 
    size => 24 
  },
  "street_address",
  {
	data_type => 'VARCHAR',
	default_value => undef,
	is_nullable => 1,
	size => 64,
  },
  "city_state_zip",
  {
    data_type => "LONGTEXT",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "phone1",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "phone2",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "email",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "active",
  { data_type => "TINYINT", default_value => 1, is_nullable => 0, size => 3 },
);
NLLC::Schema::Result::Family->set_primary_key("family_id");
NLLC::Schema::Result::Family->has_many("children", "NLLC::Schema::Result::Child", {'foreign.family_id' => 'self.family_id'});
NLLC::Schema::Result::Family->has_many(user_roles => 'NLLC::Schema::Result::UserRoles', 'family_id');
NLLC::Schema::Result::Family->many_to_many(roles => 'user_roles', 'role');
NLLC::Schema::Result::Family->has_many("activities", "NLLC::Schema::Result::Activity", {'foreign.family_id' => 'self.family_id'});
NLLC::Schema::Result::Family->has_many("contributions", "NLLC::Schema::Result::Contribution", {'foreign.family_id' => 'self.family_id'});
NLLC::Schema::Result::Family->has_many("payments", "NLLC::Schema::Result::Payment", {'foreign.family_id' => 'self.family_id'}, {order_by => 'payment_id'});

sub name1
{
   my $self = shift;
   return $self->first_name1 . " " . $self->last_name1;
}

sub name2
{
   my $self = shift;
   return $self->first_name2 . " " . $self->last_name2 if $self->first_name2;
}

1;
