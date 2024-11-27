---
description: >-
  The following information covers frequently asked questions around the use of
  Generate. For questions not covered in this document, please send an inquiry
  email to CIIDTA@AEMcorp.com.
hidden: true
---

# FAQ

## User Accounts <a href="#toc113439078" id="toc113439078"></a>

<details>

<summary>❓ <strong>How do I get a user account?</strong></summary>

Assigning users to an account is done by each state and implemented through the agency’s Active Directory Services. Contact the office that typically assigns access to other software your agency uses.

</details>

<details>

<summary>🆘 <strong>I clicked Log In and nothing happened.</strong></summary>

Try entering your username and password again. If you enter the wrong combination, a message will pop up at the top center of the page saying the login information was invalid. If you feel you are entering the correct credentials, you should contact your System Administrator for help.

</details>

<details>

<summary>🆘 <strong>I clicked on View ED</strong><em><strong>Facts</strong></em><strong> Submission Reports link, and nothing happened.</strong></summary>

Make sure you are logged in to Generate. Only users that are logged in can run reports.

</details>

<details>

<summary>❓ <strong>What types of user roles are in Generate?</strong></summary>

There are two types of users in Generate: _Reviewer_ and _Administrator_. Check out our section on [User Roles](getting-started/user-roles-and-logging-in.md) to learn more.

</details>

<details>

<summary>❓ <strong>What is the difference between a Generate Reviewer and a Generate Administrator?</strong></summary>

**Generate **_**Reviewers**_ are typically program personnel such as ED_Facts_ Coordinators, Data Managers, Data Stewards, or other staff responsible for the data and for running and reviewing reports or confirming record counts.&#x20;

**Generate **_**Administrators**_ have access to the Generate Data Store which is not accessible by Reviewers. This role is typically assigned to technical staff with a knowledge of the state’s source systems and Extract, Transform, and Load (ETL) processes. For example, the Administrator role might be assigned to a Database Administrator, or to someone responsible for processing and submitting the ED_Facts_ files through the ED_Facts_ Submission System (ESS). Anyone with the applicable knowledge and skills can be assigned to this role.

</details>

<details>

<summary>❓ <strong>Can state staff assigned to the Reviewer user role create ED</strong><em><strong>Facts</strong></em><strong> submission files?</strong></summary>

**Yes**. Staff assigned to either user role, _Reviewer_ or _Administrator_, can produce submission files.

</details>

## Submission Files <a href="#toc113439079" id="toc113439079"></a>

<details>

<summary>❓ <strong>Can you create the ED</strong><em><strong>Facts</strong></em><strong> submission reports multiple times?</strong></summary>

**Yes**. You can run the reports as many times as needed. Keep in mind, migrations overwrite existing data in the database so depending on the timing between the last time the migration was run, and when the file was produced, the submission results may be different.

</details>

<details>

<summary>❓ <strong>Can the ED</strong><em><strong>Facts</strong></em><strong> submission files be submitted to the EDEN Submission System (ESS) from Generate?</strong></summary>

**No**. You need to save the files on your computer and submit them as you normally would.

</details>

<details>

<summary>🆘 <strong>Why isn’t XML showing up as a submission file type?</strong></summary>

Submission file types can be different depending on the year selected. Beginning in 2016-17, ESS stopped accepting the .XML file type. Beginning with 2016-17 forward, Generate does not display that file type as an option. For years prior to 2016-17, the .XML file type is displayed as an option.

</details>

<details>

<summary>❓ <strong>Why does Generate exclude counts for Homebound/Hospital (HH) and Parentally Placed in Private Schools (PPPS) for FS002 at the School level? Before implementing Generate, we were able to submit these records without receiving submission or validation errors.</strong></summary>

The file specification for FS002 excludes these counts from the school level submission. There are no submission or validation errors built into the EDFacts Submission System for these two values. Since Generate is programmed to follow the business rules within each file specification, HH and PPPS records will be excluded from files created through Generate.

</details>

## Reports <a href="#toc113439080" id="toc113439080"></a>

<details>

<summary>🤔 <strong>What is the difference between the </strong><em><strong>Data Population Summary Report</strong></em><strong> and other reports?</strong></summary>

The _Data Population Summary Report_ is a high level, comprehensive count of data in the Staging Tables. The data have not been aggregated for reporting. This summary allows you to review the data for outliers or other anomalies before you produce the actual reports or file submissions.

</details>

<details>

<summary>🆘 <strong>What should I do if the counts are wrong in the Data Population Summary Report?</strong></summary>

First, contact the _Generate Administrator_. They can verify whether the ETL process is working as expected. Then, check with the person responsible for the data (e.g., the ED_Facts_ Coordinator, Data Manager, Data Steward, etc.). If the ETL is working, it is possible the data in the SLDS or in the source system itself is the cause. In that case, follow the normal procedure at your agency for troubleshooting student data. You can also contact [ciidta@aemcorp.com](mailto:ciidta@aemcorp.com) for assistance.

</details>

<details>

<summary>🆘 <strong>What should I do if the counts are wrong in the ED</strong><em><strong>Facts</strong></em><strong> or SPP/APR reports?</strong></summary>

If you think the counts are wrong, first check the [Toggle](settings/toggle.md) to make sure it was set up accurately for the report you are producing. If the Toggle is right, contact your Generate Administrator to confirm there isn’t an issue with the ETL. If the ETL is working, check that the data is correct in the SLDS and/or the source system. If the data is not correct in the source, the best practice is to trace it back to the problem and fix it. That ensures the data you are submitting to ESS is accurate and will prevent the issue from appearing again in Generate. You can also contact [ciidta@aemcorp.com](mailto:ciidta@aemcorp.com) for assistance.

</details>

<details>

<summary>🤔 <strong>Can reports be produced while the Migration is running?</strong></summary>

**No**. The user will see a message that indicates the migration must be run prior to creating any reports and all reports will be grayed out. The status on the data migration must be updated to “completed successfully” for the reports to display. Contact the _Generate Administrator_ for the status of the migration process.

</details>

<details>

<summary>🤔 <strong>What is the difference between the State Designed Reports and the ED</strong><em><strong>Facts</strong></em><strong> and SPP/APR Reports?</strong></summary>

To avoid confusion, these are maintained separately in Generate. State Defined Reports were designed by state education agency stakeholders and are not reportable to ED, while ED_Facts_ reports, and SPP/APR reports are reportable to ED. The State Designed Reports are available in the Reports Library.

</details>

<details>

<summary>❓ <strong>If I change the view in the Reports Library will it be retained, or will I have to change it every time?</strong></summary>

The Reports Library view is customized for the individual user. The layout selected will remain as is until the user changes it.

</details>

<details>

<summary>❓ <strong>Why don’t I see the </strong><em><strong>EDFacts</strong></em><strong> or SPP/APR reports in the Reports Library?</strong></summary>

ED_Facts_ reports, SPP/APR reports, and the reports in the Reports Library (also called State Designed Reports) are different types of reports. To avoid confusion, they are maintained separately in Generate.

</details>

## General <a href="#toc113439081" id="toc113439081"></a>

<details>

<summary>☎️<strong>Who do we contact if I have a question about Generate that we are unable to answer?</strong></summary>

If the _Generate Reviewer_ and _Administrator_ cannot answer the question, submit an email to [ciidta@aemcorp.com](mailto:ciidta@aemcorp.com). A shortcut to the CIIDTA email account is also available from the Menu bar located at the top of every page in Generate. From the menu bar, click on _Resources > CIID Support_.

</details>

<details>

<summary>❓ <strong>Can I access the CEDS Connections from Generate?</strong></summary>

**Yes**. You can access CEDS Connections for every report in Generate. The link to Connections is located below each report at the bottom left of the page.

</details>

<details>

<summary>❓ <strong>Can I access the ED</strong><em><strong>Facts</strong></em><strong> File Specification page from Generate?</strong></summary>

**Yes**. At the bottom left side of the page for every ED_Facts_ report there is a link to ED_Facts_ File Specification website.

</details>

<details>

<summary>❓<strong>Can I access the OSEP SPP/APR Resources page from Generate?</strong></summary>

**Yes**. At the bottom left side of the page for every SPP/APR report there is a link to the OSEP SPP/APR Resources page.

</details>
