# Data Migration

### Accessing the Migration Page:

* After logging into the system, click on the gear icon.
* Navigate to Data Migration (previously referred to as Data Store).

<figure><img src="../../.gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>

* You are now on the Single Screen Migration page.

<figure><img src="../../.gitbook/assets/image (7).png" alt=""><figcaption></figcaption></figure>

#### Selecting Migration Options:

* First, select the Year for which you want to run the migration.

<figure><img src="../../.gitbook/assets/image (8).png" alt=""><figcaption></figcaption></figure>

* Then, choose the Fact Type (e.g., Child Count).

<figure><img src="../../.gitbook/assets/image (9).png" alt=""><figcaption></figcaption></figure>

* The list of available reports will filter based on the selected fact type.
  * For example, if Child Count is selected, the available ED_Facts_ reports might include 002 and 089, along with state-defined reports.

<figure><img src="../../.gitbook/assets/image (10).png" alt=""><figcaption></figcaption></figure>

#### Filtering Reports:

* You can filter the report list to show only ED_Facts_ reports or only state-defined reports, depending on your preference.

<figure><img src="../../.gitbook/assets/image (11).png" alt=""><figcaption></figcaption></figure>

#### Running the Migration:

* After selecting the report you want to run, click Migrate to Report Data Store.

<figure><img src="../../.gitbook/assets/image (12).png" alt=""><figcaption></figcaption></figure>

* This process will automatically execute all migration steps in the background:

<figure><img src="../../.gitbook/assets/image (13).png" alt=""><figcaption></figcaption></figure>

* Step 1: Move data from the source system to the staging environment.
* Step 2: Move data from staging into the fact and dimension tables.
* Step 3: Aggregate data and move it into the report tables.

***

### Viewing Migration Logs:

* The Data Migration Log tab shows live logs of the migration process.
* This log is automatically refreshed every few seconds to provide the latest updates.

### Staging Validation Results:

* The third tab on the page is for Staging Validation Results.
* It provides a summary of the validation results after data has been loaded into the staging environment.

#### Types of Validation Feedback:

* The staging validation provides feedback in three categories:
  * Warnings: Notifications of potential issues in the data that you should review.
  * Errors: Issues like missing key data points (e.g., students missing IDEA classification, race value, or disability type) that could affect the final report.
  * Critical Errors: Major issues such as an empty K12 enrollment table, which will prevent further migration processes from executing correctly.

#### Reviewing Validation Results:

* After the staging validation completes, the system displays the number of records that failed validation checks.
* For each failed check, you can access the Show Records SQL feature, which provides the SQL code needed to view the failing records in SQL Server Management Studio (SSMS).
* This allows you to investigate the data and make necessary corrections before proceeding further.

Although critical errors are flagged, the current version of Generate allows the migration process to continue as far as possible, even with critical issues. However, it is recommended to resolve these errors quickly to ensure data integrity.

### Stored Procedures for Migration:

* The system uses shell stored procedures (e.g., `source-to-staging-child-count`, `source-to-staging-discipline`) to manage the ETL (Extract, Transform, Load) process from your state systems to the staging environment.
  * If your organization already has custom ETL processes, you can embed your ETL code into these stored procedures.
  * Alternatively, the shell stored procedures can call your existing ETL processes or SSIS packages.
* If the stored procedures are left empty, the migration process will still run as normal but will skip the custom ETL step. In this case, you will need to manually load data into the staging environment.
