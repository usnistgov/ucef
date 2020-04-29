this directory builds a UCEF virtual machine from a vagrant box (produced from packer). it's intended to checkout and build a specific version of the code. all dependencies - and installation steps that take significant time - should be part of the packer build process instead.

# configuration options
most configuration options are in the file `machine.json`:

- box: the name of the vagrant box (matches the --name provided to the vagrant box add command)
- cpus: number of CPU to allocate to the virtual machine
- memory: amount of RAM to allocate to the virtual machine
- network_static_ip: set to true when a DHCP server is unavailable
- name: the unique name of the virtual machine
- provision_scripts: extend the array to add custom bash provisioning scripts
- VBoxManage: configuration options specified to VirtualBox

# changing ucef versions
`files/clone_ucef.json` specifies the version of UCEF code to download to the virtual machine. update this JSON file with new branches for the repositories if you want to clone a specific version of the UCEF codebase. note that if you add new repositories - or the compilation process changes - you will also need to update `scripts/ucef.sh` to use the correct compilation procedure for the repository.

# static ip address
assume same gateway and dns server as the packer build process. all this will do is change the ipv4 address associated with an existing (configured via packer) network interface.

set `network_packer_ip` to the static IP address assigned by packer (if you are using DHCP, make sure the value is equal to the empty string instead). this should be the same value as `netcfg/get_ipaddress` from the packer preseed file.

set `network_static_ip` to the address you want to use for this virtual machine. it should be on the same subnet and not be in use by another machine on the network.

you cannot change the gateway or dns nameservers. if you need to change these values, you will have to modify the packer preseed file and re-build the base box using packer.

# known issues
source /etc/environment seems to be required to reset JAVA_HOME - does xfce not load the environment file correctly?

maven will generate an obscene number of warnings and error messages. this is just UCEF being UCEF - they are not actually problems. there should be no warnings/error messages except those associated with some part of the maven build process.

static ip addresses are just wrong. it's so overly complicated for such a simple thing. the correct answer is to use the line `m.vm.network "private_network", ip: machine_data['network_static_ip']` and add a network_static_ip option to the JSON file. but of course this doesn't work, because Hyper-V. the virtual machine will not update its ip address until a manual reboot. i do not know if this affects the build process in some negative way. however, it seems rather difficult to have vagrant restart a machine during the provisioning process.

no shared folders with Hyper-V. this is - once again - a NIST Windows 10 issue with permissions. trying to mount the shared folder leads to all sorts of fun errors which are best just avoided entirely by disabling the default shared folder. if you want a shared folder, figure it out.

potential for inconsistent directory names between ucef.sh and clone_ucef.json - clone_ucef.json specifies which directories should be created for each UCEF repo, but these names are also specified in ucef.sh - need to have an authoritative source for these directory names to prevent possible inconsistencies between the two files.

C++ federates won't run - there is an error in the generated code from WebGME that points to the wrong JDK path. updates to Java removed the JRE and changed the JDK path structures - and the C++ generated code has not been updated to reflect this. for now, don't use C++ federates.

installs python3-pip and some requirements file at a ridiculous directory. need to update the TE federation to remove PyPower and this installation requirement.

desktop environment not configured (shortcuts, keybinds)

optional qol features not included (eclipse, wireshark, workbench)
