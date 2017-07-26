UCEF Virtual Machine
=============================

## Download Current VM Image
  [https://s3.amazonaws.com/nist-sgcps/UCEF/ucefvms/UCEF+1.0.0-alpha-20170725.ova](https://s3.amazonaws.com/nist-sgcps/UCEF/ucefvms/UCEF+1.0.0-alpha-20170725.ova)
  
## Build Instructions

### Prerequisites 
1) Make sure you have installed Oracle Virtualbox and Vagrant software (see the links below): 
- Oracle Virtualbox: [https://www.virtualbox.org/](https://www.virtualbox.org/ )
- Vagrant: [https://www.vagrantup.com/docs/installation/](https://www.vagrantup.com/docs/installation/) - Downloads: [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)

2) After installing Vagrant (or if you already have it installed), we need to make sure that Guest-Additions plugin is installed in Vagrant, by running the command on a DOS command prompt:
    
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
- openjdk8
- docker
- python27
- shipyard
- terminator
- chromium
- webgme_cli
- eclipse
- maven
- archiva
- gridlabd
- mysql & mysql-workbench


**UserName and Password for the Virtual Machine is default vagrant**

## UCEF Git Source Repositories

The following represent the building blocks of UCEF:

- ucef-core: [https://github.com/usnistgov/ucef-core.git](https://github.com/usnistgov/ucef-core.git)

This is the core code for UCEF incorporating the HLA library of Portico and the foundation classes for UCEF implementations

- ucef-cpp: [https://github.com/usnistgov/ucef-cpp.git](https://github.com/usnistgov/ucef-cpp.git)

These are additional libraries in C++ to support the ucef-core

- ucef-meta: [https://github.com/usnistgov/ucef-meta.git](https://github.com/usnistgov/ucef-meta.git)

The meta's are the GUI components of UCEF running on WebGME

- ucef-samples: [https://github.com/usnistgov/ucef-samples.git](https://github.com/usnistgov/ucef-samples.git)

This project contains sample applications that demonstrate UCEF capabilities.

- ucef-gridlabd-meta: [https://github.com/usnistgov/ucef-gridlabd-meta.git](https://github.com/usnistgov/ucef-gridlabd-meta.git)

This project adds a Gridlab-D graphic model editor for UCEF

- ucef-db: [https://github.com/usnistgov/ucef-db.git](https://github.com/usnistgov/ucef-db.git)

This project contains database engine support for UCEF

