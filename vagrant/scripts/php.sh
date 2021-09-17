# https://phoenixnap.com/kb/install-php-7-on-ubuntu

sudo apt update && sudo apt upgrade
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt -y install php7.4
sudo apt -y install php8.0 libapache2-mod-php8.0.

php -v