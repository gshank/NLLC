package NLLC::Form::Activity;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

has '+item_class' => ( default => 'Activity' );

has_field 'name' => ( required => 1 );
has_field 'daystimes' => ( required => 1 );
has_field 'description' => ( required => 1 );
has_field 'leadname' => ( required => 1 );
has_field 'family_id' => ( type  => 'Integer' );
has_field 'session_id' => ( type => 'Integer' );
has_field 'leadbioi';
has_field 'leadphone';
has_field 'leademail';
has_field 'locreq';
has_field 'actualloc';
has_field 'childreq';
has_field 'min';
has_field 'max';
has_field 'sessions';
has_field 'progtime';
has_field 'startdate';
has_field 'enddate';
has_field 'onesession';
has_field 'matsfee';
has_field 'material';
has_field 'suggprep';
has_field 'support';
has_field 'addsection';
has_field 'current';
            
1;
