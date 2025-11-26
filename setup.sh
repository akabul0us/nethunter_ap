#!/usr/bin/env bash
PWD="$(pwd)"
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
clear_color='\033[0m'
confirm() {
    printf "${green}Yes${clear_color}\n"
}
deny() {
    printf "${red}No${clear_color}\n"
}
printf "Checking that user is root..."
if [ $EUID -ne 0 ]; then
    deny
    printf "${red}Run it as root${clear_color}\n"
    exit 1
else
    confirm
fi
printf "Checking that this is being run on aarch64..."
if [ "$(uname -m)" == "aarch64" ]; then
    confirm
else
    deny
fi
printf "Checking that this is being run from Nethunter..."
if [ "$YOU_KNOW_WHAT" != "THIS_IS_KALI_LINUX_NETHUNTER_FROM_JAVA_BINKY" ]; then
    deny
    printf "${red}This toolset has been designed around Kali Nethunter, which you do not appear to be using.\n"
    printf "You may continue, but we cannot guarantee everything functions as it should on another platform.${clear_color}\n"
    sleep 5
fi
#by including an httpd binary we no longer require this check

#printf "Checking that apache2 is installed... "
#command -v apache2 > /dev/null
#apache2_result="$?"
#if [ "$apache2_result" -eq 0 ]; then
#    printf "${green}Yes${clear_color}\n"
#else
#    printf "${red}No${clear_color}\n"
#    command -v apt > /dev/null
#    apt_is_pm="$?"
#    if [ "$apt_is_pm" -eq 0 ]; then
#        printf "${yellow} Installing apache2...${clear_color}\n"
#        apt-get update
#        apt-get install -y apache2
#    else
#        printf "${red}Automatic installation of apache2 failed - please install and run this script again${clear_color}\n"
#        exit 1
#    fi
#fi
#
#or this one
#
#printf "Checking that /var/www/html exists... "
#if [ -d /var/www/html ]; then 
#    printf "${green}Yes${clear_color}\n"
#    printf "${yellow}Moving current directory /var/www/html to $HOME/old-apache2${clear_color}\n"
#    mv /var/www/html $HOME/old-apache2
#else
#    printf "${red}No${clear_color}\n"
#fi
#printf "Copying files from $PWD/html to /var/www/html\n"
#if [ ! -d /var/www ]; then
#    mkdir -p /var/www
#fi
#cp -R $PWD/html /var/www/
#chmod -R 755 /var/www/html
#printf "Checking for file /etc/apache2/sites-enabled/000-default.conf... "
#if [ -f /etc/apache2/sites-enabled/000-default.conf ]; then
#   printf "${green}Yes${clear_color}\n"
#   #check to see if it's the standard file - if not, save a backup before overwriting
#   config_check="$(diff $PWD/setup-files/original-apache2.conf /etc/apache2/sites-enabled/000-default.conf | wc -l)"
#   if [ "$config_check" -ne 0 ]; then
#       printf "${red}Non-standard configuration file detected -- ${yellow}saving copy to $HOME/old-apache2.conf${clear_color}\n"
#       mv /etc/apache2/sites-enabled/000-default.conf $HOME/old-apache2.conf
#   else
#       printf "${yellow}Standard config file will be replaced - to revert these changes move or copy  $PWD/setup-files/original-apache2.conf back to original path${clear_color}\n"
#   fi
#else
#   printf "${red}No${clear_color}\n"
#fi
#printf "Creating new default apache2 configuration...\n"
#cp $PWD/setup-files/modified-apache2.conf /etc/apache2/sites-enabled/000-default.conf


printf "Checking for aircrack-ng... "                                   
command -v aircrack-ng > /dev/null 2>&1
aircrack_result="$?"
if [ "$aircrack_result" -eq 0 ]; then
    confirm
else
    deny
    read -p "Build it from source now? (Y/n)" build_ac
    case $build_ac in
        [Nn])
            printf "${red}Quitting...\n${clear_color}"
            exit 1
            ;;
          *)
              curl -fsSL https://raw.githubusercontent.com/akabul0us/assorted_linux_scripts/refs/heads/main/aircrack_install.sh | bash
              ;;
    esac
fi
printf "${green}Setup complete!${clear_color}\n"
printf "Run init.sh to begin.\nOptions:"
echo '-c [path to .cap file] -- Packet capture file containing 4-way handshake'
echo '-b [target BSSID] -- MAC address of AP to deauthenticate/spoof'
echo '-n [target SSID] -- Wifi network name'
echo '-i [wifi/cell] -- share internet from connected wifi or from cellular data'
echo '-d [interface] -- which interface to use to attack AP with deauthentication packets'
echo 'ex: init.sh -c "/root/hs/handshake-Home_Internet.cap" -b "da:4d:bb:33:c3:cb" -n "Home Internet" -i wifi -d wlan1'

