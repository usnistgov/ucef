#!/usr/bin/env bash
# Yogesh Barve <yogesh.d.barve@vanderbilt.edu>
# Himanshu Neema <himanshu@isis.vanderbilt.edu>
# Martin Burns <martin.burns@nist.gov>


init_func() {
    # add needed repositories
    sudo add-apt-repository universe
    sudo add-apt-repository ppa:wireshark-dev/stable -y
    sudo add-apt-repository -y ppa:webupd8team/java
    sudo apt-add-repository  -y ppa:ansible/ansible
   
    sudo apt-get update -y --fix-missing

    tr -d '\r' <  /vagrant/shell_build_scripts/env_file.sh > /home/vagrant/env_file.sh
    source /home/vagrant/env_file.sh
    DEBIAN_FRONTEND=noninteractive 


    # Multicast in a VM doesn't work properly with IPv6, so we must
    # disable IPv6 on all network interfaces.
    sudo sh -c 'echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf'
    sudo sh -c 'echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf'
    sudo sh -c 'echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf'
    sudo sysctl -p

    sudo apt-get install libssl-dev -y
}

####################
# mongo            #
####################
mongodb_func(){
    # Add the MongoDB v3.0 repository
    sudo rm /etc/apt/sources.list.d/mongodb*.list
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
    sudo echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > tempfile 
    sudo mv tempfile /etc/apt/sources.list.d/mongodb-org-3.2.list
    sudo apt update -y
    sudo apt install mongodb-org -y -f

    sudo cp /home/vagrant/ucefcodebase/ucef-devtools/build/config/mongod.service /etc/systemd/mongod.service
    sudo systemctl enable /etc/systemd/mongod.service
    sudo systemctl daemon-reload
    sudo systemctl start mongod

    # add robomongo
    cd $HOME/Downloads/
    wget -q https://download.robomongo.org/0.9.0/linux/robomongo-0.9.0-linux-x86_64-0786489.tar.gz
    tar -xvzf robomongo-0.9.0-linux-x86_64-0786489.tar.gz
    sudo mkdir /usr/local/bin/robomongo
    sudo mv  robomongo-0.9.0-linux-x86_64-0786489/* /usr/local/bin/robomongo
    sudo ln -s /usr/local/bin/robomongo/bin/robomongo /usr/local/bin/robomon
}

####################
# mysql            #
####################
mysql_func(){
    # Make sure dependencies have been updated
    sudo debconf-set-selections <<<'mysql-server mysql-server/root_password  password c2wt'
    sudo debconf-set-selections <<<'mysql-server mysql-server/root_password_again  password c2wt'
    sudo apt-get install -yf

    # Install mysql server
    sudo debconf-set-selections <<<'mysql-server mysql-server/root_password  password c2wt'
    sudo debconf-set-selections <<<'mysql-server mysql-server/root_password_again  password c2wt'
    sudo apt-get install -y mysql-server mysql-common mysql-client

    # Instsall workbench
    sudo apt-get install -y mysql-workbench
}

jquerry_func (){
    sudo apt-get install -y -f jq
}

#######################
# ucef development   ##
#######################
ucef_tools_func () {
    cd /home/vagrant/ucefcodebase/ucef-gateway
    mvn clean install -U
    cd /home/vagrant/ucefcodebase/ucef-library/Federates/metronome/source
    mvn clean install -U
    cd /home/vagrant/ucefcodebase/ucef-library/Federates/tmy3weather/source
    mvn clean install -U
    cd /home/vagrant/ucefcodebase/ucef-database
    mvn clean install -U
    cd /home/vagrant/ucefcodebase/ucef-gridlabd
    ./build.sh
    cd /home/vagrant/ucefcodebase/ucef-labview
    mvn clean install -U
    cd /home/vagrant/ucefcodebase/ucef-devtools/test
    sudo chmod +x *.sh

    echo "export PATH=/home/vagrant/ucefcodebase/ucef-devtools/test:$PATH" >> $HOME/.bashrc
    echo "export PATH=/home/vagrant/ucefcodebase/ucef-devtools/test:$PATH" >> $HOME/env_file.sh
    source $HOME/env_file.sh
}

####################
# management tools #
####################
#This installs the java
java8_func(){
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
    sudo apt-get install oracle-java8-installer -y
    sudo apt-get install oracle-java8-set-default -y
    sudo apt-get install default-jdk -y
}

maven_func(){
    sudo apt-get install maven -y -f
    
    # add archiva to /etc/hosts
    cd $HOME/Downloads/
    sed '3 i127.0.0.1\tcpswtng_archiva' </etc/hosts >hosts
    sudo cp hosts /etc
    rm hosts
}

portico_func(){
    PORTICO_VERSION=2.1.0

    # Download and extract portico
    cd $HOME/Downloads/
    wget -q  http://downloads.sourceforge.net/project/portico/Portico/portico-$PORTICO_VERSION/portico-$PORTICO_VERSION-linux64.tar.gz
    tar xzf portico-$PORTICO_VERSION-linux64.tar.gz -C $HOME
    sudo mv $HOME/portico-$PORTICO_VERSION /usr/local/portico-$PORTICO_VERSION

    # Set the RTI_HOME environment variable
    echo "export RTI_HOME=/usr/local/portico-$PORTICO_VERSION" >> $HOME/.bashrc
    echo "export RTI_HOME=/usr/local/portico-$PORTICO_VERSION" >> $HOME/env_file.sh
    source $HOME/env_file.sh

    # we will put it in archiva in the ansible script
}

##########
# Ansible #
##########
ansible_func(){
    sudo apt-get install  -y software-properties-common
    sudo apt-get install -y -f ansible
    sudo apt-get install -y -f libxml2-dev libxslt-dev python-dev
    sudo apt-get install -y -f python3-lxml
}

##########
# Archiva #
##########
archiva_ansible_func(){
    rm -rf /home/vagrant/ansible/
    mkdir -p /home/vagrant/ansible/
    cp -r /vagrant/ansible/* /home/vagrant/ansible/
    cd /home/vagrant/ansible
    sh install_requirements.sh
    ansible-playbook main.yml -vv
    sudo update-rc.d archiva defaults 80
}

##########
# Docker #
##########
docker_func(){

    # install instructions https://docs.docker.com/install/linux/docker-ce/ubuntu/#os-requirements
    sudo apt-get install -y linux-image-extra-$(uname -r)
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"

    sudo apt-get update -y
    sudo apt-get purge lxc-docker

    sudo apt-get install docker-ce -y -f --allow-unauthenticated
    sudo service docker start
    sudo usermod -aG docker vagrant

    sudo pip install docker-compose
}

# Install Shipyard for Docker Visualization
shipyard_func(){
    # May have a conflit with default port 8080
    curl -s https://shipyard-project.com/deploy | sudo bash -s
}

##########
# Wireshark #
##########
wireshark_func(){
    echo "${CPSWT_FLAVOR}-----> Installing Wireshark app"

    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install wireshark
    echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
    sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure wireshark-common

    echo "${CPSWT_FLAVOR}-----> Install Group"
    #sudo groupadd wireshark
    sudo addgroup -quiet -system wireshark
    echo "${CPSWT_FLAVOR}-----> Modify Group"
    sudo usermod -a -G wireshark vagrant
    sudo chgrp wireshark /usr/bin/dumpcap
    sudo chmod 755 /usr/bin/dumpcap
    echo "${CPSWT_FLAVOR}-----> Set Group Capabilities"
    sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
}



##########
# Eclipse #
##########
eclipse_func(){
    cd $HOME/Downloads/
    wget --progress=bar:force  http://mirror.cc.vt.edu/pub/eclipse/technology/epp/downloads/release/neon/3/eclipse-java-neon-3-linux-gtk-x86_64.tar.gz
    tar xvf eclipse*.tar.gz -C $HOME

    # add emf classes needed for pubsub to m2
    # Edit this variable to point to your location of the files listed below.
    EMF_HOME="/home/vagrant/eclipse/plugins"
    GROUP="org.eclipse.emf"

    mvn install:install-file \
        -Dfile=$EMF_HOME/org.eclipse.emf.common_2.12.0.v20160420-0247.jar \
        -DgroupId=$GROUP \
        -DartifactId=org.eclipse.emf.common \
        -Dversion=2.12.0 \
        -Dpackaging=jar
        
    mvn install:install-file \
        -Dfile=$EMF_HOME/org.eclipse.emf.ecore_2.12.0.v20160420-0247.jar \
        -DgroupId=$GROUP \
        -DartifactId=org.eclipse.emf.ecore \
        -Dversion=2.12.0 \
        -Dpackaging=jar
        
    mvn install:install-file \
        -Dfile=$EMF_HOME/org.eclipse.emf.ecore.xmi_2.12.0.v20160420-0247.jar \
        -DgroupId=$GROUP \
        -DartifactId=org.eclipse.emf.ecore.xmi \
        -Dversion=2.12.0 \
        -Dpackaging=jar    
}



##########
# Chrome #
##########
chrome_browser_func()
{
    # get chrome
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt-get update -y --fix-missing
    sudo apt-get -y install google-chrome-stable

    # Set chrome as the default browser
    xdg-mime default google-chrome.desktop text/html
    xdg-mime default google-chrome.desktop x-scheme-handler/http
    xdg-mime default google-chrome.desktop x-scheme-handler/https
    xdg-mime default google-chrome.desktop x-scheme-handler/about
}



######################
# WebGME Development #
######################
node_func(){
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
    source /home/vagrant/.nvm/nvm.sh
    nvm install 4.5.0
    nvm use 4.5.0
    nvm alias default 4.5.0
}

webgme_func()
{
    cd $CPSWT_WEBGME_HOME
    npm install

    # configure WebGME service
    sudo cp /home/vagrant/ucefcodebase/ucef-devtools/build/config/webgme.service /etc/systemd/webgme.service
    sudo systemctl enable /etc/systemd/webgme.service
    sudo systemctl daemon-reload
    sudo systemctl start webgme

    cd $CPSWT_WEBGMEGLD_HOME
    npm install

    # Autostart WebGMEGld on crash and reboot
    sudo cp /home/vagrant/ucefcodebase/ucef-devtools/build/config/webgmegld.service /etc/systemd/webgmegld.service
    sudo systemctl enable /etc/systemd/webgmegld.service
    sudo systemctl daemon-reload
    sudo systemctl start webgmegld
}

selenium_func() {
    cd $HOME/Downloads/
    sudo pip install selenium
    wget https://chromedriver.storage.googleapis.com/2.27/chromedriver_linux64.zip
}

boost_func(){
    sudo apt-get install --fix-missing gcc g++ wget libboost-all-dev libmysqlcppconn-dev -y
}

cppnetlib_func(){
    sudo mkdir /usr/local/cpp-netlib

    cd /usr/local/cpp-netlib 
    sudo wget https://github.com/cpp-netlib/cpp-netlib/archive/cpp-netlib-0.11.2-final.tar.gz 
    sudo tar xvf  cpp-netlib-0.11.2-final.tar.gz

    cd /usr/local/cpp-netlib
    sudo mkdir cpp-netlib-build 
    cd cpp-netlib-build
    sudo cmake -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_COMPILER=g++ \
    ../cpp-netlib-cpp-netlib-0.11.2-final 
    sudo make 
    sudo make install
    sudo rm ../cpp-netlib-0.11.2-final.tar.gz

    echo "export BOOST_NETWORK_INC_DIR=/usr/local/cpp-netlib/cpp-netlib-cpp-netlib-0.11.2-final" >> $HOME/env_file.sh
    echo "export BOOST_NETWORK_INC_DIR=/usr/local/cpp-netlib/cpp-netlib-cpp-netlib-0.11.2-final" >> $HOME/.bashrc
    source $HOME/env_file.sh
}

########################
# Federate Source Code #
########################
build_foundation_classes_func (){
    source $HOME/env_file.sh
    echo "Home: $HOME"
    echo "RTI_HOME: $RTI_HOME"

    # java foundation
    echo "Maven install and deploy java foundation projects"
    cd ${JAVA_ROOT_FOUNDATION_SRC}/cpswt-core
    mvn -DRTI_HOME=$RTI_HOME clean install deploy -U -B

    # CPP 3rdparty
    echo "Compiling 3rd party libraries first"
    cd ${CPP_ROOT_FOUNDATION_SRC}/3rdparty
    mvn -DRTI_HOME=$RTI_HOME clean install deploy -fae -U -B

    # CPP foundation
    echo "Compiling cpp foundation libraries" 
    cd ${CPP_ROOT_FOUNDATION_SRC}/foundation
    mvn -DRTI_HOME=$RTI_HOME clean install deploy -fae -U -B

    echo "=================================================================================="
    echo "Completed the compilation, installation, deployment of CPSWT foundation packages  "
    echo "=================================================================================="
}


#######################
# Simulation Software #
#######################

omnetpp_func (){
    # General dependencies
    sudo apt-get install -y -f\
    git \
    wget \
    vim \
    build-essential \
    clang \
    bison \
    flex \
    perl \
    tcl-dev \
    tk-dev \
    libxml2-dev \
    zlib1g-dev \
    default-jre \
    graphviz \
    libwebkitgtk-1.0-0 \
    xvfb
    
    # QT5 components
    sudo apt-get install -y -f\
    qt5-default \
    qt5-qmake \
    qtbase5-dev \
    openscenegraph \
    libopenscenegraph-dev \
    openscenegraph-plugin-osgearth \
    osgearth \
    osgearth-data \
    doxygen \
    libosgearth-dev

    # OMNeT++ 5

    export OMNET_VERSION=5.2.1
    export HOSTNAME
    export HOST
    export DISPLAY=:0.0
    echo "export PATH=/opt/omnetpp/omnetpp-$OMNET_VERSION/bin/:$PATH" >> $HOME/.bashrc
    echo "export PATH=/opt/omnetpp/omnetpp-$OMNET_VERSION/bin/:$PATH" >> $HOME/env_file.sh
    echo "export OMNETPP_CONFIGFILE=/opt/omnetpp/omnetpp-$OMNET_VERSION/Makefile.inc" >> $HOME/.bashrc
    echo "export OMNETPP_CONFIGFILE=/opt/omnetpp/omnetpp-$OMNET_VERSION/Makefile.inc" >> $HOME/env_file.sh
    source $HOME/env_file.sh

    echo "PATH=$PATH"
    echo "HOSTNAME=$HOSTNAME"
    echo "HOST=$HOST"
    echo "DISPLAY=$DISPLAY"
    echo "OMNETPP_CONFIGFILE=$OMNETPP_CONFIGFILE"

    # Create working directory
    sudo mkdir -p /opt/omnetpp

    # Fetch Omnet++ source
    # (Official mirror "doesn't support" command line downloads. Fortunately, we don't care)
    cd ~/Downloads

    wget -q https://s3.amazonaws.com/nist-sgcps/UCEF/ucefvms/omnetpp-$OMNET_VERSION-src-linux.tgz

#    wget -q --header="Accept: text/html" --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" --referer="https://omnetpp.org" --output-document=omnetpp-5.2.1-src.tgz https://www.omnetpp.org/omnetpp/send/30-omnet-releases/2321-omnetpp-5-2-1-linux
    tar -xf omnetpp-$OMNET_VERSION-src-linux.tgz
    sudo mv omnetpp-$OMNET_VERSION /opt/omnetpp

    # Configure and compile omnet++
    cd /opt/omnetpp/omnetpp-$OMNET_VERSION
    

    #source setenv
    ./configure WITH_QTENV=no
    make

    #install inet library (NIST clone of inet on github)
    git clone -b feature/can --recursive https://github.com/usnistgov/inet.git
    cd inet
    ./inet_featuretool reset
    ./inet_featuretool disable wirelesstutorial
    ./inet_featuretool disable wirelessshowcases
    ./inet_featuretool disable visualizationtutorial
    ./inet_featuretool disable configuratortutorial
    ./inet_featuretool disable visualizershowcases
    make makefiles
    make

#    #install inet library
#    cd ~/Downloads
#    wget -q https://github.com/inet-framework/inet/releases/download/v3.6.3/inet-3.6.3-src.tgz
#    tar xvfz inet-3.6.3-src.tgz
#    sudo mv inet /opt/omnetpp/omnetpp-5.2.1/
#    cd /opt/omnetpp/omnetpp-5.2.1/inet
#    make makefiles
#    make
    
    sudo ln -s /opt/omnetpp/omnetpp-5.2.1/ide/omnetpp /usr/local/bin/omnetpp

}

gridlabd_func(){
    sudo apt-get install automake autoconf libtool curl subversion build-essential libxerces-c-dev  cmake -y

    ############ MOST IMPORTANT
    # careful use of opt directory to maintain ownership by vagrant:vagrant and not root
    cd $HOME/Downloads/
    git clone https://github.com/gridlab-d/gridlab-d.git gridlab-d-code
    sudo mv gridlab-d-code /opt

    cd /opt/gridlab-d-code
    # 20180907 MJB - Commit in gridlabd caused compile to fail on ucef. Use September 5 2018 commit
    #git checkout develop 
    git checkout 75b40d9e8d9b77507a5055b62e4c221d132f6c79
    sudo mkdir -p /usr/local/gridlab-d
    autoreconf -isf
     ./configure --enable-silent-rules 'CFLAGS=-g -O0 -w' 'CXXFLAGS=-g -O0 -w' 'LDFLAGS=-g -O0 -w'
    make && sudo make install
    sudo ln -s /usr/local/gridlab-d/bin/gridlabd /usr/local/bin/gridlabd
}

build_docker_image(){
    cd $Docker_FED_SRC/c2wtcore
    sudo docker-compose build
}

######################
# Misc Applications #
######################
terminator_func(){
    sudo apt-get install terminator -y
}

vim_func(){
    sudo apt-get install vim -y

    # Configure vim to use 4 spaces instead of tabs for indentation
    echo -e "set expandtab\nset tabstop=4\nset shiftwidth=4" > /home/vagrant/.vimrc
}

ntp_func(){
    sudo apt-get install ntp -y
}

nmap_func(){
    # network mapper
    sudo apt-get install nmap -y --force-yes
}

mc_func(){
    # midnight commander
    sudo apt-get install mc -y
}





###########
# Cleanup #
###########
gnome_func(){
    # add terminal option to nautilus
    sudo apt-get install nautilus-open-terminal -y

    # Set environment variable required for gsettings
    PID=$(pgrep gnome-session)
    export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)

    # Set launcher shortcuts
    mkdir -p $HOME/.local/share/icons/hicolor/48x48/apps
    cp /home/vagrant/ucefcodebase/ucef-devtools/build/config/*.desktop $HOME/.local/share/applications
    cp /home/vagrant/ucefcodebase/ucef-devtools/build/config/*.png $HOME/.local/share/icons/hicolor/48x48/apps
    gsettings set com.canonical.Unity.Launcher favorites "['application://ubiquity.desktop', 'application://nautilus.desktop', 'archiva.desktop', 'eclipse.desktop', 'webgme.desktop', 'google-chrome.desktop', 'gnome-terminal.desktop', 'mysql-workbench.desktop', 'gedit.desktop', 'wireshark.desktop', 'omnetpp.desktop']"

    # Enable workspaces
    gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
    gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2

    # Turn off automatic screen lock
    gsettings set org.gnome.desktop.session idle-delay 0

    # allow vagrant to access shared folders
    sudo adduser vagrant vboxsf

    # set default terminal
    gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/gnome-terminal
    gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-x"

    # set shorter prompt
    echo "export PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '" >> $HOME/.bashrc
}

cleanup_func(){
    sudo apt-get clean -y

    # Remove the crash reports
    sudo rm -rf /var/crash

    # Remove the downloaded files
    sudo rm -r $HOME/Downloads/*
}

###############################################################################
# Installation Script                                                         #
###############################################################################
echo ${CPSWT_FLAVOR}-----> Start of VM Build `date`

# initialization
echo "${CPSWT_FLAVOR}-----> Initialization"
init_func

# databases 
echo "${CPSWT_FLAVOR}-----> Install Databases"
mongodb_func
mysql_func

# java development and management tools
echo "${CPSWT_FLAVOR}-----> Install management tools"
echo "${CPSWT_FLAVOR}-----> Install Java"
java8_func
echo "${CPSWT_FLAVOR}-----> Install Maven"
maven_func
echo "${CPSWT_FLAVOR}-----> Install portico"
portico_func
echo "${CPSWT_FLAVOR}-----> Install Ansible"
ansible_func
echo "${CPSWT_FLAVOR}-----> Install Archiva"
archiva_ansible_func
echo "${CPSWT_FLAVOR}-----> Install Docker"
docker_func
echo "${CPSWT_FLAVOR}-----> Install Wireshark"
wireshark_func
echo "${CPSWT_FLAVOR}-----> Install Eclipse"
eclipse_func
echo "${CPSWT_FLAVOR}-----> Install Chrome"
chrome_browser_func

#######################
# webgme development ##
#######################
echo "${CPSWT_FLAVOR}-----> Install WEBGME Development"
node_func
webgme_func
selenium_func
echo "${CPSWT_FLAVOR}-----> Install Boost and CPPNet Libs"
boost_func
cppnetlib_func
jquerry_func

#######################
# federate source code
#######################
echo "${CPSWT_FLAVOR}-----> Build Foundation Classes"
build_foundation_classes_func

#######################
# simulation software #
#######################

# install network simulator
echo "${CPSWT_FLAVOR}-----> Install Omnet++"
omnetpp_func

# install gridlab-d
echo "${CPSWT_FLAVOR}-----> Install Gridlab-D"
gridlabd_func


echo "${CPSWT_FLAVOR}-----> Build Docker Image"
build_docker_image

#######################
# ucef development   ##
#######################
echo "${CPSWT_FLAVOR}-----> Install UCEF Tools Development"
ucef_tools_func


#####################
# misc applications #
#####################
echo "${CPSWT_FLAVOR}-----> Misc Tools"
terminator_func
vim_func
ntp_func
nmap_func
mc_func

#######################
# cleanup
#######################
echo "${CPSWT_FLAVOR}-----> Cleanup"
gnome_func

# %%%% 20180517 mjb not sure this is still needed remnant from earlier debug
sudo apt-get install --reinstall libnss3 -y -f

cleanup_func

echo ${CPSWT_FLAVOR}-----> End of VM Build `date`
