#!/bin/bash -eux

# general dependencies
apt-get install -y build-essential

## C++ federate dependencies
apt-get install -y libboost-all-dev
apt-get install -y libmysqlcppconn-dev

## runtime dependencies
apt-get install -y xterm
apt-get install -y jq

## WebGME dependencies
# Node.js 12.16.1 using NVM https://github.com/nvm-sh/nvm#install--update-script
# run these commands as vagrant to prevent corruption of the user's home directory permissions
TERM="xterm" # trying to fix tput: unknown terminal "unknown"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | su - vagrant -c "bash"
su - vagrant -c "source $HOME_DIR/.nvm/nvm.sh && nvm install 12.16.1"

# MongoDB 4.2 https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add - # Warning: apt-key output should not be parsed (stdout is not a terminal)
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list
apt-get update -y
apt-get install -y mongodb-org

# autostart MongoDB
systemctl start mongod
systemctl enable mongod

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
