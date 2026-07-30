CREATE VIEW [debug].[vwDropout_StagingTables] 
AS
	SELECT	DISTINCT
		enrollment.SchoolYear
		, enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.FirstName
		, enrollment.LastOrSurname
		, enrollment.MiddleName
		, enrollment.Sex
		, enrollment.HispanicLatinoEthnicity
		, enrollment.GradeLevel

		, el.EnglishLearnerStatus
		, el.EnglishLearner_StatusStartDate
		, el.EnglishLearner_StatusExitDate

		, ecoDis.EconomicDisadvantageStatus
		, ecoDis.EconomicDisadvantage_StatusStartDate
		, ecoDis.EconomicDisadvantage_StatusExitDate
				
		, homeless.HomelessnessStatus
		, homeless.Homelessness_StatusStartDate
		, homeless.Homelessness_StatusExitDate
				
		, migrant.MigrantStatus
		, migrant.ProgramParticipationStartDate					Migrant_ProgramParticipationStartDate
		, migrant.ProgramParticipationExitDate					Migrant_ProgramParticipationExitDate
				
		, idea.IDEAIndicator
		, idea.ProgramParticipationStartDate					IDEA_ProgramParticipationStartDate
		, idea.ProgramParticipationExitDate						IDEA_ProgramParticipationExitDate
				
		, race.RaceType
		, race.RecordStartDateTime
		, race.RecordEndDateTime

	FROM Staging.K12Enrollment								enrollment
	LEFT JOIN Staging.Migrant								migrant
		ON		enrollment.StudentIdentifierState						=	migrant.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(migrant.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(migrant.SchoolIdentifierSea, '')
		-- 14.1: match the dropout fact proc's overlap window (status overlaps the enrollment span)
		AND		((migrant.ProgramParticipationStartDate <= enrollment.EnrollmentEntryDate AND ISNULL(migrant.ProgramParticipationExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear)) > enrollment.EnrollmentEntryDate)
				OR (migrant.ProgramParticipationStartDate > enrollment.EnrollmentEntryDate AND migrant.ProgramParticipationStartDate < ISNULL(enrollment.EnrollmentExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear))))

	LEFT JOIN Staging.PersonStatus							el
		ON		enrollment.StudentIdentifierState						=	el.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(el.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(el.SchoolIdentifierSea, '')
		AND		((el.EnglishLearner_StatusStartDate <= enrollment.EnrollmentEntryDate AND ISNULL(el.EnglishLearner_StatusExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear)) > enrollment.EnrollmentEntryDate)
				OR (el.EnglishLearner_StatusStartDate > enrollment.EnrollmentEntryDate AND el.EnglishLearner_StatusStartDate < ISNULL(enrollment.EnrollmentExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear))))

	LEFT JOIN Staging.PersonStatus							ecoDis
		ON		enrollment.StudentIdentifierState						=	ecoDis.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(ecoDis.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(ecoDis.SchoolIdentifierSea, '')
		AND		((ecoDis.EconomicDisadvantage_StatusStartDate <= enrollment.EnrollmentEntryDate AND ISNULL(ecoDis.EconomicDisadvantage_StatusExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear)) > enrollment.EnrollmentEntryDate)
				OR (ecoDis.EconomicDisadvantage_StatusStartDate > enrollment.EnrollmentEntryDate AND ecoDis.EconomicDisadvantage_StatusStartDate < ISNULL(enrollment.EnrollmentExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear))))

	LEFT JOIN Staging.PersonStatus							homeless
		ON		enrollment.StudentIdentifierState						=	homeless.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(homeless.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(homeless.SchoolIdentifierSea, '')
		AND		((homeless.Homelessness_StatusStartDate <= enrollment.EnrollmentEntryDate AND ISNULL(homeless.Homelessness_StatusExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear)) > enrollment.EnrollmentEntryDate)
				OR (homeless.Homelessness_StatusStartDate > enrollment.EnrollmentEntryDate AND homeless.Homelessness_StatusStartDate < ISNULL(enrollment.EnrollmentExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear))))

	LEFT JOIN Staging.ProgramParticipationSpecialEducation	idea
		ON		enrollment.StudentIdentifierState						=	idea.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(idea.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(idea.SchoolIdentifierSea, '')
		AND		((idea.ProgramParticipationStartDate <= enrollment.EnrollmentEntryDate AND ISNULL(idea.ProgramParticipationExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear)) > enrollment.EnrollmentEntryDate)
				OR (idea.ProgramParticipationStartDate > enrollment.EnrollmentEntryDate AND idea.ProgramParticipationStartDate < ISNULL(enrollment.EnrollmentExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear))))

	LEFT JOIN Staging.K12PersonRace							race
		ON		enrollment.SchoolYear									=	race.SchoolYear
		AND		enrollment.StudentIdentifierState						=	race.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(race.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(race.SchoolIdentifierSea, '')
		AND		ISNULL(race.RecordEndDateTime, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	LEFT JOIN Staging.SourceSystemReferenceData sssrd
		ON sssrd.SchoolYear = enrollment.SchoolYear
		AND sssrd.TableName = 'RefExitOrWithdrawalType'
		AND enrollment.ExitOrWithdrawalType = sssrd.InputCode

	WHERE 1 = 1
	AND sssrd.OutputCode = 01927  --need to verify if more codes need to be included

	--09927 - Discontinued schooling
	