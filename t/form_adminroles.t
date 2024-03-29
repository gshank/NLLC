use strict;
use warnings;
use Test::More;

use_ok( 'NLLC::Form::AdminRoles' );

use IO::All;
use NLLC::Schema;
#    [ 'dbi:mysql:dbname=nllc;host=mysql.odshank.com;user=nllc_admin;password=nllc2hs' ],
my $schema = NLLC::Schema->connect('dbi:mysql:dbname=nllc;host=mysql.odshank.com', 'nllc_admin', 'nllc2hs'); 
my $form = NLLC::Form::AdminRoles->new( schema => $schema );

ok( $form, 'form builds' );

$form->process( params => {} );

my $rendered = $form->render;
$rendered > io('adminrole.html');

ok( $form->field('admin_roles')->num_fields > 10, 'the admin role fields built ok' );

my $fif = $form->fif;
$form->process( params => $fif );
my $newfif = $form->fif;
is_deeply( $newfif, $fif, 'fif stays the same' );

done_testing;
