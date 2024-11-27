# Source System Reference Data

### Introduction <a href="#toc158389226" id="toc158389226"></a>

The Generate table Staging.SourceSystemReferenceData is used in the Staging to RDS Migration to determine how source system option set values map to CEDS option set values. This table needs to be updated with the complete set of values for all categorical fields by school year. If a migration is run and no mappings exist for the corresponding school year, then the migration code will update the Staging.SourceSystemReferenceData table with a copy of mapping records from the most recent school year. If the mapping is incorrect or never existed, then there will be migration error and the values in the tables will need to be updated.

### Check Source Reference Data Values <a href="#toc158389227" id="toc158389227"></a>

Before you run the migration from staging to the RDS it is important to check to make sure reference data in the Staging.SourceSystemReferenceData table is mapped correctly to make sure there is a match for the data inserted into the staging tables for each option set. All reference tables are stored in Staging.SourceSystemReferenceData. The value in the Tablename column in most cases represents the field name in the insert statement of the ETL script. For example, Tablename RefSchoolType validates the value that was inserted into Staging.K12Organization.School\_Type during the migration process.

Staging.SourceSystemReferenceData table structure:

1. The ‘SchoolYear’ columns tracks mappings from year to year
2. The ‘Tablename’ column is name of the CEDS reference table
3. The ‘TableFilter’ column is only used when the reference table needs further qualifying (See Table Filter section below)
4. The ‘InputCode’ column is the state specific code value that is being translated from
5. The ‘OutputCode’ column is the CEDS value that is being translated to

How Source Reference Tables Are Used:

This example is for the Directory Fact Type. During the source to staging migration the source data maps SchoolType value to School\_Type in the table Staging.K12Organization. During Staging to RDS migration the value in School\_Type will be validated against the reverence table RefSchoolType InputCoded column and return the OutputCode for Generate to use to process the data.

For Example, if source SchoolType inserts a 1 in School\_Type then it will need to match the value in the InputCode where Tablename equals RefSchoolType. The OutputCode is what Generate uses and in this example, it equals "Regular".

The Staging.SourceSystemReferenceData table is prefilled where the InputCode matches OutputCode but this may not match what you are inserting into the RDS tables.

| SchoolYear | TableName     | TableFilter | InputCode          | OutputCode         |
| ---------- | ------------- | ----------- | ------------------ | ------------------ |
| 2023       | RefSchoolType | NULL        | 1                  | Regular            |
| 2023       | RefSchoolType | NULL        | Special            | Special            |
| 2023       | RefSchoolType | NULL        | CareerAndTechnical | CareerAndTechnical |
| 2023       | RefSchoolType | NULL        | Alternative        | Alternative        |
| 2023       | RefSchoolType | NULL        | Reportable         | Reportable         |

You can either chose to change the ETL to insert "Regular" into the InputCode or update the InputCode in the Staging.SourceSystemReferenceData for RefSchoolType table InputCode to equal 1.

### Check Source Reference Table Values by Fact Type and Report Code <a href="#toc158389229" id="toc158389229"></a>

To verify what is in the InputCode and OutputCode columns for Directory Fact Type use the list below with the following query. Replace the TableName from the list of reference tables below to identify what the table is expecting and edit accordingly:

SELECT \* FROM Staging.SourceSystemReferenceData WHERE TableName = 'RefOrganizationType'

### Reference Tables for Directory: <a href="#toc158389230" id="toc158389230"></a>

Directory 029

RefOrganizationType

RefInstitutionTelephoneType

RefOperationalStatus (Table filter 000174 = LEA , Table filter 000533= School)

RefOperationalStatus

RefCharterSchoolAuthorizerType

RefLeaType

RefCharterLeaStatus

RefSchoolType

RefReconstitutedStatus

RefOrganizationLocationType

RefInstitutionTelephoneType

Directory 039

RefGradeLevel

### Validate Fact Types That are loaded

The Source System Reference Data Mapping Utility will show the mappings for all the file specifications in each Fact Type. The first parameter in this stored procedure is the Generate report group, they are listed at the end of this document with their associated file specifications for reference.

### Source Reference Table Filters

The only table filter used for Directory reports is for file 029.  The CEDS IDS is a third normal form database that tries to eliminate the duplication of data wherever possible.  In this specific instance that means that the CEDS reference table, RefOperationalStatus needs to be further qualified to determine what Organization level is being referenced by the operational status.  So, when that occurs in CEDS we take the code value from that qualifying reference table and add it as the Table Filter value in the SSRD table.&#x20;

For this example, if you query the CEDS reference table directly you get the following:

SELECT \* FROM dbo.RefOperationalStatus

![A screenshot of a computer](<../../../.gitbook/assets/0 (4).png>)

If you look at the results of the query there are 2 codes = ‘Open’ – RefOperationalStatusId 1 and 9, there are 2 codes = ‘Closed’ - RefOperationalStatusId 2 and 10, etc..  The data in the 6th column, RefOperationalStatusTypeId, determines which of those values is appropriate depending on the type of Organization.  If you query that reference table you get the following:

SELECT \* FROM dbo.RefOperationalStatusType

![](<../../../.gitbook/assets/1 (2).png>)

To distinguish between the different types, Generate uses filters. The value ‘000174’ as the TableFilter is used when the Operational Status belongs to the LEA and ‘000533’ when the Operational Status belongs to the ‘School’.  Note, the last value ‘001418’ defines a generic organization and that is not used by Generate.&#x20;
