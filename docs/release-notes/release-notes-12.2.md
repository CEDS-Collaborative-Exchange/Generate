---
icon: sparkles
description: This document describes the technical enhancements to Generate version 12.2.
cover: ../.gitbook/assets/Release Notes_Release Notes 12.2_banner.png
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

# Release Notes 12.2

### Required State Changes

* SQL Server: Minimum version requirement updated to 2017 or greater.
* .NET Core Runtime: Version 8.0.10 is now required.
* Database Server RAM: Minimum requirement updated to 32 GB, with 64 GB recommended.

### Enhancements

#### IDEA Reports

* Staff (009): Ensured that Certification Status is populated in the submission file.
* Staff (112): Ensured that Qualification Status is populated in the submission file.
* Staff (070, 099, 112): Fixed an issue with the UI displaying whole numbers while the submission file displays decimals.
* Exiting (009): Handled an issue with LEA exits for the State catchment area.
* Exiting (009): Added a staging validation for RMA – Reached Maximum Age students.

#### Non-IDEA Reports

* Discipline (086): Enhanced to allow duplicate aggregated counts for students where applicable.
* Staff (059): Fixed display of zeros for Category Set A and ensured the header is visible.
* Homeless (118): Corrected inclusion of PK in final counts.

#### User Interface

* Automated migration of Directory data to the `FactOrganizationCounts` table for an unprocessed school year.

#### General System Updates

* Generate Infrastructure: Updated Entity Framework Compatibility level.
* Utilities: Updated File Comparison Utility compatibility for handling longer database names.
* Staging: `School_TitleIPartASchoolDesignation` has been renamed to `School_TitleISchoolStatus` in `Staging.K12Organization`.

#### Documentation Updates

* Installation Requirements: Updated to reflect new system specifications.
* [Discord User Guide:](https://applieden.sharepoint.com/:fl:/r/contentstorage/CSP_94c83c9a-ecf1-4685-ab87-bc5c25734e26/Document%20Library/LoopAppData/Discord%20User%20Guide.loop?d=wfbac682f4313444abe1bbae76e14f676\&csf=1\&web=1\&e=YLg61b\&nav=cz0lMkZjb250ZW50c3RvcmFnZSUyRkNTUF85NGM4M2M5YS1lY2YxLTQ2ODUtYWI4Ny1iYzVjMjU3MzRlMjYmZD1iJTIxbWp6SWxQSHNoVWFyaDd4Y0pYTk9KcXVsYUliV3BNVkl0VlRoMjBFVlBSbjNMc01meXpGSFJyQlZ1MVNKYnpIVSZmPTAxR0pNMjNCSlBOQ1dQV0UyREpKQ0w0RzUyNDVYQko1VFcmYz0lMkYmYT1Mb29wQXBwJnA9JTQwZmx1aWR4JTJGbG9vcC1wYWdlLWNvbnRhaW5lciZ4PSU3QiUyMnclMjIlM0ElMjJUMFJUVUh4aGNIQnNhV1ZrWlc0dWMyaGhjbVZ3YjJsdWRDNWpiMjE4WWlGdGFucEpiRkJJYzJoVllYSm9OM2hqU2xoT1QwcHhkV3hoU1dKWGNFMVdTWFJXVkdneU1FVldVRkp1TTB4elRXWjVla1pJVW5KQ1ZuVXhVMHBpZWtoVmZEQXhSMHBOTWpOQ1RFeEZUbHBNVUZJMVUwdFdSRm8yUzFOR1MwVkNXREpMVkZNJTNEJTIyJTJDJTIyaSUyMiUzQSUyMjBjZDQ3NzRmLWM2NDMtNDNhYS1hYzAzLWU5YWE2NGQ1YTRiYyUyMiU3RA%3D%3D) Added to facilitate community collaboration.
* [Support Page:](https://applieden.sharepoint.com/:fl:/r/contentstorage/CSP_94c83c9a-ecf1-4685-ab87-bc5c25734e26/Document%20Library/LoopAppData/Support.loop?d=wcedd8a1b677c42159dfcade113ab374e\&csf=1\&web=1\&e=d3oEDg\&nav=cz0lMkZjb250ZW50c3RvcmFnZSUyRkNTUF85NGM4M2M5YS1lY2YxLTQ2ODUtYWI4Ny1iYzVjMjU3MzRlMjYmZD1iJTIxbWp6SWxQSHNoVWFyaDd4Y0pYTk9KcXVsYUliV3BNVkl0VlRoMjBFVlBSbjNMc01meXpGSFJyQlZ1MVNKYnpIVSZmPTAxR0pNMjNCSTNSTE80NDdESENWQkozN0ZONEVKMldOMk8mYz0lMkYmYT1Mb29wQXBwJnA9JTQwZmx1aWR4JTJGbG9vcC1wYWdlLWNvbnRhaW5lciZ4PSU3QiUyMnclMjIlM0ElMjJUMFJUVUh4aGNIQnNhV1ZrWlc0dWMyaGhjbVZ3YjJsdWRDNWpiMjE4WWlGdGFucEpiRkJJYzJoVllYSm9OM2hqU2xoT1QwcHhkV3hoU1dKWGNFMVdTWFJXVkdneU1FVldVRkp1TTB4elRXWjVla1pJVW5KQ1ZuVXhVMHBpZWtoVmZEQXhSMHBOTWpOQ1RFeEZUbHBNVUZJMVUwdFdSRm8yUzFOR1MwVkNXREpMVkZNJTNEJTIyJTJDJTIyaSUyMiUzQSUyMjBjZDQ3NzRmLWM2NDMtNDNhYS1hYzAzLWU5YWE2NGQ1YTRjYSUyMiU3RA%3D%3D) Consolidated resources available in the updated Generate documentation portal.

#### Generate Enhancements

The following EDFacts reports were updated in this release.

### Type of Impact:

* Data – changes will improve data quality and completeness.
* User Interface – changes impact the Generate User Interface and/or migration process.
* Source to Staging ETL – changes may require modifications to the SEA’s Source to Staging ETL.
* Performance – changes improve the performance of the application.
* Migration – changes impact a data migration process.
* Submission Files – changes may impact submission file(s).
* Database – changes to the Generate database structure.

<table><thead><tr><th>Report #</th><th>Report</th><th>Change</th><th>Ticket</th><th>Impact<select><option value="fnfPJ0nnViwz" label="User Interface" color="blue"></option><option value="jGNrs2rsS31b" label="Data" color="blue"></option><option value="qCAChsN1Kuxq" label="Database" color="blue"></option></select></th></tr></thead><tbody><tr><td>Directory</td><td>C130</td><td>Added support for file specification 130 - ESEA Status</td><td><a href="https://aemcorp.atlassian.net/browse/CIID-7223">CIID-7223</a></td><td><span data-option="jGNrs2rsS31b">Data</span></td></tr><tr><td>Discipline</td><td>C086</td><td>Enhanced to allow duplicate aggregated counts for students where applicable.</td><td><a href="https://aemcorp.atlassian.net/browse/CIID-7202">CIID-7202</a></td><td><span data-option="jGNrs2rsS31b">Data</span></td></tr><tr><td>Exiting</td><td>C009</td><td>Added a staging validation for RMA – Reached Maximum Age students</td><td><a href="https://aemcorp.atlassian.net/browse/CIID-5070">CIID-5070</a></td><td><span data-option="jGNrs2rsS31b">Data</span></td></tr><tr><td>Exiting</td><td>C009</td><td>For Statewide catchment counts, students who are still enrolled in Special Education at the end of the reporting period, regardless of LEA enrollment and exit details, will not be counted in FS009.</td><td><a href="https://aemcorp.atlassian.net/browse/CIID-4727">CIID-4727</a></td><td><span data-option="jGNrs2rsS31b">Data</span></td></tr><tr><td>Homeless</td><td>C118</td><td>Corrected inclusion of PK in final counts.</td><td><a href="https://aemcorp.atlassian.net/browse/CIID-7065">CIID-7065</a></td><td><span data-option="jGNrs2rsS31b">Data</span></td></tr><tr><td>Staff</td><td>C099 C112</td><td>Staff (009): Ensured that Certification Status is populated in the submission file Staff (112): Ensured that Qualification Status is populated in the submission file</td><td><a href="https://aemcorp.atlassian.net/browse/CIID-7064">CIID-7064</a></td><td><span data-option="jGNrs2rsS31b">Data</span></td></tr><tr><td>Staff</td><td>C070 C099 C112</td><td>Fixed an issue with the UI displaying whole numbers while the submission file displays decimals</td><td><a href="https://aemcorp.atlassian.net/browse/CIID-7203">CIID-7203</a></td><td><span data-option="jGNrs2rsS31b">Data</span></td></tr><tr><td></td><td></td><td>Updated the UI for exiting migration to make sure the School Year dropdown did not run for an unprocessed school year.</td><td><a href="https://aemcorp.atlassian.net/browse/CIID-7135">CIID-7135</a></td><td><span data-option="fnfPJ0nnViwz">User Interface</span></td></tr><tr><td></td><td></td><td>Updated Entity Framework Compatibility level to improve the ability to see the metadata</td><td><a href="https://aemcorp.atlassian.net/browse/CIID-7207">CIID-7207</a></td><td><span data-option="qCAChsN1Kuxq">Database</span></td></tr><tr><td></td><td></td><td>Updated File Comparison Utility to accept longer database names.</td><td><a href="https://aemcorp.atlassian.net/browse/CIID-7153">CIID-7153</a></td><td><span data-option="jGNrs2rsS31b">Data</span></td></tr></tbody></table>

### Upgrade Procedure

No changes have been made to the Generate upgrade procedure for this release. Follow the standard Generate upgrade process to install version 11.4.

### Compatible Systems

Generate was tested on the following operating systems and browsers:

* Windows 10 Pro
* Google Chrome, Version 68 0.3440.106 (Official Build) (64-bit) and Firefox Quantum 61.01 (64 bit)

### Generate Office Hour

{% embed url="https://youtu.be/IgzzCVSY9Nw" %}



