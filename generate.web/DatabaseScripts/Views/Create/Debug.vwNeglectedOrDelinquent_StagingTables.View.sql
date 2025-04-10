CREATE VIEW [debug].[vwNeglectedOrDelinquent_StagingTables] 
AS


		SELECT DISTINCT
			ske.id														StagingId								
			, rsy.DimSchoolYearId										SchoolYearId							
			, '15'														FactTypeId							
			, ISNULL(rgls.DimGradeLevelId, -1)							GradeLevelId							
			, -1 														AgeId									
			, ISNULL(rdr.DimRaceId, -1)									RaceId								
			, -1														K12DemographicId						
			, 1															StudentCount							
			, ISNULL(rds.DimSeaId, -1)									SEAId									
			, -1														IEUId									
			, ISNULL(rdl.DimLeaID, -1)									LEAId									
			, ISNULL(rdksch.DimK12SchoolId, -1)							K12SchoolId							
			, ISNULL(rdp.DimPersonId, -1)								K12StudentId							
			, ISNULL(rdis.DimIdeaStatusId, -1)							IdeaStatusId							
			, -1														DisabilityStatusId							
			, -1														LanguageId							
			, -1								 						MigrantStatusId						
			, -1														TitleIStatusId						
			, -1														TitleIIIStatusId						
			, -1														AttendanceId							
			, -1 														CohortStatusId						
			, ISNULL(rdnds.DimNOrDStatusId, -1)							NOrDStatusId							
			, -1														CTEStatusId							
			, -1														K12EnrollmentStatusId					
			, ISNULL(rdels.DimEnglishLearnerStatusId, -1)				EnglishLearnerStatusId				
			, -1														HomelessnessStatusId					
			, -1														EconomicallyDisadvantagedStatusId		
			, -1														FosterCareStatusId					
			, -1														ImmigrantStatusId						
			, -1														PrimaryDisabilityTypeId				
			, -1														SpecialEducationServicesExitDateId	
			, -1														MigrantStudentQualifyingArrivalDateId	
			, -1														LastQualifyingMoveDateId	
			, ISNULL(BeginDate.DimDateId, -1)							StatusStartDateNeglectedOrDelinquentId
			, ISNULL(EndDate.DimDateId, -1)								StatusEndDateNeglectedOrDelinquentId
			, ske.StudentIdentifierState
			, ske.LEAIdentifierSeaAccountability
			, ske.SchoolIdentifierSea
			, ske.FirstName
			, ske.LastOrSurname
			, ske.MiddleName
			, ske.SchoolYear
			, ske.EnrollmentEntryDate
			, ske.EnrollmentExitDate
		
			--Neglected or Delinquent
			, sppnord.NeglectedOrDelinquentStatus
			, sppnord.NeglectedOrDelinquentProgramEnrollmentSubpart
			--, sssrd3.OutputCode 'NeglectedOrDelingquentProgramskeSubpartEdFactsCode'
			, sppnord.ProgramParticipationBeginDate
			, sppnord.ProgramParticipationEndDate
			, sppnord.NeglectedOrDelinquentProgramType
			--, sssrd2.OutputCode 'NeglectedOrDelinquentProgramTypeEdFactsCode'
			, sppnord.NeglectedOrDelinquentAcademicAchievementIndicator
			, sppnord.NeglectedOrDelinquentAcademicOutcomeIndicator
			, sppnord.EdFactsAcademicOrCareerAndTechnicalOutcomeType	
			--, sssrd.OutputCode 'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode'
			, sppnord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType
			--, sssrd1.OutputCode 'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode'
			, sppnord.DiplomaCredentialAwardDate
			, sppnord.ProgressLevel_Reading
			, sppnord.ProgressLevel_Math
			, sppnord.NeglectedProgramType
			, sppnord.DelinquentProgramType
			, DR.RaceEdFactsCode AS RACE
			, DSex.SexEdFactsCode AS Sex
			, DAGE.AgeEdFactsCode AS AGE
			, CASE WHEN DIMIDEA.IdeaIndicatorEdFactsCode = 'IDEA' THEN 'WDIS'
						ELSE 'WODIS'
					END AS IDEAINDICATOR
			, EnglishLearnerStatusEdFactsCode AS EnglishLearnerStatus
			, LNGNORD.NeglectedOrDelinquentLongTermStatusEdFactsCode AS NEGLECTEDORDELINQUENTLONGTERMSTATUS

		FROM Staging.K12Enrollment ske

		JOIN Staging.K12Organization sko
			on isnull(ske.LeaIdentifierSeaAccountability,'') = isnull(sko.LeaIdentifierSea,'')
			and isnull(ske.SchoolIdentifierSea,'') = isnull(sko.SchoolIdentifierSea,'')
			and LEA_IsReportedFederally = 1

		JOIN RDS.DimSchoolYears rsy
			ON ske.SchoolYear = rsy.SchoolYear
			--and ske.SchoolYear = @SchoolYear

		JOIN RDS.DimSeas rds
			ON ske.EnrollmentEntryDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, staging.GetFiscalYearEndDate(ske.SchoolYear))

		JOIN RDS.DimPeople rdp
			ON ske.StudentIdentifierState = rdp.K12StudentStudentIdentifierState
			AND rdp.IsActiveK12Student = 1
			AND ISNULL(ske.FirstName, '') = ISNULL(rdp.FirstName, '')
			AND ISNULL(ske.MiddleName, '') = ISNULL(rdp.MiddleName, '')
			AND ISNULL(ske.LastOrSurname, 'MISSING') = rdp.LastOrSurname
			AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdp.BirthDate, '1/1/1900')
			AND ske.EnrollmentEntryDate BETWEEN rdp.RecordStartDateTime AND ISNULL(rdp.RecordEndDateTime, staging.GetFiscalYearEndDate(ske.SchoolYear))
		--inner join RDS.DimK12Demographics CAT_SEX on fact.K12DemographicId = CAT_SEX.DimK12DemographicId
		LEFT JOIN RDS.DimLeas rdl
			ON ske.LeaIdentifierSeaAccountability = rdl.LeaIdentifierSea
			AND ske.EnrollmentEntryDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, staging.GetFiscalYearEndDate(ske.SchoolYear))
		LEFT JOIN RDS.DimK12Schools rdksch
			ON ske.SchoolIdentifierSea = rdksch.SchoolIdentifierSea
			AND ske.EnrollmentEntryDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, staging.GetFiscalYearEndDate(ske.SchoolYear))


	--negelected or delinquent
		LEFT JOIN Staging.ProgramParticipationNOrD sppnord
			ON ske.StudentIdentifierState = sppnord.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(sppnord.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(sppnord.SchoolIdentifierSea, '')
			AND sppnord.ProgramParticipationBeginDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, staging.GetFiscalYearEndDate(ske.SchoolYear))

	--idea disability status
		LEFT JOIN Staging.ProgramParticipationSpecialEducation idea
			ON ske.StudentIdentifierState = idea.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(idea.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(idea.SchoolIdentifierSea, '')
			AND sppnord.ProgramParticipationBeginDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, staging.GetFiscalYearEndDate(ske.SchoolYear))

	--english learner
		LEFT JOIN Staging.PersonStatus el 
			ON ske.StudentIdentifierState = el.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(el.LeaIdentifierSeaAccountability, '') 
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(el.SchoolIdentifierSea, '')
			AND el.EnglishLearner_StatusStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, staging.GetFiscalYearEndDate(ske.SchoolYear))

	--race	
		LEFT JOIN RDS.vwUnduplicatedRaceMap spr 
			ON spr.SchoolYear = ske.SchoolYear
			AND ske.StudentIdentifierState = spr.StudentIdentifierState
			AND (ske.SchoolIdentifierSea = spr.SchoolIdentifierSea
				OR ske.LEAIdentifierSeaAccountability = spr.LeaIdentifierSeaAccountability)

	--neglected or delinquent (RDS)
		LEFT JOIN RDS.vwDimNOrDStatuses rdnds
			ON rdnds.SchoolYear = ske.SchoolYear

			--THESE WILL BE NEEDED FOR FS119 and FS127 but for now we are defaulting to 'MISSING' for FS218, FS219, FS220, FS221
			AND ISNULL(sppnord.NeglectedProgramType, 'MISSING') = ISNULL(rdnds.NeglectedProgramTypeMap, rdnds.NeglectedProgramTypeCode)
			AND ISNULL(sppnord.DelinquentProgramType, 'MISSING') = ISNULL(rdnds.DelinquentProgramTypeMap, rdnds.DelinquentProgramTypeCode)
			--AND ISNULL(sppnord.NeglectedOrDelinquentProgramType, 'MISSING') = ISNULL(rdnds.NeglectedOrDelinquentProgramTypeMap, rdnds.NeglectedOrDelinquentProgramTypeCode)
			--*/

			--AND ISNULL(sppnord.EdFactsAcademicOrCareerAndTechnicalOutcomeType, 'MISSING') = ISNULL(rdnds.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeMap, rdnds.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode)
			--AND ISNULL(sppnord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType, 'MISSING') = ISNULL(rdnds.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeMap, rdnds.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode)
	
			--AND rdnds.NeglectedOrDelinquentProgramEnrollmentSubpartMap = sppnord.NeglectedOrDelinquentProgramEnrollmentSubpart
			--AND rdnds.NeglectedOrDelinquentStatusMap = sppnord.NeglectedOrDelinquentStatus
		
	--idea disability (RDS)
		LEFT JOIN RDS.vwDimIdeaStatuses rdis
			ON rdis.SchoolYear = ske.SchoolYear
			AND ISNULL(CAST(idea.IDEAIndicator AS SMALLINT), -1) = ISNULL(rdis.IdeaIndicatorMap, -1)
			AND rdis.IdeaEducationalEnvironmentForSchoolAgeCode = 'MISSING'
			AND rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = 'MISSING'
			AND rdis.SpecialEducationExitReasonCode = 'MISSING'

	--english learner (RDS)
		LEFT JOIN RDS.vwDimEnglishLearnerStatuses rdels
			ON rdels.SchoolYear = ske.SchoolYear
			AND ISNULL(CAST(el.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)
			AND PerkinsEnglishLearnerStatusCode = 'MISSING'

	--grade (RDS)
		LEFT JOIN RDS.vwDimGradeLevels rgls
			ON ske.GradeLevel = rgls.GradeLevelMap
			AND rgls.GradeLevelTypeDescription = 'Entry Grade Level'
			AND rgls.SchoolYear = ske.SchoolYear

	--race (RDS)	
		LEFT JOIN rds.vwDimRaces rdr
			ON ISNULL(rdr.RaceMap, rdr.RaceCode) =
				CASE
					when ske.HispanicLatinoEthnicity = 1 then 'HispanicorLatinoEthnicity'
					WHEN spr.RaceMap IS NOT NULL THEN spr.RaceMap
					ELSE 'Missing'
				END
			AND rdr.SchoolYear = ske.SchoolYear
	-- ProgramParticipationEndDate
		LEFT JOIN RDS.DimDates BeginDate 
			ON sppnord.ProgramParticipationEndDate = BeginDate.DateValue

	-- ProgramParticipationEndDate
		LEFT JOIN RDS.DimDates EndDate 
			ON sppnord.ProgramParticipationEndDate = EndDate.DateValue

	--Lea Operational Status	
		LEFT JOIN Staging.SourceSystemReferenceData sssrd
			ON sko.SchoolYear = sssrd.SchoolYear
			AND sko.LEA_OperationalStatus = sssrd.InputCode
			AND sssrd.Tablename = 'RefOperationalStatus'
			AND sssrd.TableFilter = '000174'

	--------SA ADD--------------
		--LEFT JOIN staging.SourceSystemReferenceData sssrd_race ON sssrd_race =  AND sssrd.TableName = 'refRace'
		LEFT JOIN [RDS].[DimRaces] DR on dr.DimRaceId = rdr.DimRaceId
		LEFT JOIN RDS.DimIdeaStatuses DIMIDEA ON DIMIDEA.DimIdeaStatusId = ISNULL(rdis.DimIdeaStatusId, -1)
		LEFT JOIN [RDS].DimEnglishLearnerStatuses ELS ON ELS.DimEnglishLearnerStatusId = rdels.DimEnglishLearnerStatusId
		LEFT JOIN RDS.DimNOrDStatuses LNGNORD ON LNGNORD.DimNOrDStatusId = rdnds.DimNOrDStatusId
		CROSS JOIN (SELECT DimK12DemographicId,	SexCode	,	SexEdFactsCode FROM RDS.DimK12Demographics WHERE DimK12DemographicId = -1) DSex
		CROSS JOIN (Select DimAgeId, AgeCode, AgeEdFactsCode from RDS.DimAges WHERE DimAgeId = -1) DAGE

	-------------------------

		WHERE sppnord.NeglectedOrDelinquentProgramEnrollmentSubpart is not NULL
			AND sppnord.NeglectedOrDelinquentStatus = 1 -- Only get NorD students
			AND sssrd.OutputCode not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING')

GO


/*

	SELECT	DISTINCT 
		enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.FirstName
		, enrollment.LastOrSurname
		, enrollment.MiddleName
		, enrollment.SchoolYear
		, enrollment.EnrollmentEntryDate
		, enrollment.EnrollmentExitDate
		
		--Neglected or Delinquent
		, nord.NeglectedOrDelinquentStatus
		, nord.NeglectedOrDelinquentProgramEnrollmentSubpart
		, sssrd3.OutputCode 'NeglectedOrDelingquentProgramEnrollmentSubpartEdFactsCode'
		, nord.ProgramParticipationBeginDate
		, nord.ProgramParticipationEndDate
		, nord.NeglectedOrDelinquentProgramType
		, sssrd2.OutputCode 'NeglectedOrDelinquentProgramTypeEdFactsCode'
		, nord.NeglectedOrDelinquentAcademicAchievementIndicator
		, nord.NeglectedOrDelinquentAcademicOutcomeIndicator
		, nord.EdFactsAcademicOrCareerAndTechnicalOutcomeType	
		, sssrd.OutputCode 'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode'
		, nord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType
		, sssrd1.OutputCode 'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode'
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

	LEFT JOIN Staging.SourceSystemReferenceData sssrd
		on sssrd.Schoolyear = enrollment.SchoolYear
		and sssrd.tablename = 'RefEdFactsAcademicOrCareerAndTechnicalOutcomeType'
		and nord.EdFactsAcademicOrCareerAndTechnicalOutcomeType = sssrd.InputCode

	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		on sssrd1.Schoolyear = enrollment.SchoolYear
		and sssrd1.tablename = 'RefEdFactsAcademicOrCareerAndTechnicalOutcomeExitType'
		and nord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType = sssrd1.InputCode

	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		on sssrd2.Schoolyear = enrollment.SchoolYear
		and sssrd2.tablename = 'RefNeglectedOrDelinquentProgramType'
		and nord.NeglectedOrDelinquentProgramType = sssrd2.InputCode

	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		on sssrd3.Schoolyear = enrollment.SchoolYear
		and sssrd3.tablename = 'RefNeglectedOrDelinquentProgramEnrollmentSubpart'
		and nord.NeglectedOrDelinquentProgramEnrollmentSubpart = sssrd3.InputCode
		
		--AND		ISNULL(nord.ProgramParticipationEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate
	--WHERE 1 = 1
	--AND ISNULL(nord.EdFactsAcademicOrCareerAndTechnicalOutcomeType, '') <> ''
	--	OR ISNULL(nord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType, '') <> ''
	
*/

