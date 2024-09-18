CREATE PROCEDURE [App].[Migrate_Data_Validation_Logging]
	  @eStoredProc VARCHAR(500)
	, @eTable VARCHAR(100)
	, @ColumnName VARCHAR(500)
	, @eSimpleMessage VARCHAR(500)
AS

/*************************************************************************************************************
Date Created:  3/19/2019

Purpose: Insert validation error log records into the Validation Errors table.  

Assumptions: This stored procedure will only be called when an error has occured in the execution of ETL code. 
If this is used more universally then the following changes will need to be made:
1. ErrorGroup value will need to be passed as a parameter instead of manually set to 1. 
2. Identifier value will need to be passed as a parameter instead of manually set to NULL. 
 
Account executed under: LOGIN

Approximate run time:  ~ 1 millisecond.

Data Sources:  N/A

Data Targets:  Generate Database:   Staging.ValidationErrors

Return Values: N/A
  
Error Group
1	Code Execution Failure
2	Table Did Not Populate
3	Field Required But Not Populated
4	Source Value Not In The ODS
*************************************************************************************************************/
BEGIN

DECLARE @eDetailMessage		varchar(500)

SET @eDetailMessage = ERROR_MESSAGE() 

	INSERT INTO [Staging].[ValidationErrors] VALUES 
	(@eStoredProc		 -- Field: ProcessName
	, @eTable			 -- Field: TableName
	, @ColumnName		 -- Field: ElementName
	, @eSimpleMessage	 -- Field: ErrorSimple
	, @eDetailMessage	 -- Field: ErrorDetail
	, 1					 -- Field: ErrorGroup
	, NULL				 -- Field: Identifier
	, NULL				 -- Field: CreateDate - This is populated after each Migration Step executes 
	)


END
