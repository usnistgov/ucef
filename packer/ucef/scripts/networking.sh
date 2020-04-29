#!/bin/bash -eux

# disable IPv6 at boot
# GRUB_CMDLINE_LINUX will (sadly) contain an extra space; i do not know how to remove it
# this can cause dns problems on some computers if done before the packages are installed ?
sed -i 's/^GRUB_CMDLINE_LINUX="\(.*\)"$/GRUB_CMDLINE_LINUX="\1 ipv6.disable=1"/g' /etc/default/grub
sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"$/GRUB_CMDLINE_LINUX_DEFAULT="\1 ipv6.disable=1"/g' /etc/default/grub
update-grub
