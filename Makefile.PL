# IMPORTANT: if you delete this file your app will not work as
# expected.  you have been warned
use inc::Module::Install;

name 'FKApp';
all_from 'lib\Device\CoMedia\C328_7640';

requires 'Moose' => 0;
requires 'Win32::SerialPort' => 0.19;

install_script glob('bin/*.pl');
auto_install;
WriteAll;
