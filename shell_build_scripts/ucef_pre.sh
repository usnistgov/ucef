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
    # set environment variable
    set_env_var_func "CPSWT_WEBGME_HOME=/home/vagrant/cpswt/cpswt-meta"
    set_env_var_func "CPSWT_WEBGMEGLD_HOME=/home/vagrant/cpswt/cpswt-gridlabd-meta"

    # Create folders
    mkdir -p $CPSWT_WEBGME_HOME
    mkdir -p $CPSWT_WEBGMEGLD_HOME

    # Copy the folders
    #cp -R /cpswt/meta "$CPSWT_WEBGME_HOME"
    #cp -R /cpswt/gridlabd-meta "$CPSWT_WEBGMEGLD_HOME"
}

federate_src_init_func(){
    set_env_var_func "CPSWT_FLAVOR=UCEF"

    # Export SRC_DIR: It is usually the central source directory containing both the java and the c++ foundation classes.
    # Export C2WTROOT 

    #echo "C2WTROOT=\"/home/vagrant/cpswt\"" | sudo tee -a /etc/environment
    set_env_var_func "JAVA_ROOT_FOUNDATION_SRC=/home/vagrant/cpswt/cpswt-java"
    set_env_var_func "CPP_ROOT_FOUNDATION_SRC=/home/vagrant/cpswt/cpswt-cpp"
}

build_docker_image_init_func(){
    # Export Docker_FED_SRC
    set_env_var_func "Docker_FED_SRC=/home/vagrant/cpswt/cpswt-devtools/dockerfeds"
}


initialize_maven_archiva_settings_init_func(){
    #Export ARCHIVA_SETTINGS_XML_DIR
    set_env_var_func "ARCHIVA_SETTINGS_XML_DIR=/vagrant/cpswt/cpswt-devtools/config"
}

set -x
webgme_init_func
federate_src_init_func
build_docker_image_init_func
initialize_maven_archiva_settings_init_func
set +x
