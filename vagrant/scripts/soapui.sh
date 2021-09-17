

#sudo tar -xzf SoapUI-5.4.0-linux-bin.tar.gz -C /home/vagrant/
#sudo /home/vagrant/SoapUI-5.4.0/bin/testrunner.sh -r soapui-project.xml

#/home/vagrant/Downloads/SoapUI-x64-5.6.0.sh

wget --progress=bar:force https://s3.amazonaws.com/downloads.eviware/soapuios/5.6.0/SoapUI-5.6.0-linux-bin.tar.gz
sudo tar -xzf SoapUI-5.6.0-linux-bin.tar.gz -C /opt/
sudo cd /opt/SoapUI-5.6.0/bin/
sudo ./soapui.sh
sudo /opt/SoapUI-5.6.0/bin/testrunner.sh -r soapui-project.xml