UCEF Virtual Machine
=============================

## Download Current VM Image
  https://s3.amazonaws.com/nist-sgcps/UCEF/ucefvms/UCEF+1.0.0-alpha-20170725.ova
  
## Build Instructions

### Prerequisites 
1) Make sure you have installed Oracle Virtualbox and Vagrant software (see the links below): 
- Oracle Virtualbox: https://www.virtualbox.org/ 
- Vagrant: https://www.vagrantup.com/docs/installation/ - Downloads: https://www.vagrantup.com/downloads.html

1) After installing Vagrant (or if you already have it installed), we need to make sure that Guest-Additions plugin is installed in Vagrant, by running the command on a DOS command prompt:
    
        vagrant plugin install vagrant-vbguest

### Build the VM

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
