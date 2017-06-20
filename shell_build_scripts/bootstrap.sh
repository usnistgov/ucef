#!/usr/bin/env bash
# Yogesh Barve <yogesh.d.barve@vanderbilt.edu>
# Himanshu Neema <himanshu@isis.vanderbilt.edu>


set_env_var_func(){
    USER_ENV_FILE="/home/vagrant/.bashrc"
    echo $1 >> $USER_ENV_FILE
    source $USER_ENV_FILE
}

disable_ipv6() {
	# Multicast in a VM doesn't work properly with IPv6, so we must
	# disable IPv6 on all network interfaces.
	sudo sh -c 'echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf'
	sudo sh -c 'echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf'
	sudo sh -c 'echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf'
	sudo sysctl -p
}

init_func() {
    sudo apt-get update
    set -x
    tr -d '\r' <  /home/vagrant/cpswt/cpswt-devtools/shell_build_scripts/env_file.sh > /home/vagrant/env_file.sh
    source /home/vagrant/env_file.sh
    set +x
	DEBIAN_FRONTEND=noninteractive 
}

openssl_func() {
    sudo apt-get install libssl-dev -y
}

git_func(){
    sudo apt-get install git -y
	sudo apt-get install gitk -y
}

python27_func(){
    sudo add-apt-repository ppa:fkrull/deadsnakes -y
    sudo apt-get update -y
    sudo apt-get install python2.7 -y
}

wireshark_func(){
	# Install wireshark
	export DEBIAN_FRONTEND=noninteractive
	sudo add-apt-repository ppa:wireshark-dev/stable -y
	sudo apt-get update -y
	sudo apt-get install wireshark -y

	sudo groupadd wireshark
	sudo usermod -a -G wireshark vagrant
	sudo chgrp wireshark /usr/bin/dumpcap
	sudo chmod 755 /usr/bin/dumpcap
	sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap

}

##########
# Docker #
##########
docker_func(){
    sudo apt-get install linux-image-extra-"$(uname -r)" -y
    sudo apt-get install apparmor -y
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    sudo sh -c "echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list"
    sudo apt-get update --fix-missing
    sudo apt-get purge lxc-docker -y
    sudo apt-cache policy docker-engine
    sudo apt-get update --fix-missing
    sudo apt-get install docker-engine -y
    sudo service docker start
    sudo usermod -aG docker vagrant
}

docker_compose_func(){
    sudo apt-get install python-pip -y
    sudo pip install docker-compose
}

######################
# WebGME Development #
######################
mongodb_func(){
    # Add the MongoDB v3.0 repository
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

    sudo apt-get update
    sudo apt-get install -y mongodb-org

	# add robomongo
    cd $HOME/Downloads/
	wget https://download.robomongo.org/0.9.0/linux/robomongo-0.9.0-linux-x86_64-0786489.tar.gz
	tar -xvzf robomongo-0.9.0-linux-x86_64-0786489.tar.gz
	sudo mkdir /usr/local/bin/robomongo
	sudo mv  robomongo-0.9.0-linux-x86_64-0786489/* /usr/local/bin/robomongo
	cd /usr/local/bin/robomongo/bin
}

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

    # Autostart WebGME on crash and reboot
    sudo cp /home/vagrant/cpswt/cpswt-devtools/config/webgme.conf /etc/init/webgme.conf
    sudo service webgme start

   
    cd $CPSWT_WEBGMEGLD_HOME
    npm install

    # Autostart WebGMEGld on crash and reboot
    sudo cp /home/vagrant/cpswt/cpswt-devtools/config/webgmegld.conf /etc/init/webgmegld.conf
    sudo service webgmegld start
}


chrome_browser_func()
{
    # Add the chrome debian repository
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

    sudo apt-get update
    sudo apt-get install google-chrome-stable -y

    # Set chrome as the default browser
    xdg-mime default google-chrome.desktop text/html
    xdg-mime default google-chrome.desktop x-scheme-handler/http
    xdg-mime default google-chrome.desktop x-scheme-handler/https
    xdg-mime default google-chrome.desktop x-scheme-handler/about
}

####################
# Java Development #
####################
openjdk7_func(){
    sudo apt-get install openjdk-7-jdk -y
}

eclipse_func(){
    cd $HOME/Downloads/
    wget --progress=bar:force  http://mirror.cc.vt.edu/pub/eclipse/technology/epp/downloads/release/neon/3/eclipse-java-neon-3-linux-gtk-x86_64.tar.gz
    tar xvf eclipse*.tar.gz -C $HOME

    # TODO: Remove 
	# Move the source code templates into the eclipse folder
    # TODO: register the templates with eclipse automatically
    # cp /home/vagrant/cpswt/cpswt-devtools/config/eclipse_*_templates.xml $HOME

    # add emf classes needed for pubsub to m2
# Edit this variable to point to your location of the files listed below.
    EMF_HOME="./config"
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

maven_func(){
    sudo apt-get install --fix-missing maven -y

	# add archiva to /etc/hosts
    cd $HOME/Downloads/
	sed '3 i127.0.0.1\tcpswtng_archiva' </etc/hosts >hosts
	sudo cp hosts /etc
	rm hosts

    # Configure maven to connect to internal archiva repository
    mkdir -p /home/vagrant/.m2
    cp /home/vagrant/cpswt/cpswt-devtools/config/settings.xml $HOME/.m2/settings.xml
}

archiva_docker_func(){
    sudo docker run --restart unless-stopped -v /home/vagrant/archiva:/var/archiva -p 8080:8080 -d ninjaben/archiva-docker
	# Untill the password time out reset issue is resolved lets have a manual user/role creation
	#sudo tar czvf $HOME/vagrant/archiva /vagrant/config/archiva_backup.tar.gz

	# stop instance
	#sudo docker stop "tender_banach"

	# place prepopulated initial database
	#cd $HOME
	#sudo rm -rf $HOME/archiva
	#sudo tar xvf /vagrant/config/archiva_initial.tar.gz

	# restart instance
	#sudo docker start "tender_banach"
	#sleep 20

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
#######################
# Simulation Software #
#######################
gridlabd_func(){
    sudo apt-get install automake autoconf libtool curl subversion build-essential libxerces-c-dev  cmake -y

    ############ MOST IMPORTANT
    # Most Important Note!!!!!: We need to stick with commit 5307.....
    cd $HOME/Downloads/
#    sudo svn co -q svn://svn.code.sf.net/p/gridlab-d/code/trunk@5307 gridlab-d-code
    sudo svn co -q svn://svn.code.sf.net/p/gridlab-d/code/trunk gridlab-d-code

    cd $HOME/Downloads/gridlab-d-code
    sudo mkdir -p /usr/local/gridlab-d
    sudo autoreconf -isf
    sudo ./configure --prefix=/usr/local/gridlab-d --enable-silent-rules
    sudo make && sudo make install
	   sudo ln -s /usr/local/gridlab-d/bin/gridlabd /usr/local/bin/gridlabd
}

########################
# Federate Source Code #
########################
boost_func(){
    sudo apt-get install --fix-missing gcc g++ wget libboost-all-dev libmysqlcppconn-dev -y
}

portico_func(){
    PORTICO_VERSION=2.1.0

    # Download and extract portico
    cd $HOME/Downloads/
    wget --progress=bar:force  http://downloads.sourceforge.net/project/portico/Portico/portico-$PORTICO_VERSION/portico-$PORTICO_VERSION-linux64.tar.gz
    tar xzf portico-$PORTICO_VERSION-linux64.tar.gz -C $HOME

    # Set the RTI_HOME environment variable
    echo "export RTI_HOME=\"/home/vagrant/portico-$PORTICO_VERSION\"" >> $HOME/.bashrc
    source $HOME/.bashrc

    set_env_var_func "RTI_HOME=/home/vagrant/portico-$PORTICO_VERSION"

    # Install portico to the internal archiva repository
    mvn install:install-file -Dfile=$HOME/portico-$PORTICO_VERSION/lib/portico.jar -DgroupId=org.porticoproject -DartifactId=portico -Dversion=$PORTICO_VERSION -Dpackaging=jar -DgeneratePom=true
}

# federate_src_func(){
#     mvn -f $JAVA_ROOT_FOUNDATION_SRC/c2w-jni/pom.xml install
#     mvn -f $JAVA_ROOT_FOUNDATION_SRC/c2w-foundation/pom.xml install
#     mvn -f $CPP_ROOT_FOUNDATION_SRC/3rdparty/pom.xml install
#     mvn -f $JAVA_ROOT_FOUNDATION_SRC/foundation/pom.xml install
# }

######################
# Other Applications #
######################
terminator_func(){
    sudo apt-get install terminator -y
}

sublime3_func(){
    sudo add-apt-repository ppa:webupd8team/sublime-text-3
    sudo apt-get update
    sudo apt-get install sublime-text-installer -y
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

ansible_func(){
	sudo apt-get install  -y software-properties-common
	sudo apt-add-repository  -y ppa:ansible/ansible
	sudo apt-get update -y
	sudo apt-get install  -y ansible
	sudo apt-get install -y libxml2-dev libxslt-dev python-dev
	sudo apt-get install -y python3-lxml
}

selenium_func() {
    cd $HOME/Downloads/
	sudo pip install selenium
	wget https://chromedriver.storage.googleapis.com/2.27/chromedriver_linux64.zip
}

###########
# Cleanup #
###########

build_docker_image(){
    cd $Docker_FED_SRC/c2wtcore
    sudo docker-compose build
}


gnome_func(){
	# add terminal option to nautilus
	sudo apt-get install nautilus-open-terminal -y

    # Set environment variable required for gsettings
    PID=$(pgrep gnome-session)
    export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)

    # Set launcher shortcuts
    mkdir -p $HOME/.local/share/icons/hicolor/48x48/apps
    cp /home/vagrant/cpswt/cpswt-devtools/config/*.desktop $HOME/.local/share/applications
    cp /home/vagrant/cpswt/cpswt-devtools/config/*.png $HOME/.local/share/icons/hicolor/48x48/apps
    gsettings set com.canonical.Unity.Launcher favorites "['application://ubiquity.desktop', 'application://nautilus.desktop', 'archiva.desktop', 'eclipse.desktop', 'webgme.desktop', 'google-chrome.desktop', 'gnome-terminal.desktop', 'mysql-workbench.desktop', 'gedit.desktop', 'wireshark.desktop']"

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

####################
# Unused Functions #
####################
# Install the necessary Java Version on the Virtual Machine
java6_func(){
    echo "installing java6"
    oracle-java6-installer
    sudo echo oracle-java6-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
    sudo apt-get install oracle-java6-installer -y
    sudo apt-get install oracle-java6-set-default -y
    echo "Current Java Version is: "
    java -version
}

#This installs the java
java7_func(){
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
    sudo apt-get install oracle-java7-installer -y
    sudo apt-get install oracle-java7-set-default -y
}

#This installs the java
java8_func(){
    sudo add-apt-repository ppa:webupd8team/java -y
    sudo apt-get update
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
    sudo apt-get install oracle-java8-installer -y
    sudo apt-get install oracle-java8-set-default -y
}

#Finally Prepare this Box for package
emptybox_func(){
    sudo apt-get clean -y
    sudo dd if=/dev/zero of=/EMPTY bs=1M
    sudo rm -f /EMPTY
}

#lastly clear the bash_history and quit
historyclear_func(){
    echo "Cleaning the history"
    cat /dev/null > /home/vagrant/.bash_history && history -c
}
#Finally shutdown the system
shutdown_func(){
    echo "System Shutting Down"
    sudo shutdown now -h
}

# Install Shipyard for Docker Visualization
shipyard_func(){
    # May have a conflit with default port 8080
    curl -s https://shipyard-project.com/deploy | sudo bash -s
}

# Installs the Chromium
chromium_func(){
    sudo apt-get install chromium-browser -y
}

# Installs the webgme_cli_tool
webgme_cli_func(){

  npm install -g webgme/webgme-setup-tool

}

initialize_maven_archiva_settings_func()
{
    PORTICO_VERSION=2.1.0
    mkdir -p /home/vagrant/.m2
#    cp /home/vagrant/Projects/cpswt/src/dev-tools/settings.xml /home/vagrant/.m2/settings.xml
    #cp /home/vagrant/cpswt/src/dev-tools/settings.xml /home/vagrant/.m2/settings.xml
    cp $ARCHIVA_SETTINGS_XML_DIR/settings.xml /home/vagrant/.m2/settings.xml
    
}

download_cpswt_code_base_func(){
    CPSWT_PROJECT_DIR=/home/vagrant/CPSWT_Project/
    mkdir -p $CPSWT_PROJECT_DIR
    cd $CPSWT_PROJECT_DIR
    echo "Next we need to login to the Vulcan to pull C2WT Repositories....."
    echo "Type the vulcan.isis.vanderbilt username now, followed by [ENTER]:"
    read -r vulcanuser
    svn checkout https://"$vulcanuser"@svn.vulcan.isis.vanderbilt.edu/projects/cpswt/trunk .
}

build_foundation_classes_func (){

	cd $JAVA_ROOT_FOUNDATION_SRC
	sudo chmod +x setup_foundation_java.sh
	sh setup_foundation_java.sh
	cd $CPP_ROOT_FOUNDATION_SRC
	sudo chmod +x setup_foundation.sh
	sh setup_foundation.sh

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
}

archiva_ansible_func(){
    rm -rf /home/vagrant/ansible/
    mkdir -p /home/vagrant/ansible/
    cp -r /vagrant/ansible/* /home/vagrant/ansible/
    cd /home/vagrant/ansible
    sh install_requirements.sh
    ansible-playbook main.yml -vv

    # create service start script for autostart (overrides what absible installs)
    echo "sudo service archiva start" > startarchiva.sh
    sudo chmod +x startarchiva.sh
    sudo chown root:root startarchiva.sh
    sudo mv startarchiva.sh /opt/apache-archiva-2.2.1/bin/
    sudo ln -s -f /opt/apache-archiva-2.2.1/bin/startarchiva.sh /etc/rc2.d/S20archiva

}

# initialization
init_func
disable_ipv6
openssl_func
openjdk7_func
java8_func

# # databases 
echo "UCEF-----> Install Databases"
mongodb_func
mysql_func

# # java development
echo "UCEF-----> Install management tools"
ansible_func
maven_func
portico_func
archiva_ansible_func

# # docker
echo "UCEF-----> Install Docker"
docker_func
docker_compose_func
build_docker_image

# # webgme development
echo "UCEF-----> Install WEBGME Development"
node_func
webgme_func
selenium_func

# # Cpp libs
echo "UCEF-----> Install Boost and CPPNet Libs"
boost_func
cppnetlib_func

# # simulation software
echo "UCEF-----> Install Gridlab-D"
gridlabd_func

# # federate source code
echo "UCEF-----> Build Foundation Classes"
build_foundation_classes_func

# # misc applications
echo "UCEF-----> Misc Tools"
chrome_browser_func
eclipse_func
terminator_func
sublime3_func
vim_func
ntp_func
nmap_func
mc_func
wireshark_func

# # cleanup
echo "UCEF-----> Cleanup"
gnome_func
cleanup_func
