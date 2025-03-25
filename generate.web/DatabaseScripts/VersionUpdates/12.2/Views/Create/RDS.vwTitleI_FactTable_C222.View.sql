CREATE VIEW [RDS].[vwTitleI_FactTable_C222] 
AS
	SELECT	DISTINCT 
		      Fact.K12StudentStudentIdentifierState
			, Fact.LeaIdentifierSea
			, Fact.LeaOrganizationName
			
			--Foster
			, Fact.ProgramParticipationFosterCareEdFactsCode

 	FROM	[debug].[vwTitleI_FactTable]					Fact

	WHERE 	Fact.ProgramParticipationFosterCareEdFactsCode = 'FOSTERCARE'