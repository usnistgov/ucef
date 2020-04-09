#!/bin/bash -eux

# add MySQL 8.0 to the package manager (default is 5.7)
wget -O /tmp/mysql-apt-config_0.8.15-1_all.deb https://dev.mysql.com/get/mysql-apt-config_0.8.15-1_all.deb
echo mysql-apt-config mysql-apt-config/select-server select mysql-8.0 | debconf-set-selections
dpkg -i /tmp/mysql-apt-config_0.8.15-1_all.deb # Warning: apt-key should not be used in scripts
apt-get -y update

# noninteractive install using the password vagrant
debconf-set-selections <<<'mysql-community-server mysql-community-server/root-pass password vagrant'
debconf-set-selections <<<'mysql-community-server mysql-community-server/re-root-pass password vagrant'
apt-get install -y mysql-community-server
