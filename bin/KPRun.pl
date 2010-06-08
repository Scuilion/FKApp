#!perl

use strict;
use warnings;
use feature ':5.10';

use Devel::Dwarn;

use Device::CoMedia::C328_7640::Module;
use Device::CoMedia::C328_7640::Configuration::Constants;

my $cam_interface = Device::CoMedia::C328_7640::Module->new(comm_port=>'COM4');

my $test = $cam_interface->snapshot();

Dwarn 'what\'s in test', $test;

if($test->{error} ne ""){
   Dwarn 'got to end of program with no errors';
}
else{
    Dwarn 'no sync';
}
1;


