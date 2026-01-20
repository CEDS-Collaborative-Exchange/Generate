---
description: >-
  The CIID Data Integration Toolkit: Step 4 - Install Generate, create and
  perform extract, transform, and load (ETL) procedures
---

# Step 4: Install Generate, create and perform extract, transform, and load (ETL) procedures

In Step 4, the project team will integrate the data identified and aligned in previous steps by extracting the&#x20;data from the source systems, transforming it from SEA defined elements into the Common Education Data&#x20;Standards (CEDS) elements, and loading the data into CEDS database structures after installing the Generate&#x20;software. They will also validate the procedures and resulting data by matching it with data prepared through&#x20;the SEA’s legacy process. Upon completing Step 4, the project team will have installed Generate, completed the&#x20;ETL, and validated the data so it is ready for E&#x44;_&#x46;acts_ reporting.

Step 4 involves creating the ETL code and executing the movement of data from source systems into the CEDS&#x20;data structures.

<figure><img src="../../.gitbook/assets/Screenshot 2025-12-15 145735.png" alt=""><figcaption></figcaption></figure>

### Process and Timing

The tasks in Step 4 include installing Generate, building the ETLs, and reviewing data quality after the data are&#x20;transformed and migrated into Generate. Planning for the location and installation of Generate will have been&#x20;begun in Step 1.2.2 Document Data System Architecture.\
The effort involved in building ETLs and reviewing data depends on how many EDFacts files are in scope for this&#x20;project and the availability of ETL developer resources. As the team gains familiarity with the process and related&#x20;documents, the step will become less burdensome.

For each ETL checklist, allow a few weeks to build the ETL–depending on how much time each team member can dedicate to this work or if you are receiving intensive technical assistance from CIID. ETL developers who are&#x20;familiar with the CEDS physical data structure will also improve the speed at which the ETL is developed.\
The process in Step 4, except for installing Generate, will be repeated for each ETL in scope of the SEA’s project.

### Task 4.1: Install the Generate software

The Generate tool consists of two main technical components - a Structured Query Language (SQL) database&#x20;and a web application. The Generate installation package includes the full Common Education Data Standards&#x20;(CEDS) data structure although the Generate application uses only a portion of CEDS necessary for EDFacts&#x20;reporting. CEDS includes a broad scope of over 1,700 data elements spanning much of the P-20W spectrum&#x20;(pre-kindergarten through workforce education) and provides a context for understanding the standards’&#x20;interrelationships and practical utility. While this toolkit was developed to support work on IDEA EDFacts files,&#x20;SEAs can use Generate to produce any EDFacts files by repeating the steps in this toolkit for each additional data&#x20;domain. In addition to supporting the existing federal reporting requirements, Generate supports the analysis&#x20;and comparison of aggregate statistics. A full list of EDFacts file specifications in Generate are available on the&#x20;EDFacts Communities website.

The Generate web application uses the data in the CEDS Data Warehouse and Reports tables to create EDFacts&#x20;and related reports. Generate also contains Toggle, an important administrative feature that documents and&#x20;inputs meta-data needed for Generate, including, for example, whether the SEA uses Developmental Delay as&#x20;a disability category and for what ages. Instructions on the full functionality of Toggle are in the Generate User&#x20;Guide.

**Resources**&#x20;

[<mark style="color:$primary;">Generate User Guide</mark>](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/user-guide/getting-started)

[<mark style="color:$primary;">Generate Installation and Configuration Guide</mark>](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/installation)&#x20;

#### Activity 4.1.1 Ensure proper code and database management procedures are in place

Most information technology (IT) departments have documented or standard procedures and server\
environments for ensuring code management and protecting data according to standard IT practices. The&#x20;project team should consult with IT management to how the following technical standards will be addressed:

* Generate and the underlying CEDS data warehouse are installed in at least two environments: a staging/  test/development environment that is not intended for data use but will be used by IT staff for testing, and a  &#x20;production or main environment that will be used for reporting.
* Database back-ups and recovery procedures are documented and completed on a regular basis. The back-up  &#x20;copies of the databases may be needed if a server crashes or unwanted changes are applied to the system.  &#x20;This proactive approach can save staff time in rebuilding the system should an adverse event occur.
* A source control management (SCM) system such as Team Foundation Server (Microsoft TFS), Bitbucket, or  &#x20;GitHub or alternative approach is adopted. If an SCM is available, set up a repository for tracking SEA specific  &#x20;code that is used to move the data from SEA system(s) to the CEDS SQL tables. For this project, document  &#x20;the appropriate details (repository name, location, list of files tracked, etc.) and ensure the project team  &#x20;can access this information. While not required for use of Generate, an SCM is highly recommended for  &#x20;maintaining code over time, avoiding version control issues, and recovering code in case of emergency.

#### Activity 4.1.2 Install Generate&#x20;

Download and review the latest Generate Installation and Configuration Guide. Send the guide to database&#x20;administrators (DBAs) and other technical staff to review. The project team should confirm the date and&#x20;server locations where the SQL database and web application will be installed. The technical staff will use the&#x20;instructions for installing the SQL database and web application in the Generate Installation and Configuration&#x20;Guide.

**Resources**&#x20;

[<mark style="color:$primary;">Generate Installation and Configuration Guide</mark> ](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/installation)

### Task 4.2: Write ETL code, populate and validate data in Generate

During this task, an ETL Developer will use the completed ETL checklist (Activity 3.1.1) for the selected data&#x20;set and write the code to move and transform the data from the SEA’s source system into the CEDS structured&#x20;tables in Generate. Once the code is written, and data is successfully moved, the ETL Developer and SEA subject&#x20;matter experts will check the data quality and validate that the data is accurate. When data quality issues are&#x20;found, the ETL Developer will go back and modify the ETL code to correct the issue until the data are deemed&#x20;accurate. Errors found in the legacy reporting process or files should be documented for use by the ETL&#x20;developer and SME during Activity: 4.2.3 Compare Generate results with legacy EDFacts data and resolve data&#x20;quality issues.

#### Activity 4.2.1 Write ETL code and complete Source System Reference Data Mapping

SEA-specific SQL code must be written to move the data from the identified SEA source systems into the&#x20;Staging Tables. All Generate data migrations are&#x20;accomplished by running SQL Server Stored\
Procedures, which perform the ETL. They can be run&#x20;either from the Generate Web-based application’s&#x20;“Data Store” or directly through SQL Server. The ETL&#x20;Developer(s) should approach this work by creating a&#x20;single stored procedure for each data domain (such as&#x20;Child Count, Discipline, Exiting, etc.) that migrates data&#x20;for that domain into the staging tables. Reference the ETL checklist for that domain to get a list of the tables/&#x20;fields that need to be populated to create each ETL.

{% hint style="success" %}
If a data migration is run, and no entries are&#x20;available in the SSRD table for the most current&#x20;school year, the prior school year’s data will&#x20;automatically populate the current year’s table. This&#x20;table should be reviewed every year!
{% endhint %}

The Generate SQL table Staging.SourceSystemReferenceData (SSRD) must be updated with the complete set&#x20;of values for all categorical fields for each school year. This process is called the Source System Reference Data&#x20;Mapping and should be completed by an ETL developer. The information for this table comes from the ETL&#x20;checklist and is used in the data migration stage to determine how source system option set values correspond&#x20;to CEDS option set values. The Generate Implementation Guide contains the step-by-step instructions for&#x20;completing this process.

**Resources**&#x20;

[<mark style="color:$primary;">Generate Migration Guide</mark> ](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/migration)

#### Activity 4.2.2 Migrate data

Migrations move data from one database to another and are run independently. Plan to run the data\
migration from the CEDS Warehouse into Generate according to a schedule that corresponds to the EDFacts&#x20;file submission due dates and ensures source database(s) and data are available. To protect the integrity and&#x20;security of production data, all tasks performed during an ETL process/data migration should be done in the test&#x20;or development environment first to eliminate errors or bugs that could have a negative impact on production&#x20;data. Confirm with the IT department that no database maintenance is being performed or planned during the&#x20;data migration.

The **Generate User Guide** provides instructions for assigning access to individuals on the project team who are&#x20;responsible for executing the data migrations through the Generate website. The Generate User Guide also has&#x20;detailed instructions for how to use the Generate website to execute the stored procedures in each segment of&#x20;the data migration.

Once the data migration is complete, confirm that the process worked as expected. Generate contains&#x20;validation tools to assist ETL developers in verifying that data have successfully migrated across the Generate&#x20;data layers. Errors and issues captured in the first stages of data migration are logged in the Staging.&#x20;ValidationErrors table. The logs can be explored from the SQL Server database. ETL Developers should review&#x20;the table and communicate any questions about the data with the project team. ETL checklists may need to be&#x20;modified based on the results of the data migration through discussions between subject matter experts (SMEs)&#x20;and ETL Developers. SMEs should make any changes to the ETL checklists and follow the governance process&#x20;for the project team to re-finalize the document. The team will repeat the steps in the data migration activity for\
each EDFacts data domain each year.

**Resources**&#x20;

[<mark style="color:$primary;">Generate User Guide</mark> ](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/user-guide/getting-started)

#### Activity: 4.2.3 Compare Generate results with legacy EDFacts data and resolve data quality&#xD; issues

During the matching process, an ETL developer will pre-load previously reported E&#x44;_&#x46;acts_ data into tables on the&#x20;Generate test/development server. The ETL developer will then run the data migrations in Generate on the same&#x20;test/development server for the same school year as the previously reported E&#x44;_&#x46;acts_ data. They will complete&#x20;this activity during the project phase to validate the ETL code. As a best practice, this activity should be&#x20;performed once for each E&#x44;_&#x46;acts_ data domain during the project, but does not need to be repeated annually.&#x20;

Once the data are available in the Generate reports, the ETL developer can identify any variances in the&#x20;aggregate counts between the Generate report tables and the pre-loaded, previously reported E&#x44;_&#x46;acts_ data.&#x20;The ETL developer will investigate possible root causes for any variances and identify individual student records&#x20;that comprise the variances to look for patterns that could be affecting data quality. SMEs can also use the **CIID&#x20;Data Review Checklist** to ensure the original files and Generate-produced E&#x44;_&#x46;acts_ files meet basic data quality&#x20;standards. This tool should be every time an E&#x44;_&#x46;acts_ file is produced from Generate to ensure the minimum&#x20;data quality standards are addressed.

All data quality results should be shared with the project team who will then meet to review the results and identify solutions or possible next actions. Often, ETL code needs to be adjusted, and any changes that affect&#x20;the ETL checklist should be documented in the Change Log-ETL worksheet that is part of each ETL checklist.&#x20;The changes should be run through the established governance process for sign-off. This data quality review&#x20;process will repeat until the report values are accepted by SMEs.

Once the ETL developers receive final sign-off of approval from the SMEs and according to any exiting data&#x20;governance processes for your SEA, the ETL code is considered final for that school year. The code can then be&#x20;moved to the production environment and properly saved in that location. Be sure to store the finalized ETL&#x20;Checklist in the appropriate location and reconfirm the staff assigned to maintain the document. The completed&#x20;ETL is now ready for use to produce the future E&#x44;_&#x46;acts_ file(s) at the start of the next reporting cycle!

**Resources**&#x20;

[CIID Data Review Checklist](https://ciidta.communities.ed.gov/#communities/pdc/documents/21449)

### Task 4.3: After Action Review&#x20;

An after-action review is an assessment of the project team’s performance on one set of ETL development&#x20;and file submission. It will support organizational learning and improvement. This task is composed of an&#x20;assessment of the project or a component of the project and a meeting to discuss the results of the assessment.&#x20;Suggestions for future improvements in the processes and documentation are recorded, and the project team&#x20;will adjust future ETL development and file reviews based on this feedback.

#### Activity 4.3.1: Conduct after-action meeting

The project team will meet to discuss their responses to several simple questions to assess the process used for&#x20;the Generate project. An after-action meeting should occur at the completion of each successful E&#x44;_&#x46;acts_ report&#x20;that is validated and then repeated for each data domain along the way or done only once at the completion of&#x20;all E&#x44;_&#x46;acts_ reports or data domains. Each person on the project team should take turns responding to the afteraction&#x20;questions in the After Action Review Agenda. One person in the meeting should record the responses.&#x20;After all project team members have provided their feedback to each question, the group will discuss ways to&#x20;modify the process.

#### Activity 4.3.2: Evaluate action and apply lessons learned for future projects

Following the after-action meeting, the project lead will consolidate the resulting after-action ideas. The project&#x20;lead should review the project documentation for opportunities to modify future processes or record changes&#x20;to the project plan in response to suggested ideas. The complete list of ideas/results from the after-action&#x20;meeting should be available to all project team members to consult during the next phase of the project and&#x20;remind the team of any modifications. At each subsequent after-action meeting, the list of prior after-action&#x20;ideas should be reviewed, and the project team should decide if the change worked, didn’t work, should be&#x20;continued, or should be discarded. The project lead or notetaker will update the after-action meeting notes and&#x20;project plan and save them in a location where all project team members can reference them.

**Resources**&#x20;

[After Action Meeting Agenda](https://ciidta.communities.ed.gov/#communities/pdc/documents/21448)&#x20;
