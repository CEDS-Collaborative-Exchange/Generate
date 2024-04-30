CREATE VIEW [debug].[vwNeglectedOrDelinquent_StagingTables] 
AS
	SELECT	DISTINCT 
		enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.FirstName
		, enrollment.LastOrSurname
		, enrollment.MiddleName

		--Neglected or Delinquent
		, nord.NeglectedOrDelinquentAcademicAchievementIndicator
		, nord.NeglectedOrDelinquentAcademicOutcomeIndicator
		, nord.EdFactsAcademicOrCareerAndTechnicalOutcomeType	
		, nord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType
		, nord.ProgramParticipationBeginDate
		, nord.ProgramParticipationEndDate
		, nord.NeglectedOrDelinquentExitOutcomeDate
		, nord.DiplomaCredentialAwardDate
		 
	FROM Staging.K12Enrollment								enrollment		

	INNER JOIN Staging.ProgramParticipationNorD				nord
		ON		enrollment.StudentIdentifierState						=	nord.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(nord.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(nord.SchoolIdentifierSea, '')
		AND		ISNULL(nord.ProgramParticipationEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	WHERE 1 = 1
	AND ISNULL(nord.EdFactsAcademicOrCareerAndTechnicalOutcomeType, '') <> ''
		OR ISNULL(nord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType, '') <> ''
