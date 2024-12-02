---
description: >-
  This guide provides step-by-step instructions to install Generate on Microsoft
  Azure.
---

# Azure Installation Guide

### System Requirements

#### Web Server:

* [x] OS: Windows Server 2012 R2 or newer with IIS 8.5+
* [x] RAM: At least 8 GB
* [x] Software:
  * [x] .NET Core Runtime and Hosting Bundle (version 8.0)
  * [x] Application Initialization Module for IIS
  * [x] Access to Active Directory (AD); if unavailable, install AD LDS

#### Database Server:

* [x] OS: Windows Server 2012 R2 or newer with SQL Server 2016+
* [x] RAM: 32 GB
* [x] Storage: At least 50 GB of free storage

{% hint style="info" %}
Note: The Web Server and Database Server can be on the same Azure Virtual Machine if desired.
{% endhint %}

### Step-by-Step Installation

#### 1. Create Virtual Machines in Azure

* Database Server VM:
  * Choose a Windows Server 2012 R2 (or newer) image.
  * Allocate 32 GB RAM and at least 50 GB of storage.
  * Install SQL Server 2016+ on this VM.
* Web Server VM:
  * Choose a Windows Server 2012 R2 (or newer) image.
  * Allocate at least 8 GB RAM.
  * Ensure .NET Core 8.0 is installed on this VM.

#### 2. Configure Networking

* Set up an Azure Virtual Network (VNet) to allow the Web Server VM and Database Server VM to communicate securely.
* Create Network Security Groups (NSGs) to restrict access to only necessary ports (e.g., SQL Server, HTTP, and HTTPS).
* Allow external access for users if the Web Application needs to be publicly accessible.

\
From here you can follow Generate installation instructions.

{% content-ref url="./" %}
[.](./)
{% endcontent-ref %}



