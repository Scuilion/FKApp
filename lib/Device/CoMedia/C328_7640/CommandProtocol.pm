package Device::CoMedia::C328_7640::CommandProtocol;

use feature ':5.10';

use Moose;
use Devel::Dwarn;
use Time::HiRes qw(usleep);
use POSIX qw(ceil);

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

has image_size=>(
   is => 'rw',
   isa => 'Int',
   default => 2,
); 

has command => (
   is => 'rw',
   isa => 'Str',
   required => 1,
);

#has para => (
#   traits => ['Hash'],
#   is => 'rw',
#   isa => 'HashRef[Str]',
#   default => sub {{ p1 => '',
#                     p2 => '',
#                     p3 => '',
#                     p4 => '',
#                     error => '00',
#                     }},
#   handles => {
#                set_option => 'set',
#                get_option => 'get',
#                },
#);

around qw(snd_rec_resp) => sub{
   my $orig = shift;
   my $self=shift;
   my $commandset = shift;
   my $param = shift;

   if(BAUD_115200 eq $commandset->configuration->{baudrate}){
      $self->utime(60000);
   }
   return $self->$orig($commandset, $param);
};
#BAUD_7200 BAUD_9600 BAUD_14400 BAUD_19200 BAUD_28800 BAUD_38400 BAUD_57600 

sub snd_rec_resp{
   my $self = shift;
   my $commandset = shift;
   my $param = shift;
   
   my $input='';
   
   my $attempts= 0; 
   my $id;
   my $extra;

   REPEAT: for ( 0..$self->repeats){#numbers of times to send and rec the same cmd
      last if($attempts >2);#the unit has responed with a nak too many times
      $self->comm_object->w_output($commandset->send_command({ID=>$self->command,
                                                                    }));
      
      usleep($self->utime);#expected response time from unit
      for ( 0..2){#times to try and read
         $input .= $self->comm_object->r_input();
         if($input =~ /aa(..)(..)(..)(..)(..)(.*)/){
            $id = $1;
            #$self->set_option(p1 => $2);
            #$self->set_option(p2 => $3);
            #$self->set_option(p3 => $4);
            #$self->set_option(p4 => $5);
            $param->{P1}=$2;
            $param->{P2}=$3;
            $param->{P3}=$4;
            $param->{P4}=$5;
            $extra=$6; 

            if( $id eq '0f'){#nak
               $param->{error}=$3;
               return $param;
            }
            
            if(my ( $i0, $i1, $i2) =  
               $extra =~ /aa0a..(..)(..)(..).*/){#this is the metadata for the picture lengh
               my $image_size = ceil(hex($i2.$i1.$i0)/506);
               Dwarn 'inside inside', $image_size;
            }

            if ($self->respond){
               $self->ack_it($commandset, $param);
            }
            return $param;
          }
      }
   }
   return {error=>"A0"};
}

sub ack_it{
   my $self = shift;
   my $cmdset = shift;
   my $Param= shift;
   Dwarn 'ack it man';
   $self->comm_object->w_output( $cmdset->send_command( {ID=> ACK(),
                                                         Parameter1=>$Param->{'p1'},
                                                         Parameter2=>$Param->{'p2'},
                                                         Parameter3=>$Param->{'p3'},
                                                         Parameter4=>$Param->{'p4'},
                                                         }));
}

no Moose;
__PACKAGE__->meta->make_immutable();
1;
