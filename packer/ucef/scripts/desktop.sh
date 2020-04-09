#!/bin/bash -eux

# install minimal desktop
# apt-get install -y ubuntu-desktop firefox --no-install-recommends
apt-get install -y xfce4 firefox # looking for something that works with Hyper-V

# disable IPv6 at boot
# GRUB_CMDLINE_LINUX will (sadly) contain an extra space; i do not know how to remove it
sed -i 's/^GRUB_CMDLINE_LINUX="\(.*\)"$/GRUB_CMDLINE_LINUX="\1 ipv6.disable=1"/g' /etc/default/grub
sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"$/GRUB_CMDLINE_LINUX_DEFAULT="\1 ipv6.disable=1"/g' /etc/default/grub
update-grub

reboot
