package NLLC::Form::Field::Duration;

use Moose;
extends 'HTML::FormHandler::Field';
use DateTime;

our $VERSION = '0.01';

has '+widget' => ( default => 'Compound' );

sub validate {
    my ( $self ) = @_;

    my $input = $self->input;

    # get field name
    my $name = $self->name;

    my %duration;

    my $found = 0;
    my $dt_duration;
    my $fieldname;

    for my $sub ( 'years', 'months', 'weeks', 'days', 'hours', 'minutes' ) 
    {
        next unless exists $input->{$sub};
        # fields get filled in with '' if no value is entered
        my $value = $input->{$sub};
        next unless defined $value;
        $found++;

        unless ( $value =~ /^\d+$/ ) {
            $self->add_error( "Invalid value for '[_1]", $sub );
            return;
        }
        $duration{ $sub } = $value;
        $dt_duration .= "$sub:$value\,"
    }

    $self->value( $dt_duration );
}

sub deflate {
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
    return \%hash;
}



=head1 NAME

HTML::FormHandler::Field::Duration - Produces DateTime::Duration from HTML form values 

=cut

1;

