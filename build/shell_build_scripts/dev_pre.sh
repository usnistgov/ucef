#!/usr/bin/env bash


set_env_var_func(){
    USER_ENV_FILE="/home/vagrant/.bashrc"
    CPSWT_FLAVOR=CPSWT
    #cat $USER_ENV_FILE
    #echo "$1"
    echo "$1" | sudo tee -a $USER_ENV_FILE
    source $USER_ENV_FILE   
}

webgme_init_func(){
    # set environment variable
    # CPSWT_WEBGME_HOME /home/vagrant/webgme

    set_env_var_func "CPSWT_WEBGME_HOME=/home/vagrant/ucefcodebase/cpswt-meta"
    #CPSWT_WEBGME_HOME=/home/vagrant/webgme
    #cp -R /ucefcodebase/meta "$CPSWT_WEBGME_HOME"
    

    # Questions: where is this?
    # set environment variable
    # CPSWT_WEBGMEGLD_HOME /home/vagrant/webgme
    set_env_var_func "CPSWT_WEBGMEGLD_HOME=/home/vagrant/ucefcodebase/cpswt-gridlabd-meta"
    
    #cp -R /ucefcodebase/gridlabd-meta "$CPSWT_WEBGMEGLD_HOME"
}

federate_src_init_func(){
    # Export C2WTROOT 

    #echo "C2WTROOT=\"/home/vagrant/cpswt\"" | sudo tee -a /etc/environment
    set_env_var_func "JAVA_ROOT_FOUNDATION_SRC=/home/vagrant/ucefcodebase/cpswt-java"
    set_env_var_func "CPP_ROOT_FOUNDATION_SRC=/home/vagrant/ucefcodebase/cpswt-cpp"
}

build_docker_image_init_func(){
    # Export Docker_FED_SRC
    set_env_var_func "Docker_FED_SRC=/home/vagrant/ucefcodebase/cpswt-devtools/dockerfeds"
}


initialize_maven_archiva_settings_init_func(){
    #Export ARCHIVA_SETTINGS_XML_DIR
    set_env_var_func "ARCHIVA_SETTINGS_XML_DIR=/vagrant/config"
}


webgme_init_func
federate_src_init_func
build_docker_image_init_func
initialize_maven_archiva_settings_init_func
