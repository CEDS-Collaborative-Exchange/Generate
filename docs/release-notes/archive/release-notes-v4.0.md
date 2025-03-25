---
description: Generate Release Notes Version 4.0
---

# Release Notes 4.0

### Introduction <a href="#toc_250007" id="toc_250007"></a>

The purpose of this document is to communicate the technical updates made to Generate in version 4.0.

### General Release Summary <a href="#toc_250006" id="toc_250006"></a>

Generate Release version 4.0 includes updates to reports, the ETL (Data Store), and defect resolution.

### Updated Reports <a href="#toc_250005" id="toc_250005"></a>

The following E&#x44;_&#x46;acts_ reports were updated in this release.

| Report                                   | Approved Change                                                                                                                | Reference Number |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ---------------- |
| FS141                                    | Resolved issue where WDIS was not appearing in the submission file                                                             | CIID-4023        |
| FS175, FS178, FS179, FS185, FS188, FS189 | Resolved issue where the Assessment files weren’t filtering by Education Environment for the Disability Status category        | CIID-4055        |
| FS070, FS099, FS112                      | <p>Resolved issue where the UI was producing an</p><p>“unknown error has occurred” message</p>                                 | CIID-4451        |
| FS175, FS178, FS179, FS185, FS188, FS189 | <p>Resolved issue with the Assessment Reports where</p><p>the permitted value "WDIS" was missing from the submission files</p> | CIID-3848        |
| FS086                                    | Resolved issue where the system was not filtering students at the report level                                                 | CIID-4232        |
| FS212                                    | Implemented user Interface for new report                                                                                      | CIID-2822        |

### Defect Resolution <a href="#toc_250004" id="toc_250004"></a>

1. CIID-2654 FS029 Directory - Joins in Staging Organization Encapsulated Code don't filter out orgs by org type properly.
   * Filter issue has been resolved on the correct Organization type for the process being executed.
2. CIID-2742: FS185 Assess Participation Math & FS189 Assess Participation Science - Filter zero counts by grade and subject that are in app.toggleassessment.
   * Removed code that was eliminating zero counts. Added code which looks to Toggle to remove invalid grade levels for zero counts.
3. CIID-3848: Assessment Reports - the permitted value "WDIS" is missing from the submission files.
   * Resolved issue where permitted value WDIS was appearing on the UI report but was missing from the submission files.
4. CIID-3879: User Interface - Unable to Save changes (Add New Assessment or update) on Toggle Assessments screen.
   * Resolved issue where the system wasn’t saving changes made to the Assessment Toggle

screen.

1. CIID-3925: User Interface - Toggle unable to save changes.
   * Resolved issue in Toggle where the system was incorrectly indicating the changes made by the user were saved.
2. CIID-3958: FS194 Young Homeless Children Served (McKinney-Vento) - Missing 'UNDER3' permitted value on the UI screen. Also, permitted values are not displaying in SEA and LEA Submission File.
   * Resolved issue in App.CategorySets.Metadata.sql where permitted value 'UNDER3' was not showing on the UI screen and the permitted values were not displaying in the SEA and LEA Submission File.
3. CIID-3961: FS118 & FS194 Homeless - Migrate\_DimAges and Migrate\_StudentCounts Not Passing in the factTypeCode Properly.
   * Migrate\_StudentCounts and Migrate\_StudentDisciplines have been updated to use the Get\_Ages function instead of Migrate\_DimAges.Passing @factTypeCode into Migrate\_DimAges.
4. CIID-3964: FS118 Homeless - The grade code AGE3TO5NOTK should be 3TO5NOTK.
   * Resolved issue where Generate RDS function-'Get\_CountSQL' – was using the permitted value ‘AGE3TO5NOTK’ instead of ‘3TO5NOTK’.
5. CIID-3966: FS194 Homeless - RDS Migration - Age calculation sproc requires a specific date to calculate age correctly.
   * Migrate\_StudentCounts and Migrate\_StudentDisciplines were updated to use the Get\_Ages function instead of Migrate\_DimAges.Passing @factTypeCode into Migrate\_DimAges.
6. CIID-3986: FS118 Homeless Students Enrolled - calculating using Schools when the report is SEA/LEA only.
   * Resolved issue where Get\_CountSQL was using the school information in the join for an LEA level report. Also, modified the code specific to the joins for 118, and the code that gets the unique set of students, so that a student enrolled at two schools in the same LEA is counted only once.
7. CIID-4023: FS141 EL Enrolled - WDIS does not appear in the submission file.
   * The issue has been resolved and permitted value WDIS appears in the submission file.
8. CIID-4055: The Assessments (175,178,179,185,188,189) don't seem to be filtering by Education Environment for the Disability Status category.
   * Resolved issue where Disability Status category, “PPPS” was being excluded from the IDEA (with disabilities) count.
9. CIID-4404 RDS.DimK12Demographics is not being correctly populated.
   * Resolved issue where students indicated as LEP in staging were correctly represented in

IDS but showed as Missing in the RDS.

1. CIID-4417 Migrations - School Year field is empty after running the 3.8 update.
   * After running the update, the list of school years is displaying on the migration pages without having to refresh the page.
2. CIID-4418: Migrations - ODS, step 19 - the word Discipline is misspelled.
   * The typo in the word “Discipline” was corrected.
3. CIID-4433: FS029 (and others) Organization report table has columns defined as not null, affecting data migrations.
   * Column added and modified the scripts to set the 2 fields to nullable in the RDS.TableChanges script.
4. CIID-4437 FS009 (and others) Migrate\_StagingToIDS\_K12Enrollment - change inner join to left join on Grade Level.
   * Resolved issue where the inserts into dbo.K12StudentEnrollment had inner joins to the SSRD table and dbo.RefGradeLevel but they should have been LEFT joins because not all file specs require grade level to be loaded.
5. CIID-4438: FS118 - Change Homelessness value check in Get\_CountSQL.
   * Updated the WHERE clause in Get\_CountSQL to look for Yes, No and Missing values.
6. CIID-4440: FS029 (and other Organization file specs) - Migrate\_DimSeas, Migrate\_DimLeas, and Migrate\_DimK12Schools refine the telephone join.
   * If an organization had more than one telephone type loaded, the system returned more than one row which caused the Merge to fail. A qualifier was added to only pull Telephone Type = Main.
7. CIID-4441: FS005, 006, 007, 086, 088, 143, 144 - Migrate\_DimDisciplines join to @studentDates excludes previous year student records.
   * Updated join logic in Migrate\_DimDisciplines to be date-based so it pulls the appropriate record for the school year being migrated.
8. CIID-4471 Assessment files (175, 178, 179, 185, 188, 189) Permitted value = ECODIS is missing from the Submission File.
   * Resolved issue where permitted value ECODIS was appearing on the UI report but was missing from the submission files.
9. CIID-4476 FS143 - There is a condition in the Get\_CountSQL where clause that shouldn't be applied to FS143.
   * A line in the dynamic code for FS143 was excluding students that shouldn’t be excluded. Removed CAT\_IdeaInterimRemoval.IdeaInterimRemovalEdFactsCode <> Missing for this file spec.
10. CIID-4478 MERGE statement in Migrate\_DimK12Students fails for students with multiple enrollments with differing student details.
    * Resolved issue where MERGE statement that populates RDS.DimK12Students was failing.
11. CIID-4494: FS005, 007 - Fix the code that sums discipline to check for > 45 days in Get\_CountSQL
    * The summed Discipline records should only include the REMDW events when comparing

to the 45-day rule.

1. CIID-4484: Update RDS.Migrate\_StudentDisciplines.StoredProcedure to allow for all incident records to migrate.
2. Resolved issue where the final insert statement into RDS.FactK12StudentDisciplines in the RDS.Migrate\_StudentDisciplines had an unnecessary DISTINCT in the select statement.
3. CIID-4483 FS006 - Exclude REMDW Interim Removals from this count.
   * Updated Get\_CountSQL to include a rule to ensure that kids included in FS005 (Interim Removal to Alternative Education Setting for Drugs, Weapons, Serious Bodily Injury) were not being included in the count for FS006.
4. CIID-4495 Staging.Migrate\_StagingToIDS\_K12ProgramParticipation doesn't differentiate person IDs for students with multiple enrollments
   * Updated the code to also consider the organization identifier in case a student has multiple enrollments.
5. CIID-4496 Category Set Permitted Values have extra spaces at the end of the string.
   * Removed the extra space at the end of the string.

### Non-Development Tasks <a href="#toc_250003" id="toc_250003"></a>

1. CIID-4327: Redirect links within the Implementation Guide to the new Communities URL path.
   * Updated links.
2. CIID-4336 EDFacts 17.2 file specifications SY 2020-21 metadata rollover for Generate
   * Rolled over the metadata to SY 2020-21 for 054, 070, 086, 099, 112, 118, 121, 122, 144,

145, 163, 165, 170, 194, 195, 203.

1. CIID 4422 FS118 - Missing Metadata for SY2020-21
   * Resolved issue where Grade Level 3TO5NOTK was missing from the UI report.
2. CIID-4460: The word Discipline is misspelled in the ODS Migration (Execution Order 32).
   * Resolved issue with the typo in the word “Discipline.”

### Development Tasks <a href="#toc_250002" id="toc_250002"></a>

1. CIID-2505: FS202 School Quality or Student Success Indicator Status - New requirements for SY2018-19.
   * Added the following categories in the 2018-19 report: Category Set A1, Category Set B1, Category Set C1, and Category Set D1.
2. CIID-2543: FS050 - ELP Assessment SY 2019-20 Changes
   * Added category Assessment Administered (ELP) with permitted values for Category Sets A and B, e.g., REGELPASMNT, ALTELPASMNTALT and MISSING, to FS050, FS137, FS138

and FS139.

1. CIID-2823 FS212 Implement report user interface.
   * The User Interface was updated to include the new report (FS212).
2. CIID-3870: FS009 IDEA Exiting Spec Ed - Students who were in special education at the start of

the reporting period.

*
  * Updated Migrate\_SpecialEdStudentCounts procedure to ensure that:
    * A student who was in special education in another state prior to July 1, who exited, is reported on this report regardless of when they entered the state or the LEA; and
    * A student is reported on the Exit with the Age they had when they exited at the LEA level. At the SEA level, it would be the age of the last LEA exit.

1. CIID-4029 (a) Updated "Code" fields in RDS.dimK12Demographics to match CEDS values. Specifically:
   * EconomicDisadvantageStatusCode
   * HomelessnessStatusCode
   * MigrantStatusCode
   * HomelessUnaccompaniedYouthStatusCode

CIID-4029 (b) Split LEP status and Perkins LEP status into two separate fields.

1. CIID-4027: Removed tutorials from the Generate Resources menu.
2. CIID-4076: Corrected FS029 Directory checklist element "National School Lunch Program Status" to map to FS129.
3. CIID-3920: Document ETL checklist for Directory Lite.
   * Checklist includes IDEA elements only.
4. CIID-4232: C086 Not filtering students at the report level.
   * Updated Get\_CountSQL logic to filter disciplines so they only include firearm incidents.
5. CIID-4334: UI testing/RDS Migration for FS137: Update Category Set B.
   * Updated Category Set B by adding a new category “Assessment Administered (ELP)”
6. CIID-4413: FS029 - The mapping for SEA Contact Position Title is missing from the IDS migration.
   * Resolved mapping issue by mapping the SEAContact\_PositionTitle field in staging.StateDetail to dbo.StaffEmployment.
7. CIID-4431: IDS migration - correct descriptions in App.DataMigrationTasks to match the new naming standard.
   * The descriptions were corrected in the App.DataMigrationTasks table.

### Enhancements <a href="#toc_250001" id="toc_250001"></a>

1. CIID-2601: FS009 IDEA Exiting Special Education - State Designed Reports - Exit from Special Education Not Counting Distinct Students.
   * Updated Create\_ReportData by including "Graduated with an Alternate Diploma" with the exit codes in the category set.
2. CIID-3841: FS029 Directory & FS039 Grades Offered - Update \[RDS]. \[Migrate\_DimDates\_Organizations] to better handle multiple operational statuses.
   * Updated references in the following line of code from OperationalStatusEffectiveDate to RecordStartDate and EndDates.
     * AND s.OperationalStatusEffectiveDate between DATEFROMPARTS(d.\[Year], @referencePeriodStartMonth, @referencePeriodStartDay)

### Compatible Systems <a href="#toc_250000" id="toc_250000"></a>

Generate was tested on the following operating systems and browsers:

* Windows 10 Pro
* Google Chrome, Version 68 0.3440.106 (Official Build) (64-bit), Firefox Quantum 61.01 (64 bit), and Internet Explorer 11, 1387,15063.0
