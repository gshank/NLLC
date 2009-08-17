package NLLC::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'NLLC::Schema::DB',
    connect_info => [
        'dbi:mysql:dbname=nllc;host=mysql.odshank.com',
        'nllc_admin',
        'nllc2hs',
        
    ],
);

=head1 NAME

NLLC::Model::DB - Catalyst DBIC Schema Model
=head1 SYNOPSIS

See L<NLLC>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<NLLC::Schema::DB>

=head1 AUTHOR

Gerda Shank

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
