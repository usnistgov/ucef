##########
# Eclipse #
##########
eclipse_func(){
    cd $HOME/Downloads/
wget --progress=bar:force  http://mirror.cc.vt.edu/pub/eclipse/technology/epp/downloads/release/neon/3/eclipse-java-neon-3-linux-gtk-x86_64.tar.gz

 //   wget --progress=bar:force https://www.eclipse.org/downloads/download.php?file=/oomph/epp/2021-06/R/eclipse-inst-jre-linux64.tar.gz
//    wget --progress=bar:force  http://mirror.cc.vt.edu/pub/eclipse/technology/epp/downloads/release/neon/3/eclipse-java-neon-3-linux-gtk-x86_64.tar.gz
    tar xvf eclipse*.tar.gz -C $HOME


    # add emf classes needed for pubsub to m2
    # Edit this variable to point to your location of the files listed below.
    EMF_HOME="/home/vagrant/eclipse/plugins"
    GROUP="org.eclipse.emf"

    mvn install:install-file \
        -Dfile=$EMF_HOME/org.eclipse.emf.common_2.12.0.v20160420-0247.jar \
        -DgroupId=$GROUP \
        -DartifactId=org.eclipse.emf.common \
        -Dversion=2.12.0 \
        -Dpackaging=jar
        
    mvn install:install-file \
        -Dfile=$EMF_HOME/org.eclipse.emf.ecore_2.12.0.v20160420-0247.jar \
        -DgroupId=$GROUP \
        -DartifactId=org.eclipse.emf.ecore \
        -Dversion=2.12.0 \
        -Dpackaging=jar
        
    mvn install:install-file \
        -Dfile=$EMF_HOME/org.eclipse.emf.ecore.xmi_2.12.0.v20160420-0247.jar \
        -DgroupId=$GROUP \
        -DartifactId=org.eclipse.emf.ecore.xmi \
        -Dversion=2.12.0 \
        -Dpackaging=jar    
}

export CPSWT_FLAVOR="UCEF 1.1.0-test"

UCEF_HOME=/home/vagrant/

echo "${CPSWT_FLAVOR}-----> Install Eclipse"
eclipse_func
