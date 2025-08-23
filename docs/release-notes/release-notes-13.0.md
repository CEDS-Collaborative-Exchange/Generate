---
description: This document describes the technical enhancements to Generate version 13.0.
icon: sparkles
cover: ../.gitbook/assets/GenerateBanner13_0 1.avif
coverY: 0
---

# Release Notes 13.0

Release Overview

Generate version 13.0 focuses on New Fact Type pages, Debugging the Report migration, and Analysis of Generate Stored Procedures.&#x20;

{% hint style="success" %}
An enhancement was added to Generate allowing users to drill down into EDFacts reports for detailed student data within the category sets. The Student Details report includes the following information:

* Student IDs
* Category name(s)
* Permitted value(s)
* Count: Represents the number of times a student was involved in a specific event.

Note that the report count in the UI may differ from the total number of students in the student detail window. The student detail window shows each student with their appropriate permitted values once and the count column shows how many times that student was counted in the aggregated value stored in the report table.

For example, using 007 as an example, the count in the student details window reflects the number of times that student had a disciplinary removal during a school year. The student appears once in the student details window with a count of 3. The aggregated count in the report table would total the count column for that set of category values so the value in the report table would not match the number of students in the student details window, but rather than number of removals for that set of students.&#x20;
{% endhint %}

### Summary of Changes

#### IDEA Reports

* **Existing (009)** – Validated the logic that is being used to determine the students to include based on the file specification language.

#### Non-IDEA Reports

* **Discipline (163)**
  * Corrected an issue that was preventing the Gun Free Status data from migrating at the LEA level
* **Neglected or Delinquent (119, 127, 218, 219, 220, 221)**&#x20;
  * We redesigned the Neglected or Delinquent dimension table, rds.DimNorDStatuses, to include all the fields required by this group of file specifications. We also completed the migration code for this Fact Type so it is now ready for states to pilot these files and complete the testing/validation.

**User Interface Changes**

* **Student Details on Report page -** Added the ability to click on a student count within the category set data to display the students from the debug table that make up that count.
* **Corrected the pagination in the Reports pages -** When sorting the results at any report level and using the SEA/LEA/School Name or Identifier, the paging forward was losing the appropriate sequencing. That issue has been corrected.

**General Changes**

* **Migrations** – Added the population of zero counts directly into the Report table when the migration is run.  This improves visibility into the counts that will be used when creating the submission file and makes the full validation of the submission file much easier since no additional processes need to be executed to produce those counts.
* **Generate utilities** – Updated the Create Snapshot utility to account for the leading 'c' being removed from all file specification references.​
* **UI** – Worked with Maine to identify accessibility issues in the Generate UI and address any deficiencies found.  Examples of the kinds of updates include Focus and Tabbing, Keyboard Access, Text and Non-Text contrast among others.​

### Generate Documentation

* New Fact Type pages​
* Debugging the Report migration​
* Analysis of Generate Stored Procedures​
* 13.0 Release Notes

#### Generate 13.0 Release Tickets:

Tickets are available in the CEDS-Collaborative-Exchange.&#x20;

[**Click here** ](https://github.com/CEDS-Collaborative-Exchange/Generate/issues?q=is%3Aissue%20state%3Aopen%20label%3Av13.0)**to review the Generate 13.0 Release Tickets**

### Compatible Systems

Generate was tested on the following operating systems and browsers:

* Windows 10 Pro
* Google Chrome, Version 68 0.3440.106 (Official Build) (64-bit) and Firefox Quantum 61.01 (64 bit)

***

### Generate Office Hour

{% embed url="https://www.youtube.com/watch?v=dBf3k7_sMxc" %}
