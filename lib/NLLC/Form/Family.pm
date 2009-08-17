package NLLC::Form::Family;
use strict;
use warnings;
use base 'Form::Processor::Model::DBIC';

sub object_class {'DB::Family'}

sub profile
{
    return {
        required => {
            first_name1 => 'Text',
            last_name1 => 'Text',
        },
        optional => {
            first_name2 => 'Text',
            last_name2 => 'Text',
            street_address => 'Text',
            city_state_zip => 'Text',
            phone1 => 'Text',
            phone2 => 'Text',
            email => 'Text',
            active => 'Checkbox',
            username => 'Text',
            password => 'Text',
        },
    };

}

1;
