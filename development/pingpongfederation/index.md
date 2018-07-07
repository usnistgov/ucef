---
title: PingPong Federation
layout: page
---

# Making two standalone federates and a federation
This tutorial describes how to design separate re-usable federates and run them from their separate projects, along with, a federation manager based on a federation containing the federates.

## Make PingPong Project
1. Make PingPongProject using federation_design seed
1. Rename the top of the object browser on the right "PingPong"
1. Enter the IntegrationModel folder 
1. Add Ping JavaFederate by dragging from the left pallette
1. Add Pong JavaFederate
1. Add I1 Interaction by dragging from the right pallette C2WInteractionRoot
1. Add I2 Interaction

1. Wire up Pub Sub for I1 and I2 
1. Enter the experiments folder and the the FederationExperiment folder
1. Drag in federate from the right pallette as  Federation Exeecution references
1. Export project as webgmex
1. Do Federates Exporter
1. Do Deployment Exporter

## Make Separate Ping and Pong Projects
1. Make Ping by importing PingPongProject webgmex named Ping and deleting Pong  and the resulting dangling connections 
1. do Federates Exporter only
1. Make Pong  by importing PingPongProject webgmex and deleting Ping and do Federates Exporter only
1. do Federates Exporter only

## Build all the projects
1. Extract all zip files and build in each top level folder (generated first.
1. Enter each folder and run:

    ```
        mvn clean install
    ```

## Run Federation and Individual Federates
1. run fedmanager from PingPongProject_deployment folder

    ```
	mvn exec:java -P FederationManagerExecJava
    ```

2. run ping from PingProject_generated/PingProject-java-federates/PingProject-impl-java/Ping/target

    ```
	java  -Dlog4j.configurationFile=conf/log4j2.xml -jar Ping-0.1.0-SNAPSHOT.jar  -federationId=PingPong -configFile=conf/PingConfig.json
    ```

3. run pong from PingProject_generated/PingProject-java-federates/PingProject-impl-java/Ping/target

    ```
	java  -Dlog4j.configurationFile=conf/log4j2.xml -jar Pong-0.1.0-SNAPSHOT.jar  -federationId=PingPong -configFile=conf/PongConfig.json
    ```

4. to start run curl

    ```
    curl -X POST http://10.0.2.15:8083/fedmgr --data '{"action": "START"}' -H "Content-Type: application/json"
    ```
    
5. to end run

    ```
    curl -X POST http://10.0.2.15:8083/fedmgr --data '{"action": "TERMINATE"}' -H "Content-Type: application/json"
    ```
