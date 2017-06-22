#FAQs: What, Why, How, Where, When, and Who?

##*What* Is UCEF?

UCEF is the acronym for a collaborative experiment-development environment called the Universal Cyber-Physical Systems Environment for Federation (UCEF).  It has been developed by the National Institute of Standards and Technology (NIST) and its partner, the Institute for Software Integrated Systems at Vanderbilt University. It is an open source toolkit (see more details below under "*How* can UCEF be Used").

##*Why* Do We Need UCEF?

Cyber-Physical Systems (CPS) experimentation suffers from a number of limiting factors, including the following:

* Simulation tools are often developed in isolation, using a wide variety of architectures and platforms. A simulation tool developed in one environment can't be easily used in another environment without custom-developed adopters.
* Some CPS experiments are done in operational systems (e.g., on electric grid testbed or in a test vehicle). Because these operational systems may be providing critical functions in real time, these experiments are limited by the severe constraints required to ensure that experiments and testing do not affect trustworthiness (security, safety, reliability, resilience, and privacy).
* Some CPS experiments include proprietary components.
* Some CPS experiments involve equipment that is unique or can’t be collocated.

Because of these types of constraints, it is very difficult to study the general applicability of CPS concepts and technologies intended for implementation across multiple domains and in varied applications.

As scientists and engineers conduct sophisticated experiments involving systems and "systems of systems" of ever-increasing complexity, it would be very useful to have a multi-domain CPS testbed with remote federation functionality.  In addition, it would be very useful for such a testbed to be reconfigurable, reproducible, and scalable.

UCEF has been developed to address these concerns.

##*How* Does UCEF Work?

The technical approach relies on three key ideas: (1) to integrate “best-of-breed” tools from multiple domains, and (2) to do so using well-established standards for federated communications, and (3) to define the components of an experiment in a granular form that allow experiments to be composed of well-defined and tested parts.

UCEF employs a standardized communications protocol, IEEE Standard 1516 High Level Architecture (HLA), to combine and integrate simulators, emulators, and hardware from multiple researchers and companies. UCEF integrates best-of-breed tools including programming languages (e.g., ??), communications co-simulation (e.g., ???), simulation platforms (e.g., ???), hardware-in-the-loop, and others. 

##*Where* Can UCEF Be Used?

The NIST CPS testbed is physically located on the NIST campus in Gaithersburg, Maryland.  However, UCEF makes it possible to include federates from other locations.  Similarly, an organization with a testbed at its own facility may want to use UCEF to allow the incorporation of federates at other locations. 

##*When* Will UCEF Be Available?

The UCEF tool kit will be introduced to the developer community at a July 27 workshop at the NIST campus in Gaithersburg, Maryland.  [Details about the workshop are available online.](https://appam.certain.com/profile/web/index.cfm?PKWebId=0x14555479a)

At this workshop, participants will learn the details of UCEF, obtain a copy that they can install at the workshop and take home with them on a USB drive, and participate in a hands-on exercise to design/implement/build a collaborative experiment involving all attendees.

Immediately following the workshop, the UCEF tool kit will be [available online](https://www.nist.gov/cps)--at no cost and to anyone who is interested.

##*Who* can use and benefit from UCEF?

With the UCEF project, NIST is leading and encouraging the formation of a CPS testbed community of practice that includes testbed users and developers in the industrial and academic sectors.

##*What* Are UCEF's Key Features?

UCEF is provided as an open source toolkit that:

* comprises a portable, self-contained, Linux Virtual Machine which allows it to operate on any computing platform;
* contains a graphical experiment and federate design environment – Web-based graphical modeling environment (WebGME) developed by Vanderbilt University that provides code generation for adapting models to the simulators;
* defines a language for exercising the collection of federates, the federation, in the course of the experiment;
* separates the design of experiments from the design of the models composed in an experiment;
* manages its own scope in the definition of federated interfaces, federations, experiments – but not model design and implementations;
* develops experiments that can be deployed independently on a variety and combination of platforms from large cloud systems to small embedded controllers;
* allows experiments to be composed among local simulations, hardware in the loop (HIL), cloud simulations, and collaborative experiments across the world;
* integrates federates designed in (expected as of this workshop): Java, C++, Omnet++, Matlab, LabView, Gridlab-D.




