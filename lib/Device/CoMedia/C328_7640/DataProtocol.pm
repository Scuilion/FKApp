package Device::CoMedia::C328_7640::DataProtocol;

use Devel::Dwarn;
use Moose::Role;

sub snd_rec_data{
   my $self = shift;
   my $commandset = shift;
   my $param = shift;
   Dwarn 'inside of my roles';

}

#no Moose;
#__PACKAGE__->meta->make_immutable();
1;
