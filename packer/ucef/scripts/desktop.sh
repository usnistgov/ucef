#!/bin/bash -eux

# install minimal desktop
apt-get install -y xfce4 firefox # looking for something that works with Hyper-V
apt-get install -y lightdm-gtk-greeter # avoid the default unity-greeter
apt-get install -y lightdm

# install xrdp (for Windows Remote Desktop)
case "$PACKER_BUILDER_TYPE" in
hyperv-iso)
    # get the dependencies to build xrdp from source
    apt-get install -y gcc make autoconf automake libtool pkgconf nasm
    apt-get install -y xserver-xorg-dev libssl-dev libpam0g-dev libxfixes-dev libxrandr-dev
    
    # download and extract xrdp to /opt/xrdp-0.9.12
    wget https://github.com/neutrinolabs/xrdp/releases/download/v0.9.12/xrdp-0.9.12.tar.gz
    tar xvfz xrdp-0.9.12.tar.gz -C /opt
    rm xrdp-0.9.12.tar.gz
    
    # compile xrdp
    cd /opt/xrdp-0.9.12
    ./bootstrap
    ./configure
    make
    
    # install xrdp
    make install
    ln -s /usr/local/sbin/xrdp /usr/sbin
    ln -s /usr/local/sbin/xrdp-sesman /usr/sbin
    
    # download and extract xorgxrdp to /opt/xorgxrdp-0.2.12
    wget https://github.com/neutrinolabs/xorgxrdp/releases/download/v0.2.12/xorgxrdp-0.2.12.tar.gz
    tar xvfz xorgxrdp-0.2.12.tar.gz -C /opt
    rm xorgxrdp-0.2.12.tar.gz
    
    # compile xorgxrdp
    cd /opt/xorgxrdp-0.2.12
    ./bootstrap
    ./configure
    make
    
    # install xorgxrdp
    make install
    
    # fix ownership
    chown -R vagrant:vagrant /opt/xrdp-0.9.12
    chown -R vagrant:vagrant /opt/xorgxrdp-0.2.12
    sed -i 's,allowed_users=console,allowed_users=anybody,g' /etc/X11/Xwrapper.config
    
    # configure xrdp
    sudo systemctl enable xrdp
esac

reboot
