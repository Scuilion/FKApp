package Device::CoMedia::C328_7640::Commands;

use feature ':5.10';

use Moose;
use Devel::Dwarn;

use Device::CoMedia::C328_7640::Configuration::Exceptions;
use Device::CoMedia::C328_7640::Configuration::Constants;

has 'configuration' => (
      traits    => ['Hash'],
      is        => 'rw',
      isa       => 'HashRef[Str]',
      default   => sub  {{color_type           => "07",
                        preview_resolution    => "07",
                        jpeg_resolution       => "07",
                        picture_type          => "01",
                        snapshot_type         => "00",
                        package_size          => "512",
                        baudrate              => "115200", } },
      handles   => {
          set_option     => 'set',
          get_option     => 'get',
          has_no_options => 'is_empty',
          num_options    => 'count',
          delete_option  => 'delete',
          pairs          => 'kv',
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
    DATA()              => \&data_0A,
    SYNC()              => \&sync_0D,
    ACK()               => \&ack_0E,
    NAK()               => \&nak_0F,
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
sub snapshot_05{
    my ($self, $para_list)=@_;
    return 'AA'.'05'.$self->configuration->{snapshot_type}
                     .'00'.'00'.'00';
}
sub set_package_size_06{
    my ($self, $para_list)=@_;
    return 'AA'.'06'.'08'
               .sprintf("%02x", $self->configuration->{package_size}%256)
               .sprintf("%02x", $self->configuration->{package_size}/256)
               .'00';
}
sub get_picture_04{
    my ($self, $para_list)=@_;
    return 'AA'.'04'
                  .$self->configuration->{picture_type}
                  .'00'.'00'.'00';
}
sub sync_0D{
    my ($self, $para_list)=@_;
    return 'AA'.'0D'.'00'.'00'.'00'.'00';
}
sub ack_0E{
    my ($self, $para_list)=@_;
    Dwarn $para_list;
    return 'AA'.'0E'.$para_list->{Parameter1}.$para_list->{Parameter2}
                    .$para_list->{Parameter3}.$para_list->{Parameter4};
}

no Moose;
__PACKAGE__->meta->make_immutable();
1;
