package Device::CoMedia::C328_7640::CommandProtocol;

use feature ':5.10';

use Moose;
use Devel::Dwarn;
use Time::HiRes qw(usleep);

use Device::CoMedia::C328_7640::Configuration::Constants;

has comm_object => (
    is => 'ro',
    isa => 'Device::CoMedia::C328_7640::Communication::Serial::RS232::CommController',
    required=>1,
);

has attempts => (
   is => 'rw',
   isa => 'Int',
   required=> 1,
);

has commands => (
    is => 'ro',
    isa => 'Device::CoMedia::C328_7640::CommandSet',
    #builder => '_build_command_list',
    required=>1,
    );

has utime => (
   is => 'rw', 
   isa => 'Int',
   required => 1,
   default => 70000,
);

before 'snd_rec_cmd' => sub{
   my $self=shift;
   if(BAUD_115200 eq $self->commands->configuration->{baudrate}){
      Dwarn 'baud set at 115200';
      $self->utime(70000);
   }
};
#BAUD_7200 BAUD_9600 BAUD_14400 BAUD_19200 BAUD_28800 BAUD_38400 BAUD_57600 

sub snd_rec_cmd{
   my $self=shift;
   for ( 0..$self->attempts){
      Dwarn 'testing ' . $_;
      Dwarn $self->commands;
      $self->comm_object->w_output('something');
      usleep($self->utime);
   }
}
no Moose;
__PACKAGE__->meta->make_immutable();
1;
