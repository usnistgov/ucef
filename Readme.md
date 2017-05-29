

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
1) create a subdirectory .secrets and place your public and private keys for the repository with the names id_rsa_git_key and id_rsa_git_key.pub
1) Edit the file shell_build_scripts/dev_repos.json and place your username in the "vulcanuser" value.
1) After installing Vagrant (or if you already have it installed), we need to make sure that Guest-Additions plugin is installed in Vagrant, by running the command on a DOS command prompt:
    
        vagrant plugin install vagrant-vbguest

1) Issue command in the folder which contains the Vagrantfile (note: there will be some "system error" dialogs in the VM while it is being built; ignore them):
    
        vagrant up --provision

1) When the script finishes, run:

        vagrant reload


**This will install the virtual Image with:**

- git
- mongodb & robomongo
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


**UserName and Password for the Virtual Machine is default vagrant**



Archiva Repository:
#Ensure Archiva running:
#http://cpswtng_archiva:8080

-----

For running a sample example, refer to /home/vagrant/Projects/cpswt/samples/HelloWorld/Readme.txt

# ToDo:

1) Put gridlab-d and portico and other downloaded repos under repos so all are extracted in the python script.
1) Change source of gridlabd source code to git and current release branch
1) Test on MAC
1) Eliminate Portico and dockerfeds folders (done elsewhere)
1) Test with VMWare
1) change cpswt ucefsrc

oracle java8 installer:
==> UCEF 1.0.0-alpha: Failed to open terminal.debconf: whiptail output the above errors, giving up!