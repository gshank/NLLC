use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'NLLC' }
BEGIN { use_ok 'NLLC::Controller::Report' }

ok( request('/report')->is_success, 'Request should succeed' );


