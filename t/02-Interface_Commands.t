#!perl 

use warnings;
use strict;
use feature ':5.10';

use Test::More;
use Test::Deep; 
use Devel::Dwarn;
use Storable qw(dclone);
use Device::CoMedia::C328_7640::Module;
use Device::CoMedia::C328_7640::Configuration::Constants;

my $cam_interface = Device::CoMedia::C328_7640::Module->new(comm_port=>'COM1');

my ($config_array_expected, $config_array_got, $test_names) = create_arrays();

for( my $i=0; $i< scalar @$config_array_got ; $i++){
   is_deeply($config_array_got->[$i], $config_array_expected->[$i], @$test_names[$i]); 
}
plan tests=>scalar @$config_array_got;


done_testing();

sub create_arrays{
   my ($config_array_expected, $config_array_got, $test_names);
   my $current_config = $cam_interface->commands->configuration();

   #preview resolution test
   $cam_interface->change_preview_res(SMALL);
   push( @{$config_array_got}, dclone($cam_interface->commands->configuration()));
   $current_config->{preview_resolution} = '01';
   push(@{$config_array_expected}, dclone($current_config));
   push(@{$test_names}, 'change preview res, small');

   $cam_interface->change_preview_res(MEDIUM);
   push( @{$config_array_got}, dclone($cam_interface->commands->configuration()));
   $current_config->{preview_resolution} = '03';
   push(@{$config_array_expected}, dclone($current_config));
   push(@{$test_names}, 'change preview res, medium');

   #color type test
   $cam_interface->change_color_type(CT_2_B_GRAY);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{color_type} = '01';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change color type, 2 bit gray');

   $cam_interface->change_color_type(CT_4_B_GRAY);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{color_type} = '02';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change color type, 4 bit gray');

   $cam_interface->change_color_type(CT_8_B_GRAY);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{color_type} = '03';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change color type, 8 bit gray');

   $cam_interface->change_color_type(CT_12_B_COLOR);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{color_type} = '05';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change color type, 12 bit color');

   $cam_interface->change_color_type(CT_16_B_COLOR);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{color_type} = '06';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change color type, 16 bit color');

   $cam_interface->change_color_type(CT_JPEG);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{color_type} = '07';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change color type, JPEG');

   #change jpeg resolution test
   $cam_interface->change_jpeg_res(SMALL);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{jpeg_resolution} = '01';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change preview res, small');

   $cam_interface->change_jpeg_res(MEDIUM);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{jpeg_resolution} = '03';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change preview res, small');

   $cam_interface->change_jpeg_res(LARGE);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{jpeg_resolution} = '05';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change jpeg res, large');

   $cam_interface->change_jpeg_res(EX_LARGE);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{jpeg_resolution} = '07';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change jpeg res, extra large');

   #changing picture type test
   $cam_interface->change_picture_type(SNAPSHOT_PIC);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{picture_type} = '01';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change picture type, snapshot');
   
   $cam_interface->change_picture_type(PREVIEW_PIC);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{picture_type} = '02';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change picture type, preview pic');

   $cam_interface->change_picture_type(JPEG_PIC);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{picture_type} = '05';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change pciture type, jpeg pic');

   #changing snapshot type test
   $cam_interface->change_snapshot_type(COMPRESSED);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{snapshot_type} = '00';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change snapshot type, compressed');

   $cam_interface->change_snapshot_type(UNCOMPRESSED);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{snapshot_type} = '01';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change sanpshot type, uncompressed');

   #set package size
   $cam_interface->set_package_size('226');
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{package_size} = '226';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'changing the package size, 226');

   #set baudrate
   $cam_interface->set_baudrate(BAUD_7200);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{baudrate} = 'ff01';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'changing baud rate, 7200');

   $cam_interface->set_baudrate(BAUD_9600);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{baudrate} = 'bf01';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'changing baud rate, 9600');
   
   $cam_interface->set_baudrate(BAUD_14400);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{baudrate} = '7f01';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'changing baud rate, 14000');
   
   $cam_interface->set_baudrate(BAUD_19200);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{baudrate} = '5f01';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'changing baud rate, 19200');
   
   $cam_interface->set_baudrate(BAUD_28800);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{baudrate} = '3f01';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'changing baud rate, 28800');
   
   $cam_interface->set_baudrate(BAUD_38400);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{baudrate} = '2f01';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'changing baud rate, 38400');
   
   $cam_interface->set_baudrate(BAUD_57600);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{baudrate} = '1f01';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'changing baud rate, 57600');
   
   $cam_interface->set_baudrate(BAUD_115200);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{baudrate} = '0f01';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'changing baud rate, 115200');
   
   #change light frequency 
   $cam_interface->change_light_freq(FREQ_50);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{freq_value} = '00';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change light freq, 50 hz');

   $cam_interface->change_light_freq(FREQ_60);
   push( @$config_array_got, dclone($cam_interface->commands->configuration()));
   $current_config->{freq_value} = '01';
   push(@$config_array_expected, dclone($current_config));
   push(@$test_names, 'change light freq, 60 hz');

 return ($config_array_expected, $config_array_got, $test_names);
  
}



