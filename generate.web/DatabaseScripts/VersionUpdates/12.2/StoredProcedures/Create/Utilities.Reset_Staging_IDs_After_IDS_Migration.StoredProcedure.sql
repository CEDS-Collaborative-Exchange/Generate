CREATE PROCEDURE [Utilities].[Reset_Staging_IDs_After_IDS_Migration]
	@table varchar(100) = NULL
	, @group varchar(100) = NULL
	, @printSQL bit = 0
AS

    /*************************************************************************************************************
    Date Created:  5/6/2020
		[Utilities].[Reset_Staging_IDs_After_IDS_Migration]
    Purpose:
		The purpose of this Stored Procedure is to reset the ID values that are written back to the staging tables 
		after a successful IDS migration.  This would be required if the IDS migration needs to be run again 
		using the data that was previously loaded into the staging tables and used in a migration.
	
		NOTE: This Stored Procedure would never need to be used for any of the migrations that have been converted
		to the Staging-to-RDS migration sprocess.
		
		If you run into issues using this stored procedure, execute it again passing 1 into the third parameter,
			@printSQL.  That will output the statement created by the dynamic sql.  Copy that into a separate query 
			window to examine it.

    Return Values:
    	 0	= Success
  
    Example Usage: 
		--Clear the Id values for a single specific staging migration table 		
			EXEC Utilities.[Reset_Staging_IDs_After_IDS_Migration] 'K12Organization';
		--Clear the Id values for a specific group of staging migration tables (All Organization tables or All Person tables)		
			EXEC Utilities.[Reset_Staging_IDs_After_IDS_Migration] NULL, 'Organization';  --valid options - Organization, Person
		--Clear the Id values for all of the staging migration tables
			EXEC Utilities.[Reset_Staging_IDs_After_IDS_Migration];
    
	  Notes:
		This SP operates on the assumption that the required extended properties exist on the staging tables.  This should be
			part of the standard Generate installation but you can check just in case the extended prperties have been 
			modified in some way.
			There are 2 to check for to determine if it's ready for this SP
			The table itself will have a property with @name=N'TableType', @value=N'Migration'	
			The ID fields will each have a property with @name=N'Identifier', @value=N'IDS' 

			Examples:
				EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration', 
						@level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization'
				EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', 
						@level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'LEAOrganizationId'

    Modification Log:
      #	  Date		  Issue#   Description
      --  ----------  -------  --------------------------------------------------------------------
      01  05/06/2020           First Release		
    *************************************************************************************************************/

BEGIN

	SET NOCOUNT OFF;

	--------------------------------------
	--Setup
	--------------------------------------

	--declare the sql variable
	declare @updSql nvarchar(max)

	--declare the temp table that will store the staging migration table names
	CREATE TABLE #stagingTables (
		Table_Name VARCHAR(100)
		, Table_Group VARCHAR(25)
	)

	--Load the list of staging migration tables into the temp table 
	INSERT INTO #stagingTables
	SELECT DISTINCT tbl.name
		, NULL	 
	FROM sys.tables tbl
		INNER JOIN sys.extended_properties ep
			ON ep.major_id = tbl.object_id 
			AND ep.class = 1
	WHERE SCHEMA_NAME(tbl.schema_id) = 'staging'
	and ep.name = 'TableType'
	and ep.value = 'Migration'

	--have to figure out how to grab this dynamically (lookup table, etc...)
	UPDATE #stagingTables
	SET Table_Group = CASE 
						WHEN Table_Name in ('K12Organization','OrganizationAddress','OrganizationCalendarSession',
							'OrganizationCustomSchoolIndicatorStatusType','OrganizationFederalFunding','OrganizationGradeOffered',
							'OrganizationPhone','OrganizationProgramType','OrganizationSchoolComprehensiveAndTargetedSupport',
							'OrganizationSchoolIndicatorStatus','CharterSchoolAuthorizer','CharterSchoolManagementOrganization','StateDetail',
							'K12SchoolComprehensiveSupportIdentificationType','K12SchoolTargetedSupportIdentificationType')
						THEN 'Organization'
						WHEN Table_Name in ('Assessment','AssessmentResult','Discipline','K12Enrollment','Migrant','PersonRace',
							'PersonStatus','ProgramParticipationCTE','ProgramParticipationNorD','ProgramParticipationSpecialEducation',
							'ProgramParticipationTitleI','ProgramParticipationTitleIII','K12StaffAssignment','StudentCourse')
						THEN 'Person'
						ELSE NULL
					END 

	--declare the cursor variables
	declare @csSchemaName varchar(25)
	declare @csTableName varchar(100)
	declare @csColumnName varchar(100)

	--declare the cursor dynamic sql variable 
	declare @csSql nvarchar(max) = NULL

	--declare the cursor and populate it
	set @csSql = '
		DECLARE IdField_cursor CURSOR FOR 
			
		SELECT distinct 
			SCHEMA_NAME(tbl.schema_id)	
			, tbl.[name]
			, col.[name]
		FROM 
			sys.tables tbl
			INNER JOIN sys.all_columns col 
				ON col.object_id = tbl.object_id
			INNER JOIN #stagingTables st
				ON st.Table_Name = tbl.[name]
			INNER JOIN sys.extended_properties ep 
				ON ep.major_id = tbl.object_id 
				AND ep.minor_id = col.column_id 
				AND ep.class = 1
		WHERE
			SCHEMA_NAME(tbl.schema_id) = ''staging''
			and ep.name = ''identifier''
			and ep.value = ''IDS'' 
			'
		--Add the Group if it was passed in
		IF isnull(@group, '') <> ''
		BEGIN
			set @csSql += ' and st.Table_Group = ''' + @group + ''' '
		END
		--Add the Table if it was passed in
		ELSE IF isnull(@table, '') <> ''
		BEGIN
			set @csSql += ' and st.Table_Name = ''' + @table + ''' '
		END

	if @printSQL = 1
	begin 
		print @csSql
	end
	else
	begin
		exec (@csSql)
	end

	--------------------------------------
	--Processing
	--------------------------------------

	--Clear the IDs for the requested tables
	BEGIN TRY

		--Open the cursor and then run the updates
		OPEN IdField_cursor
		FETCH NEXT FROM IDField_cursor INTO @csSchemaName, @csTableName, @csColumnName


		WHILE @@FETCH_STATUS = 0
		BEGIN

			set @updSql = 'UPDATE ' + @csSchemaName + '.' + @csTableName
			set @updSql += ' SET ' + @csColumnName + ' = NULL'

--			print @updSql 
			exec (@updSql)

			FETCH NEXT FROM IDField_cursor INTO @csSchemaName, @csTableName, @csColumnName

  		END
		CLOSE IdField_cursor
		DEALLOCATE IdField_cursor
			
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS [Error Message]
			,ERROR_LINE() AS ErrorLine
			,ERROR_STATE() AS [Error State]  	
	END CATCH

END