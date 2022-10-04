![UCEF Banner](ucef.jpg)

# Univeral Cyber-Physical Systems Environment for Federation (UCEF)

## Background on UCEF and Cyber-Physical Systems

Cyber-Physical Systems (CPS) are smart systems that include co-engineered interacting networks of physical and computational components. CPS integrate computation, communication, sensing and actuation with physical systems to fulfill time-sensitive functions with varying degrees of interaction with the environment, including human interaction. The development of these systems cuts across all industrial sectors and demands high-risk, collaborative research between research and development teams from multiple institutions. Realizing the future promise of CPS will require interoperability between heterogeneous systems and development processes supported by robust platforms for experimentation and testing across domains. Meanwhile, current design and management approaches for these systems are domain-specific and would benefit from a more universally applicable approach.

The National Institute of Standards and Technology (NIST) and its partner, the Institute for Software Integrated Systems at Vanderbilt University, have developed a collaborative experiment development environment across heterogeneous architectures integrating best-of-breed tools including programming languages, communications co-simulation, simulation platforms, hardware in the loop, and others. This environment combines these simulators and emulators from many researchers and companies with a standardized communications protocol, IEEE Standard 1516 High Level Architecture (HLA). NIST calls this a Universal CPS Environment for Federation (UCEF).

UCEF is provided as an open source toolkit that:

* comprises a portable, self-contained, Linux Virtual Machine which allows it to operate on any computing platform;
* contains a graphical experiment and federate design environment – Web-based generic modeling environment (WebGME) developed by Vanderbilt University that provides code generation for adapting models to the simulators;
* develops experiments that can be deployed independently on a variety and combination of platforms from large cloud systems to small embedded controllers;
* allows experiments to be composed among local simulations, hardware in the loop (HIL), cloud simulations, and collaborative experiments across the world;
* integrates federates designed in: Java, C++, MATLAB, LabVIEW, GridLAB-D, TRNSYS, and EnergyPlus.

## System Requirements

The following two environments are supported:

### Windows 10 VirtualBox
- Windows 10
- VirtualBox 6.1.4r136177 (https://www.virtualbox.org/)
- HashiCorp Packer 1.6.1 (https://www.packer.io/)
- HashiCorp Vagrant 2.2.7 (https://www.vagrantup.com/)

### Windows 10 Hyper-V
- Windows 10
- Hyper-V 10.0.17134.1
- HashiCorp Packer 1.6.1 (https://www.packer.io/)
- HashiCorp Vagrant 2.2.7 (https://www.vagrantup.com/)

It is likely that Linux and MacOS also work when using the VirtualBox configuration, but these environments are not frequently tested. The VirtualBox environment is recommended, as it is faster and more stable, but NIST Windows 10 users must use Hyper-V due to a security feature that blocks the creation of 64-bit virtual machines. This document contains separate installation instructions for each environment, including configurable options and known issues with the installation process. It assumes you have access to a bash command line interface such as Git Bash (https://gitforwindows.org/). 

## VirtualBox Installation
All installation steps must be done as an administrator. When using a terminal application to execute the commands listed in this section, be sure to launch the terminal as an administrator.

NIST Windows 10 Enterprise users cannot use VirtualBox due to a security feature which prevents the creation of 64-bit virtual machines. If using a NIST Windows 10 computer, skip to the section on installation using Hyper-V instead. If using a Windows 10 Enterprise computer (non-NIST), check if you can create a 64-bit Linux virtual machine in VirtualBox prior to following these instructions. If when creating a virtual machine you are limited to 32-bit, either use the Hyper-V installation procedure or search the Internet for how to resolve this problem.

### Generate a .box file using Packer
1. Download HashiCorp Vagrant and run its installer.
2. Download HashiCorp Packer and place the executable in the `packer` directory. Alternatively, put the executable in a directory that's included in your system path variable.
3. Go to the `packer` directory and execute the following command from an elevated command prompt:
```
packer build -only=virtualbox-iso ubuntu-1804-amd64.json
```
4. Wait for Packer to complete with output about exporting a .box file. This can take several hours.
5. Execute the following command from the `packer` directory using an elevated command prompt:
```
vagrant box add builds/ubuntu-1804-amd64-virtualbox.box --force --name ucef-base
```

### Create the UCEF Virtual Machine using Vagrant
1. Edit the file `vagrant/machine.json` and modify the following two lines to the indicated values:
```
    "network_packer_ip": "",
    "network_static_ip": "",
```
2. Go to the `vagrant` directory and execute the following command from an elevated command prompt:
```
vagrant up --provider=virtualbox
```
3. Once Vagrant completes, restart the virtual machine.

## Hyper-V Installation
All installation steps must be done as an administrator. When using a terminal application to execute the commands listed in this section, be sure to launch the terminal as an administrator.

### Configure Hyper-V
You should create a new NAT Network in Windows 10 when using Hyper-V because the Default Switch seems to be unreliable at assigning IP addresses:

1. Enable Hyper-V Platform and Management Tools (see https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v#enable-the-hyper-v-role-through-settings)
2. Create a new virtual NAT switch in PowerShell as Administrator (https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/user-guide/setup-nat-network) 
    1. `New-VMSwitch -SwitchName "NATSwitch" -SwitchType Internal`
    2. Find the ifIndex for NATSwitch using `Get-NetAdapter`
    3. `New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceIndex <ifIndexFromGetNetAdapter>`
    4. `New-NetNat -Name NATNetwork -InternalIPInterfaceAddressPrefix 192.168.0.0/24`
3. From the Hyper-V Manager, select `Action -> Virtual Switch Manager -> NATSwitch` and ensure that `Connection type` is set to `Internal Network`.

If you choose to use a different IP address for the virtual switch (192.168.0.1), edit all of the configuration files in this repository to correspond to your custom value.

### Generate a .box file using Packer
1. Download HashiCorp Vagrant and run its installer.
2. Download HashiCorp Packer and place the executable in the `packer` directory. Alternatively, put the executable in a directory that's included in your system path variable.
3. If the virtual machine will be installed and used on the NIST Gaithersburg site, change the default DNS server:
    1. Open the file `packer/ucef/http/preseed-hyperv.cfg`
    2. Modify the line `d-i netcfg/get_nameservers string 8.8.8.8 8.8.4.4` to use `129.6.16.1 129.6.16.2`
4. Go to the `packer` directory and execute the following command from an elevated command prompt:
```
packer build -only=hyperv-iso ubuntu-1804-amd64.json
```
5. Wait for Packer to complete with output about exporting a .box file. This can take several hours.
6. Execute the following command from the `packer` directory using an elevated command prompt:
```
vagrant box add builds/ubuntu-1804-amd64-hyperv.box --force --name ucef-base
```

### Create the UCEF Virtual Machine using Vagrant
1. Go to the `vagrant` directory and execute the following command from an elevated command prompt:
```
vagrant up
```
2. Vagrant will prompt you to select a virtual network switch at the start of the provisioning process. Select the `NATSwitch` you created at the start of these instructions.
3. Once Vagrant completes, restart the virtual machine.

### Accessing the Hyper-V Virtual Machine
While you can launch the virtual machine from Hyper-V Manager, it will be slow because it was not created from a Microsoft base image. You should instead access the virtual machine using Windows remote desktop.

1. In Hyper-V Manager, right-click the virtual machine and select `Start`.
2. From the Windows start menu, search for and launch `Remote Desktop Connection`.
3. Connect to `192.168.0.21`. You can customize the session if you select `Show Options`.
4. Login using Session `Xorg`, username `vagrant`, and password `vagrant`.

If you cannot connect to `192.168.0.21`, check the network settings for the virtual machine. In Hyper-V Manager, select the virtual machine and then change to the `Networking` tab. You should connect to the value listed under `IP Addresses`.

### Using the Hyper-V Virtual Machine on NISTNet
The virtual machine will have no Internet access while on NISTNet because the default DNS Server (8.8.8.8) is not available on NISTNet. If the virtual machine will be used on NISTNet, modify the configuration files to change the default DNS Server to `129.6.16.1`. You can also install a network manager and make this change from within the virtual machine itself.
