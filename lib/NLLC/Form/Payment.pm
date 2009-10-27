package NLLC::Form::Payment;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

has '+item_class' => ( default => 'Payment' );

has_field 'family_id' => ( required => 1 );
has_field 'date';
has_field 'amount';
has_field 'comment';

1;
