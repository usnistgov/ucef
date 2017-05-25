

CPSWT Docker Virtual Machine
=============================

Instruction:

Pre-requisite 
- Virtualbox
- Vagrant
Instruction to install:
-  Vagrant: https://www.vagrantup.com/docs/installation/
-  Downloads: https://www.vagrantup.com/downloads.html

 # Prerequisites 
1) Make sure you have installed Oracle Virtualbox and Vagrant software (see the links below): - Oracle Virtualbox: https://www.virtualbox.org/ - Vagrant: https://www.vagrantup.com/docs/installation/ - Downloads: https://www.vagrantup.com/downloads.html
2) After installing Vagrant (or if you already have it installed), we need to make sure that Guest-Additions plugin is installed in Vagrant, by running the command on a DOS command prompt:
    
        vagrant plugin install vagrant-vbguest

1) Issue command in the folder which contains the Vagrantfile:
    
        vagrant up --provision

1a) When the script finishes, run:

        vagrant reload


This will install the virtual Image with:

- git
- mongodb
- node
- openjdk7
- docker
- python27
- shipyard
- terminator
- chromium
- webgme_cli
- eclipse
- maven
- archiva_docker
- gridlabd
- mysql & mysql-workbench


UserName and Password for the Machine is default vagrant



Archiva Repository:
#Ensure Archiva running:
#http://cpswtng_archiva:8080

-----

For running a sample example, refer to /home/vagrant/Projects/cpswt/samples/HelloWorld/Readme.txt

