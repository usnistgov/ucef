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
  p=$root
else
  dp=$1/target
  p=$1
fi

#determine if xterm is needed
if [ "$3" = "x" ]; then
  xt=""
else
  xt=$(cut -d"=" -f 2 <<< $3)
fi


d=`basename $dp`
fed=`basename $p`
f=$(basename $(dirname $(dirname "$PWD")))
federation=$(echo $f| cut -d'-' -f 1)
jar=$(ls target/$fed*.jar | cut -d"/" -f 2)

#determine default federation
if [ "$2" = "" ]; then
  configfile=Config.json
  configfile="../conf/$fed"$configfile
  fedidarg="-federationId=$federation -configFile=$configfile"
else
  fedidarg=$2
fi



if [ ! -d $logs ]; then
    echo Creating the $logs_directory directory
    mkdir $logs
fi

command="java $LOG4JOption -jar $jar $fedidarg"
#command="mvn exec:java -P FederationManagerExecJava -Dfederation.name=$federation $2"


echo Federate= $fed
echo DefaultFederation = $federation
echo Logs = $logs
echo Deployment Path = $dp
echo Terminal Options = $3
echo Command = $command
echo Options = $2


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




