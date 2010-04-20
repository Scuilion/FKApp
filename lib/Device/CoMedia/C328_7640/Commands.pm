package Device::CoMedia::C328_7640::Commands;

use feature ':5.10';

use Moose;
use Devel::Dwarn;

use Device::CoMedia::C328_7640::Configuration::Exceptions;
use Device::CoMedia::C328_7640::Configuration::Constants;

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
    return 'AA'.'01'.'00'.'06'.'07'.'07';
}
sub snapshot_05{
    my ($self, $para_list)=@_;
    return 'AA'.'05'.'01'.'00'.'00'.'00';
}
sub set_package_size_06{
    my ($self, $para_list)=@_;
    return 'AA'.'06'.'08'.'00'.'02'.'00';
}
sub get_picture_04{
    my ($self, $para_list)=@_;
    return 'AA'.'04'.'01'.'00'.'00'.'00';
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