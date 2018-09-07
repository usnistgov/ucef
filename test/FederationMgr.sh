#!/bin/bash

##################################
# This script will run the federation manager
##################################

##################################
# parse options
# $1 = path to deployment folder (default is xxx_deployment folder)
# $2 = execution arguments
# $3 = terminal options
##################################

root=`pwd`
timestamp=`date +"%F_%T"`
logs_directory=$root/logs
fedmgr_host=127.0.0.1
fedmgr_port=8083

#determine path to deployment folder
if [ -z "$1"]; then
	dp=$root
else
	dp=$1
fi

#determine if xterm is needed
if [ "$3" = "x" ]; then
xt=""
else
xt=$(cut -d"=" -f 2 <<< $3)
#xt='-fg white -bg black -l -lf $logs_directory/federation-manager-${timestamp}.log -T "Federation Manager" -geometry 140x40+0+0'
fi


d=`basename $root`
federation=$(echo $d | cut -d _ -f 1)

logs=$dp/logs
if [ ! -d $logs ]; then
    echo Creating the $logs_directory directory
    mkdir $logs
fi

command="mvn exec:java -P FederationManagerExecJava -Dfederation.name=$federation $2"


echo Federation= $federation
echo Logs = $logs
echo Deployment Path = $dp
echo Terminal Options = $3
echo Command = $command


##################################
# run the federation manager
##################################
cd $dp

# run the fed manager
if [ -z "$3" ]; then
  $command >$logs/federation-manager-${timestamp}.log &
else
 xterm $xt -e $command &
fi


printf "Waiting for the federation manager to come online.."
until $(curl -o /dev/null -s -f -X GET http://$fedmgr_host:$fedmgr_port/fedmgr); do
    printf "."
    sleep 5
done
printf "\n"


