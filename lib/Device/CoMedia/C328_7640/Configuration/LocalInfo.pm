package Device::CoMedia::C328_7640::Configuration::LocalInfo;

use warnings;
use strict;
use feature ':5.10';

use JSON;
use Config::JFDI;
use TryCatch;
use Net::Domain;
use Devel::Dwarn;

use Device::CoMedia::C328_7640::Configuration::Exceptions;

sub open_file{

    try{
    
        my $config = Config::JFDI->new(name => 'KP', path => 'C:\Project\Spark\FKApp\bin');
    
        #@if (!$config) error
        Configuration::Exceptions::NoFileFound->throw if (!$config);   
        return $config;
    }
    catch(Configuration::Exceptions::NoFileFound $e){
        print "config file not found";
        die $e->message;
    }
    catch(Exception::Class $e) {
        die $e->message;
    }
}

sub comm_name{
    try{
        my $file_handle = open_file();
        my $config_hash = $file_handle->get;
        Configuration::Exceptionss::COMMNameNotFound->throw unless $config_hash->{comm_port};
        return $config_hash->{comm_port};
    }
    catch(Configuration::Exceptionss::COMMNameNotFound $e){
        die $e->message;
    }
    catch(Exception::Class $e) {
        die $e->message;
    }
}

sub local_info{
        
    try{
        my $server_name = Configuration::LocalInfo->server_name();
        Configuration::Exceptionss::SeverNameNotFound->throw unless($server_name);
        my $computer_name = Configuration::LocalInfo->computer_name();
        Configuration::Exceptionss::CompNameNotFound->throw unless($computer_name);

        return $server_name, $computer_name;
    }
    catch(Configuration::Exceptionss::ServerNameNotFound $e){
        die $e->message;
    }
    catch(Configuration::Exceptionss::CompNameNotFound $e){
        die $e->message; 
    }
    catch(Exception::Class $e) {
        die $e->message;
    }
    catch($e) {
        die $e;
    }
}
sub get_comm_name{
    try{
        my $comm_name = Configuration::LocalInfo->comm_name();
        Configuration::ExceptionsS::COMMNameNotFound->throw unless($comm_name);
        return $comm_name;
    }
    catch(Configuration::Exceptionss::COMMNameNotFound $e){
        die $e->message; 
    }
    catch(Exception::Class $e) {
        die $e->message;
    }
    catch($e) {
        die $e;
    }
}
        
1;
