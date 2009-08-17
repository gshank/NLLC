package NLLC::Form::Field::Duration;
use base 'Form::Processor::Field';
use DateTime;

our $VERSION = '0.01';

sub init_widget { 'Compound' }



# override validate

sub validate_field {
    my ( $self ) = @_;

    my $params = $self->form->params;

    # get field name
    my $name = $self->name;

    my %duration;

    my $found = 0;
    my $dt_duration;
    my $fieldname;

    for my $sub ( 'years', 'months', 'weeks', 'days', 'hours', 'minutes' ) 
    {
        $fieldname = "$name.$sub";
        # fields get filled in with '' if no value is entered
        delete $params->{$fieldname} 
           if (exists $params->{$fieldname} && 
                      $params->{$fieldname} eq '');
        my $value = $params->{$fieldname};
        next unless defined $value;
        $found++;

        unless ( $value =~ /^\d+$/ ) {
            $self->add_error( "Invalid value for '[_1]", $sub );
            return;
        }
        $duration{ $sub } = $value;
        $dt_duration .= "$sub:$value\,"
    }

    # If any found, make sure all are entered
    if ( $self->required ) {
        unless ( $found ) {
            $self->add_error( "Duration is required" );
            return;
        }
    }

    $self->value( $dt_duration );

}

sub format_value {
    my $self = shift;

    my $name = $self->name;

    my %hash;

    my $dt_duration = $self->value || return ();

    $dt_duration =~ s/\:/\,/g;
    my %value_hash = split(',', $dt_duration);

   
    for my $sub ( 'years', 'months', 'weeks', 'days', 'hours', 'minutes' ) 
    {
        $hash{ $name . '.' . $sub } = $value_hash{$sub}; 
    }

    return %hash;
}



=head1 NAME

Form::Processor::Field::Duration - Produces DateTime::Duration from HTML form values 

=head1 SYNOPSIS

See L<Form::Processor>

=head1 DESCRIPTION

This is a compound field that uses modified field names for the 
sub fields instead of using a separate sub-form.

=head2 Widget

Fields can be given a widget type that is used as a hint for
the code that renders the field.

This field's widget type is: "Compound".

=head2 Subclass

Fields may inherit from other fields.  This field
inherits from: "Field".

=cut


1;

