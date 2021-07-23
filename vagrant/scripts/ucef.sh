#!/bin/bash -eux
UCEF_HOME=/home/vagrant/ucef
NODE_VERSION=v12.16.1

# clone the UCEF repositories
pushd /tmp/vagrant
python3 clone_ucef.py $UCEF_HOME
popd

# build the UCEF repositories
#   these directory names should be consistent with clone_ucef.json
cd $UCEF_HOME/java/cpswt-core
mvn clean install -B -Dmaven.javadoc.skip=true
cd $UCEF_HOME/cpp/3rdparty
mvn clean install -B
cd $UCEF_HOME/cpp/foundation
mvn clean install -B
cd $UCEF_HOME/gateway
mvn clean install -B
cd $UCEF_HOME/database
mvn clean install -B
cd $UCEF_HOME/gridlabd
./build.sh
cd $UCEF_HOME/labview
mvn clean install -B
 
# build WebGME
cd $UCEF_HOME/meta
source /home/vagrant/.nvm/nvm.sh >/dev/null
npm install

# fix the paths for the webgme.service file
sed -i "s,WorkingDirectory=,WorkingDirectory=$UCEF_HOME/meta,g" /tmp/vagrant/webgme.service
sed -i "s,ExecStart=,ExecStart=/home/vagrant/.nvm/versions/node/$NODE_VERSION/bin/node $UCEF_HOME/meta/app.js,g" /tmp/vagrant/webgme.service

# start WebGME service
sudo mv /tmp/vagrant/webgme.service /etc/systemd/webgme.service
sudo systemctl enable /etc/systemd/webgme.service
sudo systemctl daemon-reload
sudo systemctl start webgme

# required for PyPower (please remove)
sudo apt-get install -y python3-pip
sudo pip3 install -r /home/vagrant/ucef/transactive-energy/src/tesp/TE30/TE30_generated/TE30-java-federates/TE30-impl-java/PyPower/src/main/resources/requirements.txt

