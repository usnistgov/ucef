these are developer notes. they aren't supposed to make sense.

goto packer and follow the instructions there until you've generated a packer/builds/*.box file. then goto vagrant and follow the instructions there until you have a running VM with no obvious errors in the terminal.

this is not public (and should not be widely distributed) as the documentation and license files are not complete. these files will eventually become two separate repositories: one forked from bento (for all the packer stuff) and the current usnistgov/ucef repo (for the vagrant stuff).

# NOTICE ON FREQUENT ERROR
sometimes vagrant will exit with an error message about a failed dependency for xrdp. this will prevent remote desktop from working. if this happens (which is often), shut down and delete the virtual machine from Hyper-V and re-try the vagrant up command (it will have to start over from the beginning). this error seems to happen when you disable ipv6 (which is required as otherwise portico will not run); i do not know how to fix it / make it more stable.

# configure Hyper-V
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

# accessing the virtual machine using Hyper-V
Start the VM from Hyper-V
Launch Remote Desktop Connection in Windows 10
    Connect to 192.168.0.20 (or the IP you assigned)
Authenticate at the login screen using session Xorg (vagrant/vagrant)

# NISTNet
this was not tested using Hyper-V on NISTNet - it probably does not work as configured.

you will need to change the dns server for the static IP used by packer (see packer for instructions). the dns server you need to use for NISTNet is most likely `129.6.16.1`
