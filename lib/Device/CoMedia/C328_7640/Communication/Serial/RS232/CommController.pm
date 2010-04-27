package Device::CoMedia::C328_7640::Communication::Serial::RS232::CommController;

use Moose;
use Win32::SerialPort;
use Devel::Dwarn;

has com_handle => (
    is => 'rw',
    isa => 'Win32::SerialPort',
    builder => '_build_com_handle',
    handles => ['close'],
    required =>1,
    #lazy=>1,
);

has comm_port => (
    is => 'ro',
    isa => 'Str',
    builder => '_build_com_name',
    required => 1,
    lazy => 1,
);

has config_file => (
    is => 'rw',
    isa => 'Str',
    default => "CommConfig",
    required => 1,
    lazy=>1,
);

#
sub bytes_length { #counts the string in terms of bytes as opposed to chars
    use bytes;
    my $leng = bytes::length(shift @_);
    no bytes;
    return $leng;
}
sub _build_com_handle {
    my $self = shift;
    my $com_handle = Win32::SerialPort->new($self->comm_port) || die q{Can't open}.
        $self->comm_port . ": $^E\n";    # $quiet is optional

    #$PortObj->user_msg(ON);
    $com_handle->databits(8);
    $com_handle->baudrate(115200); #19200 38400 2400
    $com_handle->parity("none");
    $com_handle->stopbits(1);
    $com_handle->handshake("none");
    $com_handle->write_settings || undef $com_handle;
    $com_handle->xon_limit(102);
    $com_handle->buffers(4096, 4096);# read, write. returns current in list context
    
    $com_handle->save($self->config_file);
    
    return $com_handle;
}

sub w_output{
    my ($self, $string)=@_;
    $string =pack( 'H*' , $string);
    $self->com_handle->write($string);
}
sub check_handle {
    my $self = shift;
   if (defined $self->com_handle) {
      return $self->com_handle;
   } else { 
      warn 'invalid handle, creating a new one';
      return $self->_build_com_handle  ;
   }
}

sub comm_read() {
    my $self = shift;
    #packed hex unit are the native type for transmission from the comm port
    # ex. byte '5a' is Z, '0a' is \n etc.
    (my $count_in, my $string_in) = $self->com_handle->read(4028);
    $string_in = $self->format_for_print($string_in);
    return $string_in;
}

sub format_for_print{
    my ($self, $format_for_print) = @_;
    return join('', map(sprintf('%02x', ord($_)), split(//, $format_for_print)))  ;   
}

no Moose;
__PACKAGE__->meta->make_immutable();
1;

