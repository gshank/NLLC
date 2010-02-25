package NLLC::Form::Field::Time;

use Moose;
extends 'HTML::FormHandler::Field';

sub validate
{
   my $field = shift;

   my ($time, $am_pm) = split / /, $field->value;
   my ($hour, $minutes) = split /:/, $time;
   $am_pm = uc($am_pm) if $am_pm;
   unless ($am_pm && ( $am_pm =~ 'AM' || $am_pm =~ 'PM'))
   {
      $am_pm = 'AM' if ($hour > 8);
      $am_pm = 'PM' if ($hour <= 8);
   } 
   my $new_time = sprintf("%02d:%02d %s", $hour, $minutes, $am_pm);
   $field->_set_value($new_time);
   if ($minutes > 59)
   {
      return $field->add_error('Invalid time');
   }
  
   return 1;   
}

1;
