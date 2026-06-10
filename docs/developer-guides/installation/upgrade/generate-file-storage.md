---
description: >-
  This page will contain the links to Supplemental Release, HotFix and Metadata
  files in GitHub.
---

# Generate File Storage

**Supplemental Release**

A supplemental release extends an existing software version by introducing new components, enhancements, or expanded functionality after the original release has already been deployed. For example, after version 13.1 is released, additional scripts or code updates may be delivered to add new features or extend how an existing feature operates. Supplemental releases allow the Generate development team to deliver incremental improvements without waiting for the next full version of the application. These updates differ from HotFixes because they are not correcting broken behavior in existing functionality. Instead, they provide additional capabilities or improvements that build on the current release. When a supplemental release is issued, users will receive notification when a supplemental release is available.&#x20;

There will be links below with the data, Release Version it applies to and instructions that you will review to understand the new scripts, components, or configuration steps required to support the extended functionality.

{% hint style="info" %}
After applying the Generate 13.2 update and running the automated metadata process for 2026 you will need to execute a sql script to update the File Submission Description column that is used in the file header for every file. In the latest 2026 metadata the last character was dropped and this update will correct that so the header is valid for submission into EDPass. &#x20;

**NOTE:** This is required and needs to be done after applying the Generate 13.2 update and after running the Metadata process from the UI for 2026.&#x20;

1. Use the link provided to get to [Generate File Storage in the Generate github repository](https://github.com/CEDS-Collaborative-Exchange/Generate/tree/master/docs/Generate%20File%20Storage)&#x20;
2. Click on the file '13.2\_Metadata\_2026\_update.sql'&#x20;
3. The sql code for this update will be displayed in the window&#x20;
4. Either highlight the code and copy (CTRL-C) - or - from the right side of the header row click the COPY RAW FILE option&#x20;

<img src="../../../.gitbook/assets/image (1) (1).png" alt="" data-size="original">

5. Paste that code into Sql Server Management Studio (SSMS) or whatever tool you use to manage sql for Generate&#x20;
6. Execute the code &#x20;
7. Repeat the Paste - Execute steps if you have multiple instances of Generate
{% endhint %}

{% hint style="info" %}
No Supplemental Release at this time. Past Supplemental Releases can be found here: [Github Generate File Storage](https://github.com/CEDS-Collaborative-Exchange/Generate/tree/master/docs/Generate%20File%20Storage)
{% endhint %}

**HotFix**

A hot fix addresses an issue in an existing feature that is not functioning as expected after a release. These updates correct defects, errors, or unintended behavior discovered in the current version of the software. Hot fixes are issued to resolve problems that may impact system functionality, data accuracy, or user workflows without waiting for the next full release cycle. You will receive notification when a HotFix is available. When a HotFix is published, the required scripts, files, and implementation instructions will be provided in this section so you can apply the correction to your current environment and restore the expected behavior of the system.

{% hint style="info" %}
No Supplemental Release at this time. Past HotFix Releases can be found here: [Github Generate File Storage](https://github.com/CEDS-Collaborative-Exchange/Generate/tree/master/docs/Generate%20File%20Storage)
{% endhint %}



**Metadata Files**

With each release we are supplying the current metadata file pulled from the API.  This file would only need to be used if you are experiencing issues running the metadata process from the Generate application and you need to apply the metadata manually while that issue is being addressed.  Instructions for when that would be necessary and how to do that are located on the Configuring Metadata Updates page located here - [https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/installation/configuring-metadata-updates](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/installation/configuring-metadata-updates)

{% hint style="info" %}
After applying the Generate 13.2 update and running the automated metadata process for 2026 you will need to execute a sql script to update the File Submission Description column that is used in the file header for every file. In the latest 2026 metadata the last character was dropped and this update will correct that so the header is valid for submission into EDPass. &#x20;

**NOTE:** This is required and needs to be done after applying the Generate 13.2 update and after running the Metadata process from the UI for 2026.&#x20;

1. Use the link provided to get to [Generate File Storage in the Generate github repository](https://github.com/CEDS-Collaborative-Exchange/Generate/tree/master/docs/Generate%20File%20Storage)&#x20;
2. Click on the file '13.2\_Metadata\_2026\_update.sql'&#x20;
3. The sql code for this update will be displayed in the window&#x20;
4. Either highlight the code and copy (CTRL-C) - or - from the right side of the header row click the COPY RAW FILE option&#x20;

<img src="../../../.gitbook/assets/image (1) (1).png" alt="" data-size="original">

5. Paste that code into Sql Server Management Studio (SSMS) or whatever tool you use to manage sql for Generate&#x20;
6. Execute the code &#x20;
7. Repeat the Paste - Execute steps if you have multiple instances of Generate
{% endhint %}
