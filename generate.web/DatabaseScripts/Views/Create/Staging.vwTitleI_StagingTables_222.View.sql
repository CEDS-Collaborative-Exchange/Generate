CREATE VIEW [Staging].[vwTitleI_StagingTables_C222] 
AS
	SELECT	DISTINCT 
		      Stage.StudentIdentifierState
			, Stage.LEAIdentifierSeaAccountability
			, Stage.SchoolIdentifierSea
			
			--Foster
			, Stage.ProgramType_FosterCare

	FROM	[debug].[vwTitleI_StagingTables]				Stage

	WHERE 	Stage.ProgramType_FosterCare = 1
	AND		Stage.FosterCare_ProgramParticipationStartDate <= CAST('6/30/' + CAST(Stage.SchoolYear AS VARCHAR(4)) AS DATE)
	AND		ISNULL(Stage.FosterCare_ProgramParticipationEndDate, '1/1/9999') >= CAST('7/1/' + CAST(Stage.SchoolYear AS VARCHAR(4)) AS DATE)