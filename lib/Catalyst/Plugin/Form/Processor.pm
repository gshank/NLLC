package Catalyst::Plugin::Form::Processor;
use strict;
use warnings;
use Carp;
use UNIVERSAL::require;
use NEXT;
use HTML::FillInForm;
use Module::Find;

our $VERSION = '0.05';

=head1 NAME

Catalyst::Plugin::Form::Processor - Use Form::Processor with Catalyst

=head1 SYNOPSIS

In the Catalyst application base class:

    use Catalyst qw/ Form::Processor /;

    __PACKAGE__->config->{form} = {
        no_fillin       => 1,  # Don't auto-fill forms with HTML::FillInForm
        pre_load_forms  => 1,  # Try and load forms at setup time
        form_name_space => 'My::Forms',
        debug           => 1,   # Show forms pre-loaded.
    };

Then in a controller:

    package App::Controller::User;
    use strict;
    use warnings;
    use base 'Catalyst::Controller';

    # Create or edit
    sub edit : Local {
        my ( $self, $c, $user_id ) = @_;

        # Validate and insert/update database
        reutrn unless $c->update_from_form( $user_id );

        # Form validated.

        $c->stash->{first_name} = $c->stash->{form}->value( 'first_name' );
    }

    # Form that doesn't update database
    sub profile : Local {
        my ( $self, $c ) = @_;

        # Redisplay form
        reutrn unless $c->validate_form;

        # Form validated.

        $c->stash->{first_name} = $c->stash->{form}->value( 'first_name' );
    }


    # Use HTML::FillInForm to populate a form:
    $c->stash->{fillinform} = $c->req->parameters;



=head1 DESCRIPTION

If not obvious from the L<SYNOPSIS> above, this plugin adds methods to make
L<Form::Processor> easy to use with Catalyst.  The plugin uses the current
action name to find the form module, creates the form object and stuffs it into
the stash, and passes the Catalyst request parameters to the form for
validation.  What else could you want?

Perhaps you want automatic HTML form generation?  No, this module
does not do that.  When was the last time you wrote a web application
where automatically generated forms would be close to acceptable?  Forms
always need customization and error message formatting, custom javascript,
etc.

That said, check out the included example Catalyst application to see how easy
it is to place fields and error messages on a page.  Adding new forms often is
as simple a listing the fields to include on the page.

The method C<< $c->update_from_form >> is used when the form inherits from a
Form::Processor model class (e.g. L<Form::Processor::Model::CDBI>) which will
load a form's current values from a database and update/create rows in the
database from a posted form.

C<< $c->validate_form >> simply validates the form and you must then decide
what to do with the validated data.  This is useful when the posted data
will be used for something other than updating a row in a database.

The C<< $c->form >> method will automatically load a form module from disk.
Both C<< $c->update_from_form >> and C<< $c->validate_form >> call this method
to load the form for you.  So, you generally don't need to call this directly.

Forms are assumed to be in the $App::Form name space.  But, that's just
the default.  In case you are unfamiliar with L<Form::Processor>, forms
are Perl modules that define not only the fields associated with a form but
also any extra validation (and cross validation) you may need to process
a form.


The form object is stored in the stash as C<< $c->stash->{form} >>.  Templates
can use this to access for form.

In addition, this Plugin use HTML-FillInForm to populate the form.  Typically,
this data will come automatically form the current values in the form object,
but can be overridden by populating the stash with a hash reference:

    $c->stash->{fillinform} = $c->req->parameters;

Note that this can also be used to populate forms not managed by Form::Processor.
Currently, only one form per page is supported.

L<Form::Processor> (currently) does not generate HTML.  This distribution
contains a sample Catalyst application that includes an overly complex Template
Toolkit file (C<form_widgets.tt>) for generating HTML.  The application can be
found in the t/example directory of the distribution.


=head1 METHODS

=head2 form ( $item_or_args_ref, $form_name );

    $form = $c->form;
    $form = $c->form( $user_id );
    $form = $c->form( $args_ref );
    $form = $c->form( $args_ref, $form_name );

Generates a form object, populates the stash "form" and returns the
form object.  This method is typically not used.  Use
L<update_from_form> or L<validate_form> instead.

The form will be require()ed at run time so the form does not need to be
explicitly loaded by your application. The form is expected to be in the
App::Form name space, but that can be overridden.

But, it might be worth loading the modules at compile time if you
have a lot of modules to save on memory (e.g. under mod_perl).
See L</pre_load_forms> below.

The Catalyst context (C<$c>) is made available to the form
via the form's user data attribute.  In the form you may do:

    my $c = $form->user_data->{context};


Pass:
    $item_or_args_ref. This can be
        scalar:
            it will be assumed to be the id of the row to edit
        hash ref:
            assumed to be a list of options and will be passed
            as a list to Form::Processor->new.
        object:
            and will be set as the item and item_id is set by
            calling the "id" method on this object.  If id
            is not the correct method then pass a hash reference
            instead.

    If $form_name is not provided then will use the current controller
    class and the action for the form name.  If $form_name is defined then
    it is appended to C<$App::Form::>.  A plus sign can be included
    to avoid prefixing the form name.


    package MyApp::Controller::Foo::Bar
    sub edit : Local {

        # MyAPP::Form::Foo::Bar::Edit->new
        # Note the upper case -- ucfirst is used
        my $form = $c->form;

        # MyAPP::Form::Login::User->new
        my $form = $c->form( $args_ref, 'Login::User' );

        # External form Other::Form->new
        my $form = $c->form( $args_ref, '+Other::Form' );


Returns:
    Sets $c->{form} by calling new on the form object.
    That value is also returned.

=cut

sub form {
    my ( $c, $args_ref, $form_name ) = @_;


    # Determine the form package name
    my $package;
    if ( defined $form_name ) {

        $package
            = $form_name =~ s/^\+//
            ? $form_name
            : ref( $c ) . '::Form::' . $form_name;
    }
    else {
        $package = $c->action->class;
        $package =~ s/::C(?:ontroller)?::/::Form::/;
        $package .= '::' . ucfirst( $c->action->name );
    }

    $package->require
        or carp "Failed to load Form module $package";


    # Single argument to Form::Processor->new means it's an item id or object.
    # Hash references must be turned into lists.

    my %args;
    if ( defined $args_ref ) {
        if ( ref $args_ref eq 'HASH' ) {
            %args = %{ $args_ref };
        }
        elsif ( Scalar::Util::blessed( $args_ref ) ) {
            %args = (
                item    => $args_ref,
                item_id => $args_ref->id,
            );
        }
        else {
            %args = ( item_id => $args_ref );
        }
    }

    $args{user_data}{context} = $c;


    return $c->stash->{form} = $package->new( %args );

} ## end sub form


=head2 validate_form

    return unless $c->validate_form;

This method passes the request parameters to
the form's C<validate> method and returns true
if all fields validate.

This is the method to use if you are not using
a Form::Processor::Model class to automatically
update or insert a row into the database.

=cut

sub validate_form {
    my $c = shift;

    my $form = $c->form( @_ );

    return
        $c->form_posted
        && $form->validate( $c->req->parameters );

}



=head2 update_from_form

This combines common actions on CRUD tables.
It replaces, say:

    my $form = $c->form( $item );

    return unless $c->form_posted
        && $form->update_from_form( $c->req->parameters );

with

    $c->update_from_form( $item )

For this to work your form should inherit from a Form::Processor::Model
class (e.g. see L<Form::Processor::Model::CDBI>), or your form must
have an C<update_from_form()> method (which calls validate).

=cut

sub update_from_form {
    my $c = shift;

    my $form = $c->form( @_ );

    return
        $c->form_posted
        && $form->update_from_form( $c->req->parameters );

}

=head2 form_posted

This returns true if the request was a post request.
This could be replace with a method that does more extensive
checking, such as validating a form token to prevent double-posting
of forms.

=cut

sub form_posted {
    my $c = shift;

    return $c->req->method eq 'POST';
}

=head1 EXTENDED METHODS

=head2 dispatch

Automatically fills in a form if $form variable is found.
This can be disabled by setting

    $c->config->{form}{no_fillin};


=cut

# Used to override finalize, but that's not called in a redirect.
# TODO: add support for multiple forms on a page (and multiple forms
# in the stash).

sub dispatch {
    my $c = shift;

    my $ret = $c->NEXT::dispatch( @_ );


    return $ret if $c->config->{form}{no_fillin};

    my $params = $c->stash->{form}
        ? $c->stash->{form}->fif
        : '';

    return $ret unless
        $c->res->status == 200
        && $params && %{$params};

    # Run FillInForm
    $c->response->output(
        HTML::FillInForm->new->fill(
            scalarref => \$c->response->{body},
            fdat      => $params,
        ) );


    return $ret;

}

=head2 setup

If the C<pre_load_forms> configuration options is set will search for forms in
the name space provided by the C<form_name_space> configuration list or by
default the application name space with the suffix ::Form appended (e.g.
MyApp::Form).

=cut

sub setup {
    my $c = shift;
    $c->NEXT::setup( @_ );

    my $config = $c->config->{form} || {};

    return unless $config->{pre_load_forms};

    my $debug = $config->{debug};

    my $name_space = $c->config->{form_name_space} || $c->config->{name} . '::Form';
    my @namespace = ref $name_space eq 'ARRAY' ? @{ $name_space } : ( $name_space );


    for my $ns ( @namespace ) {
        warn "Searching for forms in the [$ns] namespace\n" if $debug;

        for my $form ( Module::Find::findallmod( $ns ) ) {

            next if $form =~ /Field/;
            warn "Loading form module [$form]\n" if $debug;

            $form->require or die "Failed to require form module [$form]: $@";

            eval { $form->load_form };
            die "Failed load_module for form module [$form]: $@" if $@;
        }
    }

    return;
}



=head2 CONFIGURATION

Configuration is specified within C<< MyApp->config->{form}} >>.
The following options are available:

=over 4

=item no_fillin

Don't use use L<HTML::FillInForm> to populate the form data.

=item pre_load_forms

It this is true then will pre-load all modules in the MyApp::Form name space
during setup.  This works by requiring the form module and loading associated
form fields.  The form is not initialized so any fields dynamically loaded may
not be included.

This is useful in a persistent environments like mod_perl or FastCGI.

=item form_name_space

This is a list of name spaces where to look for forms to pre load.  It defaults
to the application name with the ::Form suffix (e.g. MyApp::Form).  Note, this
DOES NOT currently change where C<< $c->form >> looks for form modules.
Not quite sure why that's not implemented yet.


=item debug

If true will write brief debugging information when running setup.

=back



=head1 AUTHOR

Bill Moseley

=head1 COPYRIGHT & LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 See also

L<Form::Processor>

L<Form::Processor::Model::CDBI>

=cut

return 'oh, so true';







