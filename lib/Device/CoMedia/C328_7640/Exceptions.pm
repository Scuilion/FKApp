package CoMedia::C328::Exceptions;

use strict;
use warnings;

use Exception::Class
      ( 
        'Configuration::Exceptions::NoFileFound'=>{
            fields => ['response'],
        },
        'Configuration::Exceptions::SeverNameNotFound'=>{
            fields => ['response'],
        },
        'Configuration::Exceptions::CompNameNotFound'=>{
            fields => ['response'],
        },
        'Configuration::Exceptions::COMMNameNotFound'=>{
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

class_type 'Configuration::Exceptions::NoFileFound';
class_type 'Configuration::Exceptions::SeverNameNotFound';
class_type 'Configuration::Exceptions::CompNameNotFound';
class_type 'Configuration::Exceptions::COMMNameNotFound';


no Moose::Util::TypeConstraints;
1;
