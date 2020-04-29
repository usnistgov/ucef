these are developer notes and contains many inaccuracies.

this directory builds a vagrant box for an ubuntu 18.04 virtual machine with the software requirements for UCEF. it does not produce a runnable virtual machine; a temporary virtual machine will be created during the provisioning process that will be deleted after its contents are export into a vagrant box file.

# requirements
either
- Windows 10
- Packer 1.5.4
- VirtualBox 6.1.4r136177

or
- Windows 10 
- Packer 1.5.4
- Hyper-V 10.0.17134.1

other build environments are not tested

# installation
## VirtualBox
NIST Windows 10 users cannot build using VirtualBox; use Hyper-V instead. if you are using Windows 10 Enterprise (non-NIST distribution), make sure you can create a regular 64-bit linux virtual machine in VirtualBox. if your options are restricted to 32-bit, use the Hyper-V build instead or google how to resolve this problem.

execute the following command in this directory from an elevated command prompt:
`packer build -only=virtualbox-iso ubuntu-1804-amd64.json`

## Hyper-V
add some steps about Hyper-V setup for NIST users

all installation steps must be done as an administrator. when using a terminal application to execute the commands listed in this section, make sure to launch the terminal as an administrator.

execute the following command in this directory from an elevated command prompt:
`packer build -only=hyperv-iso ubuntu-1804-amd64.json`

# configuration options
most configuration options are in the file `ubuntu-1804-amd64.json` under the sections for variables:

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

the default values were selected to match the minimum requirements for an Ubuntu desktop environment. while you can increase the resources allocated to the build process, do not decrease any of these values.

# static ip address
when preseed_path is set to `bento/http` the installation process expects a DHCP server available to assign a dynamic IP address to the created virtual machine. if DHCP is not available, the installation will fail to complete. there will be no error message, but the virtual machine will be stuck at a purple screen and the packer output will freeze at the message waiting for SSH to become active.

a static ip address can be used to resolve this issue. first, set preseed_path to `ucef/http`. second, if building with Hyper-V, set hyperv_switch to an internal switch on a NAT network. then navigate to `ucef/http` and open the preseed file for your build in a text editor (preseed.cfg for VirtualBox and preseed-hyperv.cfg for Hyper-V).

the following lines should be examined and modified if necessary to work with your network:
d-i netcfg/get_ipaddress string 192.168.0.10
d-i netcfg/get_netmask string 255.255.255.0
d-i netcfg/get_gateway string 192.168.0.1
d-i netcfg/get_nameservers string 8.8.8.8 8.8.4.4

this static ip address will only be used to provision the virtual machine. during the provisioning process, the networking script will reset the network configuration of the final output to use DHCP.

# deviations from bento
the most significant deviation from the bento build process - besides almost everything - is the change to the boot command for the Hyper-V build. it looks like the boot command was written for Generation 2 virtual machines; the original command does not work with Generation 1 virtual machines and it was changed to match the VirtualBox boot command which does work.

shockingly NIST cannot use Generation 2 virtual machines. one 'feature' of Generation 2 is it obsoletes floppy drives which can be used to transfer the preseed file to the virtual machine. the other options are to use an HTTP server on the host, or mount an ISO.

the process to mount an ISO is entirely undocumented and no one seems to use it. i have failed miserably in trying to get grub access to a mounted ISO containing the preseed file. in addition, the NIST firewall will block Packer if it tries to setup an HTTP server. as a result, there is no mechanism in Generation 2 virtual machines to use a preseed file on NIST machines. because the preseed file is the most important part of the build process, Hyper-V builds of UCEF will all be Generation 1 virtual machines.

# known issues
the bento/http option for preseed location is no longer valid and should be removed. virtualbox users should use a NAT network with IPv4 DHCP. hyper-v users should use an internal switch configured as a NAT network with a static IP address. all other configurations are unsupported. these configurations are the ones available in ucef/http

VirtualBox can sometimes fail to select and install software - leading to a permenant stall at waiting for ssh connection. i think this happens when you attempt to access the virtual machine during the preseed process; i have yet to see it occur when leaving the virtual machine in headless mode

vagrant does not support network configuration for Hyper-V. i cannot express in words the level of frustration this induces in me. in an ideal world - the box produced from this build process would reset its network configuration to the default (using DHCP) with the original packer networking scripts. however, then it would be impossible for Vagrant to launch that VM without a DHCP server because all attempts to configure a private network in Vagrant would fail. for now, i've disabled the networking provisioning entirely. if you use `preseed_path = ucef/http`, be aware that all machines you bring up with `vagrant up` will try to use the same IP address (the one you configure in the preseed file). please make sure never to run multiple instances of vagrant at the same time, and re-assign the IP address as soon as possible.

`Warning: apt-key output should not be parsed (stdout is not a terminal)` - a warning that the provision scripts misuse apt-key which was meant to be used for human interaction not scripts. because the command that causes this warning is the recommended installation procedure from the developers of the software, ignoring.

`[javac] warning: [options] bootstrap class path not set in conjunction with -source 8` - a warning that we are cross-compiling Java (using JDK 13 to compile Java 8 code) which probably has some consequence. all the code should be updated to compile as Java 13 - but this change has not been incorporated into UCEF yet so this will be around for a while.

C++ compilation warnings during `cpptask` of the Portico installation - talk with Portico.

`dd: error writing '...': No space left on device` - assuming the bento attempt to count the remaining space on the drive is not working. doesn't actually cause a problem because there (probably isn't) a risk of a buffer overflow with a single partition.

`configure: WARNING: doxygen not found - will not generate any doxygen documentation` - this is not a problem because we don't want the documentation to be generated; ignoring.

archiva is totally busted. the update to a new Java version removed the JAXB libraries from the SDK. while archiva master provided a patch for this, it has not been incorporated into a stable release. for now, archiva has been disabled. 

maven produces a ton of extremely annoying warning messages when run. this is because of the update to a new Java version. this is not an issue we have control over, and is widely discussed online: https://github.com/google/guice/issues/1133

the bento provisioning process leaves root in the permissons for the directory `/home/vagrant/.ssh`. i have not looked into whether this is something that must be fixed.
