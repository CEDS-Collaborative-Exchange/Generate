---
description: >-
  This document provides a description of the technical enhancements to Generate
  version 11.1 released in September 2023.
cover: ../../.gitbook/assets/Generate Release v5.3_Gitbook thumbnail (1).jpg
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

# Release Notes 11.1

## Release Overview &#x20;

Generate version 11.1 is primarily focused on the Special Education Assessment files, file specifications 175, 178, 179, 185, 188, and 189. Changes were made to update the staging and dimension tables to bring them into line with CEDS like the v11 release. The code was also modified to accommodate the changes to the file specifications for SY 2023.

**SEA ETL changes:** The changes to the Assessment file specifications for SY 2023 have two significant modifications. First, there are twelve new Assessment types that are available as permitted values. Second, the available Assessment types are broken down by Grade Level, 3-8 and 9-12. Below are the changes to be aware of regarding SEA ETL code.

* [x] Some column names in **Staging.Assessment** and **Staging.AssessmentResult** were updated to align with CEDS like they did for the other tables in v11.
* [x] Two new fields were added to **Staging.AssessmentResult**
* [x] The new Assessment Types and new column will require mapping in SourceSystemReferenceData
* [x] <mark style="background-color:yellow;">There are two new questions in Toggle that will require responses to correctly populate the submission files.</mark>

***

### Table Updates

#### Staging.Assessment

1. <mark style="color:green;">`AssessmentTypeAdministeredToChildrenWithDisabilities`</mark> was renamed to <mark style="color:green;">`AssessmentTypeAdministered`</mark>

**Staging.AssessmentResult**

1. <mark style="color:green;">`Student_Identifier_State`</mark> was renamed to <mark style="color:green;">`StudentIdentifierState`</mark>&#x20;
2. <mark style="color:green;">`LEA_Identifier_State`</mark> will be mapped to <mark style="color:green;">`LeaIdentifierSeaAccountability`</mark>
3. <mark style="color:green;">`School_Identifier_State`</mark> was renamed to <mark style="color:green;">`SchoolIdentifierSea`</mark>
4. <mark style="color:green;">`AssessmentTypeAdministeredToChildrenWithDisabilities`</mark> was renamed to <mark style="color:green;">`AssessmentTypeAdministered`</mark>

Two new fields added to **Staging.AssessmentResult**

1. AssessmentIdentifier
2. AssessmentRegistrationReasonNotTested

***

### Mapping Update

**Staging.SourceSystemReferenceData**

1. The new Assessment Types were added for SY 2023 to TableName = ‘RefAssessmentTypeAdministered’ with default mapping.

{% hint style="success" %}
Update as necessary
{% endhint %}

1. Mapping for the new column, <mark style="color:green;">`AssessmentRegistrationReasonNotTested`</mark> was added for SY 2023 to TableName = ‘RefAssessmentReasonNotTested’ with default mappings

{% hint style="success" %}
Update as necessary
{% endhint %}

***

### Toggle

1. Review your existing Toggle Assessments to ensure they are accurate for the new Assessment Types for SY 2023&#x20;
2. Several of the new assessments are only included in the submission file if they are used by the SEA. There are two new Toggle questions that allow you to define the assessments used in your SEA. The questions are located in the standard Toggle screen (not the Toggle Assessments link) in the Assessments section.

<figure><img src="../../.gitbook/assets/Toggle update_Generate 11.1.png" alt="Screenshot of the Generate Toggle page highlighting the new questions that read, &#x22;Please indicate any of the following Lower Grade (3-8) Assessments used by your state&#x22; and &#x22;Please indicate any of the following High School (9-12) Assessments used by your state."><figcaption><p>Screenshot of the Toggle page showing the new questions added in Generate 11.1.</p></figcaption></figure>

***

### Generate Enhancements &#x20;

The following E&#x44;_&#x46;acts_ reports were updated in this release.&#x20;

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
{% tab title="Assessment " %}
<table><thead><tr><th width="100">Report</th><th width="355">Approved Change</th><th width="130">Reference #</th><th>Impact<select><option value="fbe965b476924b13ab5479b093710231" label="Data" color="blue"></option><option value="d898e13cec774763adf933ebb1e40cd3" label="User Interface" color="blue"></option><option value="ca7fff020e8e4ce9b160fbfcd91228ce" label="Source to Staging ETL" color="blue"></option><option value="892c127e59fd40aba19bdc2a71a2afa6" label="Performance" color="blue"></option><option value="d688277c85c84925b526fff766b842b4" label="Migration" color="blue"></option><option value="2f8f5db01dbd49d2b6ff4b13a08b6086" label="Submission Files" color="blue"></option><option value="e1c892e2c22949129daf6e6b3d90a95c" label="Database" color="blue"></option></select></th></tr></thead><tbody><tr><td><p>FS175 </p><p>FS178 </p><p>FS179 </p><p>FS185 </p><p>FS188 </p><p>FS189 </p></td><td><p>Assessment files 175, 178, 179 not producing zero counts. </p><p></p><p>Assessment Files (175, 178, 179, 185, 188, 189) - No Records to Display Create Report data produces no record. </p><p></p><p>Assessment Zero Counts not considering the Participation Status/Grade Level/Subject </p><p></p><p>Assessment Files Technical changes FS175, FS178, FS179, FS185, FS188, FS189 - Metadata &#x26; Reports Functionality </p><p></p><p>Assessment Staging-to-RDS changes FS175, FS178, FS179, FS185, FS188, FS189 </p></td><td><p>CIID-4740 </p><p>CIID-4921 </p><p>CIID-5260 </p><p>CIID-5704 <br>CIID-5905 </p></td><td><span data-option="fbe965b476924b13ab5479b093710231">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Child Count" %}
<table><thead><tr><th>Report</th><th width="337">Approved Change</th><th width="128">Reference #</th><th>Impact<select><option value="53dffb0621c44c6f9e81382df8530059" label="Data" color="blue"></option><option value="9a1dcbfd6d784fda8c1ce45c11b83354" label="User Interface" color="blue"></option><option value="0430edc7188f47ffb50b97bca88aad61" label="Source to Staging ETL" color="blue"></option><option value="7a4a755d32524a7288daa75839337f7e" label="Performance" color="blue"></option><option value="19258b48d248491b91b6bd9823518149" label="Migration" color="blue"></option><option value="c0340b7aeffe43d19619692875a1db68" label="Submission Files" color="blue"></option><option value="d4ff85bddff1459e8d695cc1c3aac44d" label="Database" color="blue"></option><option value="f17b5388b22047c9ad681f393d887437" label="N/A" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS089</td><td>Unable to download the submission file. System is giving an error.</td><td>CIID-5886</td><td><span data-option="f17b5388b22047c9ad681f393d887437">N/A</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Discipline" %}
<table><thead><tr><th>Report</th><th>Approved Change</th><th>Reference #</th><th>Impact<select><option value="547555d86aae48cb9791cb06706bed15" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS005<br>FS007</td><td>Removed the cumulative 45 day limitation at the Report aggregation level.</td><td>CIID-5169</td><td><span data-option="547555d86aae48cb9791cb06706bed15">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="General" %}
<table><thead><tr><th width="124">Software</th><th width="312">Approved Change</th><th>Reference #</th><th>Impact<select><option value="3a21b86e620f461cb9f662d4372f9b8a" label="Data" color="blue"></option><option value="5c79a7d4d0994525a539a5b151a2b02c" label="User Interface" color="blue"></option><option value="3e8003a6ac79473888e7c7e64c38c89a" label="Source to Staging ETL" color="blue"></option><option value="f06f39ef820f42e98b6cc2d2d6b54ab3" label="Performance" color="blue"></option><option value="da381ef52dd7493593aea9791d6d32c2" label="Migration" color="blue"></option><option value="d2b467843ca240069a481a8bf22e4fe1" label="Submission Files" color="blue"></option><option value="e99dda51a4c44f6084f913f8432635c3" label="Database" color="blue"></option><option value="6d04127100914f938006bae53514e05c" label="N/A" color="blue"></option></select></th></tr></thead><tbody><tr><td></td><td>Revise the auto-rollover of Source System Reference Data table data</td><td>CIID-5666</td><td><span data-option="6d04127100914f938006bae53514e05c">N/A</span></td></tr></tbody></table>
{% endtab %}
{% endtabs %}

{% file src="../../.gitbook/assets/Generate Enhancements 11.1.xlsx" %}
Generate Enhancements 11.1 Excel document download
{% endfile %}

### Upgrade Procedure&#x20;

No changes have been made to the Generate upgrade procedure for this release. Follow the standard Generate upgrade process to install version 11.1.

### Compatible Systems &#x20;

Generate was tested on the following operating systems and browsers: &#x20;

* [x] Windows 10 Pro
* [x] Google Chrome, Version 68 0.3440.106 (Official Build) (64-bit) and Firefox Quantum 61.01 (64 bit)



***

## Office Hour

{% embed url="https://youtu.be/zymns0k35B0" %}
Recording from the Generate 11.1 - Office Hour session
{% endembed %}
