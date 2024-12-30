CREATE VIEW [debug].[vwTitleI_StagingTables] 
AS
		SELECT	DISTINCT 
		  enrollment.SchoolYear
		, enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.FirstName
		, enrollment.LastOrSurname
		, enrollment.MiddleName
		, enrollment.HispanicLatinoEthnicity
		, enrollment.EnrollmentExitDate
		, enrollment.EnrollmentEntryDate
	
		, sssrd.OutputCode as School_TitleISchoolStatus	
		, sssrd2.OutputCode as TitleIIndicator	

		, el.EnglishLearnerStatus
		, el.EnglishLearner_StatusStartDate
		, el.EnglishLearner_StatusEndDate

		, homeless.HomelessnessStatus
		, homeless.Homelessness_StatusStartDate
		, homeless.Homelessness_StatusEndDate
				
		, migrant.MigrantStatus
		, migrant.ProgramParticipationStartDate
		, migrant.ProgramParticipationExitDate
				
		, idea.IDEAIndicator
		, idea.ProgramParticipationBeginDate
		, idea.ProgramParticipationEndDate

		, foster.ProgramType_FosterCare	
		, foster.FosterCare_ProgramParticipationStartDate
		, foster.FosterCare_ProgramParticipationEndDate

		, race.RaceType
		, race.RecordStartDateTime
		, race.RecordEndDateTime
		, sssrd1.OutputCode AS SchoolOperationalStatus
		, Schools.School_Type --Do I need to use the sssrd3
		, sssrd3.OutputCode AS SchoolTypeCode
	
		,titleI.ProgramParticipationBeginDate titleI_ProgramParticipationBeginDate
		,titleI.ProgramParticipationEndDate titleI_ProgramParticipationEndDate
		,sssrd.OutputCode AS RefTitleISchoolStatus
		
		
	FROM Staging.K12Enrollment								enrollment
	JOIN Staging.K12Organization							Schools
		ON		enrollment.SchoolIdentifierSea							=	Schools.SchoolIdentifierSea
		AND 	enrollment.SchoolYear									=	Schools.SchoolYear

	JOIN Staging.ProgramParticipationTitleI					titleI
		ON		enrollment.StudentIdentifierState						=	titleI.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(titleI.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(titleI.SchoolIdentifierSea, '')
		AND		ISNULL(titleI.ProgramParticipationEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate
		--AND (titleI.ProgramParticipationBeginDate <= enrollment.EnrollmentEntryDate 
		--AND ISNULL(titleI.ProgramParticipationEndDate, GETDATE()) >= enrollment.EnrollmentEntryDate) 
		--OR titleI.ProgramParticipationBeginDate BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.Migrant								migrant
		ON		enrollment.StudentIdentifierState						=	migrant.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(migrant.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(migrant.SchoolIdentifierSea, '')
		AND		ISNULL(migrant.ProgramParticipationExitDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	LEFT JOIN Staging.PersonStatus							el
		ON		enrollment.StudentIdentifierState						=	el.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(el.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(el.SchoolIdentifierSea, '')
		AND		ISNULL(el.EnglishLearner_StatusEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	LEFT JOIN Staging.PersonStatus							homeless
		ON		enrollment.StudentIdentifierState						=	homeless.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(homeless.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(homeless.SchoolIdentifierSea, '')
		AND		ISNULL(homeless.Homelessness_StatusEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	LEFT JOIN Staging.ProgramParticipationSpecialEducation	idea
		ON		enrollment.StudentIdentifierState						=	idea.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(idea.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(idea.SchoolIdentifierSea, '')
		AND		ISNULL(idea.ProgramParticipationEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	LEFT JOIN Staging.PersonStatus							foster
		ON		enrollment.StudentIdentifierState						=	foster.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(foster.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(foster.SchoolIdentifierSea, '')
		AND		ISNULL(foster.FosterCare_ProgramParticipationEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate
		--AND (foster.FosterCare_ProgramParticipationStartDate <= enrollment.EnrollmentEntryDate 
		--AND ISNULL(foster.FosterCare_ProgramParticipationEndDate, GETDATE()) >= enrollment.EnrollmentEntryDate) 
		--OR foster.FosterCare_ProgramParticipationStartDate BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())


	LEFT JOIN Staging.K12PersonRace							race
		ON		enrollment.SchoolYear									=	race.SchoolYear
		AND		enrollment.StudentIdentifierState						=	race.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(race.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(race.SchoolIdentifierSea, '')
		AND		ISNULL(race.RecordEndDateTime, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	LEFT JOIN Staging.SourceSystemReferenceData sssrd
		ON sssrd.SchoolYear = enrollment.SchoolYear
		AND sssrd.TableName = 'RefTitleISchoolStatus'
		AND Schools.School_TitleISchoolStatus = sssrd.InputCode

	LEFT JOIN Staging.SourceSystemReferenceData sssrd2
		ON sssrd2.SchoolYear = enrollment.SchoolYear
		AND sssrd2.TableName = 'RefTitleIIndicator'
		AND titleI.TitleIIndicator = sssrd2.InputCode

	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON Schools.School_OperationalStatus = sssrd1.InputCode
		AND sssrd1.TableName = 'RefOperationalStatus'
		AND sssrd1.TableFilter = '000533'
		AND Schools.SchoolYear = sssrd1.SchoolYear

	LEFT JOIN staging.SourceSystemReferenceData sssrd3 
		ON Schools.School_Type = sssrd3.InputCode
		AND sssrd3.TableName = 'RefSchoolType'
		AND Schools.SchoolYear = sssrd3.SchoolYear

	WHERE 1 = 1
	
GO
	