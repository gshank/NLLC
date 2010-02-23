package NLLC::Form::CmsPage;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

has_field 'name' => ( type => 'Text', label => 'Page Name' );
has_field 'body' => ( type => 'TextArea', label => 'Edit Page', id => 'cmsbody',
                      cols => 80, rows => 20 
) ;
has_field 'submit' => ( type => 'Submit', value => 'Save' );

1;
