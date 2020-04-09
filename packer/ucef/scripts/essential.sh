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
