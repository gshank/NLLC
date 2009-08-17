package ICal::Types;

use Moose;
use Moose::Util::TypeConstraints;

use DateTime;
use DateTime::Duration;
use DateTime::Format::ICal;

subtype 'DateTime' => as 'Object' => where { $_->isa('DateTime') };
subtype 'DTDuration' => as 'Object' => where { $_->isa('DateTime::Duration') };
