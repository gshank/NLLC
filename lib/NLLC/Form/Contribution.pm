package NLLC::Form::Contribution;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

has '+item_class' => ( default => 'Contribution' );

has_field 'description';
has_field 'family_id' => ( type => 'Integer' );
has_field 'session_id' => ( type => 'Integer' );

1;
