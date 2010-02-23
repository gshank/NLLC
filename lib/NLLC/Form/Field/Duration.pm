package NLLC::Form::Field::Duration;

use Moose;
extends 'HTML::FormHandler::Field::Compound';
use DateTime;

our $VERSION = '0.01';

has '+widget' => ( default => 'Compound' );

=pod

around '_result_from_object' => sub {
    my $orig = shift;
    my ( $self, $self_result, $duration_string ) = @_;

    my %hash;
    $duration_string =~ s/\:/\,/g;
    my %duration_hash = split(',', $duration_string);
    return $self->$orig($self_result, \%duration_hash);
};

=cut

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
    my ( $self, $dt_duration ) = @_;

    return unless $dt_duration;
    return $dt_duration if ref $dt_duration eq 'HASH';
    $dt_duration =~ s/\:/\,/g;
    my %hash = split(',', $dt_duration);
    return \%hash;
}


=head1 NAME

HTML::FormHandler::Field::Duration - Produces DateTime::Duration from HTML form values 

=cut

1;

