# Run the File Comparison

## Run the File Comparison Utility

The file comparison utility is a stored procedure executed within SSMS. When the file comparison utility is executed, a new table is created containing the results of the comparison. The new “comparison” table contains a row for every record in the Legacy and Generate files. Depending on the file specification, the table may include more details for any mismatched records.

A different procedure will be executed depending on the E&#x44;_&#x46;acts_ file specification to be compared.

### Comparing Directory Files

To compare C029 or C039 files, execute the following:

```sql
exec Utilities.Compare_DIRECTORY 
@DatabaseName = 'Generate', 	-- Your database name 
@SchemaName = 'XX', 		-- Your schema name 
@SubmissionYear = 2022, 		-- The report year
@ReportCode = '029', -- EdFacts File Number – either 029 or 039
@ReportLevel = 'LEA', -- 'SEA', 'LEA', 'SCH' 
@LegacyTableName = 'Generate.XX.029_LEA_2022_Legacy', -- Legacy table
@ShowSQL = 0 
```

### Comparing Discipline Files

To compare 005, 006, 007, 088, 143, or 144 files, execute the following:

```sql
exec Utilities.Compare_DISCIPLINE
@DatabaseName = 'Generate', 	-- Your database name 
@SchemaName = 'XX', 		-- Your schema name 
@SubmissionYear = 2022, 	-- The report year
@ReportCode = '005', -- EdFacts File Number – 005, 006, 007, 088, 143, 144
@ReportLevel = 'LEA', -- 'SEA', 'LEA'
@LegacyTableName = 'Generate.XX.005_LEA_2022_Legacy', -- Legacy table
@ShowSQL = 0
```

### Comparing Child Count Files

To compare 002 or 089 files, execute the following:

```sql
exec Utilities.Compare_CHILDCOUNT 
@DatabaseName = 'Generate', 	-- Your database name 
@SchemaName = 'XX', 		-- Your schema name 
@SubmissionYear = 2022, 		-- The report year
@ReportCode = '089', -- EdFacts File Number – either 002 or 089
@ReportLevel = 'LEA', -- 'SEA', 'LEA', 'SCH' 
@LegacyTableName = 'Generate.XX.C089_LEA_2022_Legacy', -- Legacy table
@ShowSQL = 0
```

### Comparing Exiting Files

To compare 009 files, execute the following:

```sql
exec Utilities.Compare_EXITING
@DatabaseName = 'Generate', 	-- Your database name 
@SchemaName = 'XX', 		-- Your schema name 
@SubmissionYear = 2022, 	-- The report year
@ReportCode = '009', -- EdFacts File Number – 009
@ReportLevel = 'LEA', -- 'SEA', 'LEA' 
@LegacyTableName = 'Generate.XX.009_LEA_2022_Legacy', -- Legacy table
@ShowSQL = 0
```

### Comparing All Other Files

To compare other E&#x44;_&#x46;acts_ files, execute the following:

```sql
exec Utilities.CompareSubmissionFiles 
@DatabaseName = 'Generate', 	-- Your database name 
@SchemaName = 'XX', 		-- Your schema name 
@SubmissionYear = 2022, 		-- The report year
@ReportCode = '005', -- EdFacts File Number
@ReportLevel = 'LEA', -- 'SEA', 'LEA', 'SCH' 
@LegacyTableName = 'Generate.XX.005_LEA_2022_Legacy', -- Legacy table
@GenerateTableName = 'Generate.XX.005_LEA_2022_Generate', -- Generate table
@ShowSQL = 0, 
@ComparisonResultsTableName = NULL
```
