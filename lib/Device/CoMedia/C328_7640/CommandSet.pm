#Generates the commands as defined by the COMedia datasheet
package Device::CoMedia::C328_7640::CommandSet;

use feature ':5.10';

use Moose;
use Devel::Dwarn;

use Device::CoMedia::C328_7640::Configuration::Exceptions;
use Device::CoMedia::C328_7640::Configuration::Constants;

has 'parameter' => (
      traits => ['Hash'],
      is => 'rw',
      isa => 'HashRef[Str]',
      default => sub {{Parameter1 => '00',
                       Parameter2 => '00',
                       Parameter3 => '00',
                       Parameter4 => '00',
                       }},
      handles => {
         set_param => 'set',
         get_param => 'get',
         },
);
                  
has 'configuration' => (
      traits    => ['Hash'],
      is        => 'rw',
      isa       => 'HashRef[Str]',
      default   => sub  {{color_type           =>CT_JPEG(), 
                        preview_resolution    => EX_LARGE(),
                        jpeg_resolution       => EX_LARGE(),
                        picture_type          => SNAPSHOT_PIC(),
                        snapshot_type         => COMPRESSED(),
                        package_size          => 512,
                        baudrate              => BAUD_115200(),
                        freq_value            => FREQ_50() ,
                        reset_type            => R_STATE() } },
      handles   => {
          set_config     => 'set',
          get_config     => 'get',
      },

  );

my $command_dispatch_table= {
    INITIAL()           => \&initialize_01,
    GET_PICTURE()       => \&get_picture_04,
    SNAPSHOT()          => \&snapshot_05,
    SET_PACKAGE_SIZE()  => \&set_package_size_06,
    SET_BAUDRATE()      => \&set_baudrate_07,
    RESET()             => \&reset_module_08,
    POWER_OFF()         => \&power_off_09,
    SYNC()              => \&sync_0D,
    ACK()               => \&ack_0E,
    LIGHT_FREQUENCE()   => \&light_frequency_13,
};

sub send_command{
    my ($self, $parameter_list)=@_;
    
    $parameter_list->{ID} =~ /([[:xdigit:]]+)/;
    if( my $function = $command_dispatch_table->{$1}){
        return $self->$function($parameter_list);
    }
    else{
        Dwarn 'There is not method for this command: <',$parameter_list,'>!';
        return undef;
    }
}

sub initialize_01{
    my ($self, $para_list)=@_;
    return 'AA'.'01'.'00'.$self->configuration->{color_type}
                     .$self->configuration->{preview_resolution}
                     .$self->configuration->{jpeg_resolution};
}

sub get_picture_04{
    my ($self, $para_list)=@_;
    return 'AA'.'04'
                  .$self->configuration->{picture_type}
                  .'00'.'00'.'00';
}

sub snapshot_05{
    my ($self, $para_list)=@_;
    return 'AA'.'05'.$self->configuration->{snapshot_type}
                     .'00'.'00'.'00';
}

sub set_package_size_06{
    my ($self, $para_list)=@_;
    return 'AA'.'06'.'08'
               .$self->low_byte()
               .$self->high_byte()
               .'00';
}

sub high_byte{
   my $self = shift;
   return sprintf("%02x", $self->configuration->{package_size}/256);
}

sub low_byte{
   my $self = shift;
   return sprintf("%02x", $self->configuration->{package_size}%256);
}

sub set_baudrate_07{
   my $self = shift;
   return 'AA07' . $self->configuration->{baudrate}."0000";              
}

sub reset_module_08{
   my $self = shift;
   return 'AA08' . $self->configuration->{reset_type}."000000";              
}
sub power_off_09{
   return 'AA0900000000';
}

sub sync_0D{
    my ($self, $para_list)=@_;
    return 'AA'.'0D'.'00'.'00'.'00'.'00';
}

sub ack_0E{
    my $self =shift;
    #Dwarn 'parms here' , $para_list , 'parms end here';
    return 'AA'.'0E'.$self->parameter->{Parameter1}
                     .$self->parameter->{Parameter2}
                     .$self->parameter->{Parameter3}
                     .$self->parameter->{Parameter4};

}

sub light_frequency_13{
   my $self= shift;
   return 'AA13'.$self->configuration->{freq_value}.'000000';
}

no Moose;
__PACKAGE__->meta->make_immutable();
1;
