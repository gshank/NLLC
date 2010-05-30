package NLLC::Form::Family;
use HTML::FormHandler::Moose;
use base 'HTML::FormHandler::Model::DBIC';

has '+item_class' => ( default => 'Family' );

has_field 'first_name1' => ( required => 1 );
has_field 'last_name1' => ( required => 1 );
has_field 'first_name2';
has_field 'last_name2';
has_field 'street_address';
has_field 'city_state_zip';
has_field 'phone1';
has_field 'phone2';
has_field 'email';
has_field 'active' => ( type => 'Checkbox' );
has_field 'username';
has_field 'password';

1;
