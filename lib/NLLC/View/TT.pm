package NLLC::View::TT;

use Moose;
extends 'Catalyst::View::TT';
with 'Catalyst::View::FillInForm';

__PACKAGE__->config(TEMPLATE_EXTENSION => '.tt');

=head1 NAME

NLLC::View::TT - TT View for NLLC

=head1 DESCRIPTION

TT View for NLLC. 

=cut

NLLC::View::TT->config({
	INCLUDE_PATH => [
     NLLC->path_to( 'root', 'templates' ),
	  NLLC->path_to( 'root', 'templates' )
	],
	WRAPPER => 'layouts/wrapper.tt',
   COMPILE_EXT => '.ttc',
	TEMPLATE_EXTENSION => '.tt',
});

=head1 AUTHOR

Gerda Shank

=head1 SEE ALSO

L<NLLC>

Gerda Shank

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
