use strict;
use warnings;
use Test::More;


use_ok('NLLC::Form::Event');
use NLLC::Schema;
#    [ 'dbi:mysql:dbname=nllc;host=mysql.odshank.com;user=nllc_admin;password=nllc2hs' ],
my $schema = NLLC::Schema->connect('dbi:mysql:dbname=nllc;host=mysql.odshank.com', 'nllc_admin', 'nllc2hs'); 

my $form_args = { 
                  schema => $schema, 
                  params => {}, 
                  activity => 999, 
                  session_id => 99, 
};
$form_args->{init_object} = { summary => 'Summary event', 
    description => 'test event' };
my $form = NLLC::Form::Event->new;
ok( $form, 'form built' );
$form->process( %$form_args );

is( $form->field('summary')->value, 'Summary event', 'summary filled in' );
