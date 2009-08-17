package NLLC::Form::Activity;
use strict;
use warnings;
use base 'Form::Processor::Model::DBIC';

sub object_class {'DB::Activity'}

sub profile 
{
   return {
      required => {
          name => 'Text',
          daystimes => 'Text',
          description => 'Text',
          leadname => 'Text',
      },
      optional => {
          family_id => 'Integer',
          session_id => 'Integer',
          leadbio => 'Text',
          leadphone => 'Text',
          leademail => 'Text',
          locreq => 'Text',
          actualloc => 'Text',
          childreq => 'Text',
          min => 'Text',
          max => 'Text',
          sessions => 'Text',
          progtime => 'Text',
          startdate => 'Text',
          enddate => 'Text',
          onesession => 'Text',
          matsfee => 'Text',
          material => 'Text',
          suggprep => 'Text',
          support => 'Text',
          addsection => 'Text',
          current => 'Integer',
      },
  };
}
            
1;
