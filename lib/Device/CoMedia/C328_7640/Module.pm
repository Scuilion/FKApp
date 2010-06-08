package Device::CoMedia::C328_7640::Module;

use feature ':5.10';

use Moose;
use Devel::Dwarn;
use DateTime;
use Time::HiRes qw(usleep);
use POSIX qw(ceil);

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
   default =>  'C:\dump\\',
);

has file_name => (
   is => 'rw',
   isa => 'Str',
   default => '',
);

has file_handle => (
   is => 'rw',
   isa => 'FileHandle',
);

has return_value => (
   traits => ['Hash'],
   is => 'rw',
   isa => 'HashRef[Str]',
   default => sub { {error=>'',
                     Parameter1=>'',
                     Parameter2=>'',
                     Parameter3=>'',
                     Parameter4=>''}},
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

#end of command objects
after qw(snapshot) => sub{
   Dwarn 'called after';
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
   Device::CoMedia::C328_7640::CommandProtocol->new( comm_object => $self->comm_object,
                                                    command=> RESET(),
                                                    ) }

#end of builders for command objects

sub sync{
   my $self = shift;
   Dwarn 'in sysnc';
   return $self->sync_cmd->snd_rec_resp($self->commandset);
}

sub snapshot{
   my $self=shift;
   my $filehandle = shift;
Dwarn 'called sanpshot';
   my $res;

   Dwarn $res= $self->sync_cmd->snd_rec_resp($self->commandset);
   Dwarn $self->get_ret_v('error');
   Dwarn 'response ' , $res;
   Dwarn $res->{error};
   $self->set_ret_v(error=>$res->{error});
   die;
   return $res if(exists $res->{error});
   
   Dwarn $self->return_value = $self->init_cmd->snd_rec_resp($self->commandset);
   return $res if(exists $res->{error});

   Dwarn $self->return_value = $self->pack_cmd->snd_rec_resp($self->commandset);
   return $res if(exists $res->{error});

   Dwarn $self->return_value = $self->snap_cmd->snd_rec_resp($self->commandset);
   return $res if(exists $res->{error});

   $filehandle = $self->get_cmd->snd_rec_resp($self->commandset);
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
        $self->baud_cmd->commandset->set_config(baudrate=>$ct);
    }
    else{
      die 'baudrate not valid';
    }
}

sub change_light_freq{
   my ($self, $ct) = @_;
   $self->commandset->set_config(freq_value=>$ct);
}#end of methods for chaning configuration


sub generic_snd_packet{
   my $self=shift;
   my $action = shift;
   my $tries = shift;

   my $command=$self->commandset->send_command({ID=>$action });
   $self->comm_object->w_output($command);

    my ($ack, $counter, $image_size, $image);
    for my $i (0..10){
        usleep(70000);
        $ack .= $self->comm_object->comm_read();
        #Dwarn 'rec 1: ' . $ack;
        last if( $ack=~/......(..)..../);
        return 0 if($i==10);
    }
}

sub take_picture{
    my $self=shift;
    my $file_name= shift;
    my $loc_name = $self->file_location;
    my $dt=DateTime->now;

    #check and/or set file name
    if(!defined $file_name ){$loc_name .= $dt->strftime('%Y%m%d%H%M%S.jpg');}
    else{$loc_name .= $file_name; }

    $self->generic_snd_packet(INITIAL());

    $self->generic_snd_packet(SET_PACKAGE_SIZE());

    my $ack='';
    my ($counter, $image, $image_size);

    $self->generic_snd_packet(SNAPSHOT());

    $ack="";
    my $command=$self->commandset->send_command({ID=>GET_PICTURE()});
    Dwarn 'Get picture: ' . $command;
    $self->comm_object->w_output($command);
    for my $i(0..10){
        usleep(60000);
        $ack .= $self->comm_object->comm_read();
        if(($counter , my $i0, my $i1, my $i2, $image)
           =  $ack=~/......(..)..........(..)(..)(..)(.*)/){
            Dwarn 'rec 4: ' . $ack;
            $ack="";
            $image_size = ceil(hex($i2.$i1.$i0)/506);
            $image = $3;
            
            last;        
        }
        return 0 if($i==10);
    }
    open (my $file, '>>',$loc_name);
    binmode $file;

    for my $ack_counter(0..$image_size+1){
        $command=$self->commandset->send_command({ID=>ACK(),
                                            Parameter1=>'00',
                                            Parameter2=>'00',
                                            Parameter3=>sprintf( "%02x", $ack_counter),
                                            Parameter4=>'00', 
                                            });
        #Dwarn 'ack ' . $command;
        $self->comm_object->w_output($command);
        usleep(60000);
        my $image_data = $self->comm_object->comm_read();
        if( $image_data ne ''){
           $image_data = substr($image_data, 8, -4);
           print {$file} join '', map{ chr hex $_} grep($_ ne "", split /(..)/ , $image_data);
        }
    }                                        
    close ($file);
    
    Dwarn 'write ' . $command;
    $self->comm_object->w_output($command);
    for my $i(0..10){
        usleep(60000);
        $ack .= $self->comm_object->comm_read();
        Dwarn 'rec 5: ' . $ack;
        last if( $ack=~/......(..)..../);
        return 0 if($i==10);
    }
    
    my $temp =$self->commandset->send_command({ID=>ACK(),
                    Parameter1=>'0e',
                    Parameter2=>$counter,
                    Parameter3=>'00',
                    Parameter4=>'00',
                    });
        Dwarn 'response ' . $temp;
        $self->comm_object->w_output($temp);
        
    Dwarn $ack;
    
    return $ack;
}

no Moose;
__PACKAGE__->meta->make_immutable();
1;
