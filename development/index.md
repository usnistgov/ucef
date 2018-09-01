---
title: Development
layout: page
---

---

*Table of Contents for this Page*

* TOC
{:toc}

---


# Development Resources
This is the developer resources page for UCEF. To access documentation you can follow the links below for each of the topics listed:

## General Development Topics
* [Federates and Federated Testbed Architecture](federatedtestbedarch)
* [Testing and Curation of Federates](testingandcuration)

## Development of Federates, Federations and Experiments
* [How to use WebGME to design federates](webgme)
* [How to run a federation](fedmgr)
* [How to create separate runnable federates and a federation containing them](pingpongfederation)

# UCEF Git Source Repositories

UCEF consists of a set of separate projects that collaborate to provide the integrated testbed development experience.

## UCEF Core Components
The following represent the building blocks of UCEF:

- ucef: [https://github.com/usnistgov/ucef.git](https://github.com/usnistgov/ucef.git)

    - This is the home project for UCEF. From this project you can build the UCEF virtual machine with all its components.

- ucef-core: [https://github.com/usnistgov/ucef-core.git](https://github.com/usnistgov/ucef-core.git)

    - This is the core code for UCEF incorporating the HLA library of Portico and the foundation classes for UCEF implementations

- ucef-cpp: [https://github.com/usnistgov/ucef-cpp.git](https://github.com/usnistgov/ucef-cpp.git)

    - These are additional libraries in C++ to support the ucef-core

- ucef-meta: [https://github.com/usnistgov/ucef-meta.git](https://github.com/usnistgov/ucef-meta.git)

    - The meta's are the GUI components of UCEF running on WebGME

- ucef-samples: [https://github.com/usnistgov/ucef-samples.git](https://github.com/usnistgov/ucef-samples.git)

    - This project contains sample applications that demonstrate UCEF capabilities.

- ucef-gridlabd-meta: [https://github.com/usnistgov/ucef-gridlabd-meta.git](https://github.com/usnistgov/ucef-gridlabd-meta.git)

    - This project adds a Gridlab-D graphic model editor for UCEF

- ucef-database: [https://github.com/usnistgov/ucef-database.git](https://github.com/usnistgov/ucef-database.git)

    - This project contains database engine support for UCEF

## UCEF Wrappers
- ucef-gateway: [https://github.com/usnistgov/ucef-gateway.git](https://github.com/usnistgov/ucef-gateway.git)

    - ucef-gateway provides for a simplified method of adapting any external simulator or solver to the HLA infrastructure of UCEF.

- ucef-gridlabd: [https://github.com/usnistgov/ucef-gridlabd.git](https://github.com/usnistgov/ucef-gridlabd.git)

    - ucef-gridlabd provides for the ability to run GridLAB-D(TM) simulations under UCEF allowing interactions between federates to reach inside the GridLAB-D(TM) simulation.

- ucef-labview: [https://github.com/usnistgov/ucef-labview.git](https://github.com/usnistgov/ucef-labview.git)

    - ucef-labview provides for the ability to run LabVIEW(TM) simulations under UCEF allowing interactions between federates to reach inside the LabVIEW(TM) simulation.

## UCEF Library
- ucef-library: [https://github.com/usnistgov/ucef-library.git](https://github.com/usnistgov/ucef-library.git)
    - ucef-library provides for available re-usable federates, federations, and experiments.

