#!/bin/bash

# This script will extract, compile and run a federation with one federate if the generated and deployment zip files are in a clean directory.

root=`pwd`
timestamp=`date +"%F_%T"`
f1=*_generated.zip
f2=*_deployment.zip
federation=$(echo $f1 | cut -d _ -f 1)
g=$(echo $f1 | cut -d . -f 1)
d=$(echo $f2 | cut -d . -f 1)
echo $federation
logs=$root/$d/logs
LOG4J=$root/$d/conf/log4j2.xml

mkdir -p $g
mkdir -p $d
mkdir -p $d/logs

unzip -u $f1 -d$g
unzip -u $f2 -d$d

cd $g
mvn clean install

cd ../$d
mvn clean install


##################################
# run the federation manager
##################################
cd $root/$d

xterm -fg white -bg black -l -lf $logs/federation-manager-${timestamp}.log -T "Federation Manager" -geometry 140x40+0+0 -e "export CPSWT_ROOT=`pwd` && mvn -Dlog4j.configurationFile=$LOG4J exec:java -P FederationManagerExecJava" &

printf "Waiting for the federation manager to come online.."
until $(curl -o /dev/null -s -f -X GET http://127.0.0.1:8083/fedmgr); do
    printf "."
    sleep 5
done
printf "\n"

cd $root
for i in $g/$federation-java-federates/$federation-impl-java/* ; do
  if [ -d "$i" ]; then
	echo running $root/$i

   cd $root/$i/target

	fed=`basename $i`
	config=conf/$fed
	config+=Config.json
	command="java -Dlog4j.configurationFile=$LOG4J -jar $fed-0.1.0-SNAPSHOT.jar -federationId=$federation -configFile=../$config -name=$fed"
	echo Command: $command
	xterm -fg green -bg black -l -lf $logs/$fed-${timestamp}.log -T "$fed" -geometry 140x40+100+100 -e $command &

	printf "\n"

	cd $root

  fi
done

##################################
# start the simulation
##################################
read -n 1 -r -s -p "Press any key to start the federation execution..."
printf "\n"

curl -o /dev/null -s -X POST http://127.0.0.1:8083/fedmgr --data '{"action": "START"}' -H "Content-Type: application/json"


##################################
# terminate the simulation
##################################
read -n 1 -r -s -p "Press any key to terminate the federation execution..."
printf "\n"

curl -o /dev/null -s -X POST http://127.0.0.1:8083/fedmgr --data '{"action": "TERMINATE"}' -H "Content-Type: application/json"

printf "Waiting for the federation manager to terminate.."
while $(curl -o /dev/null -s -f -X GET http://127.0.0.1:8083/fedmgr); do
    printf "."
    sleep 5
done
printf "\n"



