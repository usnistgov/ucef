#!/bin/bash -eux
ARCHIVA_PORT=8081
MIRROR=https://mirrors.ocf.berkeley.edu
VERSION=2.2.4

# download and extract archiva to /opt/apache-archiva-$VERSION
wget $MIRROR/apache/archiva/$VERSION/binaries/apache-archiva-$VERSION-bin.tar.gz
tar xvfz apache-archiva-$VERSION-bin.tar.gz -C /opt
rm apache-archiva-$VERSION-bin.tar.gz

cd /opt/apache-archiva-$VERSION

# change permissions to user vagrant
sed -i 's,#RUN_AS_USER=,RUN_AS_USER=vagrant,g' bin/archiva
chown -R vagrant:vagrant /opt/apache-archiva-$VERSION

# create the /var/log/archiva directory
mkdir /var/log/archiva
chown -R vagrant:vagrant /var/log/archiva

# output jetty and archiva logs to the /var/log/archiva directory
sed -i 's,%ARCHIVA_BASE%/logs,/var/log/archiva,g' conf/wrapper.conf
sed -i 's,default="./logs",default="/var/log/archiva",g' conf/jetty.xml
sed -i 's,${sys:appserver.base}/logs,/var/log/archiva,g' apps/archiva/WEB-INF/classes/log4j2.xml

# change the default port number for the archiva service
sed -i 's,default="8080",default="'"$ARCHIVA_PORT"'",g' conf/jetty.xml

# setup the archiva service
ln -s /opt/apache-archiva-$VERSION/bin/archiva /etc/init.d/archiva
update-rc.d archiva defaults 80

# Archiva fails to load
