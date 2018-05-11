---
title: Federates
layout: page
---

This tutorial describes how to design a new federate in WebGME. The tutorial assumes that you have already created a WebGME project for the federate, and have the root folder of that project open. Refer to the tutorial on WebGME project management if you are not familiar with these steps.

# Create a Federate
You should never place federates into the root folder of WebGME. The code generation plugins for WebGME expect federate models to be located in a special folder called a Federation Object Model (FOM) sheet. Navigate to the project's root folder, find the **FOMSheet* part in the WebGME component palette, and drag a FOMSheet into the WebGME workspace to create an instance. A FOMSheet is a special folder that can be used to design HLA models. You can left click on the FOMSheet and change its name in the property editor. Double click on the FOMSheet to open it and begin the federate design.

<img style="width:100%;" src="webgme-federates-1.png" alt="Figure 1: Create a Federate"/>

The above image shows how to create a new java federate. The same procedure can be used to create any supported federate types, but the properties shown in the property editor might vary across different federate types. First find the **JavaFederate** part in the component palette and drag it into the FOMSheet. Then left click on the new java federate instance and modify its properties in the property editor. Unless you are familiar with HLA and CPSWT, only change the property for the federate name.

# Create an Interaction
An interaction is the HLA term for a message type; it defines a set of data that the federate uses as either an input or an output. A federate can be associated with any number of interactions, but this tutorial will only cover the creation of a single interaction.

Although there is an *Interaction* part in the component palette, you cannot use it because it is not compatible with your new federate instance. When you perform code generation on your federate, it will be linked against a library called CPSWT that extends the HLA standard. The interactions used in this CPSWT library are based on the basic HLA *Interaction*, but include some additional data. When you created your WebGME project based on the CPSWT seed, you brought in the a library called **BasicPackage** that includes this extended interaction definition. The image below illustrates how to create an interaction instance from the BasicPackage library.

<img style="width:100%;" src="webgme-federates-2.png" alt="Figure 2: Create an Interaction"/>

Left click on the arrow next to **BasicPackage** in the object browser to expand its content, and then select the child object called **C2WInteractionRoot**. Drag C2WInteractionRoot from the object browser into the main workspace and drop it into your model. Choose **Create instance here** from the menu that opens when you release C2WInteractionRoot. The new interaction instance will appear in the workspace. Left click the interaction and change its name in the property editor. Unlike federates, the interaction will have the text <C2WInteractionRoot> below it in the workspace even after it has been renamed. This text indicates that your interaction extends C2WInteractionRoot and will contain all the data defined by C2WInteractionRoot.

An interaction in HLA has a set of parameters which define the set of data the interaction can contain. Because your new interaction class is based on C2WInteractionRoot, it should already contain four parameters. These inherited parameters cannot be changed or removed, but you can modify your new interaction class to define additional parameters. Double click on the new interaction to open it in WebGME and change its parameters. You must double click on blank space, or WebGME might think you are trying to rename the interaction.

<img style="width:100%;" src="webgme-federates-3.png" alt="Figure 3: Add a Parameter to an Interaction"/>

The above image shows how to define a new parameter; drag and drop the **Parameter** part from the component palette and modify its properties in the property editor. This time you will want to modify both the name and the ParameterType properties, where the ParameterType refers to the data type such as String or Double. Repeat this process until you have the desired number of parameters, and then use either the object browser or the go to parent button to return to the FOMSheet.

# Publications and Subscriptions
Your model now contains at least one federate and interaction. However, these two objects have no relationship to each other. In HLA, a federate can either subscribe to an interaction to indicate its inputs, or publish an interaction to indicate its outputs. Publications and subscriptions in WebGME are indicated by directed lines. A line from an interaction to a federate represents a subscription where the data is fed into the federate as an input. A line from a federate to an interaction represents a publication where the federate produces the data defined in the interaction.

<img style="width:100%;" src="webgme-federates-4.png" alt="Figure 4: Add Publish or Subscribe to an Interaction"/>

The above image shows how to define a subscription in WebGME. When you hover over an interaction, you will see two blue boxes on the top and bottom of the interaction. Click and drag a line from either of these blue boxes over to the federate. Release the mouse button when you are hovering over a corresponding blue box of the federate who should subscribe to the interaction. A directed line will be drawn between the two objects to indicate the new subscription. You have no control over the layout of the line.

To define a publication, the same process can be done in reverse starting from clicking on the blue box associated with the federate and then dragging over to the interaction's blue box. A federate can both publish and subscribe to the same interaction by repeating the process in both directions. If there are multiple federates in the model, an interaction can be associated with one or more of the federates. 