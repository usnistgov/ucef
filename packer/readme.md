This directory builds a vagrant box for an Ubuntu 18.04 virtual machine with the software requirements for UCEF. It does not produce a runnable virtual machine. A temporary virtual machine will be created during the Packer provisioning process that will be converted into a vagrant box file (and deleted). 

### Configurable Options
The file `ubuntu-1804-amd64.json` contains the following options under the variables section:
- cpus: number of cores allocated to the build process
- disk_size: size (MB) of the virtual hard disk allocated to the virtual machine
- hyperv_switch: the name of a Hyper-V switch with internet connectivity to use to download packages
- iso_checksum: the checksum for the iso file
- iso_checksum_type: the algorithm used to compute the checksum of the file specified in iso_checksum
- iso_url: a URL to an ISO containing the Ubuntu installation image
- memory: amount of RAM allocated to the build process
- preseed_path: the path to the desired preseed files (either packer/http or ucef/htpp)
- vm_name: a unique name to associate with the build virtual machine
- vram: amount of video RAM allocated to the build process

The default values were selected to match the minimum requirements for an Ubuntu desktop environment. While you can increase the resources allocated to the build process, do not decrease them or the build process may fail.

### Configuring a Static IP Address
When the preseed_path is set to `bento/http` the installation process expects a DHCP server available to assign a dynamic IP address to the created virtual machine. If DHCP is not available, the installation will fail to complete. There will be no error message, but the virtual machine will be stuck at a purple screen and the Packer output will freeze at the message waiting for SSH to become active.

A static IP address can be used to resolve this issue:
1. Set `preseed_path` to `ucef/http`
2. If using Hyper-V:
    1. Set `hyperv_switch` to an internal switch on a NAT network.
    2. Open `ucef/http/preseed-hyperv.cfg`
    3. Goto Step 4
3. If using VirtualBox, open `ucef/http/preseed.cfg`
4. Edit the following lines to work with your network:
```
d-i netcfg/get_ipaddress string 192.168.0.10
d-i netcfg/get_netmask string 255.255.255.0
d-i netcfg/get_gateway string 192.168.0.1
d-i netcfg/get_nameservers string 8.8.8.8 8.8.4.4
```

This static IP address will only be used to provision the virtual machine. During the provisioning process, the networking script will reset the network configuration of the final output to use DHCP.

### Deviations from Bento
The most significant deviation from the Bento build process - besides almost everything - is the change to the boot command for the Hyper-V build. It looks like the Bento boot command was written for Generation 2 virtual machines. Shockingly NIST cannot use Generation 2 virtual machines. One 'feature' of Generation 2 is that it obsoletes floppy drives which can be used to transfer the preseed file to the virtual machine. It instead provides the options to use an HTTP server on the host machine, or mount an ISO.

The process to mount an ISO is entirely undocumented and no one seems to use it. I have failed miserably and repeatedly in trying to get grub access to a mounted ISO containing the preseed file. In addition, the NIST firewall will block Packer if it tries to setup an HTTP server. As a result, there is no mechanism in Generation 2 virtual machines to use a preseed file on NIST machines. Because the preseed file is the most important part of the build process, Hyper-V builds of UCEF will all be Generation 1 virtual machines.

The boot command has been changed to match the VirtualBox boot command, which seems to work for Generation 1 Hyper-V virtual machines.

### Known Issues
- the `bento/http` option for preseed location is no longer valid and should be removed. VirtualBox users should use a NAT network with IPv4 DHCP. Hyper-V users should use an internal switch configured as a NAT network with a static IP address. all other configurations are unsupported. these configurations are the ones available in `ucef/http`
- VirtualBox can sometimes fail to select and install software - leading to a permenant stall at waiting for SSH connection. i think this happens when you attempt to access the virtual machine during the preseed process; i have yet to see it occur when leaving the virtual machine in headless mode
- Vagrant does not support network configuration for Hyper-V. i cannot express in words the level of frustration this induces in me. in an ideal world - the box produced from this build process would reset its network configuration to the default (using DHCP) with the original Packer networking scripts. however, then it would be impossible for Vagrant to launch that VM without a DHCP server because all attempts to configure a private network in Vagrant would fail. for now, i've disabled the networking provisioning entirely. if you use `preseed_path = ucef/http`, be aware that all machines you bring up with `vagrant up` will try to use the same IP address (the one you configure in the preseed file). please make sure never to run multiple instances of Vagrant at the same time, and re-assign the IP address as soon as possible.
- `Warning: apt-key output should not be parsed (stdout is not a terminal)` - a warning that the provision scripts misuse apt-key which was meant to be used for human interaction not scripts. because the command that causes this warning is the recommended installation procedure from the developers of the software, ignoring.
- `[javac] warning: [options] bootstrap class path not set in conjunction with -source 8` - a warning that we are cross-compiling Java (using JDK 13 to compile Java 8 code) which probably has some consequence. all the code should be updated to compile as Java 13 - but this change has not been incorporated into UCEF yet so this will be around for a while.
- C++ compilation warnings during `cpptask` of the Portico installation - talk with Portico.
- `dd: error writing '...': No space left on device` - assuming the bento attempt to count the remaining space on the drive is not working. doesn't actually cause a problem because there (probably isn't) a risk of a buffer overflow with a single partition.
- `configure: WARNING: doxygen not found - will not generate any doxygen documentation` - this is not a problem because we don't want the documentation to be generated; ignoring.
- Archiva is totally busted. the update to a new Java version removed the JAXB libraries from the SDK. while Archiva main provided a patch for this, it has not been incorporated into a stable release. for now, Archiva has been disabled. 
- maven produces a ton of extremely annoying warning messages when run. this is because of the update to a new Java version. this is not an issue we have control over, and is widely discussed online: https://github.com/google/guice/issues/1133
- the Bento provisioning process leaves root in the permissons for the directory `/home/vagrant/.ssh`. i have not looked into whether this is something that must be fixed.
