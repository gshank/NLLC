package NLLC::Schema::ResultSet::Activity;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub child_curr_act_count
{
    my ( $self, $child_id ) = @_;
    return $self->search({current => 1})->search_related('activity_children', {child_id => $child_id})->count;

}

1;
