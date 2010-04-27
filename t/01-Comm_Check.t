#!perl

use strict;
use warnings;
use feature ':5.10';

use Test::More tests => 1;
use Devel::Dwarn;

use Device::CoMedia::C328_7640::Communication::Serial::RS232::CommController;

#this tests that there is a comm port on the current maching
#it assumes that the comm port is COM1

my $comm_controller = Device::CoMedia::C328_7640::Communication::Serial::RS232::CommController->new(comm_port=>'COM3');

ok(defined $comm_controller , 'Did CommController return something');

done_testing();
