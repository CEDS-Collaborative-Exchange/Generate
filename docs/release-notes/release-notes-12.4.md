---
description: This document describes the technical enhancements to Generate version 12.4.
icon: sparkles
cover: ../.gitbook/assets/ReleaseNotesBanner.avif
coverY: 0
layout:
  cover:
    visible: true
    size: hero
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
---

# Release Notes 12.4

Release Overview

Generate version 12.4 focuses on EDPass submissions due **July 30, 2025**, specifically enhancing reporting and compatibility for child count files (002, 089), membership (052, 033), CCD schools (129) and staff FTE (059).&#x20;

### Required State Changes - Action Required​

{% hint style="warning" %}
**SchoolYear**

There were 5 tables in the Staging environment that didn't have the SchoolYear column. We added that column to simplify the migrations and make them all standard. The tables involved are:​

* Staging.PersonStatus​
* Staging.ProgramParticipationSpecialEducation​
* Staging.ProgramParticipationNorD​
* Staging.ProgramParticipationTitleI​
* Staging.ProgramParticipationTitleIII&#x20;



This will require every state that has an ETL migration that involves one of these tables to update that code to include the new column. It can be populated using the same method that you are currently using to populate SchoolYear in the other tables like Staging.K12Enrollment, Staging.K12PersonRace, etc...​\
​\
**There are 2 other changes to be aware of that MAY NOT require any action on your part:**

* Removed the 'c' from the file specification number in all tables, functions, stored procedures, and views​
* In the Staging-to-Fact migration stored procedures we added the population of a temp table named #dimPeople which will be used for the joins instead of joining directly to rds.DimPeople.
{% endhint %}

***

### Reports

The following E&#x44;_&#x46;acts_ reports were updated in this release.

#### IDEA Reports

* **Staff (070)** – The DimensionId in the metadata table App.FileColumns was incorrect, so the Qualification Status column was not populated in the LEA or SEA submission files

SPECIAL NOTE: This issue was identified and fixed by the community and then added to the Generate release. Thank you to Greg in Kansas for this contribution!

#### Non-IDEA Reports

* **Membership (033, 052)**
  * 033 - Added the ability to migrate the counts for only 1 data group or both​
  * Fixed the migration order from the UI (if both 033 and 052 are selected) so that 052 runs first
* **Neglected or Delinquent (119)**&#x20;
  * Added support for this file through the migration code into the Fact and Report tables
* **Directory (207)**&#x20;
  * Identified a column that needs to be added in Staging.OrganizationFederalFunding to support this file and created the OSC tickets to support that
* **Staff (067, 203)**
  * Added support for this file through the migration code into the Fact and Report tables

***

**General Changes**

* **Generate infrastructure** – Removed the preceding 'c' from the file specification numbers. This applies to parameters passed into functions and stored procedures as well as the data stored in tables.​
* **Generate infrastructure** – Updated the metadata table name from App.GenerateReport\_GenerateStagingTablesXREF to App.GenerateReport\_GenerateStagingXREF and began adding staging column information. This will allow us to connect a specific EDFacts report to the required staging tables and columns needed to support it.​
* **Generate infrastructure** – Cleaned up a few remaining stored procedure and view names that did not align with the CEDS element name or the Generate Fact Type name​
* **Migrations** – Added the population of a temp table from the RDS.DimPeople data to the Staging.Staging-to-FactK12(…) stored procedures. This will populate a single record per student and help address issues caused by segmented records for the same student in RDS.DimPeople ​
* **UI** – Refactored the middle-tier code to handle the dimensions better when creating submission files.​
* **ETL Documentation Templates** – Added the changes from this release into the appropriate templates.

### Generate Documentation

* Added a new navigation option to the left menu called: _Working With Generate Code_

SPECIAL NOTE: Thank you to Jason Young from DoubleLine for contributing this documentation!&#x20;

[https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/working-with-generate-code](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/working-with-generate-code)&#x20;

***

#### Generate 12.4 Release Tickets:

Tickets are available in the CEDS-Collaborative-Exchange.&#x20;

[**Click here** ](https://github.com/CEDS-Collaborative-Exchange/Generate/issues?q=is%3Aissue%20state%3Aopen%20label%3Av12.4)**to review the Generate 12.4 Release** [**Tickets**](https://github.com/CEDS-Collaborative-Exchange/Generate/issues?q=is%3Aissue%20state%3Aopen%20label%3Av12.4)

### Upgrade Procedure

No changes have been made to the Generate upgrade procedure for this release. Follow the standard Generate upgrade process to install version 12.4.

### Compatible Systems

Generate was tested on the following operating systems and browsers:

* Windows 10 Pro
* Google Chrome, Version 68 0.3440.106 (Official Build) (64-bit) and Firefox Quantum 61.01 (64 bit)

***

### Generate Office Hour

{% embed url="https://www.youtube.com/watch?v=SWB_7jmYonw" %}
