---
description: >-
  This document provides a description of the technical enhancements to Generate
  version 11.0 (v11) released in August 2023.
---

# Release Notes 11.0

{% hint style="info" %}
Please note: Generate moved from version 5.3 to version 11 in this release to align with the CEDS Data Warehouse.&#x20;
{% endhint %}

## Release Overview &#x20;

Generate version 11.0 is a significant update that leverages the updated CEDS Data Warehouse, better aligns the Generate Staging environment with the Data Warehouse, implements Staging-to-RDS for all migrations, and adds some additional tools to aid in the file migration process.  &#x20;

Some of the highlights of this release:

* [x] Expand the Data Warehouse Fact and Dimension tables to match the updated CEDS Data Warehouse v11. &#x20;
* [x] Align the column names between the Generate Staging and CEDS Data Warehouse environments for ease of use and consistency.&#x20;
* [x] Expand the handling of Disability Types.&#x20;
* [x] Update all data migrations to use the simplified Staging-to-RDS process.&#x20;
* [x] Add more visibility into the data migrations by making the Data Migrations Histories Log table viewable on the migration pages.&#x20;

#### State ETL changes:&#x20;

There are changes that will be required for existing Staging ETLs to work for v11 and they are detailed below.

1. The column names within the _**Staging environment**_ were modified to adhere to the CEDS naming standards, aligning them with those used in the CEDS Data Warehouse. This is the supporting spreadsheet that helps identify the mapping between previous column name and new column name in the tables that are affected.

{% file src="../../.gitbook/assets/Generate 11.0 staging field mapping.xlsx" %}
Excel version of the Generate 11.0 staging field map
{% endfile %}

2. These _**three**_ changes are documented in the spreadsheet, however, are called out here since they will impact each of the **Student** related tables in **Staging**.&#x20;
   1. The v5.3 column <mark style="color:blue;">`LEA_Identifier_State`</mark> will now map to <mark style="color:blue;">`LEAIdentifierSeaAccountability`</mark>
   2. The v5.3 column <mark style="color:blue;">`School_Identifier_State`</mark> will now map to <mark style="color:blue;">`SchooldentifierSea`</mark>
   3. The v5.3 column <mark style="color:blue;">`Student_Identifier_State`</mark> will now map to <mark style="color:blue;">`StudentIdentifierState`</mark>
3.  The _**Staging.PersonStatus**_ table was used to identify Special Education students by populating:

    1. <mark style="color:blue;">`IdeaIndicator`</mark>
    2. <mark style="color:blue;">`Idea_StatusStartDate`</mark>
    3. <mark style="color:blue;">`Idea_StatusEndDate`</mark>

    Those columns have been dropped from that table and a record will need to be loaded into:

    1. <mark style="color:blue;">`Staging.ProgramParticipationSpecialEducation`</mark> with <mark style="color:blue;">`IdeaIndicator`</mark>
    2. <mark style="color:blue;">`ProgramParticipationBeginDate`</mark>
    3. <mark style="color:blue;">`ProgramParticipationEndDate`</mark>

to identify the student as Special Education.

4. There is a new staging table and a new dimension table named _**IDEADisabilityTypes**_. In v5.3 there was a single field named <mark style="color:blue;">`PrimaryDisabilityType`</mark> in <mark style="color:blue;">`Staging.PersonStatus`</mark> . That field has been dropped. This new table allows the state to load every disability that applies to the student so all of them can be captured. So, if a student is identified with four disabilities, you should load four rows into the new table. There are two flags in the table, _**IsPrimaryDisability**_ and _**IsSecondaryDisability**_. For the purposes of ED_Facts_ reporting set the _**IsPrimaryDisability**_ flag for the row that should be reported for that student.&#x20;

### Generate Enhancements &#x20;

The following ED_Facts_ reports were updated in this release.&#x20;

#### Type of Impact:&#x20;

* **Data** – the changes will improve data quality and completeness.
* **Database** – changes to the Generate database structure.
* **Migration** – the changes impact a data migration process.
* **Performance** – the changes improve the performance of a data migration.
* **Reports** - changes that impact the Reports available in Generate.
* **Submission Files** – the changes may impact submission file(s)&#x20;
* **Source to Staging ETL** – the changes may require modifications to the SEA’s Source to Staging ETL&#x20;
* **User Interface** – the changes impact the Generate User Interface and/or migration process.

{% tabs %}
{% tab title="Child Count" %}
<table><thead><tr><th width="104">Report</th><th width="357">Approved Change</th><th width="127">Reference #</th><th>Impact<select><option value="f06633655d2641dfbc6ff5bca8f594ff" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS089</td><td>Updated Zero Count Logic in <code>RDS.Get_CountSQL</code> to exclude LEAs that don't serve PK</td><td>CIID-5771</td><td><span data-option="f06633655d2641dfbc6ff5bca8f594ff">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Discipline" %}
<table data-full-width="true"><thead><tr><th width="104">Report</th><th width="357">Approved Change</th><th width="127">Reference #</th><th>Impact<select><option value="bed944244a0f4278bd88712556ee551b" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td><p>FS005 </p><p>FS006</p><p>FS007</p><p>FS086</p><p>FS143</p></td><td>Updated all references from Primary Disability Type to use IDEA Disability Type</td><td>CIID-5811</td><td><span data-option="bed944244a0f4278bd88712556ee551b">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Directory" %}
<table><thead><tr><th width="104">Report</th><th width="358">Approved Change</th><th width="126">Reference #</th><th>Impact<select><option value="5548d2c8815d41b5ae42ab67d5cff7df" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS029</td><td>Reconstituted Status values were corrected to populate into Reports as all Caps.</td><td>CIID-5728</td><td><span data-option="5548d2c8815d41b5ae42ab67d5cff7df">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Membership" %}
<table><thead><tr><th width="104">Report</th><th width="358">Approved Change</th><th width="127">Reference #</th><th>Impact<select><option value="4e024463674647e184f977910b12a48a" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS052</td><td>The school level file was corrected to exclude Reportable Programs</td><td>CIID-5789</td><td><span data-option="4e024463674647e184f977910b12a48a">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="CCD School" %}
<table><thead><tr><th width="104">Report</th><th width="358">Approved Change</th><th width="127">Reference #</th><th>Impact<select><option value="8f2039417e114a7bb11356e3dbd9b5ac" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS129</td><td><p>"Updated the view RDS.vwDimK12SchoolStatuses</p><p>Fixed the mapping for NSLPPRO2 in DimK12SchoolStatus."</p></td><td><p>CIID-5783</p><p>CIID-5807</p></td><td><span data-option="8f2039417e114a7bb11356e3dbd9b5ac">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="MEP Students Eligible and Served" %}
<table><thead><tr><th width="104">Report</th><th width="358">Approved Change</th><th width="127">Reference #</th><th>Impact<select><option value="d7a9ccf8757e4c0c8c08046b23fbdf9a" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS122</td><td>Remove all references/display for FS 122 for SY 2022-23 going forward.</td><td>CIID-5701</td><td><span data-option="d7a9ccf8757e4c0c8c08046b23fbdf9a">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Primary Nighttime" %}
<table><thead><tr><th width="104">Report</th><th width="358">Approved Change</th><th width="127">Reference #</th><th><select><option value="de93c304c99c4ce3a525b9cfe82bff82" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS118</td><td>Primary Nighttime Residence Codes corrected to show in Submission Files</td><td>CIID-4773</td><td><span data-option="de93c304c99c4ce3a525b9cfe82bff82">Data</span></td></tr></tbody></table>
{% endtab %}
{% endtabs %}

{% tabs %}
{% tab title="User Interface" %}
<table><thead><tr><th width="461">Approved Change</th><th width="130">Reference #</th><th>Impact<select><option value="3fdf7eac8a5841dfa834e6cb7b25f5a3" label="Reports" color="blue"></option></select></th></tr></thead><tbody><tr><td>Made the log table, Data Migration Histories, available in the User Interface during the migrations.</td><td><p>CIID-5693 </p><p>CIID-5799 </p><p>CIID-5792</p></td><td><span data-option="3fdf7eac8a5841dfa834e6cb7b25f5a3">Reports</span></td></tr></tbody></table>
{% endtab %}

{% tab title="General" %}
<table><thead><tr><th width="461">Approved Change</th><th width="130">Reference #</th><th>Impact<select><option value="1520d836e3d54ecebca60f9d8f078551" label="Migration" color="blue"></option><option value="268aebd1381e4f4da7debb0c8bcf17ef" label="Database" color="blue"></option><option value="01bee6b229284cd4a14f23ff939f0a4f" label="CEDS OSC" color="blue"></option><option value="4d010d20fee9450bbdf86f66338c1f0c" label="Generate" color="blue"></option></select></th></tr></thead><tbody><tr><td>DW 11 upgrade Develop Staging-to-RDS ETL Script for Membership Counts</td><td>CIID-5706</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>DW 11 IDEA Develop Staging-to-RDS ETL Script for Directory Files</td><td>CIID-5707</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>DW11 IDEA Develop Staging-to-RDS ETL Script for Discipline Counts</td><td>CIID-5708</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>DW 11 Develop Staging-to-RDS ETL Script for Staff Counts - FS070, FS099, FS112</td><td>CIID-5709</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>DW 11 IDEA Develop Staging-to-RDS ETL Script for DimLEAs</td><td>CIID-5710</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>DW 11 IDEA Develop Staging-to-RDS ETL Script for Child Count Counts</td><td>CIID-5711</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>DW 11 Develop Staging-to-RDS ETL Script for DimK12Schools</td><td>CIID-5712</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>DW 11 Develop Staging-to-RDS ETL Script for DimSEAs</td><td>CIID-5713</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>DW 11 Develop Staging-to-RDS ETL Script for DimCharterSchoolAuthorizers</td><td>CIID-5714</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>DW 11 Develop Staging-to-RDS ETL Script for DimK12Students</td><td>CIID-5719</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>DW 11 IDEA Develop Staging-to-RDS ETL Script for Special Ed Exit Counts</td><td>CIID-5720</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>DW 11 Drop column Program Type Code from Staging.K12StaffAssignment</td><td>CIID-5778</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>CEDS DW 11 Upgrade - Use CEDS script to Create and populate all the dimension tables</td><td>CIID-4812</td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>CEDS DW 11 Upgrade-Update Metadata for Dimension Changes</td><td>CIID-4813</td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>CEDS DW 11 Upgrade-Fact Table Changes</td><td>CIID-4814</td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>CEDS DW 11 Upgrade-Create a Script to Update existing Fact Data</td><td>CIID-4815</td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>CEDS DW 11 Upgrade-Report Table Changes</td><td>CIID-4816</td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>CEDS DW 11 Upgrade-Report Migration Updates</td><td>CIID-4818</td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>CEDS DW 11 Upgrade-UI &#x26; Submission File related changes</td><td>CIID-4819</td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>CEDS Add a new column and remove unnecessary columns from V11 staging. K12Organization table</td><td>CIID-5747</td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>CEDS Update the OSC with switch to Staging.PersonRace</td><td>CIID-5749</td><td><span data-option="01bee6b229284cd4a14f23ff939f0a4f">CEDS OSC</span></td></tr><tr><td>CEDS Add Columns to Staging.StateDetail</td><td>CIID-5750</td><td><span data-option="01bee6b229284cd4a14f23ff939f0a4f">CEDS OSC</span></td></tr><tr><td>Determine if DimK12StudentStatuses.PlacementStatusCode and DimK12StudentStatuses.PlacementTypeCode exist in Generate</td><td>CIID-5765</td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>CEDS Add _CEDSElements and _CEDStoRDSMapping tables to DW</td><td>CIID-5766</td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>Create a view into the CEDS Extended Properties available for the Data Warehouse in Generate v11</td><td>CIID-5781</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>Correct an issue with Staging to RDS code for Race where it was duplicating records if SSRD has more than 1 value mapped</td><td>CIID-5734</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>Get_CountSQL - correct the population of the Child Count Date and Membership Date so they use the School Year of the migration.</td><td>CIID-5740</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>Staging.Staging-to-DimK12Schools Incorrectly Handling OutOfStateIndicator</td><td>CIID-5744</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>Create a utility for reviewing the Source System Reference Data mappings by Report Group</td><td>CIID-5804</td><td><span data-option="1520d836e3d54ecebca60f9d8f078551">Migration</span></td></tr><tr><td>Split DimCohortStatuses into DimAcademicAwardStatuses &#x26; DimK12EnrollmentStatuses</td><td>CIID-5773</td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>Populate EdFacts codes in Dimension tables</td><td>CIID-5775</td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>Create new Dimension Tables​ - Update ETL scripts, Report migration and Metadata</td><td>CIID-4845</td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td><p>"Added responsible LEA Type Foreign Keys to the appropriate tables.</p><p>Staging tables, Fact tables and Update ETL scripts"</p></td><td><p>CIID-4846 </p><p>CIID-4847 </p><p>CIID-4848</p></td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>Reworked IDEA and Disability Dimensions</td><td><p>CIID-4849 </p><p>CIID-4850 </p><p>CIID-4851</p></td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>New dimension tables include​-Upgrade the data to new dimensional model</td><td>CIID-4852</td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>Reworked FactK12StudentAssessments</td><td><p>CIID-4853 </p><p>CIID-4854 </p><p>CIID-4855</p></td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>Refactor Staff dimension tables</td><td>CIID-4874</td><td><span data-option="268aebd1381e4f4da7debb0c8bcf17ef">Database</span></td></tr><tr><td>Allow Generate to be run from a subfolder in IIS (e.g., https://doe.nh.gov/generate)</td><td>CIID-5263</td><td><span data-option="4d010d20fee9450bbdf86f66338c1f0c">Generate</span></td></tr></tbody></table>
{% endtab %}
{% endtabs %}

### Upgrade Procedure&#x20;

No changes have been made to the Generate upgrade procedure for this release.  Follow the standard Generate upgrade process to install version 11.0.&#x20;

### Compatible Systems &#x20;

Generate was tested on the following operating systems and browsers: &#x20;

* [x] Windows 10 Pro&#x20;
* [x] Google Chrome, Version 68 0.3440.106 (Official Build) (64-bit) and Firefox Quantum 61.01 (64 bit)

***

## Office Hour

{% embed url="https://www.youtube.com/watch?v=di2lPmZSu2c" %}
Recording from the Generate 11.0 - Office Hour session
{% endembed %}
