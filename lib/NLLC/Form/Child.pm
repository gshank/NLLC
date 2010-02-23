package NLLC::Form::Child;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

has '+item_class' => ( default => 'Child' );

has_field 'firstname' => ( required => 1 );
has_field 'lastname' => ( required => 1 );
has_field 'birthday';
has_field 'gender';
has_field 'active' => ( type => 'Checkbox' );


1;
