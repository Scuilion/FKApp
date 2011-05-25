package Device::CoMedia::C328_7640::Module;

use feature ':5.10';

use Moose;
use Devel::Dwarn;
use DateTime;
use Time::HiRes qw(usleep);
use POSIX qw(ceil);
use File::HomeDir;

use Device::CoMedia::C328_7640::Communication::Serial::RS232::CommController;
use Device::CoMedia::C328_7640::CommandSet;
use Device::CoMedia::C328_7640::Configuration::Constants;
use Device::CoMedia::C328_7640::CommandProtocol;

has comm_object => (
    is => 'ro',
    isa => 'Device::CoMedia::C328_7640::Communication::Serial::RS232::CommController',
    builder => '_build_C328_controller',
    required=>1,
    lazy=>1,
    );

has comm_port => (
    is => 'ro',
    isa => 'Str',
    required=>1,
    );

has commandset => (
    is => 'ro',
    isa => 'Device::CoMedia::C328_7640::CommandSet',
    builder => '_build_command_list',
    required=>1,
    lazy=>1,
    );

has file_location =>(
   is => 'rw',
   isa => 'Str',
   default => sub { File::HomeDir->my_home . "/C328_7640/"},
   lazy=>1,
);

has file_name => (
   is => 'rw',
   isa => 'Str',
   default => '',
   lazy=>1,
);
#TODO: Will allow for a smarter handling without file non-sense
has file_handle => (
   is => 'rw',
   isa => 'FileHandle',
);

has return_value => (
   traits => ['Hash'],
   is => 'rw',
   isa => 'HashRef[Str]',
   default => sub { {error=>'00',
                     P1=>'',
                     P2=>'',
                     P3=>'',
                     P4=>''}},
   lazy => 1,
   handles   => {
          set_ret_v => 'set',
          get_ret_v => 'get',
      },
);

#the following are individual objects for each command
has sync_cmd => (
   is => 'rw',
   isa => 'Device::CoMedia::C328_7640::CommandProtocol',
   lazy => 1,
   builder => '_sync_obj_builder',
);

has init_cmd => (
   is => 'rw',
   isa => 'Device::CoMedia::C328_7640::CommandProtocol',
   lazy => 1,
   builder => '_init_obj_builder',
);

has pack_cmd => (
   is => 'rw',
   isa => 'Device::CoMedia::C328_7640::CommandProtocol',
   lazy => 1,
   builder => '_pack_obj_builder',
);

has snap_cmd => (
   is => 'rw',
   isa => 'Device::CoMedia::C328_7640::CommandProtocol',
   lazy => 1,
   builder => '_snap_obj_builder',
);

has get_cmd => (
   is => 'rw',
   isa => 'Device::CoMedia::C328_7640::CommandProtocol',
   lazy => 1,
   builder => '_get_obj_builder',
);

has reset_cmd => (
   is => 'rw',
   isa => 'Device::CoMedia::C328_7640::CommandProtocol',
   lazy => 1,
   builder => '_reset_obj_builder',
);

has data_cmd => (
   is => 'rw',
   isa => 'Device::CoMedia::C328_7640::CommandProtocol',
   lazy => 1,
   builder => '_data_obj_builder',
);#end of command objects

after qw(snapshot) => sub{#lets try and reset the device
   my $self = shift;
   if( $self->get_ret_v('error') ne '00'){
      $self->reset_cmd->snd_rec_resp($self->commandset);
   }

};

sub _build_C328_controller{
    my $self=shift;
    Device::CoMedia::C328_7640::Communication::Serial::RS232::CommController->new(comm_port=>$self->comm_port) }

sub _build_command_list{ Device::CoMedia::C328_7640::CommandSet->new() }

sub _sync_obj_builder {
   my $self=shift;
   Device::CoMedia::C328_7640::CommandProtocol->new(repeats=>30, 
                                                    comm_object => $self->comm_object,
                                                    command=> SYNC(),
                                                    respond=> 1,
                                                    ) }
sub _init_obj_builder {
   my $self=shift;
   Device::CoMedia::C328_7640::CommandProtocol->new(repeats=>1, 
                                                    comm_object => $self->comm_object,
                                                    command=> INITIAL(),
                                                    ) }
sub _pack_obj_builder {
   my $self=shift;
   Device::CoMedia::C328_7640::CommandProtocol->new(repeats=>1, 
                                                    comm_object => $self->comm_object,
                                                    command=> SET_PACKAGE_SIZE(),
                                                    ) }
sub _snap_obj_builder {
   my $self=shift;
   Device::CoMedia::C328_7640::CommandProtocol->new(repeats=>1, 
                                                    comm_object => $self->comm_object,
                                                    command=> SNAPSHOT(),
                                                    ) }
sub _get_obj_builder {
   my $self=shift;
   Device::CoMedia::C328_7640::CommandProtocol->new(repeats=>1, 
                                                    comm_object => $self->comm_object,
                                                    command=> GET_PICTURE(),
                                                    ) }
sub _reset_obj_builder {
   my $self=shift;
   Device::CoMedia::C328_7640::CommandProtocol->new(repeats=>1,
                                                    comm_object => $self->comm_object,
                                                    command=> RESET(),
                                                    ) }
sub _data_obj_builder {
   my $self=shift;
   Device::CoMedia::C328_7640::CommandProtocol->new(repeats=>1,
                                                    comm_object => $self->comm_object,
                                                    command=> DATA(),
                                                    respond=> 1,
                                                    ) }
#end of builders for command objects
sub init{
   my $self = shift;
   DwarnN $self;
}
sub sync{
   my $self = shift;
   Dwarn 'in sync';
   return $self->sync_cmd->snd_rec_resp($self->commandset);
}

sub snapshot{
   my $self=shift;
   my $filehandle = shift;
   my $res;
   
   Dwarn $res = $self->sync_cmd->snd_rec_resp($self->commandset, $self->return_value);
   $self->set_ret_v(error=>$res->{error});
   return $res if($res->{error} ne '00');

   Dwarn $res = $self->init_cmd->snd_rec_resp($self->commandset, $self->return_value);
   $self->set_ret_v(error=>$res->{error});
   return $res if($res->{error} ne '00');

   Dwarn $res = $self->pack_cmd->snd_rec_resp($self->commandset, $self->return_value);
   $self->set_ret_v(error=>$res->{error});
   return $res if($res->{error} ne '00');

   Dwarn $res = $self->snap_cmd->snd_rec_resp($self->commandset, $self->return_value);
   $self->set_ret_v(error=>$res->{error});
   return $res if($res->{error} ne '00');

   Dwarn $res = $self->get_cmd->snd_rec_resp($self->commandset, $self->return_value, $self->file_handle);
   $self->set_ret_v(error=>$res->{error});
   return $res if($res->{error} ne '00');

   Dwarn $self->get_ret_v('packet_qty');
   Dwarn $res = $self->data_cmd->snd_rec_data($self->commandset, $self->return_value, $res->{packet_qty});
   return $self->return_value;
}#end of camera functions

#methods for changing the configurations
sub change_preview_res{
    my ($self, $ct) = @_;
    $self->commandset->set_config(preview_resolution=>$ct);
}

sub change_color_type{
    my ($self, $ct) = @_;
    $self->commandset->set_config(color_type=>$ct);
}

sub change_jpeg_res{
    my ($self, $ct) = @_;
    $self->commandset->set_config(jpeg_resolution=>$ct);
}

sub change_picture_type{
    my ($self, $ct) = @_;
    $self->commandset->set_config(picture_type=>$ct);
}

sub change_snapshot_type{
    my ($self, $ct) = @_;
    $self->commandset->set_config(snapshot_type=>$ct);
}

sub set_package_size{
    my ($self, $ct) = @_;
    if($ct >= 64 && $ct <=512){
      $self->commandset->set_config(package_size=>$ct);
    }
    else{
      die 'size not acceptable';
    }
}

sub set_baudrate{
    my ($self, $ct) = @_;

    if( $ct ~~ [BAUD_7200(), BAUD_9600(), BAUD_14400(), BAUD_19200(), BAUD_28800(), BAUD_38400(), BAUD_57600(), BAUD_115200()] ){
        #$self->baud_cmd->commandset->set_config(baudrate=>$ct);
        $self->commandset->set_config(baudrate=>$ct);
    }
    else{
      die 'baudrate not valid';
    }
}

sub change_light_freq{
   my ($self, $ct) = @_;
   $self->commandset->set_config(freq_value=>$ct);
}#end of methods for chaning configuration

no Moose;
__PACKAGE__->meta->make_immutable();
1;
