CREATE VIEW [Staging].[vwTitleI_StagingTables_222] 
AS
	SELECT	DISTINCT 
		     
			
			 Stage.StudentIdentifierState
			, Stage.LEAIdentifierSeaAccountability
			, Stage.SchoolIdentifierSea
			
			--Foster
			, Stage.ProgramType_FosterCare

			-- School
			, SchoolOperationalStatus
			, SchoolTypeCode
			


	FROM [debug].[vwTitleI_StagingTables]				Stage
	
	WHERE 	Stage.ProgramType_FosterCare = 1 
	AND		SchoolOperationalStatus IN ('Open','New') 
	AND		SchoolTypeCode in ('CareerAndTechnical','Alternative','Special','Regular')
	--AND		ISNULL(Stage.ProgramParticipationEndDate, Stage.EnrollmentExitDate) >= Stage.EnrollmentEntryDate
	AND		RefTitleISchoolStatus in ('TGELGBTGPROG', 'SWELIGTGPROG', 'SWELIGSWPROG')