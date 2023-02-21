CREATE PROCEDURE [App].[Migrate_Data_Validation]
	  @eStoredProc VARCHAR(100)
	, @eTable VARCHAR(100)
	, @SchoolYear SMALLINT
AS

/*************************************************************************************************************
Date Created:  2/12/2018

Purpose:
    This stored procedure contains all of the validation rules for the Staging tables and populates the Staging.ValidationErrors table

Assumptions:
        

Account executed under: LOGIN

Approximate run time:  ~ 5 seconds

Data Sources:  Staging tables in the generate database

Data Targets:  Generate Database:   Staging.ValidationErrors

Return Values:
    	0	= Success
    All Errors are Thrown via Try/Catch Block	
  
Example Usage: 
    EXEC App.[Migrate_Data_Validation];
    
Modification Log:
    #	  Date		    Developer	  Issue#	 Description
    --  ----------  ----------  -------  --------------------------------------------------------------------
    01		  	 
*************************************************************************************************************/
BEGIN

	--Delete records from the previous run for this ETL & Table Name
	DELETE FROM Staging.ValidationErrors 
	WHERE ProcessName = @eStoredProc 
	AND TableName = @eTable

	--------------------------------------------------------------------------
    --Table-Level Errors -----------------------------------------------------
    --------------------------------------------------------------------------

	--Error Group 2: Table Did Not Populate 
	DECLARE @ColumnName VARCHAR(100), @SQL VARCHAR(MAX), @PrimaryKeyField VARCHAR(100)
		
	SELECT @PrimaryKeyField = Col.Column_Name 
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab
	JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
		ON Col.Constraint_Name = Tab.Constraint_Name
	WHERE Col.Table_Name = Tab.Table_Name
		AND Constraint_Type = 'PRIMARY KEY'
		AND Col.TABLE_SCHEMA = 'Staging'
		AND Col.Table_Name = @eTable

		
	SET @SQL = 'IF (SELECT COUNT(*) FROM Staging.' + @eTable + ') = 0 BEGIN INSERT INTO Staging.ValidationErrors VALUES (''' + @eStoredProc + ''', ''' + @eTable + ''', NULL, ''Table Did Not Populate'', ''"' + @eTable + '" table did not populate'', 2, NULL, NULL) END'

	EXECUTE(@SQL)

	--------------------------------------------------------------------------
    --Field-Level Errors -----------------------------------------------------
    --------------------------------------------------------------------------

	DECLARE SourceColumnList CURSOR FOR
	
	--Get list of fields that are Required or Lookup (meaning values should match an option set in CEDS) 
	SELECT DISTINCT C.Name 
	FROM sys.extended_properties EP
	LEFT JOIN sys.all_objects O ON ep.major_id = O.object_id 
	LEFT JOIN sys.schemas S on O.schema_id = S.schema_id
	LEFT JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
	WHERE S.Name = 'Staging' 
		AND O.Name = @eTable
		AND ep.Name = 'Lookup'
		--AND (ep.Name = 'Lookup'
		--	OR ep.Name = 'Required')

	--Loop through the list of Required or Lookup fields 
	OPEN SourceColumnList

	FETCH NEXT FROM SourceColumnList
	INTO @ColumnName

	WHILE @@FETCH_STATUS = 0  
	BEGIN	



		--Error Group 3: Field Required But Not Populated 
		--SET @SQL = 'INSERT INTO Staging.ValidationErrors SELECT ''' + @eStoredProc + ''', ''' + @eTable + ''', ''' + @ColumnName + ''', ''' + @ColumnName + ' is required, but a record was found without a value'', ' + @PrimaryKeyField + ', NULL FROM Staging.' + @eTable + ' WHERE ' + @ColumnName + ' IS NULL'
		--SET @SQL = 'INSERT INTO Staging.ValidationErrors SELECT ''' + @eStoredProc + ''', ''' + @eTable + ''', ''' + @ColumnName + ''', ''Field Required But Not Populated'', ''' + @ColumnName + ' is required, but a record was found without a value'', 3, ' + @PrimaryKeyField + ', NULL FROM Staging.' + @eTable + ' WHERE ' + @ColumnName + ' IS NULL'
		
		EXECUTE(@SQL)


		--Error Group 4: Source Value Not In CEDS Option Set 
		-- Validate that all lookup values have a corresponding value in ODS.SourceSystemReferenceData
		DECLARE @LookupTable VARCHAR(100), @TableFilter VARCHAR(100)
		SET @LookupTable = NULL
		SET @TableFilter = NULL

		SELECT @LookupTable = CONVERT(VARCHAR(100), ep.Value)
		FROM sys.extended_properties EP
		JOIN sys.all_objects O ON ep.major_id = O.object_id 
		JOIN sys.schemas S on O.schema_id = S.schema_id
		JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
		WHERE S.Name = 'Staging' 
			AND O.Name = @eTable 
			AND C.Name = @ColumnName 
			AND ep.Name = 'Lookup'

		SELECT @TableFilter = CONVERT(VARCHAR(100), ep.Value)
		FROM sys.extended_properties EP
		JOIN sys.all_objects O ON ep.major_id = O.object_id 
		JOIN sys.schemas S on O.schema_id = S.schema_id
		JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
		WHERE S.Name = 'Staging' 
			AND O.Name = @eTable 
			AND C.Name = @ColumnName 
			AND ep.Name = 'TableFilter'

		IF (@LookupTable IS NOT NULL AND @LookupTable <> '') BEGIN
			SET @SQL = 'INSERT INTO Staging.ValidationErrors '
			SET @SQL = @SQL + 'SELECT ''' + @eStoredProc + ''', ''' + @eTable + ''', ''' + @ColumnName + ''', ''Source Value Not In CEDS Option Set'', ''No match for lookup value "'' + stg.' + @ColumnName + ' + ''" in ODS.SourceSystemReferenceData for Staging.' + @eTable + '.' + @ColumnName + ''', 4,' + @PrimaryKeyField + ', NULL '
			SET @SQL = @SQL + 'FROM Staging.' + @eTable + ' stg '
			SET @SQL = @SQL + 'LEFT JOIN ODS.SourceSystemReferenceData ref ON ref.TableName = ''' + @LookupTable + ''' AND InputCode = stg.' + @ColumnName + ' '
			IF (@TableFIlter IS NOT NULL) BEGIN
				SET @SQL = @SQL + ' AND ref.TableFilter = ''' + @TableFilter + ''' '
			END
			SET @SQL = @SQL + 'WHERE stg.' + @ColumnName + ' IS NOT NULL AND ref.OutputCode IS NULL'

			EXECUTE(@SQL)
		END

		
		FETCH NEXT FROM SourceColumnList
		INTO @ColumnName
	END 

	DEALLOCATE SourceColumnList
			
	--Error Group 5: OperationalStatusEffectiveDate 
	DECLARE @LEAId VARCHAR(100), @LEAName VARCHAR(100), @SchoolId VARCHAR(100), @SchoolName VARCHAR(100)

	---------------------
	--LEA
	---------------------
	DECLARE LEAIdList_cursor CURSOR FOR
	
	--Get list of LEAs with invalid LEA_OperationalStatusEffectiveDate values
	SELECT DISTINCT LEA_Identifier_State, LEA_Name
	FROM staging.Organization 
	WHERE LEA_OperationalStatusEffectiveDate NOT BETWEEN LEA_RecordStartDateTime AND ISNULL(LEA_RecordEndDateTime, GETDATE())

	--Loop through the LEAs with potential Op Status Date issues 
	OPEN LEAIdList_cursor

	FETCH NEXT FROM LEAIdList_cursor
	INTO @LEAId, @LEAName

	WHILE @@FETCH_STATUS = 0  
	BEGIN	

		INSERT INTO Staging.ValidationErrors
		(
		    ProcessName,
		    TableName,
		    ElementName,
		    ErrorSimple,
		    ErrorDetail,
		    ErrorGroup,
		    Identifier,
		    CreateDate
		)
		VALUES
		(	
			@eStoredProc								-- ProcessName
		    , 'Staging.Organization'					-- TableName
		    , 'LEA_OperationalStatusEffectiveDate'      -- ElementName
		    , 'Check Organization Dates'				-- ErrorSimple
		    , 'LEA_OperationalStatusEffectiveDate is out of range for LEA_RecordStartDateTime and LEA_RecordEndDateTime'       -- ErrorDetail
		    , 5											-- ErrorGroup
		    , CONCAT(@LEAId, '/', @LEAName)				-- Identifier
		    , GETDATE()									-- CreateDate
		)	

		FETCH NEXT FROM LEAIdList_cursor
		INTO @LEAId, @LEAName
	END 

	DEALLOCATE LEAIdList_cursor

	---------------------
	--School
	---------------------
	DECLARE SchoolIdList_cursor CURSOR FOR
	
	--Get list of Schools with invalid School_OperationalStatusEffectiveDate values
	SELECT DISTINCT School_Identifier_State, School_Name
	FROM staging.Organization 
	WHERE School_OperationalStatusEffectiveDate NOT BETWEEN School_RecordStartDateTime AND ISNULL(School_RecordEndDateTime, GETDATE())

	--Loop through the Schools with potential Op Status Date issues 
	OPEN SchoolIdList_cursor

	FETCH NEXT FROM SchoolIdList_cursor
	INTO @SchoolId, @SchoolName

	WHILE @@FETCH_STATUS = 0  
	BEGIN	

		INSERT INTO Staging.ValidationErrors
		(
		    ProcessName,
		    TableName,
		    ElementName,
		    ErrorSimple,
		    ErrorDetail,
		    ErrorGroup,
		    Identifier,
		    CreateDate
		)
		VALUES
		(	
			@eStoredProc								-- ProcessName
		    , 'Staging.Organization'					-- TableName
		    , 'School_OperationalStatusEffectiveDate'   -- ElementName
		    , 'Check Organization Dates'				-- ErrorSimple
		    , 'School_OperationalStatusEffectiveDate is out of range for School_RecordStartDateTime and School_RecordEndDateTime'       -- ErrorDetail
		    , 5											-- ErrorGroup
		    , CONCAT(@SchoolId, '/', @SchoolName)		-- Identifier
		    , GETDATE()									-- CreateDate
		)	

		FETCH NEXT FROM SchoolIdList_cursor
		INTO @SchoolId, @SchoolName
	END 

	DEALLOCATE SchoolIdList_cursor

	-------------------
	--Wrap Up
	-------------------
	--Apply the same getdate/time to every record recorded for this ETL & Table Name
	UPDATE Staging.ValidationErrors
	SET CreateDate = GETDATE()
	WHERE ProcessName = @eStoredProc
	AND TableName = @eTable

END

