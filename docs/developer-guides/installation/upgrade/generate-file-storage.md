---
description: >-
  This page will contain the links to Supplemental Release, HotFix and Metadata
  files in GitHub.
---

# Generate File Storage

**Supplemental Release**

A supplemental release extends an existing software version by introducing new components, enhancements, or expanded functionality after the original release has already been deployed. For example, after version 13.1 is released, additional scripts or code updates may be delivered to add new features or extend how an existing feature operates. Supplemental releases allow the Generate development team to deliver incremental improvements without waiting for the next full version of the application. These updates differ from HotFixes because they are not correcting broken behavior in existing functionality. Instead, they provide additional capabilities or improvements that build on the current release. When a supplemental release is issued, users will receive notification when a supplemental release is available.

There will be links below with the data, Release Version it applies to and instructions that you will review to understand the new scripts, components, or configuration steps required to support the extended functionality.

{% hint style="info" %}
After applying the Generate 13.2 update and running the automated metadata process for 2026 you will need to execute a sql script to update the File Submission Description column that is used in the file header for every file. In the latest 2026 metadata the last character was dropped and this update will correct that so the header is valid for submission into EDPass.

**NOTE:** This is required and needs to be done after applying the Generate 13.2 update and after running the Metadata process from the UI for 2026.

1. Use the link provided to get to [Generate File Storage in the Generate github repository](../../../Generate%20File%20Storage)
2. Click on the file '13.2\_Metadata\_2026\_update.sql'
3. The sql code for this update will be displayed in the window
4. Either highlight the code and copy (CTRL-C) - or - from the right side of the header row click the COPY RAW FILE option

<img src="../../../.gitbook/assets/image (1) (1).png" alt="GitHub file page with the Copy Raw File option." data-size="original">

5. Paste that code into Sql Server Management Studio (SSMS) or whatever tool you use to manage sql for Generate
6. Execute the code
7. Repeat the Paste - Execute steps if you have multiple instances of Generate
{% endhint %}

{% hint style="info" %}
No Supplemental Release at this time. Past Supplemental Releases can be found here: [Github Generate File Storage](../../../../generate.filestorage)
{% endhint %}

**HotFix**

A hot fix addresses an issue in an existing feature that is not functioning as expected after a release. These updates correct defects, errors, or unintended behavior discovered in the current version of the software. Hot fixes are issued to resolve problems that may impact system functionality, data accuracy, or user workflows without waiting for the next full release cycle. You will receive notification when a HotFix is available. When a HotFix is published, the required scripts, files, and implementation instructions will be provided in this section so you can apply the correction to your current environment and restore the expected behavior of the system.

{% hint style="info" %}
**The 13.3 HotFix supports files 033 – Free and Reduced Lunch and 052 – Membership**

**Updates for 033**

* The file specification defines the aggregation of the Free and Reduced counts with the following language: ‘Free and reduced-price lunch (DG565) includes students who are directly certified plus students who qualified for free or reduced-price lunch by completing an application.’ Generate was not including the students identified as Direct Certification so the Free and Reduced total was under-reported.
* In a previous Generate release we corrected an issue with the reporting capabilities for this file. The file specification says, ‘States are required to submit **either** DG565 (Free and reduced-price lunch) **or** DG813 (direct certification) data’ but ED prefers both counts be submitted if they are available. Generate was automatically migrating and aggregating both counts. We added a Toggle question so each state can define how they prefer to submit this data. The correction with this release relates to the zero counts. Generate was still creating zero counts for both categories even if the Toggle response was limited to one category or the other.

**Updates for 052**

* We added some additional filtering to the zero count logic to ensure that zero count rows were only created for LEAs/Schools that offered the grade level ‘PK’

There is an additional update to the specific metadata for files 033 and 129. The File Description which is used to create the header row had an incorrect value. There is a sql script that corrects those File Description values.

**Instructions for Applying the Updates**

1. The updates are contained in a zip file.
2. Unzip the file and you should have 3 individual files.
3. In Sql Server Management Studio (SSMS) or whatever tool you use to connect to the Generate database, open the 3 files.
   1. Function (Get\_CountSQL)
   2. Stored Procedure (Create\_ReportData\_ZeroCounts),
   3. 2 sql Updates Statements
4. In each case, need to execute them by either clicking the **Execute button** in the ribbon or hitting **F5**.
5. You can then close those tabs in SSMS.
6. If you’ve already migrated 033 and/or 052 data you will need to run the report migration.
   1. If you use the Generate UI you can migrate those 2 files from the Membership fact type which will complete a full migration at all levels.
   2. If you migrate from the back-end you only need to execute the report migration for those 2 files.
{% endhint %}

{% hint style="info" %}
HotFix Release 13.3 can be found here: [Github Generate File Storage](https://github.com/CEDS-Collaborative-Exchange/Generate/blob/master/docs/Generate%20File%20Storage/13.3_hotfix.zip)
{% endhint %}

**Metadata Files**

With each release we are supplying the current metadata file pulled from the API. This file would only need to be used if you are experiencing issues running the metadata process from the Generate application and you need to apply the metadata manually while that issue is being addressed. Instructions for when that would be necessary and how to do that are located on the Configuring Metadata Updates page located here - [https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/installation/configuring-metadata-updates](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/installation/configuring-metadata-updates)

{% hint style="info" %}
After applying the Generate 13.2 update and running the automated metadata process for 2026 you will need to execute a sql script to update the File Submission Description column that is used in the file header for every file. In the latest 2026 metadata the last character was dropped and this update will correct that so the header is valid for submission into EDPass.

**NOTE:** This is required and needs to be done after applying the Generate 13.2 update and after running the Metadata process from the UI for 2026.

1. Use the link provided to get to [Generate File Storage in the Generate github repository](../../../Generate%20File%20Storage)
2. Click on the file '13.2\_Metadata\_2026\_update.sql'
3. The sql code for this update will be displayed in the window
4. Either highlight the code and copy (CTRL-C) - or - from the right side of the header row click the COPY RAW FILE option

<img src="../../../.gitbook/assets/image (1) (1).png" alt="GitHub file page with the Copy Raw File option." data-size="original">

5. Paste that code into Sql Server Management Studio (SSMS) or whatever tool you use to manage sql for Generate
6. Execute the code
7. Repeat the Paste - Execute steps if you have multiple instances of Generate
{% endhint %}
