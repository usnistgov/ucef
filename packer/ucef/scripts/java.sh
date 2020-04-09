#!/bin/bash -eux

# install OpenJDK 13
add-apt-repository -y ppa:openjdk-r/ppa
apt-get install -y openjdk-13-jdk 

# set JAVA_HOME (variable provided through Packer)
echo "JAVA_HOME=$JAVA_HOME" | tee -a /etc/environment

# cleanup OpenJDK 13
apt-add-repository --remove ppa:openjdk-r/ppa
apt-get update -y

# install maven
apt-get install -y maven
