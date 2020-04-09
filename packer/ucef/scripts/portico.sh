#!/bin/bash -eux
PORTICO_DIRECTORY=/home/vagrant/portico
PORTICO_BRANCH=portico-2.1.0    # you must change PORTICO_VERSION together with this value; not all branches will build (tested with tag portico-2.1.0 and commit b7e807e1d68c2fe179d0f05d1d9c5901f3105da2)
BUILD_VERSION=portico-2.1.0     # the version name is `build.shortname-build.version` as defined in portico/codebase/build.properties
MAVEN_VERSION=2.1.0             # version number for the maven/archiva artifact

# clone Portico
git clone --branch $PORTICO_BRANCH https://github.com/openlvc/portico.git $PORTICO_DIRECTORY

# enter source directory
pushd $PORTICO_DIRECTORY/codebase

##
# Portico was implemented for Oracle JDK 8 and does not compile when using OpenJDK 13
# changes to the Oracle JDK license (April 2019) make it questionable to redistribute
# the following commands patch Portico to compile with OpenJDK on Ubuntu 18.04
# this patch works for both the 2.1.0 and 2.2.0 versions of Portico
# this patch does not fix linux32, macosx, or windows builds
#
# the following linux64 files are not modified and will not work:
#   resources/dist/common/bin/forwarder.sh (2.2.0)
#   resources/dist/common/bin/rtiexec.sh (2.2.0)
#   resources/dist/common/bin/wanrouter.sh
#   src/cpp/ieee1516e/example/gdb-linux.env
#   src/cpp/ieee1516e/example/linux64.sh
#   src/cpp/hla13/example/gdb-linux.env
#   src/cpp/hla13/example/linux64.sh
##

# update the Java home directory for OpenJDK 13 (variable provided through Packer)
sed -i "s,jdk.home.linux64 = /usr/lib/jvm/java-8-oracle,jdk.home.linux64 = $JAVA_HOME,g" build.properties

# update the compilation to use Java 8 (this should be updated to Java 13 - but UCEF generates code for 8)
sed -i 's,name="java.compiler.source" value="1.7",name="java.compiler.source" value="1.8",g' profiles/java.xml
sed -i 's,name="java.compiler.target" value="1.7",name="java.compiler.target" value="1.8",g' profiles/java.xml

# verifyJdk no longer works because OS_ARCH for OpenJDK 13 is x86_64 not amd64, and x86_64 cannot be embedded into the XML
#   profiles/linux/hla13.xml
#   profiles/linux/ieee1516e.xml
#   profiles/linux/installer.xml (2.1.0)
find profiles/linux -type f -exec sed -i 's,<verifyJdk location="\${jdk.home.linux64}" arch="amd64"/>,<\!-- verifyJdk location="\${jdk.home.linux64}" arch="amd64"/ -->,g' {} \;

# change directory structure to match Java 13 which no longer contains a JRE
#   profiles/linux/hla13.xml
#   profiles/linux/ieee1516e.xml
#   profiles/linux/installer.xml
find profiles/linux -type f -exec sed -i 's,jre/lib/amd64/server,lib/server,g' {} \;

# the original command navigates to JDK_HOME and copies the JRE into the distribution directory; removed because Java 13 no longer contains a JRE
sed -i 's|-czpf \${tarball.file} --transform=s,jre,\${dist.name}/jre,g ./\${dist.name} -C\${jdk.home.linux64} ./jre|-czpf \${tarball.file} ./\${dist.name}|g' profiles/linux/installer.xml

# the original command copied the JRE directory; changed to copy the JDK directory and re-name it JRE (because Java 13 no longer contains a JRE)
sed -i 's,"-Rfp ${_jdkpath}/jre @{todir}/","-Rfp ${_jdkpath} @{todir}/jre",g' profiles/system.macros.xml

# change the path to use the JDK instead of the JRE which is no longer included in Java 13 (2.2.0)
sed -i 's,string(javahome).append( "/jre" ),string(javahome),g' src/cpp/ieee1516e/src/jni/Runtime.cpp
#   rtihome from this file is unchanged because $RTI_HOME/jre will still exist (it will be the JDK copied from the previous command)
#   libraryPath from this file is unchanged because /lib/server is still a valid subdirectory structure

# it seems like the original path would have been invalid (jre/jre/lib/server)
sed -i 's,"/jre/lib/server:","/lib/server:",g' src/cpp/hla13/src/jni/Runtime.cpp

# Portico must be compiled with its custom distribution of ant; using release.thin because the unit tests are all broken in 2.2.0
./ant release.thin

# move the compiled code
mv $PORTICO_DIRECTORY/codebase/dist/$BUILD_VERSION /opt/$BUILD_VERSION

# set RTI_HOME
echo "RTI_HOME=/opt/$BUILD_VERSION" | tee -a /etc/environment

# cleanup
./ant clean

# leave source directory
popd

# fix permissions
chown -R vagrant:vagrant $PORTICO_DIRECTORY
chown -R vagrant:vagrant /opt/$BUILD_VERSION

# upload the Portico artifact (run as vagrant to install to the correct local maven repository)
su - vagrant -c "mvn install:install-file -Dfile=/opt/$BUILD_VERSION/lib/portico.jar -DgroupId=org.porticoproject -DartifactId=portico -Dversion=$MAVEN_VERSION -Dpackaging=jar"
