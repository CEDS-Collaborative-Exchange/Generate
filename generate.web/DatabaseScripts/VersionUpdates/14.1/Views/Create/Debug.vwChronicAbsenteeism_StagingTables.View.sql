CREATE VIEW [debug].[vwChronicAbsenteeism_StagingTables] 
AS
	SELECT DISTINCT	
		enrollment.SchoolYear
		, enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.FirstName
		, enrollment.LastOrSurname
		, enrollment.MiddleName
		, enrollment.Sex
		, enrollment.HispanicLatinoEthnicity
		, enrollment.NumberOfDaysInAttendance
		, enrollment.NumberOfDaysAbsent
		, enrollment.AttendanceRate
		
		, el.EnglishLearnerStatus
		, el.EnglishLearner_StatusStartDate
		, el.EnglishLearner_StatusExitDate
				
		, ecoDis.EconomicDisadvantageStatus
		, ecoDis.EconomicDisadvantage_StatusStartDate
		, ecoDis.EconomicDisadvantage_StatusExitDate
				
		, homeless.HomelessnessStatus
		, homeless.Homelessness_StatusStartDate
		, homeless.Homelessness_StatusExitDate
				
		, sec504.Section504Status
				
		, idea.IDEAIndicator
		, idea.ProgramParticipationStartDate
		, idea.ProgramParticipationExitDate
				
		, race.RaceType
		, race.RecordStartDateTime
		, race.RecordEndDateTime

	FROM Staging.K12Enrollment								enrollment
	LEFT JOIN Staging.PersonStatus							el
			ON		enrollment.StudentIdentifierState						=	el.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(el.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(el.SchoolIdentifierSea, '')
			-- 14.1: match the fact proc's EL window (StatusStartDate within the enrollment span)
			AND		el.EnglishLearner_StatusStartDate BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear))

	LEFT JOIN Staging.PersonStatus							ecoDis
			ON		enrollment.StudentIdentifierState						=	ecoDis.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(ecoDis.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(ecoDis.SchoolIdentifierSea, '')
			-- 14.1: match the fact proc's econ-disadvantage window (StatusStartDate within enrollment span)
			AND		ecoDis.EconomicDisadvantage_StatusStartDate BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear))

	LEFT JOIN Staging.PersonStatus							homeless
			ON		enrollment.StudentIdentifierState						=	homeless.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(homeless.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(homeless.SchoolIdentifierSea, '')
			-- 14.1: match the fact proc's homelessness window (StatusStartDate within enrollment span)
			AND		homeless.Homelessness_StatusStartDate BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear))

	LEFT JOIN Staging.Disability							sec504
			ON		enrollment.SchoolYear									=	sec504.SchoolYear
			AND		enrollment.StudentIdentifierState						=	sec504.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(sec504.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(sec504.SchoolIdentifierSea, '')
			-- 14.1: no Disability_StatusExitDate window — the ChronicAbsenteeism fact proc's
			-- #tempDisabilityStatus applies none, so windowing Section504 here mis-bucketed ~178
			-- students into MISSING-504 versus the fact/report actual (FS195 expected-vs-actual).

	LEFT JOIN Staging.ProgramParticipationSpecialEducation	idea
			ON		enrollment.StudentIdentifierState						=	idea.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(idea.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(idea.SchoolIdentifierSea, '')
			-- 14.1: match the ChronicAbsenteeism fact proc's IDEA window (ParticipationStartDate
			-- within the enrollment span), not ExitDate>=EntryDate, which under-counted IDEA vs the fact.
			AND		idea.ProgramParticipationStartDate BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear))

	LEFT JOIN Staging.K12PersonRace							race
			ON		enrollment.SchoolYear									=	race.SchoolYear
			AND		enrollment.StudentIdentifierState						=	race.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(race.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(race.SchoolIdentifierSea, '')
			AND		ISNULL(race.RecordEndDateTime, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	WHERE 1 = 1
	AND	
		CAST((CASE WHEN enrollment.NumberOfDaysInAttendance = '0' THEN 0
				WHEN enrollment.NumberOfDaysAbsent = '0' THEN 1
				ELSE CAST(enrollment.NumberOfDaysInAttendance - enrollment.NumberOfDaysAbsent  AS decimal(5,2)) / CAST(enrollment.NumberOfDaysInAttendance AS decimal(5,2))
			END) AS decimal(5,4)) <= 0.9



