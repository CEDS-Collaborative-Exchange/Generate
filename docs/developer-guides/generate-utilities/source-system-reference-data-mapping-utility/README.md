# Source System Reference Data Mapping Utility

### Overview

The Staging.SourceSystemReferenceData table is used by the Generate application to map state values for option sets to the corresponding CEDS values.  When starting the ETL work for a new file or set of files this mapping is critical for getting accurate results in the data warehouse and submission reports.  This utility will show the mappings for all the file specifications in a report group. \
The first parameter in this stored procedure is the Generate report group, they are listed at the end of this document with their associated file specifications for reference.

There are 3 parameters for the stored procedure:

1. @generateReportGroup = The report group name used by the Generate application.
2. @schoolYear = The 4 digit School Year to limit the mappings to.
3. @showUnmappedOnly = Show only the results for CEDS values that have no corresponding state value mapped to them

If the **generatReportGroup** or **schoolYear** parameters are missing the stored procedure will not execute.

The last parameter is used to show all the mappings in that Report Group using @showUnmappedOnly = 0, or only show the CEDS values that do not have a corresponding mapped value using @showUnmappedOnly = 1.  It defaults to showing all the mappings.

### Sample Execution

{% code overflow="wrap" %}
```sql
exec [Utilities].[Check_SourceSystemReferenceData_Mapping] 'childcount', '2023', 0 -- This will show all mappings for the Child Count report group (files 002 and 089) for School Year 2023

exec [Utilities].[Check_SourceSystemReferenceData_Mapping] 'discipline', '2023', 1 -- This will show only the CEDS unmapped values for the Discipline report group (files 005, 006, 007, 086, 088, 143, and 144) for School Year 2023
```
{% endcode %}

### Report Group Reference

<table><thead><tr><th width="263">Generate Report Groups</th><th>File Specs</th></tr></thead><tbody><tr><td>Assessment</td><td>175, 178, 179, 185, 188, 189, 113, 125, 126, 137, 138, 139, 142</td></tr><tr><td>ChildCount</td><td>002,089</td></tr><tr><td>ChronicAbsenteeism</td><td>195</td></tr><tr><td>Directory</td><td>029, 039, 190, 196, 035, 103, 129, 130, 131, 163, 170, 193, 197, 198, 205, 206</td></tr><tr><td>Discipline</td><td>005, 006, 007, 086, 088, 143, 144</td></tr><tr><td>Dropout</td><td>032</td></tr><tr><td>Exiting</td><td>009</td></tr><tr><td>GraduatesCompleters</td><td>040</td></tr><tr><td>GraduationRate</td><td>150, 151</td></tr><tr><td>Homeless</td><td>118, 194</td></tr><tr><td>HSGraduatePSEnrollment</td><td>160</td></tr><tr><td>Staff</td><td>070, 099, 112, 059, 065, 067, 203</td></tr><tr><td>Immigrant</td><td>165</td></tr><tr><td>Membership</td><td>033, 052</td></tr><tr><td>MigrantEducationProgram</td><td>054, 121, 145</td></tr><tr><td>NeglectedOrDelinquent</td><td>119, 127</td></tr><tr><td>TitleI</td><td>037, 134</td></tr><tr><td>TitleIIIELOct</td><td>116, 141</td></tr><tr><td>TitleIIIELSY</td><td>045, 204</td></tr></tbody></table>

