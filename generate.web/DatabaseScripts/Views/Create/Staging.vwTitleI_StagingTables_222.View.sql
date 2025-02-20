CREATE VIEW [Staging].[vwTitleI_StagingTables_222] 
AS
	SELECT	DISTINCT 
		     
			
			 Stage.StudentIdentifierState
			, Stage.LEAIdentifierSeaAccountability
			, Stage.SchoolIdentifierSea
			
			--Foster
			, Stage.ProgramType_FosterCare

			-- School
			-- , SchoolOperationalStatus
			-- , SchoolTypeCode
			
	FROM [debug].[vwTitleI_StagingTables]				Stage
	
	WHERE 	Stage.ProgramType_FosterCare = 1 
