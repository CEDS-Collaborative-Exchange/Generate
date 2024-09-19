---
description: >-
  This documentation outlines the configuration steps required to enable the new
  Metadata Process in Generate using the EDFacts Metadata Repository (EMDR) API.
---

# Configuring Metadata Updates

The settings are adjusted in the `appsettings.json` file, which controls the Generate Web application for fetching and updating metadata.

***

### **Metadata Update Using Web Service API**

To configure metadata updates via the EMDR Web Service API, modify the following settings in the `appsettings.json` file:

1.  **useWSforFSMetaUpd**: Set this to `"true"` to use the web service for metadata updates. If the server does not have an internet connection, set this to `"false"` to avoid attempting a web service connection.

    ```json
    "useWSforFSMetaUpd": "true"
    ```
2.  **fsWSURL**: If the web service is being used for metadata updates, set this to the following URL:

    ```json
    "fsWSURL": "https://edfacts.ed.gov/generate/"
    ```

***

### **Metadata Update Using Files Stored on the Server**

If metadata updates are performed using files stored on the server, configure the following settings:

1.  **fsMetaFileLoc**: Set this to the directory path where the metadata file is stored.

    ```json
    "fsMetaFileLoc": "<Your Metadata File Location>"
    ```
2.  **fsMetaESSDetailFileName**: Specify the file name of the ESS metadata.

    ```json
    "fsMetaESSDetailFileName": "<Your ESS Metadata File Name>"
    ```
3.  **fsMetaCHRDetailFileName**: Specify the file name of the Charter metadata.

    ```json
    "fsMetaCHRDetailFileName": "<Your Charter Metadata File Name>"
    ```
4.  **fsMetaESSLayoutFileName**: Specify the file name for the ESS layout.

    ```json
    "fsMetaESSLayoutFileName": "<Your ESS Layout File Name>"
    ```
5.  **fsMetaCHRLayoutFileName**: Specify the file name for the Charter layout.

    ```json
    "fsMetaCHRLayoutFileName": "<Your Charter Layout File Name>"
    ```

***

### **Backup and Recovery**

To handle metadata update failures and ensure data integrity, configure backup and recovery settings:

1.  **bkfsMetaFileLoc**: Set this to the directory path where the backup metadata file is stored.

    ```json
    "bkfsMetaFileLoc": "<Your Backup File Location>"
    ```
2.  **reloadFromBackUp**: Set this to `"true"` to automatically reload metadata from the backup file if the primary metadata update process fails.

    ```json
    "reloadFromBackUp": "true"
    ```

### Refreshing Metadata

To refresh metadata directly from the Generate UI, follow these quick steps:

1. Navigate to the gear icon in the top-right corner of the screen.
2. Select "Metadata" from the dropdown menu.
3. Click on the **Refresh Metadata** button to initiate the update.

For more in-depth instructions, refer to the full metadata management guide.

{% content-ref url="../../user-guide/settings/metadata.md" %}
[metadata.md](../../user-guide/settings/metadata.md)
{% endcontent-ref %}
