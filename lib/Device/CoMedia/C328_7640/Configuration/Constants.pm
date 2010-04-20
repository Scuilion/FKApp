package Device::CoMedia::C328_7640::Configuration::Constants;
my $constants;
BEGIN {
    $constants = [qw{INITIAL GET_PICTURE SNAPSHOT SET_PACKAGE_SIZE SET_BAUDRATE
                  RESET POWER_OFF DATA SYNC ACK NAK LIGHT_FREQUENCE
                  CT_2_B_GRAY CT_4_B_GRAY CT_8_B_GRAY CT_12_B_COLOR CT_16_B_COLOR CT_JPEG
                  SMALL MEDIUM LARGE EX_LARGE
                  SNAPSHOT2 PREVIEW JPEG
                  COMPRESSED UNCOMPRESSED}]
}
use Sub::Exporter -setup =>{
    exports => $constants,
    groups => {
        default => $constants,
    },
};

use constant {
    INITIAL             =>'01',
    GET_PICTURE         =>'04',
    SNAPSHOT            =>'05',
    SET_PACKAGE_SIZE    =>'06',
    SET_BAUDRATE        =>'07',
    RESET               =>'08',
    POWER_OFF           =>'09',
    DATA                =>'0A',
    SYNC                =>'0D',
    ACK                 =>'0E',
    NAK                 =>'0F',
    LIGHT_FREQUENCE     =>'13',
    
    CT_2_B_GRAY         =>'01',
    CT_4_B_GRAY         =>'02',
    CT_8_B_GRAY         =>'03',
    CT_12_B_COLOR       =>'05',
    CT_16_B_COLOR       =>'06',
    CT_JPEG             =>'07',
                                        #works for both preview resolution and JPEG resolution
    SMALL               =>'01',         #80x64
    MEDIUM              =>'03',         #160x128
    LARGE               =>'05',         #320x240
    EX_LARGE            =>'07',         #640x480
    
    SNAPSHOT2            =>'01',
    PREVIEW             =>'02',
    JPEG                =>'05',
    
    COMPRESSED          =>'00',
    UNCOMPRESSED        =>'01',
};

1