#!/bin/bash
export LOG4J=/home/vagrant/Downloads/foo/PingPong_deployment/conf/log4j2.xml 


federationMgr.sh ~/Downloads/foo/PingPong_deployment "" "x=-fg white -bg black -geometry 140x40+0+0"
federate.sh "/home/vagrant/Downloads/foo/PingPong_generated/PingPong-java-federates/PingPong-impl-java/Ping" "-federationId=PingPong -configFile=../conf/PingConfig.json -name=Ping" "x=-fg green -bg black -geometry 140x40+200+0"
federate.sh "/home/vagrant/Downloads/foo/PingPong_generated/PingPong-java-federates/PingPong-impl-java/Pong" "-federationId=PingPong -configFile=../conf/PongConfig.json -name=Pong" "x=-fg orange -bg black -geometry 140x40+400+0"

##################################
# start the simulation
##################################
read -n 1 -r -s -p "Press any key to start the federation execution..."
printf "\n"

federation_start.sh

##################################
# terminate the simulation
##################################
read -n 1 -r -s -p "Press any key to terminate the federation execution..."
printf "\n"

federation_terminate.sh

printf "Waiting for the federation manager to terminate.."
while $(curl -o /dev/null -s -f -X GET http://127.0.0.1:8083/fedmgr); do
    printf "."
    sleep 5
done
printf "\n"
