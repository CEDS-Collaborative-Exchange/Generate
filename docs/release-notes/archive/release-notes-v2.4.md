---
description: Generate Release Notes Version 2.4
---

# Release Notes v2.4

### Introduction <a href="#introduction" id="introduction"></a>

The purpose of this document is to communicate the major new features and changes in the release of Generate Version 2.4.

### About this Release <a href="#about-this-release" id="about-this-release"></a>

Release v2.4 contains the ED_Facts_ Submission Reports and files for the Charter Organizations.

### Compatible Systems <a href="#compatible-systems" id="compatible-systems"></a>

Generate was tested on the following operating systems and browsers:

1. Windows 10 Pro
2. Internet Explorer 11, Google Chrome, Version 68 0.3440.106 (Official Build) )64-bit), and Firefox Quantum 61.01 (64 bit)

### System Upgrades <a href="#system-upgrades" id="system-upgrades"></a>

1. If you are upgrading from an earlier installation, please use the following instructions.

Database Server

The database upgrade process was improved this release to avoid upgrade conflicts in the future. However, upgrading to Generate v2.4 requires states to restore their Generate databases using the database backup provided.

*
  * Copy the database backup found in the “DatabaseFiles” folder in the Generate 2.4 download to a location accessible to the SQL server.
  * Open the scripts named “RestoreDatabase.sql” in the “DatabaseFiles” folder.
  * Update the path in line 14 to point to the database backup above.
  * Update the database name in line 10.
  * Run the script.

Web Server

*
  *
    * In IIS, stop the Generate website.
    * Make a backup of the Generate website folder.
    * Delete all files within the Generate website folder, except for the “appSettings.json” file located in the “Config” directory.
    * Extract contents of “generate.web.zip” into a temporary directory.
    * Copy all files from the just extracted “generate.web” folder, except for the “appSettings.json” file located in the “Config” directory, into the website folder.

1. If you are installing Generate for the first time, go [here.](https://ciidta.grads360.org/%23program/generate)

### New Reports <a href="#new-reports" id="new-reports"></a>

**The following reports were added in this Release:**

ED_Facts_ Submission Reports

1. FS130 – ESEA Status
2. FS190 – Charter Authorizer Directory
3. FS196 – Management Organization Directory
4. FS197 – Crosswalk of Charter Schools to management Organizations
5. FS198 – Charter Contracts

### Updated Reports <a href="#updated-reports" id="updated-reports"></a>

The following reports were updated in this Release:

ED_Facts_ Submission Reports

NOTE: changes to these reports reflect updates to the File Specifications for [SY 2017-18](https://www2.ed.gov/about/inits/ed/edfacts/sy-17-18-nonxml.html)

1. FS070 – Special Education Teachers
2. FS009 – Children with Disabilities (IDEA) Existing Special Education

### Update Details <a href="#update-details" id="update-details"></a>

1. FS070 – Special Education Teachers
   1. Revised category name and permitted values for “Highly Qualified Status”
      1. Qualification Status (Special Education Teachers)
         * SPEDTCHFULCRT – Fully certified
         * SPEDTCHNFULCRT – Not fully certified
2. FS009 – Children with Disabilities (IDEA) Exiting Special Education
   1. Revised category name and permitted values for “Basis of Exit – LEP Status”
      1. English Learner Status (Both)
         * LEP – English learner
         * NLEP – Non-English learner
   2. Added permitted value
      1. GRADALTDPL: Graduated with an alternate diploma

### Known Issues and Limitations <a href="#known-issues-and-limitations" id="known-issues-and-limitations"></a>

### Issues/Limitations <a href="#issues-limitations" id="issues-limitations"></a>

1. Reports – ED_Facts_ Submission Reports
   1. Report titles for SY 2017-18 (all reports):
   2. Reports begin with “C” not “FS” for SEA, LEA and Schools, and all category sets. For example, C045 should display FS045.
   3. Format Error (all reports)
   4. Columns can’t be resized so permitted values aren’t displayed in full on some of the online reports
   5. In some screen sizes, the drop-downs on the report page overlap, making it unusable.
   6. Format Error: C178
      1. SY 2016-17, Category C, Level 1 - column header displays abbreviation rather than the full name
   7. C032: report isn’t filtered by Exit or Withdrawal Type
   8. C089: Permitted Value of “Home” is displayed as “Homeless” on the online reports
2. Settings - Toggle
   1. IDEA - EXITING Reference Period – error message “End date of reference period cannot be on or before the Start Date”
      1. The system should override the error message when the radio button is set to “Yes.” Currently, users must change the date fields regardless of whether radio button selection is Yes or No. Switching the radio button to "Yes" should override the error message about the date fields below it being the same (e.g., "End date of reference period cannot be on or before the Start Date.")
3. Settings - Data Store
   1. There isn’t a kill switch to cancel the Migration process. Kill switch is needed.
4. General:
   1. Link to ED_Facts_ File Specifications goes to SY 2015-16 File Specifications instead of the main File Specification page. The correct link is: [https://www2.ed.gov/about/inits/ed/edfacts/file-](https://www2.ed.gov/about/inits/ed/edfacts/file-specifications.html) [specifications.html](https://www2.ed.gov/about/inits/ed/edfacts/file-specifications.html)
