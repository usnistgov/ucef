#!/bin/bash

##################################
# This script will run a federate
##################################

##################################
# parse options
# $1 = path to federate folder
# $2 = execution arguments
# $3 = terminal options
##################################

root=`pwd`
timestamp=`date +"%F_%T"`
logs=$root/logs
fedmgr_host=127.0.0.1
fedmgr_port=8083
LOG4JOption=$LOG4J

if [ "$LOG4J" = "" ]; then
LOG4JOption=""
else
LOG4JOption="-Dlog4j.configurationFile=$LOG4J"
fi


#determine path to federate folder
if [ -z "$1" ]; 
then
  dp=$root/target
else
  dp=$1/target
fi

#determine if xterm is needed
if [ "$3" = "x" ]; then
  xt=""
else
  xt=$(cut -d"=" -f 2 <<< $3)
fi


d=`basename $dp`
fed=`basename $1`

if [ ! -d $logs ]; then
    echo Creating the $logs_directory directory
    mkdir $logs
fi

jar=$dp/$fed-*
command="java $LOG4JOption -jar $jar $2"
#command="mvn exec:java -P FederationManagerExecJava -Dfederation.name=$federation $2"


echo Federate= $fed
echo Logs = $logs
echo Deployment Path = $dp
echo Terminal Options = $3
echo Command = $command


##################################
# run the federation manager
##################################
cd $dp
echo `pwd`
# run the fed manager
if [ -z "$3" ]; then
  $command  &
#  $command >$logs/$fed-${timestamp}.log &
else
 xterm $xt -e $command &
fi




