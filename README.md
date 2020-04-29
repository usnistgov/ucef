this is not public (and should not be widely distributed) as the documentation and license files are not complete. these files will eventually become two separate repositories: one forked from bento (for all the packer stuff) and the current usnistgov/ucef repo (for the vagrant stuff).


i have tested two different configurations:

either
- Windows 10
- VirtualBox 6.1.4r136177
- HashiCorp Packer 1.5.4
- HashiCorp Vagrant 2.2.7

or
- Windows 10
- Hyper-V 10.0.17134.1
- HashiCorp Packer 1.5.4
- HashiCorp Vagrant 2.2.7

other build environments are not tested. this file contains separate instructions for installation of each environment. if you have not been instructed otherwise, use the VirtualBox build process. the installation assumes you have a bash command line interface (such as Git Bash) that is used to input all the commands.

# installation with VirtualBox
all installation steps must be done as an administrator. when using a terminal application to execute the commands listed in this section, make sure to launch the terminal as an administrator.

NIST Windows 10 Enterprise users cannot build using VirtualBox; use Hyper-V instead. if you are using Windows 10 Enterprise (non-NIST distribution), make sure you can create a regular 64-bit linux virtual machine in VirtualBox. if your options are restricted to 32-bit, use the Hyper-V build instead or google how to resolve this problem.

## generate a .box file using Packer
download HashiCorp Packer and either put it on your system path or place the executable in the `packer` directory. download HashiCorp Vagrant and run its installer.

navigate to the packer directory and execute the following command from an elevated command prompt:
`packer build -only=virtualbox-iso ubuntu-1804-amd64.json`

once packer completes (outputs something about exporting a .box file), execute the following command from the packer directory:
`vagrant box add builds/ubuntu-1804-amd64-virtualbox.box --force --name ucef-base`

## create the UCEF virtual machine using Vagrant
open the file `vagrant/machine.json` and modify the following two lines to the indicated values:
```
    "network_packer_ip": "",
    "network_static_ip": "",
```

navigate to the vagrant directory and execute the following command from an elevated command prompt:
`vagrant up --provider=virtualbox`

restart the virtual machine once before using it. otherwise the networking settings will not take effect.

# installation with Hyper-V
all installation steps must be done as an administrator. when using a terminal application to execute the commands listed in this section, make sure to launch the terminal as an administrator.

## configure Hyper-V
you should create a new NAT Network in Windows 10 if you plan to use Hyper-V. the default switch sometimes works - but sometimes it fails to assign an IP address, and i'm not sure it would work on NISTNet. instructions follow.

Enable Hyper-V Platform and Management Tools
https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v#enable-the-hyper-v-role-through-settings

Create a new virtual NAT switch
https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/user-guide/setup-nat-network
in PowerShell as Administrator
    New-VMSwitch -SwitchName "NATSwitch" -SwitchType Internal
    Get-NetAdapter
        find the ifIndex for NATSwitch
    New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceIndex <ifIndexFromGetNetAdapter>
    New-NetNat -Name NATNetwork -InternalIPInterfaceAddressPrefix 192.168.0.0/24
Hyper-V Manager > Virtual Switch Manager > NATSwitch
    Ensure the Connection type is set to Internal network

you must use the IP configuration specified above for the switch, or adjust all the configuration files in this repo to use your customized settings.

## generate a .box file using Packer
download HashiCorp Packer and either put it on your system path or place the executable in the `packer` directory. download HashiCorp Vagrant and run its installer.

navigate to the packer directory and execute the following command from an elevated command prompt:
`packer build -only=hyperv-iso ubuntu-1804-amd64.json`

once packer completes (outputs something about exporting a .box file), execute the following command from the packer directory:
`vagrant box add builds/ubuntu-1804-amd64-hyperv.box --force --name ucef-base`

## create the UCEF virtual machine using Vagrant
navigate to the vagrant directory and execute the following command from an elevated command prompt:
`vagrant up`

vagrant may prompt you to select a virtual network switch towards the start of the installation process. select the NATSwitch you created from the prior step.

restart the virtual machine once before using it. otherwise the networking settings will not take effect.

## accessing the virtual machine using Hyper-V
Start the VM from Hyper-V
Launch Remote Desktop Connection in Windows 10
    Connect to 192.168.0.21 (or the IP you assigned)
Authenticate at the login screen using session Xorg (vagrant/vagrant)

## NISTNet connection issues
this was not tested using Hyper-V on NISTNet - it probably does not work as configured.

you will need to change the dns server for the static IP used by packer (see packer for instructions). the dns server you need to use for NISTNet is most likely `129.6.16.1`
