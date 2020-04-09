#!/bin/bash -eux

if [[ "$#" -eq 3 && ! -z "$1" && ! -z "$2" ]]; then
    # fix static IP allocation
    sudo sed -i "s,$1,$2,g" /etc/netplan/01-netcfg.yaml
    # sudo netplan apply # this would break vagrant / ssh
fi
