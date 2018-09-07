# UCEF Regression Test
This file contains the start of a complete integration test for UCEF-Beta

## Build and verify VM
1. build vm
2. check archiva for SynchronizedFederate built, cpp built -- in chrome browse: http://127.0.0.1:8080/#browse/org.cpswt
3. test Docker by running:
```
docker run hello-world
```
4. test gridlabd by running command -- should bring up browser with message
```
gridlabd
```

1. test omnetpp by run can/arbitration simulation

## Build and verify Samples projects
1. Build and test the samples projects -- hello world, hello world gridlabd, and ChallengeResponse
TBD Tom and Himanshu -- should require no configuration edits -- just compile and run


## Build and Run a Simple Federation
1. Open Chrome
2. Open Katalon Recorder (see [Instructions on installing recorder for Chrome](selenium.md) )
3. Import script [Script that creates federation in webgme and exports deployment and generated federates](BuildPingPongFederationWithExports.html) 
4. -- note that between Federates Exporter and Deployment Exporter, you have to refresh browser because recorded script stalls (we will try to resolve).
5. Two zip files PingPong_generated.zip and PingPong_deployment are in the ~/Downloads folder
6. Place them in their own folder
7. Run the script "unpackcompileandrunfederation.sh" from that folder
8. The zip files should be unpacked, compiled, and the federation run. The script pauses for a spacebar input to send the federation start command and terminate command

## Build and Run TEChallenge Simulation
1. Run the TEChallenge simulation (note space bar to proceed from federates joining to curl to run and curl to end)
```
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/usnistgov/TEChallengeComponentModel.git
cd ~/Projects/TEChallengeComponentModel/
git checkout feature/TEJavaFederation
cd src/Federation
./buildall.sh
```
2. Then run the federation
```
cd ~/Projects/TEChallengeComponentModel/experiments/techallenge
./run.sh
```
3. Open the mysql workbench (root:c2wt) and examine the tables
4. There should be entries in the index table for each object and interaction
5. There should be one row per timeStep/instanceName and for object tables each attribute

# HowTo Refresh Code on updates
We can anticipate updates to the samples, meta, and core projects as well as the individual federates. Use the following instructions to update your VM with these updates.

1. To get updates to ucef-core
``` 
cd ~/cpswt-core
git pull
./setup_foundation_java.sh
```
2. To get updates to ucef-meta
``` 
cd ~/cpswt-meta
git pull
./build.sh
sudo service webgme restart
```
3. To get updates to samples
``` 
cd ~/cpswt-samples
git pull
cd <sample> and build
```

# Miscellaneous   
## How to extract from archiva

extract from archiva:
```
mvn dependency:copy -Dartifact=org.webgme.guest:Metronome:0.1.0-SNAPSHOT -DoutputDirectory='.
```

push to archiva:
```
mvn deploy
```
