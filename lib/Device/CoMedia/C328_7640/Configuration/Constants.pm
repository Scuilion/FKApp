package Device::CoMedia::C328_7640::Configuration::Constants;
my $constants;
BEGIN {
    $constants = [qw{INITIAL GET_PICTURE SNAPSHOT SET_PACKAGE_SIZE SET_BAUDRATE
                  RESET POWER_OFF DATA SYNC ACK NAK LIGHT_FREQUENCE
                  CT_2_B_GRAY CT_4_B_GRAY CT_8_B_GRAY CT_12_B_COLOR CT_16_B_COLOR CT_JPEG
                  SMALL MEDIUM LARGE EX_LARGE
                  SNAPSHOT_PIC PREVIEW_PIC JPEG_PIC
                  COMPRESSED UNCOMPRESSED
                  BAUD_7200 BAUD_9600 BAUD_14400 BAUD_19200 BAUD_28800 BAUD_38400 BAUD_57600 BAUD_115200
                  FREQ_50 FREQ_60
                  R_SYSTEM R_STATE
                  }]
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
    
    SNAPSHOT_PIC        =>'01',
    PREVIEW_PIC         =>'02',
    JPEG_PIC            =>'05',
    
    COMPRESSED          =>'00',
    UNCOMPRESSED        =>'01',
    BAUD_7200           =>"ff01",
    BAUD_9600           =>"bf01",
    BAUD_14400          =>"7f01",
    BAUD_19200          =>"5f01",
    BAUD_28800          =>"3f01",
    BAUD_38400          =>"2f01",
    BAUD_57600          =>"1f01",
    BAUD_115200         =>"0f01",

    FREQ_50             =>'00',
    FREQ_60             =>'01',

    R_SYSTEM            =>'00',
    R_STATE             =>'01'
};

1;
