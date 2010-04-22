package Device::CoMedia::C328_7640::Module;

use feature ':5.10';

use Moose;
use Devel::Dwarn;
use DateTime;
use Time::HiRes qw(usleep);
use POSIX qw(ceil);

use Device::CoMedia::C328_7640::Communication::Serial::RS232::CommController;
use Device::CoMedia::C328_7640::Commands;
use Device::CoMedia::C328_7640::Configuration::Constants;

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

has commands => (
    is => 'ro',
    isa => 'Device::CoMedia::C328_7640::Commands',
    builder => '_build_command_list',
    required=>1,
    lazy=>1,
    );
has file_location =>(
   is => 'rw',
   isa => 'Str',
   default =>  'C:\Documents and Settings\kevino\Desktop\dump\\',
);

sub _build_C328_controller{
    my $self=shift;
    Device::CoMedia::C328_7640::Communication::Serial::RS232::CommController->new(comm_port=>$self->comm_port) }
sub _build_command_list{ Device::CoMedia::C328_7640::Commands->new() }

sub change_color_type{
    my ($self, $ct) = @_;
    $self->commands->set_option(color_type=>$ct);
}

sub change_preview_res{
    my ($self, $ct) = @_;
    $self->commands->set_option(preview_resolution=>$ct);
}
sub change_jpeg_res{
    my ($self, $ct) = @_;
    $self->commands->set_option(jpeg_resolution=>$ct);
}
sub change_picture_type{
    my ($self, $ct) = @_;
    $self->commands->set_option(picture_type=>$ct);
}
sub change_snapshot_type{
    my ($self, $ct) = @_;
    $self->commands->set_option(snapshot_type=>$ct);
}
sub set_package_size{
    my ($self, $ct) = @_;
    Dwarn $ct;
    if($ct >= 64 && $ct <=512){
    Dwarn 'got here';
      $self->commands->set_option(package_size=>$ct);
    }
    else{
      return 0; #set up error handeling here
    }
}
sub set_baudrate{
    my ($self, $ct) = @_;
    $self->commands->set_option(baudrate=>$ct);
}

sub sync_cam{
    my $self=shift;
    my $ack;
    for(0..33){# 25 times as defined by user manual
        $self->comm_object->w_output($self->commands->send_command({ID=>SYNC()}));
        $ack .= $self->comm_object->comm_read();
        my ($counter, $id_b2, $id_b1, $cmd);
        if( ($cmd , $counter, $id_b1, $id_b2) =
           $ack =~ /....(..)(..)(..)(..)............/){
        
        my $temp =$self->commands->send_command({ID=>ACK(),
                    Parameter1=>$cmd,
                    Parameter2=>$counter,
                    Parameter3=>$id_b1,
                    Parameter4=>$id_b2,
                    
                    });
        Dwarn 'response ' . $temp;
        $self->comm_object->w_output($temp);
           
            return 1;
        }
        usleep(5000);
    }
    return 0;
}


sub take_picture{
    my $self=shift;
    my $file_name= shift;
    my $loc_name = $self->file_location;
    my $dt=DateTime->now;

    if(!defined $file_name ){
          $loc_name .= $dt->strftime('%Y%m%d%H%M%S');
          Dwarn $file_name;
    }
    else{
          $loc_name .= $file_name;
          Dwarn 'in here';
    }
    Dwarn $loc_name;
    my $command;

    $command=$self->commands->send_command({ID=>INITIAL()});
    Dwarn 'Initialize: ' . $command;
    $self->comm_object->w_output($command);
    my ($ack, $counter, $image_size, $image);
    for my $i (0..10){
        usleep(50000);
        $ack .= $self->comm_object->comm_read();
        Dwarn 'rec 1: ' . $ack;
        last if( $ack=~/......(..)..../);
        return 0 if($i==10);
    }
    $ack='';
    $command=$self->commands->send_command({ID=>SET_PACKAGE_SIZE()});
    Dwarn 'set package size: ' . $command;
    $self->comm_object->w_output($command);
    for my $i (0..10){
        usleep(50000);
        $ack .= $self->comm_object->comm_read();
        Dwarn 'rec 2: ' . $ack;
        last if( $ack=~/......(..)..../);
        return 0 if($i==10);
    }
    $ack='';
    $command=$self->commands->send_command({ID=>SNAPSHOT()});
    Dwarn 'Take Snapshot: ' . $command;
    $self->comm_object->w_output($command);
    for my $i(0..10){
        usleep(50000);
        $ack .= $self->comm_object->comm_read();
        Dwarn 'rec 3: ' . $ack;
        last if( $ack=~/......(..)..../);
        return 0 if($i==10);
    }
    
    $ack="";
    $command=$self->commands->send_command({ID=>GET_PICTURE()});
    Dwarn 'Get picture: ' . $command;
    $self->comm_object->w_output($command);
    for my $i(0..10){
        usleep(50000);
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
        $command=$self->commands->send_command({ID=>ACK(),
                                            Parameter1=>'00',
                                            Parameter2=>'00',
                                            Parameter3=>sprintf( "%02x", $ack_counter),
                                            Parameter4=>'00', 
                                            });
        #Dwarn 'ack ' . $command;
        $self->comm_object->w_output($command);
        usleep(50000);
        my $image_data = $self->comm_object->comm_read();
        $image_data = substr($image_data, 8, -4);
        #Dwarn $image_data;
        print {$file} join '', map{ chr hex $_} grep($_ ne "", split /(..)/ , $image_data);
        
        #Dwarn $ack;                         
    }                                        
    close ($file);
    
    Dwarn 'write ' . $command;
    $self->comm_object->w_output($command);
    for my $i(0..10){
        usleep(50000);
        $ack .= $self->comm_object->comm_read();
        Dwarn 'rec 5: ' . $ack;
        last if( $ack=~/......(..)..../);
        return 0 if($i==10);
    }
    
    ####$ack="";
    ####for(0..200){
    ####    usleep(50000);
    ####    $image .= $self->comm_object->comm_read();
    ####    #Dwarn $self->comm_object->comm_read();
    ####    
    ####    last if(length($image)>=72000);
    ####}
    ####Dwarn length($image);
    #####Dwarn $image;
    
    
    my $temp =$self->commands->send_command({ID=>ACK(),
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
