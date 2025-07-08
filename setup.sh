#!/usr/bin/env bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
clear_color='\033[0m'
if [ $EUID -ne 0 ]; then
    printf "${red}Run it as root${clear_color}\n"
    exit 1
fi
if [ $YOU_KNOW_WHAT!="THIS_IS_KALI_LINUX_NETHUNTER_FROM_JAVA_BINKY" ]; then
    printf "${red}This toolset has been designed around Kali Nethunter, which you do not appear to be using.\n"
    printf "You may continue, but we cannot guarantee everything functions as it should on another platform.${clear_color}\n"
    sleep 5
fi
printf "Checking that apache2 is installed... "
command -v apache2 > /dev/null
apache2_result="$?"
if [ "$apache2_result" -eq 0 ]; then
    printf "${green}Yes${clear_color}\n"
else
    printf "${red}No${clear_color}\n"
fi
printf "Checking that /var/www/html exists... "
if [ -d /var/www/html ]; then 
    printf "${green}Yes${clear_color}\n"
else
    printf "${red}No${clear_color}\n"
fi
printf "Checking for aircrack-ng... "
command -v aircrack-ng > /dev/null
aircrack_result="$?"
if [ "$aircrack_result" -eq 0 ]; then
    printf "${green}Yes${clear_color}\n"
else
    printf "${red}No${clear_color}\n"
fi
printf "Checking for file /etc/apache2/sites-enabled/000-default.conf... "
if [ -f /etc/apache2/sites-enabled/000-default.conf ]; then
   printf "${green}Yes${clear_color}\n"
   #if it already exists, run function to modify it
else
   printf "${red}No${clear_color}\n"
   #if it does not exist, run function to create it
fi
