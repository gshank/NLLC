package NLLC::Form::Contribution;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

has '+item_class' => ( default => 'Contribution' );

has_field 'description';

1;
