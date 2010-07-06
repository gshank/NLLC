package NLLC::Schema::Result::CmsPage;

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

NLLC::Schema::Result::CmsPage

=cut

__PACKAGE__->table("cms_page");

=head1 ACCESSORS

=head2 page_id

  data_type: INT
  default_value: undef
  is_auto_increment: 1
  is_nullable: 0
  size: 11

=head2 name

  data_type: VARCHAR
  default_value: undef
  is_nullable: 1
  size: 24

=head2 body

  data_type: TEXT
  default_value: undef
  is_nullable: 1
  size: 65535

=head2 last_edit

  data_type: INT
  default_value: undef
  is_nullable: 1
  size: 11

=cut

__PACKAGE__->add_columns(
  "page_id",
  {
    data_type => "INT",
    default_value => undef,
    is_auto_increment => 1,
    is_nullable => 0,
    size => 11,
  },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 24,
  },
  "body",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "last_edit",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
);
__PACKAGE__->set_primary_key("page_id");
__PACKAGE__->add_unique_constraint(name => ['name']);


1;
