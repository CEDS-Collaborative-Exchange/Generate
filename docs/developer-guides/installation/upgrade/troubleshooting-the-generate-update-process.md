---
description: >-
  This document provides a high level overview of the Generate update process
  from the user interface (UI). It explains what happens on the back end and how
  to resolve issues if they occur.
---

# Troubleshooting the Generate Update Process

{% hint style="success" %}
The database should be backed up before updating the Generate application. If backups are scheduled, make sure the most recent backup is available before updating.
{% endhint %}

## **Update Steps, Potential Issues, and Troubleshooting**

The following information describes the steps to migrate data from the UI, potential issues that can be encountered, and how to troubleshoot them. &#x20;

**Step 1:** Select 'Update' from the gear icon (Settings).&#x20;

<figure><img src="../../../.gitbook/assets/Generate Update Menu Item Image.jpg" alt="Image 1"><figcaption></figcaption></figure>



* The state server tries to connect to the Generate production server that stores the updates.&#x20;
* The application checks the current version of Generate to determine which updates (if any) are applicable and available.&#x20;
* The update(s) are presented in the UI.&#x20;

<figure><img src="../../../.gitbook/assets/Generate Update Page Screenshot.jpg" alt=""><figcaption></figcaption></figure>

**Potential Issues:**&#x20;

1. No update(s) are available on the screen even though the state is not on the current version.&#x20;

<figure><img src="../../../.gitbook/assets/No Updates Available Image.jpg" alt=""><figcaption></figcaption></figure>

**Troubleshooting:**

| Cause                                                                                                                                                           | Resolution                                                                 |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| Cashed version of the browser page.                                                                                                                             | Clear the cache.                                                           |
| State server does not have external connectivity to Generate’s server.                                                                                          | Confirm that the state web server can connect to an external source.       |
| An update previously attempted did not complete and there are already files in the “/Updates” folder on the web application and/or the background application.  | Clear the folder(s) of everything except for the file “app\_offline.htm.”  |

**Step 2:** Click 'Download Next Update' on the appropriate update. NOTE: If the state’s version of Generate is more than one update behind, every update that has not yet been applied will display.&#x20;

<figure><img src="../../../.gitbook/assets/Generate Update Page Screenshot.jpg" alt=""><figcaption></figcaption></figure>

{% hint style="info" %}
**The updates must be run in order.**
{% endhint %}

* The files are downloaded into the  folder “/Updates” in the background application.&#x20;
* The files are then copied over from the background application to the same folder in the web application, i.e., “/Updates.”&#x20;

**Potential Issues:**&#x20;

1. When the page refreshes, the button doesn’t change to “Apply Update.”

**Troubleshooting:**

| Cause                                                                                                     | Resolution                                                                                                   |
| --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| There was a problem with the file download.                                                               | Check the logs for an error that references a count mismatch.                                                |
| The update files downloaded, but the copy from the background application to the web application failed.  | Ensure the service account user has full ddl permissions (read, write, update, and delete) to do this step.  |

**Step 3:** Once the download is complete, the button will change to “Apply Update.” . Click the “Update” button to perform the update.

<figure><img src="../../../.gitbook/assets/APPLY or DELETE Update.jpg" alt=""><figcaption></figcaption></figure>

* The old web files are backed up and put in the folder called ”/Updates/Backups.”&#x20;
* The new web files are copied into the folder above /Updates. &#x20;
* Both web and background “/Updates” folders are cleared of the downloaded files.&#x20;
* The database changes are applied.&#x20;
* The version numbers are updated to the new version.&#x20;

**Potential Issues:**&#x20;

a) The update fails on the update of the web application.

**Troubleshooting:**

| Cause                                                                  | Resolution                                                                                                                                 |
| ---------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| There was a problem with the file download.                            | Check the logs.                                                                                                                            |
| There was a problem backing up the old files or copying the new ones.  | Check the logs **AND** Verify the service account user has the appropriate permissions and access to those file locations on the server.   |

{% hint style="warning" %}
The update can be reset in the Generate application by removing everything from the “/Updates” folder for both web and background applications (except for the file “app\_offline.htm,”) and refreshing the page in the UI.
{% endhint %}

b) The update fails on the update of the database.

**Troubleshooting:**&#x20;

| Cause                                                               | Resolution                                                                                                                    |
| ------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| There was a problem with one of the scripts in the update package.  | Check the logs AND Contact Generate support (this issue is probably not something the state can resolve without assistance).  |

{% hint style="warning" %}
The update can be ‘reset’ in the Generate application by: (1) restoring the database using the backup; (2) removing everything from the “/Updates” folder for both the web and background applications (except for the file “app\_offline.htm”); and (3) refreshing the page in the UI.
{% endhint %}
