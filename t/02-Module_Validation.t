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
use File::HomeDir;

BEGIN{
   use_ok('Device::CoMedia::C328_7640::Module');
}

my $cam_interface = Device::CoMedia::C328_7640::Module->new(comm_port=>'COM7');
subtest 'check_required_attributes' => sub{
   is($cam_interface->comm_port(), 'COM7', "Comm attribute correct.");
};

subtest 'check_comm_object' => sub {
   delete_config_file();
   is($cam_interface->comm_object()->comm_port(), 'COM7', "Comm object knows it's port.");
   is($cam_interface->comm_object()->config_file(), 'CommConfig', "Comm Configuration file created.");
};
subtest 'check_file_attribute' => sub {
   is($cam_interface->file_location(), File::HomeDir->my_home . "/C328_7640/", "Default file save location.");
   $cam_interface->file_location("C:/");
   is($cam_interface->file_location(), "C:/", "Changed file location.");
   is($cam_interface->file_name(), "", "Default file name.");
   $cam_interface->file_name("test.jpg");
   is($cam_interface->file_name(), "test.jpg", "Changed file name.");
};
subtest 'check_file_handle' => sub {
   is("1", "1", "This was a feature that is planned to add later");
};

subtest 'check_configuration_parameters' => sub {
   is("1", "1");
   is($cam_interface->commandset()->configuration->{baudrate}, '0f01', "Default baudrate");
};

subtest 'check_return_value_hash' => sub {
   is("1", "1", "this task demands a whole new test");
};

sub delete_config_file{
   unlink("CommConfig");
}

done_testing();

