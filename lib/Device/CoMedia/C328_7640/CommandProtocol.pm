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

has commandset => (
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

has command => (
   is => 'rw',
   isa => 'Str',
   required => 1,
);

has para => (
   is => 'rw',
   isa => 'HashRef[Str]',
   default => sub {{ p1 => '00',
                     p2 => '00',
                     p3 => '00',
                     p4 => '00',
                     }},
   handles => {
                set_option => 'set',
                get_option => 'get',
                },
);
;
before qw(snd_rec_resp) => sub{
      Dwarn 'baud set at 115200';
      $self->utime(70000);
   }
};
#BAUD_7200 BAUD_9600 BAUD_14400 BAUD_19200 BAUD_28800 BAUD_38400 BAUD_57600 

sub snd_rec{
   my $self = shift;

}

sub snd_rec_resp{
   my $self=shift;
   my $input;
   my $p = $self->para;
   my $attempts= 0; 

   ATTEMPT: for ( 0..$self->attempts){
      last ATTEMPT if($attempts >2);
      $self->comm_object->w_output($self->commandset->send_command({id=>$self->command,
                                                                    parameter1 => $p->{p1},
                                                                    parameter2 => $p->{p2},
                                                                    parameter3 => $p->{p3},
                                                                    parameter4 => $p->{p4},
                                                                    }));
      usleep($self->utime);
      $input = $self->comm_object->r_input();
      if((my $id, $p->{p1},$p->{p2},$p->{p3},$p->{p4}) = 
          $input =~ /..(..)(..)(..)(..)(..)/){
          if( $id eq '0f'){#nak
            $attempts++;
            redo ATTEMPT; 
          }
          $self->comm_object->w_output($self->commandset->send_command({ID=>ACK(),
                                                                        Parameter1=> $p->{p1},
                                                                        Parameter2=> $p->{p2},
                                                                        Parameter3=> $p->{p3},
                                                                        Parameter4=> $p->{p4},
                                                                        }));
         last;
      }
   }
}

no Moose;
__PACKAGE__->meta->make_immutable();
1;
