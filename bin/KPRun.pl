#!perl

use strict;
use warnings;
use feature ':5.10';

use Devel::Dwarn;

use Device::CoMedia::C328_7640::Module;
use Device::CoMedia::C328_7640::Configuration::Constants;

my $cam_interface = Device::CoMedia::C328_7640::Module->new(comm_port=>'COM1');

$cam_interface->sync_test();

die;

if($cam_interface->sync_cam()){
    if($cam_interface->take_picture()){
        Dwarn 'got a picture';
    }
    else{
        Dwarn 'failed to get a picture';
    }
}
else{
    Dwarn 'no sync';
}
1;


