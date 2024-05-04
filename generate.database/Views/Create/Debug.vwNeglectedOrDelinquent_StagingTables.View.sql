CREATE VIEW [debug].[vwNeglectedOrDelinquent_StagingTables] 
AS
	SELECT	DISTINCT 
		enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.FirstName
		, enrollment.LastOrSurname
		, enrollment.MiddleName
		, enrollment.SchoolYear
		
		--Neglected or Delinquent
		, nord.NeglectedOrDelinquentStatus
		, nord.NeglectedOrDelinquentProgramEnrollmentSubpart
		, nord.ProgramParticipationBeginDate
		, nord.ProgramParticipationEndDate
		, nord.NeglectedOrDelinquentProgramType
		, nord.NeglectedOrDelinquentAcademicAchievementIndicator
		, nord.NeglectedOrDelinquentAcademicOutcomeIndicator
		, nord.EdFactsAcademicOrCareerAndTechnicalOutcomeType	
		, nord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType
		, nord.DiplomaCredentialAwardDate
		, nord.ProgressLevel_Reading
		, nord.ProgressLevel_Math
		, nord.NeglectedProgramType
		, nord.DelinquentProgramType
		
	FROM Staging.K12Enrollment								enrollment		

	INNER JOIN Staging.ProgramParticipationNorD				nord
		ON		enrollment.StudentIdentifierState						=	nord.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(nord.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(nord.SchoolIdentifierSea, '')
		--AND		ISNULL(nord.ProgramParticipationEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	--WHERE 1 = 1
	--AND ISNULL(nord.EdFactsAcademicOrCareerAndTechnicalOutcomeType, '') <> ''
	--	OR ISNULL(nord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType, '') <> ''

