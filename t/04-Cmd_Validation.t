#!perl 

use warnings;
use strict;
use feature ':5.10';

use Test::More;
use Test::Deep;
use Devel::Dwarn;
use Storable qw(dclone);

use Device::CoMedia::C328_7640::CommandSet;
use Device::CoMedia::C328_7640::Configuration::Constants;

my $commands = Device::CoMedia::C328_7640::CommandSet->new();

my ($got_cmds, $exp_cmds, $test_name) = make_commands($commands);

for(my $i=0; $i < scalar @$got_cmds; $i++){
   is_deeply( $got_cmds->[$i], $exp_cmds->[$i], $test_name->[$i]);
}
plan tests=>scalar @$got_cmds;
done_testing();


sub make_commands{
   my $cmd_obj = shift;
   my (@exp_cmds, @got_cmds, @test_name);

   #initialize command 01
   push( @got_cmds , $cmd_obj->send_command( {ID=>INITIAL()}));   
   push( @exp_cmds, "AA0100".$cmd_obj->configuration->{color_type}
                           .$cmd_obj->configuration->{preview_resolution}
                           .$cmd_obj->configuration->{jpeg_resolution});
   push( @test_name, "01 command");

   #get picture command 04
   push( @got_cmds , $cmd_obj->send_command( {ID=>GET_PICTURE()}));   
   push( @exp_cmds, "AA04" .$cmd_obj->configuration->{snapshot_type}
                           ."000000");
   push( @test_name, "04 command");
   return (\@got_cmds, \@exp_cmds, \@test_name);

   #take snapshot command 05
   
   
   
   #set package size command 06
   

   
   #set baudrate command 07
   
   
   
   #reset command 08
   
   
   
   #power off command 09
   
   
   
   #data command 0A
   
   
   
   #sync command 0D
   
   
   
   #ack command 0E
   
   
   
   #nak command 0F
   
   
   
   #set light frequency command 13
   return (\@got_cmds, \@exp_cmds, \@test_name);
}
1;
