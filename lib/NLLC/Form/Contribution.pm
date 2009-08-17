package NLLC::Form::Contribution;

use strict;
use warnings;
use base 'Form::Processor::Model::DBIC';

sub object_class {'DB::Contribution'};

sub profile
{
   return {
      fields => {
         description => 'Text',
         family_id   => 'Integer',
         session_id  => 'Integer',
      },
   };
}

1;
