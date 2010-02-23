#!/usr/bin/env perl 

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

=head1 NAME

    nllc_schema_dump.pl

=head1 DESCRIPTION

    Dumps the schema in the database to lib/NLLC/Schema/SchemaDump

=head1 SYNOPSIS

   script/nllc_schema_dump.pl

=cut

use DBIx::Class::Schema::Loader ('make_schema_at');

make_schema_at(
   'NLLC::Schema::SchemaDump',
   { debug => 1, 
	 dump_directory => "$FindBin::Bin/../lib" },
   [ 'dbi:mysql:nllc', 'nllc_admin', 'nllc_pw' ],
  ); 

 # should remove SchemaDump.pm file
