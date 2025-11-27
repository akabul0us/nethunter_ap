## Nethunter AP

This Evil Twin script creates a fake access point using a virtual interface on Kali Nethunter. Attempts to authenticate using the PSK are verified against the captured hash and logged. You only need one external adapter for deauthing the target AP.

### Usage

```bash
git clone https://github.com/dr1408/nethunter_ap.git
cd nethunter_ap
```

Plug in your wireless adapter

```bash
./evil.sh
```

### [Attack Demo](https://github.com/user-attachments/assets/629a6c2d-ac79-46f7-b233-6c9ad3d6f469)


### Credits
- @yesimxev - Internet sharing rules
- @ikteach - Script editing
- @Justxd22 - Handshake verification methods and portals - _check his [repo](https://github.com/Justxd22/Eviltwin-Huawei_XD)_


