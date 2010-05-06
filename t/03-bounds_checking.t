#!perl

use warnings;
use strict;
use feature ':5.10';

use Test::More;
use Test::Deep; 
use Test::Exception;
use Devel::Dwarn;
use Storable qw(dclone);
use Device::CoMedia::C328_7640::Module;
use Device::CoMedia::C328_7640::Configuration::Constants;

my $cam_interface = Device::CoMedia::C328_7640::Module->new(comm_port=>'COM1');

ok($cam_interface->set_baudrate(BAUD_7200), 'check baudrate, 7200');
ok($cam_interface->set_baudrate(BAUD_9600), 'check baudrate, 9600');
ok($cam_interface->set_baudrate(BAUD_14400), 'check baudrate, 14400');
ok($cam_interface->set_baudrate(BAUD_19200), 'check baudrate, 19200' );
ok($cam_interface->set_baudrate(BAUD_28800), 'check baudrate, 28800');
ok($cam_interface->set_baudrate(BAUD_38400), 'check baudrate, 38400');
ok($cam_interface->set_baudrate(BAUD_57600), 'check baudrate, 57600');
ok($cam_interface->set_baudrate(BAUD_115200), 'check baudrate, 115200');
dies_ok{ $cam_interface->set_baudrate('12345')} 'check bad baudrate' ;

#check fencepost errors for set_package_size
dies_ok{$cam_interface->set_package_size(45)} 'check lower out of bounds';
dies_ok{$cam_interface->set_package_size(600)} 'check upper out of bounds';
ok($cam_interface->set_package_size(64),  'check lower fencepost');
ok($cam_interface->set_package_size(512), 'check upper fencepost');

#check for non valid baudrates
done_testing();
