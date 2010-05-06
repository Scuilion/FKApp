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
   push( @exp_cmds, "AA04" .$cmd_obj->configuration->{picture_type}
                           ."000000");
   push( @test_name, "04 command");

   #take snapshot command 05
   push( @got_cmds , $cmd_obj->send_command( {ID=>SNAPSHOT()}));   
   push( @exp_cmds, "AA05" .$cmd_obj->configuration->{snapshot_type}
                           ."000000");
   push( @test_name, "05 command");
   
   #set package size command 06
   push( @got_cmds , $cmd_obj->send_command( {ID=>SET_PACKAGE_SIZE()}));   
   push( @exp_cmds, "AA0608" .$cmd_obj->low_byte()
                              .$cmd_obj->high_byte()
                           ."00");
   push( @test_name, "06 command");

   #set baudrate command 07
   push( @got_cmds , $cmd_obj->send_command( {ID=>SET_BAUDRATE()}));   
   push( @exp_cmds, "AA07" .$cmd_obj->configuration->{baudrate}
                           ."0000");
   push( @test_name, "07 command");
   
   #reset command 08
   push( @got_cmds , $cmd_obj->send_command( {ID=>RESET()}));   
   push( @exp_cmds, "AA08" .$cmd_obj->configuration->{reset_type}
                           ."000000");
   push( @test_name, "08 command");

   #power off command 09
   push( @got_cmds , $cmd_obj->send_command( {ID=>POWER_OFF()}));   
   push( @exp_cmds, "AA0900000000");
   push( @test_name, "09 command");

   #sync command 0D
   push( @got_cmds , $cmd_obj->send_command( {ID=>SYNC()}));   
   push( @exp_cmds, "AA0D00000000");
   push( @test_name, "0D command");

   #ack command 0E
   push( @got_cmds , $cmd_obj->send_command( {ID=>ACK(), Parameter1 => '00' , Parameter2 => '01',
                                                         Parameter3 => '02' , Parameter4 => '03' }));   
   push( @exp_cmds, "AA0E00010203");
   push( @test_name, "0E command");
   
   #set light frequency command 13
   push( @got_cmds , $cmd_obj->send_command( {ID=>LIGHT_FREQUENCE()}));   
   push( @exp_cmds, "AA13" .$cmd_obj->configuration->{freq_value}
                           ."000000");
   push( @test_name, "13 command");

   return (\@got_cmds, \@exp_cmds, \@test_name);
}
1;
