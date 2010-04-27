#!perl 

use warnings;
use strict;
use feature ':5.10';

use Test::More;
use Test::Deep; 
use Devel::Dwarn;
use Device::CoMedia::C328_7640::Module;
use Device::CoMedia::C328_7640::Configuration::Constants;

my $cam_interface = Device::CoMedia::C328_7640::Module->new(comm_port=>'COM4');

my ($config_array_expected, $config_array_got, $test_names) = create_arrays();


for( my $i=0; $i< scalar @$config_array_got ; $i++){
   is_deeply(@$config_array_got[$i], @$config_array_expected[$i], @$test_names[$i]); 
}

plan tests=>scalar @$config_array_got;

sub create_arrays{
   my ($config_array_expected, $config_array_got, $test_names);
   my $current_config = $cam_interface->commands->configuration();

Dwarn $current_config;
   $cam_interface->change_preview_res(SMALL);
   push( @{$config_array_got}, $cam_interface->commands->configuration());
   $current_config->{preview_resolution} = '01';
   push(@{$config_array_expected}, $current_config);
   push(@{$test_names}, 'change preview res, small');

   $cam_interface->change_preview_res(MEDIUM);
   push( @{$config_array_got}, $cam_interface->commands->configuration());
   $current_config->{preview_resolution} = 'e2';
   push(@{$config_array_expected}, $current_config);
   push(@{$test_names}, 'change preview res, medium');

   $cam_interface->change_color_type(CT_2_B_GRAY);
   push( @$config_array_got, $cam_interface->commands->configuration());
   $current_config->{color_type} = '01';
   push(@$config_array_expected, $current_config);
   push(@$test_names, 'change color type, 2 bit gray');

   $cam_interface->change_color_type(CT_4_B_GRAY);
   push( @$config_array_got, $cam_interface->commands->configuration());
   $current_config->{color_type} = '03';
   push(@$config_array_expected, $current_config);
   push(@$test_names, 'change color type, 4 bit gray');

   $cam_interface->change_color_type(CT_8_B_GRAY);
   push( @$config_array_got, $cam_interface->commands->configuration());
   $current_config->{color_type} = '03';
   push(@$config_array_expected, $current_config);
   push(@$test_names, 'change color type, 8 bit gray');

   $cam_interface->change_color_type(CT_12_B_COLOR);
   push( @$config_array_got, $cam_interface->commands->configuration());
   $current_config->{color_type} = '05';
   push(@$config_array_expected, $current_config);
   push(@$test_names, 'change color type, 12 bit color');

   $cam_interface->change_color_type(CT_16_B_COLOR);
   push( @$config_array_got, $cam_interface->commands->configuration());
   $current_config->{color_type} = '06';
   push(@$config_array_expected, $current_config);
   push(@$test_names, 'change color type, 16 bit color');

   $cam_interface->change_color_type(CT_JPEG);
   push( @$config_array_got, $cam_interface->commands->configuration());
   $current_config->{color_type} = '07';
   push(@$config_array_expected, $current_config);
   push(@$test_names, 'change color type, JPEG');

   $cam_interface->change_jpeg_res(SMALL);
   push( @$config_array_got, $cam_interface->commands->configuration());
   $current_config->{jpeg_resolution} = '01';
   push(@$config_array_expected, $current_config);
   push(@$test_names, 'change preview res, small');

   $cam_interface->change_jpeg_res(MEDIUM);
   push( @$config_array_got, $cam_interface->commands->configuration());
   $current_config->{jpeg_resolution} = '02';
   push(@$config_array_expected, $current_config);
   push(@$test_names, 'change preview res, small');

   $cam_interface->change_jpeg_res(LARGE);
   push( @$config_array_got, $cam_interface->commands->configuration());
   $current_config->{jpeg_resolution} = '05';
   push(@$config_array_expected, $current_config);
   push(@$test_names, 'change jpeg res, large');

   $cam_interface->change_jpeg_res(EX_LARGE);
   push( @$config_array_got, $cam_interface->commands->configuration());
   $current_config->{jpeg_resolution} = '07';
   push(@$config_array_expected, $current_config);
   push(@$test_names, 'change jpeg res, extra large');

   return ($config_array_expected, $config_array_got, $test_names);
}


