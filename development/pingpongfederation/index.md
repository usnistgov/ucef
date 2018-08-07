---
title: PingPong Federation
layout: page
---

---

*Table of Contents for this Page*

* TOC
{:toc}

---

# Making two standalone federates and a federation
This tutorial describes how to design separate re-usable federates and run them from their separate projects, along with, a federation manager based on a federation containing the federates.

## Make the PingPong Project
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

## Some Variations
* Instead of Interactions, add ObjectRoot instances O1 and O2 instead of I1 and I2 (see above).
* Add parameters to the I1 and I2 instances, or O1 and O2 instances, as appropriate.

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

## Building a federation only and running within the federation project (PingPongProject_deployment)

### Alternatives: Run all federates from the PingPongProject_deployment folder
In this case, build all behavior into the federates in the PingPongProject_generated folder. These federates can be separated at a later time as individual federates.

1.  Run FederationManager

    ```
	mvn exec:java -P FederationManagerExecJava
    ```
1.  Run Ping

    ```
	mvn exec:java -P ExecJava,Ping
    ```
1.  Run Pong

    ```
	mvn exec:java -P ExecJava,Pong
    ```
1.  Run the curl statements to start and stop the experiment

### Alternatives: Run/Debug from Eclipse
1. Open a new eclipse workspace
2. Import from existing maven projects
3. Browse to the folder that contains the deployment and generated projects
4. Accept all subprojects (each pom.xml file in the file tree creates a separate project
5. If you right click on the PingPong_root and select Run As / Maven Install you can compile the federate code
6. If you right click on the PingPong_exec and select Run As / Maven Install you can build the federation manager and the federation code
7. If you right click on the PingPong_exec and select Run As / Maven Build you can create a runtime configuration for the federation manager. 
* In the Goals: section type ```exec:java```
* In the Profiles section type ```FederationManagerExecJava```
8. Now you can run the federation manager with the eclipse run or debug
9. To run the Ping from the same folder, if you right click on the PingPong_exec and select Run As / Maven Build you can create a runtime configuration for the Ping federate: 
* In the Goals: section type ```exec:java```
* In the Profiles section type (the space between profile names is important) ```ExecJava Ping```
10. Do the same for Pong  

You can now run the FederationManager, Ping, and Pong from within eclipse and set break points and otherwise debug. You may find it a little difficult to select from the different console windows. There are icons that will allow you to open multiple console windows.