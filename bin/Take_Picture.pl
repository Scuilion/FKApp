#!perl

use strict;
use warnings;
use feature ':5.10';

use Device::CoMedia::C328_7640::Module;
use Time::Local;
use Devel::Dwarn;

my $cam_interface = Device::CoMedia::C328_7640::Module->new(comm_port=>'COM7');

my $current_time;
my $taken_time=0; 
my $file_name=0;
Dwarn $current_time;

while(1){
   $current_time = time; 
   if($current_time > $taken_time + 5){
      $cam_interface->sync();
      $cam_interface->snapshot();
      $taken_time = time;
      $file_name++;
      $cam_interface->file_name($file_name);
   }
}

1;

