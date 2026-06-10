---
description: This document describes the technical enhancements to Generate version 13.3.
icon: sparkles
cover: ../.gitbook/assets/GenerateBanner13_3.avif
coverY: 0
layout:
  width: default
  cover:
    visible: true
    size: hero
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
  metadata:
    visible: true
  tags:
    visible: true
  actions:
    visible: true
---

# Release Notes 13.3

**Release Overview**

Generate 13.3 requires some additional steps that must be performed prior to performing the Generate upgrade. Below are the instructions for performing the update.

**Step 1: Update the version of .NET to 10.0**

.NET 10.0 download link: [https://dotnet.microsoft.com/en-us/download](https://dotnet.microsoft.com/en-us/download)

**Step 2: Update Configuration Settings**

Prior to updating to Generate version 13.3, you will need to update the parameters in the **appSettings.json** file in **\web\config**. This file is located on the webserver where Generate was installed.

In that file, there is a parameter for the metadata process named "**fsWSURL**”.  You will need to update the value for that parameter to the one below:&#x20;

"fsWSURL": "[https://il96nnsqbe.execute-api.us-east-1.amazonaws.com/api/](https://il96nnsqbe.execute-api.us-east-1.amazonaws.com/api/)"&#x20;

<figure><img src="../.gitbook/assets/image (3) (1).png" alt=""><figcaption></figcaption></figure>

### Summary of Changes

#### IDEA Reports&#x20;

* **Assessments (175, 178, 179)**
  * Added support for Performance Levels up to 6

#### Non-IDEA Reports

* **Directory (207**)
  * Added migration and submission file code for this file specification, State Appropriations for Charter Schools
  * Special thanks to the state of New Mexico for contributing this code!&#x20;
* **Membership (052)**
  * Corrected the zero count logic so that rows are only created for Grades Offered at the LEA/School

### User Interface Changes

* **Metadata:** Implemented the newly created API so the automated metadata update in Generate is available again

{% hint style="info" %}
Note: There is a change to appSettings.json required for the new API and there is a new SY variable in app.GenerateConfigurations. (Reference image above)
{% endhint %}

* **User Accessibility:** Added more user accessibility updates

#### General Changes

* Updated .NET to version 10
* Updated Angular to version 20

**Generate 13.3 Release Tickets:**

Tickets are available in the CEDS-Collaborative-Exchange.

[**Click here** ](https://github.com/CEDS-Collaborative-Exchange/Generate/issues?q=is%3Aissue%20state%3Aopen%20label%3Av13.3)**to review the Generate 13.3 Release Tickets**

***

### **Generate Office Hour**

{% embed url="https://www.youtube.com/watch?v=4JhGOudE-yU" %}
