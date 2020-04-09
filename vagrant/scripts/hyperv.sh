#!/bin/bash -eux

# enable remote desktop
sudo apt-get install -y xrdp
sudo adduser xrdp ssl-cert

# fix problem with xrdp-sesman running
#   seems to be related to disabling IPv6
sudo sed -i 's,ExecStart,ExecStartPre=/bin/sleep 20\nExecStart,g' /lib/systemd/system/xrdp-sesman.service
