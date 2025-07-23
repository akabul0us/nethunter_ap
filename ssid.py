#!/usr/bin/env python3

import hashlib, hmac, sys, struct

hashline = None

if len(sys.argv) > 1: 
    hashline=sys.argv[1]
    hl = hashline.split("*")
    mic = bytes.fromhex(hl[2])
    bssid = bytes.fromhex(hl[3])
    mac_cl = bytes.fromhex(hl[4])
    essid = bytes.fromhex(hl[5])

def show_values(bssid, essid):
    print("ESSID: ", essid.decode())
    print("BSSID: ", "%02x:%02x:%02x:%02x:%02x:%02x" % struct.unpack("BBBBBB", bssid))

show_values(bssid, essid)
