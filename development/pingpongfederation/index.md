---
title: PingPong Federation
layout: page
---

---

*Table of Contents for this Page*

* TOC
{:toc}

---

# Making two standalone Java federates and a federation
This tutorial describes how to design separate re-usable federates and run them from their separate projects, along with, a federation manager based on a federation containing the federates.

The basic workflow used is:
1. Build a federation with Ping and Pong federates
1. Generate code for all
1. Create separate Ping and Pong standalone and reusable fedederates by importing the entire federation and deleting all but the desired federate and its interactions

Several alternative configurations are described for running natively, using maven, and using eclipse for development.

## Make the PingPong Project
1. Make PingPongProject using federation_design seed
1. Rename the top of the object browser on the right "PingPong"
1. Enter the IntegrationModel folder 
1. Add Ping JavaFederate by dragging from the left pallette
1. Add Pong JavaFederate
1. Add I1 Interaction by dragging from the left pallette C2WInteractionRoot
1. Add I2 Interaction
1. Wire up Pub Sub for I1 and I2 
1. Export project as webgmex by right-clicking the top of the object browser and selecting export with assets -- this will allow you to archive and reload the WebGME project at a later date
1. Select the "player" icon near the top left of the browser and select Federates Exporter
1. Select Save & Run
1. The select Deployment Exporter
1. Select Save & Run
1. Select the "player" icon near the top left of the browser and select Show Results
1. Download resulting zip files containing code generated projects by clicking on the results

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
4. Accept all subprojects (each pom.xml file in the file tree creates a separate project)
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

### Alternatives: Run/Debug from Eclipse as Java Application (as opposed to Maven)
1. Open the menu Debug/Debug Configurations
2. On left side double click on Java Application to create a new debug configuration
3. Change the Name to Ping
4. Browse the Project for the Ping project
5. Search for the main class PingPong.Ping
6. Check the Stop in main so on debug it will stop on main
7. Click the Arguments tab
8. In the Program arguments add the command line arguments ```-federationId=PingPong -configFile=conf/PongConfig.json```
9. In the VM arguments add ```-Dlog4j.configurationFile=conf/log4j2.xml```

10. On the bottom right of the form select Apply
11. Debug now by selecting Debug or close the form. The configuration should be available on the Debug or Run menu.

### Alternatives: Create and Run Cpp Federates under Maven
1. Instead of selecting JavaFederate from left panel in the WebGME editor, select CppFederate
2. Complete project the same way you do a Java federate
3. After exporting Federates and Deployment
In _generated:
```
mvn package install 
```
In _deployment:
```
mvn package install -P CppFed
```
4. To run C++ federates in deployment:
5.  Run FederationManager

```
mvn exec:java -P FederationManagerExecJava
```
6. Run Ping Federate in new terminal terminal
```
mvn exec:exec -P CppFed,Ping
```
7. Run Pong Federate in new terminal terminal
```
mvn exec:exec -P CppFed,Pong
```
8. In a new terminal, run start and terminate scripts accordingly
```
federation_start.sh
```
9. Run terminate script to end simulation
```
federation_terminate.sh
```



## Final Notes

* You can mix and match the execution methods in this tutorial. For example, you can run the federation manager from the command line and all but one federate as well. The last federate -- perhaps the one you are working on -- can be run under debug in eclipse.

* Once you add behavior to your federates, if you regenerate the exported projects from the WebGME environment, you will need to merge your custom code into the regenerated projects. There are many publicly available merge and diff tools that make this process easy since it typically requires just merging the one implementation file and copying the additional classes generated.