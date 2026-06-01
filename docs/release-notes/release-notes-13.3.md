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

"fsWSURL": "[https://w1st3s2lpd.execute-api.us-east-1.amazonaws.com/api/%22](https://w1st3s2lpd.execute-api.us-east-1.amazonaws.com/api/%22)"&#x20;

There is also a new parameter that supports the metadata process that needs to be added to the file. Paste the line below after the “fsWSURL” parameter:

**"metadataApiKey": "6b5af5c15f74e7d3b4d2a5b564aec7bd9f7c60161e0e0f30"**

{% hint style="info" %}
NOTE: There is one additional parameter that is used by the updated metadata process and it is located in the table App.GenerateConfigurations.\
It will be added to the table as part of the update and the value will be set as ‘2026’.
{% endhint %}

### Summary of Changes

#### IDEA Reports&#x20;

* **Assessments (175, 178, 179)**
  * Added support for Performance Levels up to 6

#### Non-IDEA Reports

* **Directory (207**)
  * Added migration and submission file code for this file specification
* **Membership (052)**
  * Corrected the zero count logic so that rows are only created for Grades Offered at the LEA/School

### User Interface Changes

* **Metadata:** Implemented the newly created API so the automated metadata update in Generate is available again

{% hint style="info" %}
Note: There is a change to appSettings.json required for the new API and there is a new SY variable in app.GenerateConfigurations
{% endhint %}

<figure><img src="../.gitbook/assets/image (2) (1).png" alt=""><figcaption></figcaption></figure>

* **User Accessibility:** Added more user accessibility updates

#### General Chnages

* Updated .NET to version 10
* Updated Angular to version 20

**Generate 13.3 Release Tickets:**

Tickets are available in the CEDS-Collaborative-Exchange.

[**Click here** ](https://github.com/CEDS-Collaborative-Exchange/Generate/issues?q=is%3Aissue%20state%3Aopen%20label%3Av13.3)**to review the Generate 13.3 Release Tickets**

***

### **Generate Office Hour**

{% embed url="https://www.youtube.com/watch?v=4JhGOudE-yU" %}
