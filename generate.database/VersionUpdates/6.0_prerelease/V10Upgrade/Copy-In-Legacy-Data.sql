SET NOCOUNT ON;
GO 

INSERT INTO RDS.DimPeople (
	  FirstName
	, MiddleName
	, LastOrSurname
	, BirthDate 
    , IsActiveK12Student
	, K12StudentStudentIdentifierState 
   	, RecordStartDateTime 
	, RecordEndDateTime 
)
SELECT 
	  FirstName
	, MiddleName
	, LastOrSurname
	, BirthDate 
    , 1
	, K12StudentStudentIdentifierState 
   	, RecordStartDateTime 
	, RecordEndDateTime 
FROM Upgrade.DimK12Students


INSERT INTO RDS.DimPeople (
	  FirstName
	, MiddleName
	, LastOrSurname
	, BirthDate 
    , IsActiveK12Staff
	, K12StaffStaffMemberIdentifierState 
   	, RecordStartDateTime 
	, RecordEndDateTime 
)
SELECT 
	  FirstName
	, MiddleName
	, LastOrSurname
	, BirthDate 
    , 1
	, K12StaffStaffMemberIdentifierState 
   	, RecordStartDateTime 
	, RecordEndDateTime 
FROM Upgrade.DimK12Staff


INSERT INTO RDS.FactK12StudentCounts
    (
	  SchoolYearId
	, FactTypeId
	, SeaId
	, IeuId
	, LeaId
	, K12SchoolId
	, K12StudentId
	, AgeId
	, AttendanceId
	, CohortStatusId
	, CteStatusId
	, EnglishLearnerStatusId
	, GradeLevelId
	, HomelessnessStatusId
	, EconomicallyDisadvantagedStatusId
	, FosterCareStatusId
	, IdeaStatusId
	, ImmigrantStatusId
	, K12DemographicId
	, K12EnrollmentStatusId
	, K12StudentStatusId
	, LanguageId
	, MigrantStatusId
	, NOrDStatusId
	, PrimaryDisabilityTypeId
	, RaceId
	, SpecialEducationServicesExitDateId
	, MigrantStudentQualifyingArrivalDateId
	, LastQualifyingMoveDateId
	, TitleIStatusId
	, TitleIIIStatusId
	, StudentCount        
    )
SELECT 
	  ISNULL(DimSchoolYearId, -1)
	, ISNULL(FactTypeId, -1)
	, ISNULL(DimSeaId, -1)
	, ISNULL(DimIeuId, -1)
	, ISNULL(DimLeaId, -1)
	, ISNULL(DimK12SchoolId, -1)
	, ISNULL(DimPersonId, -1)
	, ISNULL(DimAgeId, -1)
	, ISNULL(DimAttendanceId, -1)
	, ISNULL(DimCohortStatusId, -1)
	, ISNULL(DimCteStatusId, -1)
	, ISNULL(DimEnglishLearnerStatusId, -1)
	, ISNULL(DimGradeLevelId, -1)
	, ISNULL(DimHomelessnessStatusId, -1)
	, ISNULL(DimEconomicallyDisadvantagedStatusId, -1)
	, ISNULL(DimFosterCareStatusId, -1)
	, ISNULL(DimIdeaStatusId, -1)
	, ISNULL(DimImmigrantStatusId, -1)
	, ISNULL(DimK12DemographicId, -1)
	, ISNULL(DimK12EnrollmentStatusId, -1)
	, ISNULL(DimK12StudentStatusId, -1)
	, ISNULL(DimLanguageId, -1)
	, ISNULL(DimMigrantStatusId, -1)
	, ISNULL(DimNOrDStatusId, -1)
	, ISNULL(DimIdeaDisabilityTypeId, -1)
	, ISNULL(DimRaceId, -1)
	, ISNULL(rdsesed.DimDateId, -1) -- DimSpecialEducationServicesExitDateId
	, -1
	, -1
	, ISNULL(DimTitleIStatusId, -1)
	, ISNULL(DimTitleIIIStatusId, -1)
	, ISNULL(StudentCount, -1)
FROM Upgrade.FactK12StudentCounts f
LEFT JOIN RDS.DimSchoolYears rdsy 
    ON f.SchoolYear = rdsy.SchoolYear
LEFT JOIN RDS.DimSeas rds 
    ON f.SeaIdentifierState = rds.SeaOrganizationIdentifierSea
    AND f.SEA_RecordStartDateTime = rds.RecordStartDateTime
    AND ISNULL(f.SEA_RecordEndDateTime, '1/1/1900') = ISNULL(rds.RecordEndDateTime, '1/1/1900') 
LEFT JOIN RDS.DimIeus rdi 
    ON f.IeuIdentifierState = rdi.IeuOrganizationIdentifierSea
    AND f.IEU_RecordStartDateTime = rdi.RecordStartDateTime
    AND ISNULL(f.IEU_RecordEndDateTime, '1/1/1900') = ISNULL(rdi.RecordEndDateTime, '1/1/1900') 
LEFT JOIN RDS.DimLeas rdl 
    ON f.LeaIdentifierState = rdl.LeaIdentifierSea
    AND f.LEA_RecordStartDateTime = rdl.RecordStartDateTime
    AND ISNULL(f.LEA_RecordEndDateTime, '1/1/1900') = ISNULL(rdl.RecordEndDateTime, '1/1/1900') 
LEFT JOIN RDS.DimK12Schools rdksch
    ON f.SchoolIdentifierState = rdksch.SchoolIdentifierSea
    AND f.SCH_RecordStartDateTime = rdksch.RecordStartDateTime
    AND ISNULL(f.SCH_RecordEndDateTime, '1/1/1900') = ISNULL(rdksch.RecordEndDateTime, '1/1/1900') 
LEFT JOIN RDS.DimPeople rdp
	ON f.StateStudentIdentifier = rdp.K12StudentStudentIdentifierState
	AND f.STU_RecordStartDateTime = rdp.RecordStartDateTime
    AND ISNULL(f.STU_RecordEndDateTime, '1/1/1900') = ISNULL(rdp.RecordEndDateTime, '1/1/1900') 
LEFT JOIN RDS.DimAges rda    
    ON f.AgeCode = rda.AgeCode
LEFT JOIN RDS.DimAttendances rdab
    ON f.AbsenteeismCode = rdab.AbsenteeismCode
LEFT JOIN RDS.DimCohortStatuses rdcs 
    ON f.CohortStatusCode = rdcs.CohortStatusCode
LEFT JOIN RDS.DimCteStatuses rdctes
    ON  f.CteAeDisplacedHomemakerIndicatorCode = rdctes.CteAeDisplacedHomemakerIndicatorCode
    AND f.CteNontraditionalGenderStatusCode = rdctes.CteNontraditionalGenderStatusCode
    AND 'MISSING' = rdctes.CteNontraditionalCompletionCode
    AND f.SingleParentOrSinglePregnantWomanCode = rdctes.SingleParentOrSinglePregnantWomanStatusCode
    AND f.CteGraduationRateInclusionCode = rdctes.CteGraduationRateInclusionCode
    AND f.LepPerkinsStatusCode  = rdctes.PerkinsLEPStatusCode
    AND CASE f.CteProgramCode 
            WHEN 'CTEPART' THEN 'Yes'
            WHEN 'NONCTEPART' THEN 'No'
            ELSE 'MISSING'
        END = rdctes.CteParticipantCode
    AND 'MISSING' = rdctes.CteConcentratorCode
LEFT JOIN RDS.DimEnglishLearnerStatuses rdels
    ON  f.EnglishLearnerStatusCode = rdels.EnglishLearnerStatusCode
    AND f.LepPerkinsStatusCode = rdels.PerkinsLEPStatusCode
    AND f.TitleiiiAccountabilityProgressStatusCode = rdels.TitleIIIAccountabilityProgressStatusCode	
    AND f.TitleiiiLanguageInstructionCode = rdels.TitleIIILanguageInstructionProgramTypeCode
LEFT JOIN RDS.DimGradeLevels rdgl
    ON  f.GradeLevelCode = rdgl.GradeLevelCode
LEFT JOIN RDS.DimHomelessnessStatuses rdhs
    ON  f.HomelessnessStatusCode = rdhs.HomelessnessStatusCode
    AND f.HomelessPrimaryNighttimeResidenceCode = rdhs.HomelessPrimaryNighttimeResidenceCode
    AND f.HomelessServicedIndicatorCode = rdhs.HomelessServicedIndicatorCode
    AND f.HomelessUnaccompaniedYouthStatusCode = rdhs.HomelessUnaccompaniedYouthStatusCode
LEFT JOIN RDS.DimEconomicallyDisadvantagedStatuses rdeds
    ON  f.EconomicDisadvantageStatusCode = rdeds.EconomicDisadvantageStatusCode
    AND f.EligibilityStatusForSchoolFoodServiceProgramCode = rdeds.EligibilityStatusForSchoolFoodServiceProgramsCode
    AND f.NSLPDirectCertificationIndicatorCode = rdeds.NationalSchoolLunchProgramDirectCertificationIndicatorCode
LEFT JOIN RDS.DimFosterCareStatuses rdfcs
    ON f.FosterCareProgramCode = rdfcs.ProgramParticipationFosterCareCode
LEFT JOIN RDS.DimIdeaStatuses rdis
    ON  f.SpecialEducationExitReasonCode = rdis.SpecialEducationExitReasonCode
    AND f.IdeaEducationalEnvironmentCode = rdis.IdeaEducationalEnvironmentForSchoolAgeCode
    AND f.IdeaIndicatorCode = rdis.IdeaIndicatorCode
    AND f.IdeaEducationalEnvironmentCode = rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode
LEFT JOIN RDS.DimImmigrantStatuses rdimms
    -- I think
    ON  f.TitleiiiProgramParticipationCode = rdimms.TitleIIIImmigrantStatusCode
    AND f.TitleIIIImmigrantParticipationStatusCode = rdimms.TitleIIIImmigrantParticipationStatusCode
LEFT JOIN RDS.DimK12Demographics rdkdemo
    ON f.SexCode = rdkdemo.SexCode
LEFT JOIN RDS.DimK12EnrollmentStatuses rdkes
    ON  f.EnrollmentStatusCode = rdkes.EnrollmentStatusCode
    AND f.EntryTypeCode = rdkes.EntryTypeCode
    AND f.ExitOrWithdrawalTypeCode = rdkes.ExitOrWithdrawalTypeCode
    AND f.PostSecondaryEnrollmentStatusCode = rdkes.PostSecondaryEnrollmentStatusCode
    AND f.AcademicOrVocationalOutcomeCode = rdkes.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode
    AND f.AcademicOrVocationalExitOutcomeCode = rdkes.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode
LEFT JOIN RDS.DimK12StudentStatuses rdkss   
    ON f.HighSchoolDiplomaTypeCode = rdkss.HighSchoolDiplomaTypeCode
LEFT JOIN RDS.DimLanguages rdlang
    ON f.Iso6392LanguageCode = rdlang.Iso6392LanguageCodeCode
LEFT JOIN RDS.DimMigrantStatuses rdms
	ON  f.MigrantStatusCode = rdms.MigrantStatusCode
	AND 'MISSING' = rdms.MigrantEducationProgramEnrollmentTypeCode
	AND f.ContinuationOfServicesReasonCode = rdms.ContinuationOfServicesReasonCode
	AND f.ConsolidatedMepFundsStatusCode = rdms.ConsolidatedMepFundsStatusCode
	AND 'MISSING' = rdms.MigrantEducationProgramServicesTypeCode
	AND f.MigrantPrioritizedForServicesCode = rdms.MigrantPrioritizedForServicesCode
LEFT JOIN RDS.DimNOrDStatuses rdnords
	ON  f.LongTermStatusCode = rdnords.NeglectedOrDelinquentLongTermStatusCode
	AND f.NeglectedOrDelinquentProgramTypeCode = rdnords.NeglectedOrDelinquentProgramTypeCode
LEFT JOIN RDS.DimIdeaDisabilityTypes rdidt
	ON f.PrimaryDisabilityTypeCode = rdidt.IdeaDisabilityTypeCode
LEFT JOIN RDS.DimRaces rdr
	ON f.RaceCode = rdr.RaceCode
LEFT JOIN RDS.DimDates rdsesed
	ON f.SpecialEducationServicesExitDate = rdsesed.DateValue 
LEFT JOIN RDS.DimTitleIStatuses rdtis
	ON  f.TitleIInstructionalServicesCode = rdtis.TitleIInstructionalServicesCode
	AND f.TitleIProgramTypeCode = rdtis.TitleIProgramTypeCode
	AND f.TitleISchoolStatusCode = rdtis.TitleISchoolStatusCode
	AND f.TitleISupportServicesCode = rdtis.TitleISupportServicesCode
LEFT JOIN RDS.DimTitleIIIStatuses rdtiiis
	ON  f.TitleiiiProgramParticipationCode = rdtiiis.ProgramParticipationTitleIIICode
	AND f.TitleIIIImmigrantParticipationStatusCode = rdtiiis.TitleIIIImmigrantParticipationStatusCode
	AND f.FormerEnglishLearnerYearStatusCode = rdtiiis.FormerEnglishLearnerYearStatusCode
	AND f.ProficiencyStatusCode = rdtiiis.ProficiencyStatusCode
	AND f.TitleiiiAccountabilityProgressStatusCode = rdtiiis.TitleIIIAccountabilityProgressStatusCode
	AND f.TitleiiiLanguageInstructionCode = rdtiiis.TitleIIILanguageInstructionProgramTypeCode
