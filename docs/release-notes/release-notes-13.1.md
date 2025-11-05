---
description: This document describes the technical enhancements to Generate version 13.1.
icon: sparkles
cover: ../.gitbook/assets/Generate 13.1 thumbnail.png
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
---

# Release Notes 13.1

Release Overview

Generate version 13.1 focuses on IDEA Reports, Non-IDEA Reports, User Interface, General Changes (Migrations, Generate utilities, ETL Documentation Templates).&#x20;

### Summary of Changes

#### IDEA Reports

* Assessments **(**&#x31;75, 178, 179, 185, 188, 18&#x39;**)**&#x20;
  * Removed an old version of the debug views that is no longer valid
  * Renamed the Source-to-Staging\_Assessment stored procedure to match the Fact Type name

#### Non-IDEA Reports

* Homeless **(**&#x31;18, 19&#x34;**)**
  * Updated the logic in Get\_CountSQL to correctly return the unduplicated counts required by the file spec for students with multiple enrollments.&#x20;
  * Added School Year as a join condition in the Staging-to-RDS migration to the view for DimHomelessnessStatuses
  * Added the Homeless Serviced Indicator to the Staging debug view
* **Neglected or Delinquent (**&#x31;19, 127, 218, 219, 220, 22&#x31;**)**&#x20;
  * Refined the migration code to improve performance.
* **School Performance Indicators (**&#x31;99, 200, 201, 202, 20&#x35;**)**&#x20;
  * Worked with Mississippi to add a new Fact Type (SchoolPerformanceIndicators) modified the infrastructure that supports the migration process for this group of files including:&#x20;
    * Stored procedures from Staging to DIM
    * Stored procedure from Staging to Fact
    * Views for Debugging
    * Views for the migration process
  * Report Migration still being developed/tested. Anticipated completion is Release 13.2

#### User Interface Changes

* **Student Details on Report page**&#x20;
  * Added scroll bars where necessary to see all the available columns.&#x20;
  * Addressed an issue with some reports and the Total of the Education Unit category set&#x20;
  * Added additional filtering to the Assessments popup to correctly segregate the Lower Grade and High School assessment results
* **Logout functionality**
  * Addressed an issue a few states were experiencing where either a manual logout or a timeout logout was creating a javascript error and not logging the user out.
* **User Accessibility**
  * Continued adding improvements to the User Interface
* **Corrected the pagination in the Reports pages**&#x20;
  * When sorting the results at any report level and using the SEA/LEA/School Name or Identifier, the paging forward was losing the appropriate sequencing. That issue has been corrected.

### General Changes

* **Migrations**&#x20;
  * Added an additional qualifier to the population of the #dimPeople temporary table that better handles dates that start prior to the default 7/1 date.
* **Generate utilities**&#x20;
  * Added a new utility, Utilities.View\_EDFactsReportMetadata, that provides 3 views into the Generate metadata that is used in the migrations, report population, and submission file creation.
  * Updated the Compare Submission Files utility to account for the leading 'c' being removed from all file specification references
* **ETL Documentation Templates**
  * Added the changes from this release into the appropriate templates.​

### Generate Documentation

* All Fact Type pages now available
* Added troubleshooting information for multiple processes, more available soon
* Added more information on Azure implementations of Generate​
* 13.1 Release Notes

#### Generate 13.1 Release Tickets:

Tickets are available in the CEDS-Collaborative-Exchange.&#x20;

[**Click here** ](https://github.com/CEDS-Collaborative-Exchange/Generate/issues?q=is%3Aissue%20state%3Aopen%20label%3Av13.1)**to review the Generate 13.1 Release Tickets**



***

### Generate Office Hour

{% embed url="https://youtu.be/leM-Y0peAmI" %}
