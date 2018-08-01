![UCEF logo](ucef_final.jpg)

# UCEF

### Background on UCEF and Cyber-Physical Systems

Cyber-Physical Systems (CPS) are smart systems that include co-engineered interacting networks of physical and computational components [1].  CPS integrate computation, communication, sensing and actuation with physical systems to fulfill time-sensitive functions with varying degrees of interaction with the environment, including human interaction.  These highly interconnected systems provide new functionalities to improve quality of life and enable technological advances in critical areas, such as personalized health care, emergency response, traffic flow management, smart manufacturing, defense and homeland security, and energy supply and use.  CPS and related systems (including the Internet of Things (IoT) and the Industrial Internet) are widely recognized as having potential to enable innovative applications and impact multiple economic sectors in the worldwide economy [2].

The impacts of CPS will be revolutionary and pervasive – this is evident today in emerging smart cars, intelligent buildings, robots, unmanned vehicles and medical devices [3]. The development of these systems cuts across all industrial sectors and demands high-risk, collaborative research between research and development teams from multiple institutions. Realizing the future promise of CPS will require interoperability between heterogeneous systems and development processes supported by robust platforms for experimentation and testing across domains. Meanwhile, current design and management approaches for these systems are domain-specific and would benefit from a more universally applicable approach.

Cyber-Physical Systems (CPS) experimentation suffers from isolated simulation tools and many cross-platform custom adaptors which increases complexity and cost. Yet the demand for more sophisticated experiments and configurations is growing.

The National Institute of Standards and Technology (NIST) and its partner, the Institute for Software Integrated Systems at Vanderbilt University [4], have developed a collaborative experiment development environment across heterogeneous architectures integrating best-of-breed tools including programming languages, communications co-simulation, simulation platforms, hardware in the loop, and others. This environment combines these simulators and emulators from many researchers and companies with a standardized communications protocol, IEEE Standard 1516 High Level Architecture (HLA) [5]. NIST calls this a Universal CPS Environment for Federation (UCEF).

UCEF is provided as an open source toolkit that:

* comprises a portable, self-contained, Linux Virtual Machine which allows it to operate on any computing platform;
* contains a graphical experiment and federate design environment – Web-based graphical modeling environment (WebGME) developed by Vanderbilt University that provides code generation for adapting models to the simulators;
* defines a language for exercising the collection of federates, the federation, in the course of theexperiment;
* separates the design of experiments from the design of the models composed in an experiment;
* manages its own scope in the definition of federated interfaces, federations, experiments – but not model design and implementations;
* develops experiments that can be deployed independently on a variety and combination of platforms from large cloud systems to small embedded controllers;
* allows experiments to be composed among local simulations, hardware in the loop (HIL), cloud simulations, and collaborative experiments across the world;
* integrates federates designed in (expected as of this workshop): Java, C++, Omnet++, Matlab, LabView, Gridlab-D.

### To Build the Virtual Machine or Download One
See [**Build**](build) which contains code to allow for the automated generation of the UCEF Virtual Machine


### UCEF Website

Follow this link to the [UCEF Collaboration Website](https://pages.nist.gov/ucef "") 

