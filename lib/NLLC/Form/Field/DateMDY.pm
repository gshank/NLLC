package NLLC::Form::Field::DateMDY;

use strict;
use warnings;
use base 'Form::Processor::Field';

sub validate
{

   my $field = shift;

   return unless $field->SUPER::validate;

   my ($month, $day, $year) = split /\//, $field->input;
   # check for digits
   unless( $month =~ /^\d+$/ && $day =~ /^\d+$/ && $year =~ /^\d+$/ )
   {
      return $field->add_error( 'Invalid date');
   } 
   # check for the right digits
   unless ($month > 0 && $month < 13)
   {
      $field->add_error( 'Month is not valid' );
   }
   unless ($day > 0 && $day < 32)
   {
      $field->add_error( 'Day is not valid' );
   }
   unless ($year > 2007 && $year < 2020 )
   {
      $field->add_error( 'Year is not vaid' );
   }
   return if $field->has_error;
   return 1;
}

1;
