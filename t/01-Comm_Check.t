#!perl

use strict;
use warnings;
use feature ':5.10';

use Test::More;
use Devel::Dwarn;

use Device::CoMedia::C328_7640::Communication::Serial::RS232::CommController;

#this tests that there is a comm port on the current maching
#it assumes that the comm port is COM1
if ($ENV{COMM_TEST}){
   my $comm_controller = Device::CoMedia::C328_7640::Communication::Serial::RS232::CommController->new(comm_port=>$ENV{COMM_TEST});
   ok(defined $comm_controller , 'CommController return something');
   plan tests=>1;
}
else{
   plan skip_all=>'Enviromental variable \'COMM_TEST\' not set.';
}


done_testing();
