package NLLC::Schema::DB::Contribution;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("contribution");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INT",
    default_value => undef,
    is_auto_increment => 1,
    is_nullable => 0,
    size => 11,
  },
  "family_id",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "session_id",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "description",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
);
NLLC::Schema::DB::Contribution->set_primary_key("id");
NLLC::Schema::DB::Contribution->belongs_to("family", "NLLC::Schema::DB::Family", {'foreign.family_id' => 'self.family_id'});


1;
