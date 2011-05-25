#!perl 

use warnings;
use strict;
use feature ':5.10';

use Test::More;
use Test::Deep; 
use Devel::Dwarn;
use Device::CoMedia::C328_7640::Module;
use Device::CoMedia::C328_7640::Configuration::Constants;

my $cam_interface = Device::CoMedia::C328_7640::Module->new(comm_port=>'nada');

subtest 'default_values' => sub{
is("1","1", "todo");
};
done_testing();
