use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'NLLC' }
BEGIN { use_ok 'NLLC::Controller::Member' }

ok( request('/member')->is_success, 'Request should succeed' );


