---
description: >-
  The CIID Data Integration Toolkit: Step 4 - Install Generate, create and
  perform extract, transform, and load (ETL) procedures
---

# Step 4: Install Generate, create and perform extract, transform, and load (ETL) procedures

In Step 4, the project team will integrate the data identified and aligned in previous steps by extracting the data from the source systems, transforming it from SEA defined elements into the Common Education Data Standards (CEDS) elements, and loading the data into CEDS database structures after installing the Generate software. They will also validate the procedures and resulting data by matching it with data prepared through the SEA’s legacy process. Upon completing Step 4, the project team will have installed Generate, completed the ETL, and validated the data so it is ready for E&#x44;_&#x46;acts_ reporting.

Step 4 involves creating the ETL code and executing the movement of data from source systems into the CEDS data structures.

<figure><img src="../../.gitbook/assets/Screenshot 2025-12-15 145735.png" alt=""><figcaption></figcaption></figure>

### Process and Timing

The tasks in Step 4 include installing Generate, building the ETLs, and reviewing data quality after the data are transformed and migrated into Generate. Planning for the location and installation of Generate will have been begun in Step 1.2.2 Document Data System Architecture.\
The effort involved in building ETLs and reviewing data depends on how many EDFacts files are in scope for this project and the availability of ETL developer resources. As the team gains familiarity with the process and related documents, the step will become less burdensome.

For each ETL checklist, allow a few weeks to build the ETL–depending on how much time each team member can dedicate to this work or if you are receiving intensive technical assistance from CIID. ETL developers who are familiar with the CEDS physical data structure will also improve the speed at which the ETL is developed.

The process in Step 4, except for installing Generate, will be repeated for each ETL in scope of the SEA’s project.

### Task 4.1: Install the Generate software

The Generate tool consists of two main technical components - a Structured Query Language (SQL) database and a web application. The Generate installation package includes the full Common Education Data Standards (CEDS) data structure although the Generate application uses only a portion of CEDS necessary for EDFacts reporting. CEDS includes a broad scope of over 1,700 data elements spanning much of the P-20W spectrum (pre-kindergarten through workforce education) and provides a context for understanding the standards’ interrelationships and practical utility. While this toolkit was developed to support work on IDEA EDFacts files, SEAs can use Generate to produce any EDFacts files by repeating the steps in this toolkit for each additional data domain. In addition to supporting the existing federal reporting requirements, Generate supports the analysis and comparison of aggregate statistics. A full list of EDFacts file specifications in Generate are available on the EDFacts Communities website.

The Generate web application uses the data in the CEDS Data Warehouse and Reports tables to create EDFacts and related reports. Generate also contains Toggle, an important administrative feature that documents and inputs meta-data needed for Generate, including, for example, whether the SEA uses Developmental Delay as a disability category and for what ages. Instructions on the full functionality of Toggle are in the Generate User Guide.

**Resources**

[<mark style="color:$primary;">Generate User Guide</mark>](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/user-guide/getting-started)

[<mark style="color:$primary;">Generate Installation and Configuration Guide</mark>](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/installation)

#### Activity 4.1.1 Ensure proper code and database management procedures are in place

Most information technology (IT) departments have documented or standard procedures and server\
environments for ensuring code management and protecting data according to standard IT practices. The project team should consult with IT management to how the following technical standards will be addressed:

* Generate and the underlying CEDS data warehouse are installed in at least two environments: a staging/ test/development environment that is not intended for data use but will be used by IT staff for testing, and a production or main environment that will be used for reporting.
* Database back-ups and recovery procedures are documented and completed on a regular basis. The back-up copies of the databases may be needed if a server crashes or unwanted changes are applied to the system. This proactive approach can save staff time in rebuilding the system should an adverse event occur.
* A source control management (SCM) system such as Team Foundation Server (Microsoft TFS), Bitbucket, or GitHub or alternative approach is adopted. If an SCM is available, set up a repository for tracking SEA specific code that is used to move the data from SEA system(s) to the CEDS SQL tables. For this project, document the appropriate details (repository name, location, list of files tracked, etc.) and ensure the project team can access this information. While not required for use of Generate, an SCM is highly recommended for maintaining code over time, avoiding version control issues, and recovering code in case of emergency.

#### Activity 4.1.2 Install Generate

Download and review the latest Generate Installation and Configuration Guide. Send the guide to database administrators (DBAs) and other technical staff to review. The project team should confirm the date and server locations where the SQL database and web application will be installed. The technical staff will use the instructions for installing the SQL database and web application in the Generate Installation and Configuration Guide.

**Resources**

[<mark style="color:$primary;">Generate Installation and Configuration Guide</mark>](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/installation)

### Task 4.2: Write ETL code, populate and validate data in Generate

During this task, an ETL Developer will use the completed ETL checklist (Activity 3.1.1) for the selected data set and write the code to move and transform the data from the SEA’s source system into the CEDS structured tables in Generate. Once the code is written, and data is successfully moved, the ETL Developer and SEA subject matter experts will check the data quality and validate that the data is accurate. When data quality issues are found, the ETL Developer will go back and modify the ETL code to correct the issue until the data are deemed accurate. Errors found in the legacy reporting process or files should be documented for use by the ETL developer and SME during Activity: 4.2.3 Compare Generate results with legacy EDFacts data and resolve data quality issues.

#### Activity 4.2.1 Write ETL code and complete Source System Reference Data Mapping

SEA-specific SQL code must be written to move the data from the identified SEA source systems into the Staging Tables. All Generate data migrations are accomplished by running SQL Server Stored\
Procedures, which perform the ETL. They can be run either from the Generate Web-based application’s “Data Store” or directly through SQL Server. The ETL Developer(s) should approach this work by creating a single stored procedure for each data domain (such as Child Count, Discipline, Exiting, etc.) that migrates data for that domain into the staging tables. Reference the ETL checklist for that domain to get a list of the tables/ fields that need to be populated to create each ETL.

{% hint style="success" %}
If a data migration is run, and no entries are available in the SSRD table for the most current school year, the prior school year’s data will automatically populate the current year’s table. This table should be reviewed every year!
{% endhint %}

The Generate SQL table Staging.SourceSystemReferenceData (SSRD) must be updated with the complete set of values for all categorical fields for each school year. This process is called the Source System Reference Data Mapping and should be completed by an ETL developer. The information for this table comes from the ETL checklist and is used in the data migration stage to determine how source system option set values correspond to CEDS option set values. The Generate Implementation Guide contains the step-by-step instructions for completing this process.

**Resources**

[<mark style="color:$primary;">Generate Migration Guide</mark>](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/migration)

#### Activity 4.2.2 Migrate data

Migrations move data from one database to another and are run independently. Plan to run the data\
migration from the CEDS Warehouse into Generate according to a schedule that corresponds to the EDFacts file submission due dates and ensures source database(s) and data are available. To protect the integrity and security of production data, all tasks performed during an ETL process/data migration should be done in the test or development environment first to eliminate errors or bugs that could have a negative impact on production data. Confirm with the IT department that no database maintenance is being performed or planned during the data migration.

The **Generate User Guide** provides instructions for assigning access to individuals on the project team who are responsible for executing the data migrations through the Generate website. The Generate User Guide also has detailed instructions for how to use the Generate website to execute the stored procedures in each segment of the data migration.

Once the data migration is complete, confirm that the process worked as expected. Generate contains validation tools to assist ETL developers in verifying that data have successfully migrated across the Generate data layers. Errors and issues captured in the first stages of data migration are logged in the Staging. ValidationErrors table. The logs can be explored from the SQL Server database. ETL Developers should review the table and communicate any questions about the data with the project team. ETL checklists may need to be modified based on the results of the data migration through discussions between subject matter experts (SMEs) and ETL Developers. SMEs should make any changes to the ETL checklists and follow the governance process for the project team to re-finalize the document. The team will repeat the steps in the data migration activity for\
each EDFacts data domain each year.

**Resources**

[<mark style="color:$primary;">Generate User Guide</mark>](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/user-guide/getting-started)

#### Activity: 4.2.3 Compare Generate results with legacy EDFacts data and resolve data quality issues

During the matching process, an ETL developer will pre-load previously reported E&#x44;_&#x46;acts_ data into tables on the Generate test/development server. The ETL developer will then run the data migrations in Generate on the same test/development server for the same school year as the previously reported E&#x44;_&#x46;acts_ data. They will complete this activity during the project phase to validate the ETL code. As a best practice, this activity should be performed once for each E&#x44;_&#x46;acts_ data domain during the project, but does not need to be repeated annually.

Once the data are available in the Generate reports, the ETL developer can identify any variances in the aggregate counts between the Generate report tables and the pre-loaded, previously reported E&#x44;_&#x46;acts_ data. The ETL developer will investigate possible root causes for any variances and identify individual student records that comprise the variances to look for patterns that could be affecting data quality. SMEs can also use the **CIID Data Review Checklist** to ensure the original files and Generate-produced E&#x44;_&#x46;acts_ files meet basic data quality standards. This tool should be every time an E&#x44;_&#x46;acts_ file is produced from Generate to ensure the minimum data quality standards are addressed.

All data quality results should be shared with the project team who will then meet to review the results and identify solutions or possible next actions. Often, ETL code needs to be adjusted, and any changes that affect the ETL checklist should be documented in the Change Log-ETL worksheet that is part of each ETL checklist. The changes should be run through the established governance process for sign-off. This data quality review process will repeat until the report values are accepted by SMEs.

Once the ETL developers receive final sign-off of approval from the SMEs and according to any exiting data governance processes for your SEA, the ETL code is considered final for that school year. The code can then be moved to the production environment and properly saved in that location. Be sure to store the finalized ETL Checklist in the appropriate location and reconfirm the staff assigned to maintain the document. The completed ETL is now ready for use to produce the future E&#x44;_&#x46;acts_ file(s) at the start of the next reporting cycle!

**Resources**

{% file src="../../.gitbook/assets/CIID Data Review Checklist.xlsx" %}

### Task 4.3: After Action Review

An after-action review is an assessment of the project team’s performance on one set of ETL development and file submission. It will support organizational learning and improvement. This task is composed of an assessment of the project or a component of the project and a meeting to discuss the results of the assessment. Suggestions for future improvements in the processes and documentation are recorded, and the project team will adjust future ETL development and file reviews based on this feedback.

#### Activity 4.3.1: Conduct after-action meeting

The project team will meet to discuss their responses to several simple questions to assess the process used for the Generate project. An after-action meeting should occur at the completion of each successful E&#x44;_&#x46;acts_ report that is validated and then repeated for each data domain along the way or done only once at the completion of all E&#x44;_&#x46;acts_ reports or data domains. Each person on the project team should take turns responding to the afteraction questions in the After Action Review Agenda. One person in the meeting should record the responses. After all project team members have provided their feedback to each question, the group will discuss ways to modify the process.

#### Activity 4.3.2: Evaluate action and apply lessons learned for future projects

Following the after-action meeting, the project lead will consolidate the resulting after-action ideas. The project lead should review the project documentation for opportunities to modify future processes or record changes to the project plan in response to suggested ideas. The complete list of ideas/results from the after-action meeting should be available to all project team members to consult during the next phase of the project and remind the team of any modifications. At each subsequent after-action meeting, the list of prior after-action ideas should be reviewed, and the project team should decide if the change worked, didn’t work, should be continued, or should be discarded. The project lead or notetaker will update the after-action meeting notes and project plan and save them in a location where all project team members can reference them.

**Resources**

{% file src="../../.gitbook/assets/After Action Meeting Agenda.docx" %}
