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

has repeats => (
   is => 'rw',
   isa => 'Int',
   required=> 1,
);

has utime => (
   is => 'rw', 
   isa => 'Int',
   required => 1,
   default => 70000,
);

has respond=> (
   is => 'rw',
   isa => 'Bool',
   required => 1, 
   lazy => 1,
   default => 0,
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

around qw(snd_rec_resp) => sub{
   my $orig = shift;
   my $self=shift;
   my $commandset = shift;

   if(BAUD_115200 eq $commandset->configuration->{baudrate}){
      Dwarn 'baud set at 115200';
      $self->utime(70000);
   }
   return $self->$orig($commandset);
};
#BAUD_7200 BAUD_9600 BAUD_14400 BAUD_19200 BAUD_28800 BAUD_38400 BAUD_57600 

sub snd_rec_resp{#{{{
   my $self = shift;
   my $commandset = shift;
   my $input='';
   my $p = $self->para;
   my $attempts= 0; 

   REPEAT: for ( 0..$self->repeats){#numbers of times to send and rec the same cmd
      last if($attempts >2);#the unit responed with a nak too many times
      $self->comm_object->w_output($commandset->send_command({ID=>$self->command,
                                                                    }));
      
      usleep($self->utime);#expected response time from unit
      for ( 0..2){#times to try and read
         $input .= $self->comm_object->r_input();
         if((my $id, $p->{p1},$p->{p2},$p->{p3},$p->{p4}) = 
            $input =~ /..(..)(..)(..)(..)(..)/){

            if( $id eq '0f'){#nak
              $attempts++;
              redo REPEAT; 
            }
            if ($self->respond){
               $self->comm_object->w_output($commandset->send_command({ID=>ACK(),
                                                                             Parameter1=> $p->{p1},
                                                                             Parameter2=> $p->{p2},
                                                                             Parameter3=> $p->{p3},
                                                                             Parameter4=> $p->{p4},
                                                                            }));
            }
      #      last if($self->command eq SYNC());
            return   {Parameter1=> $p->{p1},
                     Parameter2=> $p->{p2},
                     Parameter3=> $p->{p3},
                     Parameter4=> $p->{p4},}

          }
      }
   }
   return 0;
}#}}}

no Moose;
__PACKAGE__->meta->make_immutable();
1;
