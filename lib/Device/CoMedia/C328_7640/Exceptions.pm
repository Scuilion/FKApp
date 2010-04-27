package Device::CoMedia::C328_7640::Exceptions;

use strict;
use warnings;

use Exception::Class
      ( 
        'Device::CoMedia::C328_7640::Exceptions::GenericCommError'=>{
            fields => ['response'],
        },

        #'AnotherException' =>
        #{ isa => 'MyException' },
        #
        #'YetAnotherException' =>
        #{ isa => 'AnotherException',
        #  description => 'These exceptions are related to IPC' },
        #
        #'ExceptionWithFields' =>
        #{ isa => 'YetAnotherException',
        #  fields => [ 'grandiosity', 'quixotic' ],
        #  alias => 'throw_fields',
        #},
      );
      
use Moose::Util::TypeConstraints;

class_type 'Device::CoMedia::C328_7640::Exceptions::GenericCommError';

no Moose::Util::TypeConstraints;
1;
