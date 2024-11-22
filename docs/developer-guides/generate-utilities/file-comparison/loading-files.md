# Loading Files

## Loading Legacy Files into a SQL Table

Depending on your server configurations, there are several methods for loading a legacy file into a table.&#x20;

1. If your SQL instance has the bulk copy program (BCP) enabled, you can use a utility in Generate to load the file directly into a table.&#x20;
2. If your SQL instances does not have BCP enabled, you can use the Generate utility to create an empty table and then import the file using whatever method you prefer.

{% hint style="info" %}
Generate expects 100 characters for every field. Errors will occur if SEA data's character counts go over 100 characters.
{% endhint %}

### Create an Empty SQL Table for the Legacy File

Execute the following SQL statement in SSMS to create an EMPTY table for the file specification:

```sql
exec Utilities.CreateSubmissionFileTable 
@DatabaseName = 'Generate', 	-- Your database name 
@SchemaName = 'XX', 		-- Your schema name 
@SubmissionYear = 2022, 		-- The report year
@ReportCode = 'C002', 		-- EdFacts File Number 
@ReportLevel = 'LEA', 		-- 'SEA', 'LEA', 'SCH' 
@Label = 'Legacy', 
@ShowSQL = 0, 
@CreatedTableName = NULL
```

<table><thead><tr><th width="213">Parameter</th><th>Description</th></tr></thead><tbody><tr><td><strong>@DatabaseName</strong></td><td>Is the name of the database where your table will be created.  This can be the Generate database.</td></tr><tr><td><strong>@SchemaName</strong></td><td>Is the schema within the database where the table will be created.  If the database is Generate, states often create a schema named as their state code (i.e., “VT”, “MT”, “IL”, etc.). This provides a separate location for these comparison files that do not interfere with other Generate tables.</td></tr><tr><td><strong>@SubmissionYear</strong></td><td>The year of the report</td></tr><tr><td><strong>@ReportCode</strong></td><td>The report code</td></tr><tr><td><strong>@ReportLevel</strong></td><td>The report level (SEA, LEA, SCH)</td></tr><tr><td><strong>@Label</strong> </td><td>Identifier to distinguish that this is a legacy file. Typically, “Legacy” is used.</td></tr><tr><td><strong>@ShowSQL</strong></td><td>Used for debugging purposes if the utility fails to execute. Set this to 1 to view the dynamic SQL that is produced in this utility, otherwise set it to 0.</td></tr><tr><td><strong>@CreatedTableName</strong></td><td>An output parameter that will be returned from the procedure to show you the name of the table that is created</td></tr></tbody></table>

***

### Loading a Legacy File When BCP is Enabled

If BCP is enabled on your server, you can execute the following SQL command to load the ED_Facts_ file into the table created in the previous step:

```sql
exec Utilities.LoadSubmissionFileTable 
@TargetTableName = 'Generate.XX.C002_LEA_2022_Legacy', -- Existing table 
@SourceFilePathAndName = 'D:\EdFactsFiles\C002LEA2022.tab', -- Your file 
@FileType = 'Tab', -- 'Tab', 'CSV' 
@ShowSQL = 0
```

<table><thead><tr><th width="264">Parameter</th><th>Description</th></tr></thead><tbody><tr><td><strong>@TargetTableName</strong></td><td>The name of the table where the file should be loaded. This would be the table created in the previous step.</td></tr><tr><td><strong>@SourceFilePathName</strong></td><td>The fully qualified path to the file to be loaded.</td></tr><tr><td><strong>@FileType</strong></td><td>Can be “TAB” or “CSV”, depending on the format of the file being imported.</td></tr><tr><td><strong>@ReportCode</strong></td><td>The report code</td></tr><tr><td><strong>@ReportLevel</strong></td><td>The report level (SEA, LEA, SCH)</td></tr><tr><td><strong>@Label</strong></td><td>Some identifier to distinguish that this is a legacy file.  Typically, “Legacy” is used.</td></tr><tr><td><strong>@ShowSQL</strong></td><td>Used for debugging purposes if the utility fails to execute. Set this to 1 to view the dynamic SQL that is produced in this utility, otherwise set it to 0.</td></tr></tbody></table>

{% hint style="info" %}
You will need to remove the header row from the file prior to loading it into SQL Server.
{% endhint %}

***

### Loading a Legacy File When BCP is NOT Enabled

If BPC is not enabled on your server, you will need to import the file into the table created earlier using whatever utility you have available. This could be the SQL Import tool or some other utility. Make sure to remove or ignore the header row when importing the file.

***

## Loading Generate Files into a Table

The submission file comparison process was originally developed to require that the Generate submission files be created and then imported back into a SQL table to do the comparison to the Legacy files.

The process has been updated for several file specifications to not require those files to be loaded back into a SQL table – instead, the file submission process will use data directly from the Generate Reports tables to populate a comparison table.

As of Generate v11.4, the following files do NOT require that a Generate file be imported into a table to do a file comparison to a Legacy file:

* DIRECTORY - FS029, FS039
* CHILD COUNT - FS002, FS089
* EXITING – FS009
* DISCIPLINE – FS005, FS006, FS007, FS088, FS143, FS144

{% hint style="success" %}
Generate v12 will include:

* ASSESSMENT – FS175, FS178, FS179, FS185, FS188, FS189
{% endhint %}

For all other file specifications, follow the same steps as loading a Legacy file into a SQL table (previous section of this document), but switch the @Label parameter from “Legacy” to “Generate” and load the Generate-produced file into that table.
