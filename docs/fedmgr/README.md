add ucef logo

# Running the federation manager

The federation manager requires a federation model before it can run. A federation model is a WebGME project that contains multiple federates connected by shared interactions. You can either design the federation model from scratch, or use the import federate feature of WebGME to bring the federate models into a single diagram. This tutorial will use the following federation model as an example.

![Federation Model](fedmgr-1.png)

You must have run the federate exporter, finished the implementation of each federate, and compiled the federates using maven prior to working through this tutorial. After the federates are implemented, run the deployment exporter plugin on the federation model and extract the generated files to your hard drive. Your deployment directory should resemble the following file structure, with the JSON files named after your individual federates:

![Deployment Project](fedmgr-2.png)

The default configuration for the federation manager is sufficient to run the federation on your local computer. Open a terminal, navigate to the top level directory that contains **pom.xml**, and execute the following two commands in sequence: 

    mvn install
    mvn exec:java -P FederationManagerExecJava

This will run the federation manager and produce the following output:

	[INFO] Scanning for projects...
	[INFO]                                                                         
	[INFO] ------------------------------------------------------------------------
	[INFO] Building SigDur_exec 0.1.0-SNAPSHOT
	[INFO] ------------------------------------------------------------------------
	[INFO] 
	[INFO] --- exec-maven-plugin:1.5.0:java (default-cli) @ SigDur_exec ---
	
	-------------------------------------------------------------------
	GMS: address=vagrant-55943, cluster=FedManager, physical address=127.0.0.1:52243
	-------------------------------------------------------------------
	14:47:46.803 [org.cpswt.host.FederationManagerHostApp.main()] INFO  org.cpswt.host.FederationManagerHostApp - Server online at 127.0.0.1:8083 ...

federation name & network address & server address

RESTful command to start federation

NEED OUTPUT HERE!!!!

# RESTful API

steal from the workshop configuration files

# Configuring the federation manager
## fedmgrconfig.json

	{
	  "federateRTIInitWaitTimeMs": 200,
	  "federateType": "FederationManager",
	  "federationId": "FedManager",
	  "isLateJoiner": true,
	  "lookAhead": 0.1,
	  "stepSize": 1,
	  "bindHost": "127.0.0.1",
	  "port": 8083,
	  "controlEndpoint": "/fedmgr",
	  "federatesEndpoint": "/federates",
	  "federationEndTime": 0,
	  "realTimeMode": true,
	  "terminateOnCOAFinish": false,
	  "fedFile": "fom/SigDur.fed",
	  "experimentConfig": "conf/experimentConfig.json"
	}

## experimentConfig.json

	{
	  "federateTypesAllowed": [
	    "LightController",
	    "LightSensor",
	    "ProximitySensor",
	    "Switch"
	  ],
	  "expectedFederates": [
	    {
	      "federateType": "LightController",
	      "count": 0
	    },
	    {
	      "federateType": "LightSensor",
	      "count": 0
	    },
	    {
	      "federateType": "ProximitySensor",
	      "count": 0
	    },
	    {
	      "federateType": "Switch",
	      "count": 0
	    }
	  ],
	  "lateJoinerFederates": [
	    {
	      "federateType": "LightController",
	      "count": 1
	    },
	    {
	      "federateType": "LightSensor",
	      "count": 1
	    },
	    {
	      "federateType": "ProximitySensor",
	      "count": 1
	    },
	    {
	      "federateType": "Switch",
	      "count": 1
	    }
	  ]
	}

## log4j2.xml

	<?xml version="1.0" encoding="UTF-8"?>
	<Configuration status="WARN">
		<Appenders>
			<Console name="Console" target="SYSTEM_OUT">
				<PatternLayout pattern="%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n" />
			</Console>
		</Appenders>
		<Loggers>
			<Root level="INFO">
				<AppenderRef ref="Console" />
			</Root>
		</Loggers>
	</Configuration>

## RTI.rid

	# (4.2) JGroups Bind Address
	#        The address/NIC Portico should use. Can use an IP address associated with a NIC, or
	#        one of the following special values:
	#
	#            GLOBAL: Pick a global IP address if available. If not, falls back to a SITE_LOCAL IP address.
	#        SITE_LOCAL: Picks a site local (non routable) IP address, e.g. from the 192.168.0.0 or 10.0.0.0 address range.
	#        LINK_LOCAL: Picks a link-local IP address, from 169.254.1.0 through 169.254.254.255.
	#      NON_LOOPBACK: Picks any non loopback address.
	#          LOOPBACK: Pick a loopback address, e.g. 127.0.0.1.
	#   match-interface: Pick an address which matches a pattern against the interface name, e.g. match-interface:eth.*
	#     match-address: Pick an address which matches a pattern against the host address, e.g. match-address:192.168.*
	#        match-host: Pick an address which matches a pattern against the host name, e.g. match-host:linux.*
	#
	#        DEFAULT: SITE_LOCAL
	#
	portico.jgroups.udp.bindAddress = LOOPBACK
