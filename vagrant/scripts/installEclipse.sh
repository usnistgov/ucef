#!/bin/bash

# Eclipse download link <<version>>
Eclipse_URL="https://mirror.umd.edu/eclipse/technology/epp/downloads/release/2021-06/R/eclipse-jee-2021-06-R-linux-gtk-x86_64.tar.gz"

#JAVA_HOME Check
function check_Java_Home {
    if [ -z ${JAVA_HOME} ]
    then
        echo 'Could not find JAVA_HOME. Please install Java and set JAVA_HOME'
        exit
    else
        echo 'JAVA_HOME found: '$JAVA_HOME
        if [ ! -e ${JAVA_HOME} ]
        then
            echo 'Invalid JAVA_HOME. Make sure your JAVA_HOME path exists'
            exit
        fi
    fi
}

function createDesktopIcon {
    echo 'Create Eclipse Desktop Icon...'
    sudo touch 'Eclipse IDE for Enterprise Java and Web Developers - 2021-06.desktop'
    sudo chmod 777 'Eclipse IDE for Enterprise Java and Web Developers - 2021-06.desktop'


    echo "#!/usr/bin/env xdg-open" > 'Eclipse IDE for Enterprise Java and Web Developers - 2021-06.desktop'
    echo "[Desktop Entry]" >> 'Eclipse IDE for Enterprise Java and Web Developers - 2021-06.desktop'
    echo "Type=Application" >> 'Eclipse IDE for Enterprise Java and Web Developers - 2021-06.desktop'
    echo "Terminal=false" >> 'Eclipse IDE for Enterprise Java and Web Developers - 2021-06.desktop'
    echo "Encoding=UTF-8" >> 'Eclipse IDE for Enterprise Java and Web Developers - 2021-06.desktop'
    echo "Version=1.1" >> 'Eclipse IDE for Enterprise Java and Web Developers - 2021-06.desktop'
    echo "Name=Eclipse IDE for Enterprise Java and Web Developers - 2021-06" >> 'Eclipse IDE for Enterprise Java and Web Developers - 2021-06.desktop'
    echo "Exec=env GTK_IM_MODULE=ibus /opt/Eclipse/eclipse/eclipse" >> 'Eclipse IDE for Enterprise Java and Web Developers - 2021-06.desktop'
    echo "Categories=Development;IDE;" >> 'Eclipse IDE for Enterprise Java and Web Developers - 2021-06.desktop'
    echo "Icon=/opt/Eclipse/eclipse/icon.xpm" >> 'Eclipse IDE for Enterprise Java and Web Developers - 2021-06.desktop'
    sudo mv 'Eclipse IDE for Enterprise Java and Web Developers - 2021-06.desktop' /home/vagrant/Desktop/'Eclipse IDE for Enterprise Java and Web Developers - 2021-06.desktop'
    echo 'Created Eclipse Desktop Icon...'
}

echo 'Installing Eclipse EE'
echo 'Checking for JAVA_HOME...'
check_Java_Home

# Downloading Eclipse
echo 'Downloading Eclipse IDE for Enterprise Java and Web Developers ...'

if [ ! -f eclipse*tar.gz ]
then
    wget $Eclipse_URL
fi
echo 'Finished downloading...'


# Creating Eclipse directory
echo 'Creating install directories...'
sudo mkdir -p '/opt/Eclipse'

if [ -d "/opt/Eclipse" ]
then
    echo 'Extracting binaries to install directory...'
    sudo tar -zxvf eclipse*tar.gz -C "/opt/Eclipse"

    # Updating Permissions
    echo 'Updating file permissions...'
    cd "/opt/Eclipse"
    sudo chgrp -R vagrant "/opt/Eclipse"
    sudo chmod -R 755 *
    createDesktopIcon
else
    echo 'Could not locate installation direcotry..exiting..'
    exit
fi
