#!/usr/bin/env bash

set_env_var_func(){
    USER_ENV_FILE="/home/vagrant/.bashrc"
    #cat $USER_ENV_FILE
    #echo "$1"
    echo "$1" | sudo tee -a $USER_ENV_FILE
    source $USER_ENV_FILE
    eval $1

}

webgme_init_func(){
    set_env_var_func "CPSWT_WEBGME_HOME=/home/vagrant/webgme"
    set_env_var_func "CPSWT_WEBGMEGLD_HOME=/home/vagrant/webgmegld"

    CPSWT_WEBGME_HOME
    # Create folders

    mkdir -p $CPSWT_WEBGME_HOME
    mkdir -p $CPSWT_WEBGMEGLD_HOME

    # Copy the folders
    cp -r /cpswt/meta/* $CPSWT_WEBGME_HOME
    cp -r /cpswt/gridlabd-meta/* $CPSWT_WEBGMEGLD_HOME
    

}

federate_src_init_func(){

    set_env_var_func "JAVA_ROOT_FOUNDATION_SRC=/home/vagrant/cpswt/java"
    set_env_var_func "CPP_ROOT_FOUNDATION_SRC=/home/vagrant/cpswt/cpp"
    
    # Create Directories
    mkdir -p $JAVA_ROOT_FOUNDATION_SRC
    mkdir -p $CPP_ROOT_FOUNDATION_SRC

    # Copy the sources
    cp -r /cpswt/src/cpp/* $CPP_ROOT_FOUNDATION_SRC
    cp -r /cpswt/src/java/* $JAVA_ROOT_FOUNDATION_SRC
   
    # Export SRC_DIR: in UCEF it is the central source directory containing both the java and the c++ foundation classes.
    # Export C2WTROOT 

    echo "C2WTROOT=\"/home/vagrant/cpswt\"" | sudo tee -a /etc/environment
    mkdir -p /home/vagrant/cpswt/log


    # Also copy the  cpswt-samples
    mkdir -p /home/vagrant/cpswt/samples/
    cp -r /cpswt/samples/* /home/vagrant/cpswt/samples/

}

build_docker_image_init_func(){
    # Export Docker_FED_SRC
    set_env_var_func "Docker_FED_SRC=/home/vagrant/cpswt/src/dev-tools/dockerfeds"

    # create directory
    mkdir -p $Docker_FED_SRC

    # copy
    cp -R /cpswt/src/dev-tools/dockerfeds/* $Docker_FED_SRC
    
}

initialize_maven_archiva_settings_init_func()
{
    #Export ARCHIVA_SETTINGS_XML_DIR
    set_env_var_func "ARCHIVA_SETTINGS_XML_DIR=/vagrant/config"
}

set -x
webgme_init_func
federate_src_init_func
build_docker_image_init_func
initialize_maven_archiva_settings_init_func
set +x