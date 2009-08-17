package NLLC::Form::Child;
use strict;
use warnings;
use base 'Form::Processor::Model::DBIC';

sub object_class {'DB::Child'};

sub profile
{
    return {
        required => {
            firstname => 'Text',
            lastname => 'Text',
        },
        optional => {
            birthday => 'Text',
            gender => 'Text',
            active => 'Checkbox',
        }
    };

}


1;
