#!/bin/bash

# Eclipse download link <<version>>
SoapUI_URL="https://s3.amazonaws.com/downloads.eviware/soapuios/5.6.0/SoapUI-x64-5.6.0.sh"

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

echo 'Installing SoapUI 5.6...'
echo 'Checking for JAVA_HOME...'
check_Java_Home

# Downloading SoapUI 5.6
echo 'Downloading SoapUI 5.6...'

if [ ! -f SoapUI*sh ]
then
    wget $SoapUI_URL
fi
echo 'Finished downloading...'


# Installing SoapUI 5.6 

if [ -f SoapUI*sh ]
then
    echo 'Installing SoapUI 5.6...'
    sudo chmod 755 SoapUI*sh
    ./SoapUI*sh
else
    echo 'Could not locate installation file..exiting..'
    exit
fi
