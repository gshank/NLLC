package NLLC::Form::Payment;
use strict;
use warnings;
use base 'Form::Processor::Model::DBIC';

sub object_class {'DB::Payment'};

sub profile
{
    return {
        required => {
            family_id => 'Integer',
        },
        optional => {
            date => 'Text',
            amount => 'Text',
            comment => 'Text',
        }
    };

}


1;
