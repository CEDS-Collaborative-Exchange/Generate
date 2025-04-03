# Metadata

The new Metadata feature in Generate 12.0 provides an option to refresh the metadata from the EDPass system directly within the user interface. This enhancement simplifies the process of updating file specification metadata by automating the retrieval and integration of the most current data from EDPass.

### Overview:

* By selecting this option, Generate will use an API to pull the latest file specification metadata from EDPass.
* This metadata includes changes such as file layouts, category sets, and permitted values that affect the structure and validation of E&#x44;_&#x46;acts_ submissions.

### Process:

1. **Navigate to gear icon and select Metadata from the dropdown.**

<figure><img src="../../.gitbook/assets/image (3).png" alt="" width="185"><figcaption></figcaption></figure>

2. **Single Click Operation:** Clicking the Metadata refresh button will initiate the process, and Generate will:
   * Retrieve the most current metadata file from EDPass.
   * Process the file and load the updated metadata into the relevant tables within the Generate environment.

<figure><img src="../../.gitbook/assets/image (2).png" alt=""><figcaption></figcaption></figure>

3. **Duration:** The process can take anywhere from 30 minutes to an hour, depending on system performance and the size of the metadata file.

{% hint style="info" %}
**Note:** While the metadata update is in progress, other Generate functionalities, including migrations, will be unavailable until the update is complete.
{% endhint %}

### Benefits:

* You can refresh metadata on demand at any point, ensuring you are working with the most up-to-date file specifications.
* This allows greater flexibility, especially during periods when file specification updates are critical to your work.
* File Specification Metadata Only: This process applies solely to the metadata related to E&#x44;_&#x46;acts_ file specifications provided by the Department of Education. It does not apply to state-specific metadata, such as state supplemental survey responses.

### Frequency of Metadata Updates:

* Metadata from EDPass: EDPass updates metadata in chunks based on the upcoming E&#x44;_&#x46;acts_ reporting windows. It is not updated daily, so there’s no need to run the refresh daily.
* Expected Timelines: Metadata changes are typically rolled out well in advance of submission deadlines, giving you ample time to refresh and validate your data with the latest specifications.

### Limitations During Metadata Refresh:

While the metadata update is in progress, you will not be able to run data migrations or other Generate processes until the update is complete. Plan your work around this downtime, especially during heavy data submission periods.
