use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'NLLC' }
BEGIN { use_ok 'NLLC::Controller::Family' }

ok( request('/family')->is_success, 'Request should succeed' );


