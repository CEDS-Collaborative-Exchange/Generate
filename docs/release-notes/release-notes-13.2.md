---
description: This document describes the technical enhancements to Generate version 13.2.
icon: sparkles
cover: ../.gitbook/assets/GenerateBanner13_2.avif
coverY: 0
layout:
  width: default
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
  metadata:
    visible: true
  tags:
    visible: true
---

# Release Notes 13.2

Release Overview

Generate version 13.2 focuses on IDEA Reports, Non-IDEA Reports, User Interface, General Changes (CEDS, Migrations, File Sharing, and Documentation).&#x20;

### Summary of Changes

#### IDEA Reports

* Assessments (088, 143)&#x20;
  * Added additional filtering to correctly create the zero counts for the TOT category set

#### Non-IDEA Reports

* **Directory (029)**
  * Corrected issues with the metadata for file 029 that was preventing the Organization Level buttons from displaying in the UI and another that was preventing some columns from populating in the submission file
* **Membership (226)**
  * Corrected the new report migration code for file 226 to add zero counts where appropriate
* **Staff (067)**
  * Added a new column to Staging.K12StaffAssignment, TitleIIILanguageInstructionIndicator, and completed to the migration for file 067
* **Homeless (118)**
  * Refined the logic in Get\_CountSQL that removes duplicates from the SEA and LEA files for the TOT category set
* **Chronic Absenteeism (195)**
  * Refined the aggregation logic to exclude students not in Grades K-12 and Ungraded
* **High School Graduate Post Secondary Enrollment (160)**
  * Refined the migration code to improve performance
* **Discipline (086, 163)**
  * Modified the report logic for file 086 to aggregate by Incident Identifier and Student Identifier so no students are miscounted​
  * Corrected an issue for file 163 at the School level that was preventing the School Identifier from displaying in the UI
* **Title 1 (134, 222)**
  * Fixed the logic so the lower ages/grades are correctly aggregated into UNDER3 and 3TO5NOTK​
  * Corrected the new report migration code for file 222 to add zero counts where appropriate
* **Title III EL SY (045, 116)**
  * Completed the migration logic for files 045 and 116 through to the Reports
* **Title III EL October (141)**
  * Refined the aggregation logic to exclude Schools that are not reportable
* **Graduates/Completers (040)**
  * Completed the migration logic for file 040 through to the Reports

#### User Interface Changes

* Metadata
  * Corrected the issue preventing the 2026 school year from displaying in the dropdown
* **User Accessibility**
  * Corrected an issue with the navigation menu at high zoom levels​
  * Fixed homepage misalignment issue at the layout breaking point

### General Changes

* **CEDS**
  * Implemented CEDS v13 Data Warehouse changes
* **Migrations**&#x20;
  * Updated all Staging-to-Fact migrations to use DimPeople\_Current
    * Added the DimPeople\_Current table from CEDS V13
    * Reduces the number of student records down to 1 per student
    * Removes dates from the records and simplifies the join logic in Generate
    * Consistent ID values in Fact tables across Fact Types&#x20;
  * Updated all the report specific views used by the new report migration logic to filter on Reported Federally​
  * Cleaned up all the Fact table debug views to use the EdFacts column from the corresponding dimension where available and verified that all the views are consistent in that column use​
  * Cleaned up all the dimension views that were using a cross join against SourceSystemReferenceData to improve performance​
  * Corrected an issue in the migration for DimLeas and DimK12Schools that could result in State Name and State Abbreviation being NULL resulting in Report migration issues

### Generate Documentation / File Sharing

* File Sharing
  * Added a file sharing location (pictured right) in the Generate github for easy access to metadata files, hotfixes, and the standard install packages
* Documentation
  * Added a page under Installation to describe Generate security protocols​
  * Added documentation on the new Report migration process that will be incrementally phased in ​
  * Updated the installation instructions with the latest information on the appropriate connection strings​
  * Added a location to document any hotfixes that may be required for a specific release​
  * 13.2 Release Notes

#### Generate 13.2 Release Tickets:

Tickets are available in the CEDS-Collaborative-Exchange.&#x20;

[**Click here** ](https://github.com/CEDS-Collaborative-Exchange/Generate/issues?q=is%3Aissue%20state%3Aopen%20label%3Av13.1)**to review the Generate 13.2 Release Tickets**
