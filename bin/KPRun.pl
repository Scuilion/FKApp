#!perl

use strict;
use warnings;
use feature ':5.10';

use Devel::Dwarn;

use Device::CoMedia::C328_7640::Module;
use Device::CoMedia::C328_7640::Configuration::Constants;

my $cam_interface = Device::CoMedia::C328_7640::Module->new(comm_port=>'COM4');
#Dwarn $cam_interface->commands->configuration();
#$cam_interface->change_color_type(  CT_4_B_GRAY);
#$cam_interface->change_preview_res(SMALL);
#$cam_interface->change_jpeg_res(LARGE);
#$cam_interface->change_picture_type(PREVIEW_PIC);
#$cam_interface->change_snapshot_type(COMPRESSED);
#$cam_interface->set_package_size(63);
#$cam_interface->set_baudrate(BAUD_38400);
#Dwarn $cam_interface->commands->configuration();
#$cam_interface->reset_system();
#$cam_interface->soft_rest();

if($cam_interface->sync_cam()){
    #sleep(3);
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


