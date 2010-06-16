package Device::CoMedia::C328_7640::DataProtocol;

use Devel::Dwarn;
use Moose::Role;
use Time::HiRes qw(usleep);

use Device::CoMedia::C328_7640::Configuration::Constants;

sub snd_rec_data{
   my $self = shift;
   my $commandset = shift;
   my $param = shift;
   my $packet_qty = shift;
   
my $command;
open(my $file, '>>', 'C:\dump\testing');
binmode $file;
   for my $ack_counter(0..$packet_qty+1){
   Dwarn $ack_counter;
      $command='AA'.'0E'.'00'.'00'.
                sprintf( "%02x", $ack_counter).
                sprintf( "%02x", 0);
                                            Dwarn $command;
        $self->comm_object->w_output($command);
        usleep(60000);
        my $image_data = $self->comm_object->r_input();
        if( $image_data ne ''){
           $image_data = substr($image_data, 8, -4);
           print {$file} join '', map{ chr hex $_} grep($_ ne "", split /(..)/ , $image_data);
        }
   }
   close($file);
}

#no Moose;
#__PACKAGE__->meta->make_immutable();
1;
