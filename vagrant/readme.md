This directory builds a UCEF virtual machine from the vagrant box produced from Packer. It is intended to checkout and build a specific version of the UCEF code. All of the software dependencies, and installation steps that take significant time, should be part of the Packer build process instead.

### Configurable Options
Most of the configuration options are in the file `machine.json`:
- box: the name of the vagrant box (matches the --name provided to the `vagrant box add` command)
- cpus: number of CPU to allocate to the virtual machine
- memory: amount of RAM to allocate to the virtual machine
- network_static_ip: set to true when a DHCP server is unavailable
- name: the unique name of the virtual machine in VirtualBox or Hyper-V
- provision_scripts: extend the array to add custom bash provisioning scripts
- VBoxManage: configuration options specified to VirtualBox

### Building a different version of UCEF
The file `files/clone_ucef.json` lists the different GitHub repositories included in the Vagrant build process. You can modify this file to select a different branch or tag for each repository if you want to clone into a specific version of the UCEF codebase. When you modify this file, especially if you add a new repository, also modify the `scripts/ucef.sh` file to use the correct compilation procedure for your new branch.

### Configuring a Static IP Address
You can only change the gateway and DNS server during the Packer build process. However, you can change the IP Address associated with the virtual machine using Vagrant.

1. Open the file `machine.json`
2. Set `network_packer_ip` to the static IP address assigned during the Packer build process. If you are using DHCP (the case when using VirtualBox), you should set this value to the empty string `""`. Otherwise, this should be the same value as `netcfg/get_ipaddress` from the Packer preseed file. 
3. Set `network_static_ip` to the static IP address you want to use for this virtual machine.

You cannot change the gateway or DNS name server. If you want to change these values, you will have to modify the Packer preseed file and re-run the Packer build process.

### Known Issues
- source /etc/environment seems to be required to reset the JAVA_HOME environment variable
- maven generates an obscene number of warnings and error messages right after running a maven command. these do not seem to impact the compilation process.
- static IP addresses are just wrong. it's so overly complicated for such a simple thing. the correct answer is to use the Vagrant configuration option `m.vm.network "private_network", ip: machine_data['network_static_ip']` and add a network_static_ip option to the JSON file. but of course this doesn't work, because Hyper-V refuses to support user friendly network configuration.
- no shared folders when using Hyper-V. this is another NIST Windows 10 issue with permissions. trying to mount the shared folder leads to all sorts of fun errors which are best just avoided entirely by disabling the default shared folder.
- there is the potential for inconsistent directory names between `ucef.sh` and `clone_ucef.json` - clone_ucef.json specifies which directories should be created for each UCEF repository, and these names are repeated in ucef.sh. there should be an authoritative source for these directory names to prevent possible inconsistencies between the two files.
- installs python3-pip and some requirements file at a ridiculous directory. these requirements should be removed when the TE federation is updated to remove PyPower.
- optional QoL features not included
