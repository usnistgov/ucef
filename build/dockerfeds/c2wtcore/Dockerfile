# #### README ######################################################
# Base Image to be downloaded from the Docker Registry
# the tag will be of the format of YYMMDD
# This is going to be the "c2wtcore_v002:160816" image.
# To build the image:
# Instructions for using DockerFile.
# 1) Build a docker image:
#      cd <directory_containing_c2wtbase_folder>
#    sudo docker build -t cpswt/c2wtcore_v002:160816
# 2) Run the docker image:
#    sudo docker run -i -t cpswt/c2wtcore_v002:160816
# 3) List of docker images: 
#      sudo docker images
# 4) Delete docker image: 
#      sudo docker rmi imagename
# cpswt/c2wtcore_v002:160816
# ##################################################################

FROM ubuntu:14.04
MAINTAINER Yogesh Barve <yogesh.d.barve@vanderbilt.edu>, Himanshu Neema <himanshu@isis.vanderbilt.edu>

# ##### OPENJDK 7, WGET, GCC, G++ ##################################
RUN apt-get update --fix-missing

# Installing GCC,G++, BOOST, MYSQLCONNECTION
RUN apt-get install --fix-missing gcc g++ wget libboost-all-dev libmysqlcppconn-dev -y

# Installing OPENJDK-7/JAVA
# RUN apt-get install --fix-missing openjdk-7-jdk ant xvfb  maven -y 


RUN apt-get update && apt-get install software-properties-common python-software-properties --fix-missing -y

RUN	add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
    apt-get install oracle-java8-installer -y && \
    apt-get install oracle-java8-set-default -y

#RUN	apt-get install ant maven --no-install-recommends -y
RUN add-apt-repository ppa:andrei-pozolotin/maven3 && apt-get update && apt-get install maven3 --no-install-recommends -y


# Portico Version:
ENV PORTICO_RELEASE 2.1.0



# Installing portico
RUN mkdir /usr/local/portico/ && \ 
    cd /usr/local/portico/ && \
    wget http://downloads.sourceforge.net/project/portico/Portico/portico-${PORTICO_RELEASE}/portico-${PORTICO_RELEASE}-linux64.tar.gz && \
    tar zxvf portico-${PORTICO_RELEASE}-linux64.tar.gz && \
    rm -rf portico-${PORTICO_RELEASE}-linux64.tar.gz

# #### BASIC FOLDER SETUP #########################################
RUN mkdir -p /root/Projects/c2wt && \ 
 	chmod -R 777 /root/Projects/c2wt 

# #### ENVIRONMENT VARIABLES ######################################

# RTI Portico Home Path
ENV RTI_HOME=/usr/local/portico/portico-${PORTICO_RELEASE}

# C2WT Root Folder
ENV C2WTROOT=/root/Projects/c2wt

# Setting the JAVA Home
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle


# Setting the PATH variables
ENV PATH=$PATH:$JAVA_HOME/bin
ENV PATH=$PATH:$JAVA_HOME/jre/lib/amd64/server:$RTI_HOME/lib/gcc4

# Adding the jar to the CLASSPATH
ENV CLASSPATH=$CLASSPATH:$RTI_HOME/lib/portico.jar
# ###### Start Up Sequence ###################################################
ADD pom.xml $C2WTROOT/tmp/

RUN cd $C2WTROOT/tmp && mvn clean install package

RUN mkdir -p $C2WTROOT/log && mkdir -p $C2WTROOT/logs

RUN echo "portico.jgroups.timeout = 5000" > $C2WTROOT/RTI.rid

ENV RTI_RID_FILE=$C2WTROOT/RTI.rid

RUN apt-get update --fix-missing && apt-get install automake autoconf libtool curl subversion build-essential libxerces-c-dev  cmake libssl-dev -y 

############ MOST IMPORTANT 
# Most Important Note!!!!!: We need to stick with commit 5307.....
RUN mkdir /tmp/gridlab-d/ && \
	cd /tmp/gridlab-d/ && \
	svn co svn://svn.code.sf.net/p/gridlab-d/code/trunk@5307 gridlab-d-code

ENV GRIDLAB_HOME=/usr/local/gridlab-d
RUN mkdir $GRIDLAB_HOME
RUN cd /tmp/gridlab-d/gridlab-d-code && \
	autoreconf -isf && \ 
	./configure --prefix=$GRIDLAB_HOME && \
	make && \
	make install 

RUN rm -rf /tmp/gridlab-d
#RUN apt-get install libcppnetlib-dev -y

RUN mkdir /usr/local/cpp-netlib
RUN cd /usr/local/cpp-netlib && wget https://github.com/cpp-netlib/cpp-netlib/archive/cpp-netlib-0.11.2-final.tar.gz && \
	tar xvf  cpp-netlib-0.11.2-final.tar.gz 

#RUN cd /usr/local/cpp-netlib && unzip /usr/local/cpp-netlib/cpp-netlib-0.11.2-final.zip && rm -rf *.zip && \

RUN cd /usr/local/cpp-netlib && mkdir cpp-netlib-build && cd cpp-netlib-build && \
cmake -DCMAKE_BUILD_TYPE=Debug \
-DCMAKE_C_COMPILER=gcc \
-DCMAKE_CXX_COMPILER=g++ \
../cpp-netlib-cpp-netlib-0.11.2-final && \
make && \
make install && \
rm -rf /usr/local/cpp-netlib

ADD settings.xml /home/root/.m2/

WORKDIR $C2WTROOT/input
# WORKDIR /usr/local/portico/portico-2.0.2
CMD ["/bin/bash"]
