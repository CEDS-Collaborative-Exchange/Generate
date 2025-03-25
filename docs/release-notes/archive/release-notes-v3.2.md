---
description: Generate Release Notes Version 3.2
---

# Release Notes 3.2

### Introduction <a href="#bookmark0" id="bookmark0"></a>

The purpose of this document is to communicate the major new features and changes that are included in the release of Generate Version 3.2.

### About this Release <a href="#bookmark1" id="bookmark1"></a>

Generate Release v3.2 includes functionality to improve the RDS migration and resolve defects.

### Compatible Systems <a href="#bookmark2" id="bookmark2"></a>

Generate was tested on the following operating systems and browsers:

1. Windows 10 Pro
2. Internet Explorer 11, Google Chrome, Version 68 0.3440.106 (Official Build) )64-bit), and Firefox Quantum 61.01 (64 bit)

### Updated Reports <a href="#bookmark3" id="bookmark3"></a>

The following reports were updated in this release:

1. FS029 – the following new options were added to Charter LEA Status:
   1. NA: Not applicable – State does not have charters or state does not permit charter LEAs
   2. NOTCHR: Not a charter district – State has charter LEAs but this LEA is not a charter LEA
   3. CHRTIDEAESEA: LEA for federal programs – Charter district which is an LEA for programs authorized under IDEA, ESEA and Perkins
   4. CHRTESEA: LEA for ESEA and Perkins – Charter district which is an LEA for programs authorized under ESEA and Perkins but not under IDEA
   5. CHRTIDEA: LEA for IDEA – Charter district which is an LEA for programs authorized under IDEA but not under ESEA and Perkins
   6. CHRTNOTLEA: Not LEA for federal programs – Charter district which is not an LEA for federal programs
2. FS175, FS178, FS179, FS188 and FS189 - improved performance of creating and downloading assessment school level submission files.
3. FS143 – updated to include count of distinct incidents rather than removals.

### New Feature <a href="#bookmark4" id="bookmark4"></a>

The following feature was added to the Update page in Settings:

1. Settings > Update
   1. Generate Release Notes were added to the Update page and are visible when Updates are available.

### Migration <a href="#bookmark5" id="bookmark5"></a>

The following issues related to the migration process were resolved:

1. Improve the RDS migration process by only migrating the dimensions needed for a particular fact type and reviewing the following dimensions: Title III Dimension; Discipline Firearms; Assessment; Assessment Status; and Student Status.
2. Organization data doesn’t load into RDS if data is already present in DIM tables.
3. Migrate\_DimDemographics does not join on report type dates properly.
4. FS029 Charter LEA Status migrations do not translate to E&#x44;_&#x46;acts_ option set.
5. Three reports are selected by default on the Reports Migration page – they should be deselected.
6. Add "Reportable Program" to RefSchoolType, DimDirectories.SchoolType\*, and all migrations related to FS029.
7. Submit "MISSING" for a category set at all levels if a particular dimension value is MISSING.
8. Sproc list on migration pages returns to the top every 5-10 seconds.
9. Missing values in RefLeaType and RefSchoolType needed for FS029.
10. Get\_StudentOrganization filters out LEA - only students if not processing Child Count data (such as Sped Exit).
11. Migrate\_DimRaces is excluding Hispanic only students.
12. Create Staging Stored Procedure for Person Race.
