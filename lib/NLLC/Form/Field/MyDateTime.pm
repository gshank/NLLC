package NLLC::Form::Field::MyDateTime;
use Moose;
extends 'HTML::FormHandler::Field';
use DateTime;
our $VERSION = '0.03';

has '+widget' => ( default => 'Compound' );

# override completely validate

sub validate_field {
    my ( $self ) = @_;

    my $params = $self->form->params;
    my $name = $self->name;
    my %date;
    my $found = 0;
    my $fieldname;

    for my $sub ( 'month', 'day', 'year', 'hour', 'minute' ) 
    {
        $fieldname = "$name.$sub";
        # Not sure why these fields get filled in with ''...
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
        $date{ $sub } = $value;
    }

    # If any found, make sure all are entered
    if ( $self->required ) {
        unless ( $found ) {
            $self->add_error( "Date is required" );
            return;
        }
    }
    return unless $found;


    my $dt;
    eval {  $dt = DateTime->new( %date, time_zone => 'floating' ) };

    if ( $@ ) {
        my $error = $@;
        $error =~ s! at .+$/!!;
        # probably don't want to use that error message directly
        $self->add_error( "Invalid date ([_1])", "$error" );
        return;
    }

    $self->value( $dt );

    1;
}

sub fif_value {
    my $self = shift;

    return unless $self->value;

    my $name = $self->name;
    my $dt = $self->value;
    my %hash;
    for my $sub ( 'month', 'day', 'year', 'hour', 'minute' ) {

        $hash{ $name . '.' . $sub } = sprintf( '%02d', $dt->$sub );
    }

    return %hash;
}


1;

