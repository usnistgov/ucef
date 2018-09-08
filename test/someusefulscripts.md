# Some Useful Scripts
The test directory has some useful scripts to use in running federates and federations. This directory is in the default path for the "vagrant" user and so may be run directly from any folder.

## federationmgr.sh
Run this script to start the federation manager in any xxxx_deployment folder generated from WebGME.

Arguments: 
* $1 = path to deployment folder (default is xxx_deployment folder)
* $2 = execution arguments
* $3 = terminal options

## federate.sh
Run this script to start a federate.

Arguments: 
* $1 = path to federate folder
* $2 = execution arguments
* $3 = terminal options

## test.sh
The script test.sh illustrates how to use federate.sh & federationmgr.sh operating on the PingPong federation in /home/vagrant/Downloads/foo.

## unpackcompileandrunfederation.sh
This is a useful script to run a java federation as generated out of WebGME. To use it, 
1. Generate xxx_generated.zip and xxx_deployment.zip files in from WebGME.
2. Place them in a separate folder (folder now contains two zip files)
3. Open a terminal in this folder
4. Run:
```
unpackcompileandrunfederation.sh
```
5. The script will unzip the source files, compile the programs, and then run the federation manager followed by each of the federates. The script will prompt for keypresses to then start the experiment and conclude it.

## waitforfederationmgr.sh
If you start the federation manager by some other means, this script will test for the federation manager to be online ready for federates to join.

## Scripts to Control Experiment
These scripts assume that the Federation Manager is listening on 127.0.0.1:8083:
1. Start the federation running: federation_start.sh
1. Pause the federation: federation_pause.sh   
1. Terminate the federation: federation_terminate.sh
1. Resume a paused federation: federation_resume.sh  
