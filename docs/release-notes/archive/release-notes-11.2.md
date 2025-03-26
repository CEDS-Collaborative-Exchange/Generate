---
description: >-
  This document provides a description of the technical enhancements to Generate
  version 11.2 released in December 2023.
cover: ../../.gitbook/assets/Generate 11.2.png
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

# Release Notes 11.2

## Release Overview

Generate version 11.2 is primarily focused on the **Staff**, **Discipline**, and **Directory** files, file specifications 070, 099, 112, 005, and 029, and other files due in the January – March timeframe.

{% hint style="info" %}
**State ETL changes**: There are no changes in this release that require updating of the existing state ETL scripts.
{% endhint %}

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
{% tab title="Child Count" %}
<table><thead><tr><th width="102">Report</th><th width="346">Approved Change</th><th width="130">Reference #</th><th>Impact<select><option value="65e36e3dcd00490587a173db84706bad" label="Data" color="blue"></option><option value="b376e90cfa3145759c4d6357147ae04c" label="Reports" color="blue"></option><option value="2b5dea5b2f0a4832999d865cab631cbb" label="Data Quality" color="blue"></option><option value="344543d70c8747b6a52b5b66bf9d325e" label="Performance" color="blue"></option></select></th></tr></thead><tbody><tr><td><p>FS002 </p><p>FS089</p></td><td><p>Improved migration performance.</p><p> </p><p>Correct issue where two SEA organizations are showing up on the UI. </p><p></p><p>Added support for states that do not report Primary Disability Type</p><p></p><p>IDEA School-Age - Child count report headers displaying the wrong </p><p></p><p>Organization level in the UI</p></td><td>CIID-6002 CIID-5969 CIID-5861 CIID 3997</td><td><span data-option="65e36e3dcd00490587a173db84706bad">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Discipline" %}
<table><thead><tr><th width="102">Report</th><th width="346">Approved Change</th><th width="126">Reference #</th><th>Impact<select><option value="f64e69fdd7444e75a786a8631c454233" label="Data" color="blue"></option><option value="44a14e5598e74f0bbb680d5783091bb8" label="Reports" color="blue"></option><option value="b17f10bf0e6a460d9fc164dbaf37b161" label="Data Quality" color="blue"></option><option value="145af0ed54554b61831021592b80be01" label="Performance" color="blue"></option><option value="9c3221aa83dc46d8875296e3a24ad435" label="User Interface" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS005</td><td>Limit the students to only those with REMDW removals</td><td>CIID-4542</td><td><span data-option="145af0ed54554b61831021592b80be01">Performance</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Staff" %}
<table><thead><tr><th width="102">Report</th><th width="345">Approved Change</th><th>Reference #</th><th>Impact<select><option value="60be2ad7483c48b1ad0b24ab938f7c4b" label="Data" color="blue"></option><option value="bcc96c60804e417196c1dd2012a7ecaf" label="Reports" color="blue"></option><option value="55987855d5ee4992b3ed90d2cc298d3f" label="Data Quality" color="blue"></option><option value="f6772777a5074b90b5b996f10c840e99" label="Performance" color="blue"></option><option value="5ebee8d65fc047b9aeea346625445011" label="User Interface" color="blue"></option></select></th></tr></thead><tbody><tr><td><p>FS070 </p><p>FS099 </p><p>FS112</p></td><td><p>Update PVs in the category Age Group </p><p></p><p>Special education teachers and paras - Permitted Values on the UI and Submission file are not correct.</p><p></p><p>Dynamic SQL needs to be further qualified. </p><p></p><p>Remove retired category Certification Status. Add new category Certification Status (IDEA) </p><p></p><p>Capture new 2023 metadata for FS112 Spec Ed Paraprofessionals, FS070 Spec Ed Teachers, and others</p></td><td>CIID-5923 CIID-5897 CIID-5132 CIID-5925 CIID-4777</td><td><span data-option="60be2ad7483c48b1ad0b24ab938f7c4b">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Directory" %}
<table><thead><tr><th width="101">Report</th><th width="346">Approved Change</th><th>Reference #</th><th>Impact<select><option value="059ab1577782475794da101c9b516ebc" label="Data" color="blue"></option><option value="c4e17f8d174f4842bb6d6b0dc42f0fec" label="Reports" color="blue"></option><option value="ec64ad0c0f20444bab0c66b81b97fbea" label="Data Quaility" color="blue"></option><option value="d63e3ed2b03f423dbfcca622a0cc433c" label="Performance" color="blue"></option><option value="5f9888ad99de4219943cbb00fabf9ec1" label="User Interface" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS029</td><td><p>Corrected issue where the report would not display on the UI.</p><p></p><p>Corrected issue where Charter School Authorizer Type is missing from the RDS Report tables.</p><p></p><p>Corrected issue with duplicate LEAs showing up in the LEA dropdown list on the UI.</p></td><td>CIID-5900 CIID-5872 CIID-4722</td><td><span data-option="059ab1577782475794da101c9b516ebc">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="User Interface" %}
<table><thead><tr><th width="101">Report</th><th width="346">Approved Change</th><th>Reference #</th><th>Impact<select><option value="a600656b4c36401bb1d6e92a7c7c068a" label="Data" color="blue"></option><option value="9724fd5fac1442918748548f0193fc79" label="Reports" color="blue"></option><option value="41a4b18b292a4f88a7f455c204f629f5" label="Data Quality" color="blue"></option><option value="2cfb09d570c4401ca6466036354229ad" label="Performance" color="blue"></option><option value="de006d57804045559cf3d25e60ef7d6a" label="User Interface" color="blue"></option></select></th></tr></thead><tbody><tr><td></td><td>No file specification changes for this reporting period so rollover the metadata - FS006, FS007, FS009, FS037, FS040, FS088, FS132, FS134, FS143, FS144, FS163, FS206, FS212</td><td>CIID-5922</td><td><span data-option="9724fd5fac1442918748548f0193fc79">Reports</span></td></tr></tbody></table>
{% endtab %}

{% tab title="General" %}
<table><thead><tr><th width="101">Report</th><th width="347">Approved Change</th><th>Reference #</th><th>Impact<select><option value="b29b769ff1484d5c97ef0f50a328697d" label="Data" color="blue"></option><option value="b7e831d567124770a2195ce774b39200" label="Reports" color="blue"></option><option value="a1b3d970566b4af088e58d0820bb9175" label="Data Quality" color="blue"></option><option value="3c4c7d2ec88549c4868297fcb808e8d0" label="Performance" color="blue"></option><option value="f4e80dff0ee140ac99e0de2d7c83cc77" label="User Interface" color="blue"></option></select></th></tr></thead><tbody><tr><td><p>FS099 </p><p>FS112</p></td><td>099/112 - Correct failed tests</td><td>CIID-6010</td><td><span data-option="b29b769ff1484d5c97ef0f50a328697d">Data</span></td></tr><tr><td>FS029</td><td>029 - Correct failed tests</td><td>CIID-6009</td><td><span data-option="b29b769ff1484d5c97ef0f50a328697d">Data</span></td></tr><tr><td>FS002</td><td>resolve failed test</td><td>CIID-6007</td><td><span data-option="a1b3d970566b4af088e58d0820bb9175">Data Quality</span></td></tr><tr><td>FS088</td><td>Generate FS088 nightly run failed in the test</td><td>CIID-5977</td><td><span data-option="a1b3d970566b4af088e58d0820bb9175">Data Quality</span></td></tr><tr><td><p>FS070 </p><p>FS099</p></td><td>Generate FS070 and FS099 nightly run failed in test</td><td>CIID-5976</td><td><span data-option="a1b3d970566b4af088e58d0820bb9175">Data Quality</span></td></tr><tr><td>FS040</td><td>Test the end-to-end migration process for File Specification 040</td><td>CIID-5988</td><td><span data-option="3c4c7d2ec88549c4868297fcb808e8d0">Performance</span></td></tr><tr><td>FS032</td><td>Create end-to-end tests for File Specification 032</td><td>CIID-5984</td><td><span data-option="a1b3d970566b4af088e58d0820bb9175">Data Quality</span></td></tr><tr><td><p>FS032 </p><p>FS040</p></td><td>Check and Fix Metadata Issues with File Specs 032 &#x26; 040</td><td>CIID-5987</td><td><span data-option="a1b3d970566b4af088e58d0820bb9175">Data Quality</span></td></tr><tr><td>FS086</td><td>Remove retired category Weapons. Add a new category Firearms</td><td>CIID-5924</td><td><span data-option="a1b3d970566b4af088e58d0820bb9175">Data Quality</span></td></tr><tr><td>FS052</td><td>School level - Try to open the submission file message appears unknown error occurred</td><td>CIID-5902</td><td><span data-option="f4e80dff0ee140ac99e0de2d7c83cc77">User Interface</span></td></tr><tr><td></td><td>Create additional Fact Type views for Staging and the RDS</td><td>CIID-5978</td><td><span data-option="a1b3d970566b4af088e58d0820bb9175">Data Quality</span></td></tr><tr><td></td><td>Update File Comparison Utility for V11</td><td>CIID-5967</td><td><span data-option="a1b3d970566b4af088e58d0820bb9175">Data Quality</span></td></tr><tr><td></td><td>Update the RDS wrapper script names to match the corresponding Staging-to-Fact names</td><td>CIID-5951</td><td><span data-option="3c4c7d2ec88549c4868297fcb808e8d0">Performance</span></td></tr></tbody></table>
{% endtab %}
{% endtabs %}

### Upgrade Procedure&#x20;

No changes have been made to the Generate upgrade procedure for this release. Follow the standard Generate upgrade process to install version 11.1.

### Compatible Systems &#x20;

Generate was tested on the following operating systems and browsers: &#x20;

* [x] Windows 10 Pro
* [x] Google Chrome, Version 68 0.3440.106 (Official Build) (64-bit) and Firefox Quantum 61.01 (64 bit)

***

## Office Hour

{% embed url="https://www.youtube.com/watch?v=VrwWwM2bqYE" %}
Generate 11.2 Office Hour recording
{% endembed %}
