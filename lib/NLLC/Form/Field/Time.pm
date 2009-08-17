package NLLC::Form::Field::Time;

use strict;
use warnings;
use base 'Form::Processor::Field';

sub validate
{
   my $field = shift;

   return unless $field->SUPER::validate;

   my ($time, $am_pm) = split / /, $field->input;
   my ($hour, $minutes) = split /:/, $time;
   unless ($am_pm)
   {
      $am_pm = 'am' if ($hour > 8);
      $am_pm = 'pm' if ($hour <= 8);
      $field->input($field->input . " " . $am_pm);
   } 
   if ($minutes > 59)
   {
      return $field->add_error('Invalid time');
   }
   return 1;   
}

1;
