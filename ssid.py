#!/usr/bin/env python3
import hashlib, hmac, sys, struct, argparse

hashline = None

parser = argparse.ArgumentParser()
parser.add_argument("file", help=".hc22000 file containing WPA/WPA2 hashes")
args = parser.parse_args()
hash_file = (args.file)
with open(hash_file, 'r') as file:
    contents = file.read()
    hashline = str(contents)
    hl = hashline.split("*")
    mac_ap = bytes.fromhex(hl[3])
    essid = bytes.fromhex(hl[5])

def show_values(mac_ap, essid):
    print("SSID: ", essid.decode())
    print("BSSID: ", "%02x:%02x:%02x:%02x:%02x:%02x" % struct.unpack("BBBBBB", mac_ap))

show_values(mac_ap, essid)
