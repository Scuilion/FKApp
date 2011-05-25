#!perl

#use strict;
use warnings;
use feature ':5.10';

use Devel::Dwarn;

use Device::CoMedia::C328_7640::Module;
use Device::CoMedia::C328_7640::Configuration::Constants;
use FileHandle;

my $file_handle_o=FileHandle->new;

my $cam_interface = Device::CoMedia::C328_7640::Module->new(comm_port=>'COM7');#, file_handle=>$file_handle);

$cam_interface->sync();
my $test = $cam_interface->snapshot();

if($test->{error} eq "00"){
   Dwarn 'got to end of program with no errors';
}
else{
    Dwarn 'error getting picture';
}
1;


