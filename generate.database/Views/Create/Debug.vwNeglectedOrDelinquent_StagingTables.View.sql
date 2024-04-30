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
		, nord.NeglectedOrDelinquentAcademicOutcomeIndicator
--At the time of creation, the following field was not present in the staging table
		, nord.NeglectedOrDelinquentAcademicAchievementIndicator
		, nord.ProgramParticipationBeginDate
		, nord.ProgramParticipationEndDate
		, nord.NeglectedOrDelinquentProgramType
--At the time of creation, the following field was not present in the staging table
		, nord.NeglectedProgramType
--At the time of creation, the following field was not present in the staging table
		, nord.DelinquentProgramType
		, nord.DiplomaCredentialAwardDate
		 
	FROM Staging.K12Enrollment								enrollment		

	INNER JOIN Staging.ProgramParticipationNorD				nord
		ON		enrollment.StudentIdentifierState						=	nord.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(nord.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(nord.SchoolIdentifierSea, '')
		AND		ISNULL(nord.ProgramParticipationEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	WHERE 1 = 1
	AND nord.NeglectedOrDelinquentAcademicOutcomeIndicator = 1
		OR nord.NeglectedOrDelinquentAcademicAchievementIndicator = 1
