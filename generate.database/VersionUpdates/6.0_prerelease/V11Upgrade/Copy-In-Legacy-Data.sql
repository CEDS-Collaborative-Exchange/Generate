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
    , IsActiveK12StaffMember
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

INSERT INTO RDS.FactK12StudentCounts (
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
    ON  CASE f.CteAeDisplacedHomemakerIndicatorCode
            WHEN 'DH' THEN 'Yes'
            ELSE 'MISSING'
        END = rdctes.CteAeDisplacedHomemakerIndicatorCode
    AND CASE f.CteNontraditionalGenderStatusCode
            WHEN 'MEM' THEN 'Underrepresented'
            WHEN 'NM' THEN 'NotUnderrepresented'
            ELSE 'MISSING'
        END = rdctes.CteNontraditionalCompletionCode
    AND CASE f.CteNontraditionalGenderStatusCode
            WHEN 'NTE' THEN 'Yes'
            ELSE 'MISSING'
        END = rdctes.CteNontraditionalCompletionCode
    AND CASE f.SingleParentOrSinglePregnantWomanCode
            WHEN 'SPPT' THEN 'Yes'
            ELSE 'MISSING'
        END = rdctes.SingleParentOrSinglePregnantWomanStatusCode
    AND CASE f.CteGraduationRateInclusionCode
            WHEN 'GRAD' THEN 'IncludedAsGraduated'
            WHEN 'NOTG' THEN 'NotIncludedAsGraduated'
            ELSE 'MISSING'
        END = rdctes.CteGraduationRateInclusionCode
    AND CASE f.CteProgramCode 
            WHEN 'CTEPART' THEN 'Yes'
            WHEN 'NONCTEPART' THEN 'No'
            ELSE 'MISSING'
        END = rdctes.CteParticipantCode
    AND CASE f.CteProgramCode 
            WHEN 'CTECONC' THEN 'Yes'
            WHEN 'NONCTEPART' THEN 'No'
            ELSE 'MISSING'
        END = rdctes.CteParticipantCode
LEFT JOIN RDS.DimEnglishLearnerStatuses rdels
    ON  CASE f.EnglishLearnerStatusCode  
            WHEN 'LEP' THEN 'Yes'
            WHEN 'NLEP' THEN 'No'
            ELSE 'MISSING'
        END = rdels.EnglishLearnerStatusCode
LEFT JOIN RDS.DimGradeLevels rdgl
    ON  f.GradeLevelCode = rdgl.GradeLevelCode --Codes are the same
LEFT JOIN RDS.DimHomelessnessStatuses rdhs
    ON  f.HomelessnessStatusCode = rdhs.HomelessnessStatusCode --Codes are the same
    AND f.HomelessPrimaryNighttimeResidenceCode = rdhs.HomelessPrimaryNighttimeResidenceCode --Codes are the same
    AND f.HomelessServicedIndicatorCode = rdhs.HomelessServicedIndicatorCode --Codes are the same
    AND f.HomelessUnaccompaniedYouthStatusCode = rdhs.HomelessUnaccompaniedYouthStatusCode --Codes are the same
LEFT JOIN RDS.DimEconomicallyDisadvantagedStatuses rdeds
    ON  f.EconomicDisadvantageStatusCode = rdeds.EconomicDisadvantageStatusCode --Codes are the same
    AND f.EligibilityStatusForSchoolFoodServiceProgramCode = rdeds.EligibilityStatusForSchoolFoodServiceProgramsCode --Codes are the same
    AND f.NSLPDirectCertificationIndicatorCode = rdeds.NationalSchoolLunchProgramDirectCertificationIndicatorCode --Codes are the same
LEFT JOIN RDS.DimFosterCareStatuses rdfcs
    ON CASE f.FosterCareProgramCode
            WHEN 'FOSTERCARE' THEN 'Yes'
            WHEN 'NONFOSTERCARE' THEN 'No'
            ELSE 'MISSING'
        END = rdfcs.ProgramParticipationFosterCareCode
LEFT JOIN RDS.DimIdeaStatuses rdis
    ON  f.SpecialEducationExitReasonCode = rdis.SpecialEducationExitReasonCode --Codes are the same
    AND CASE f.IdeaIndicatorCode
            WHEN 'IDEA' THEN 'Yes'
            ELSE 'MISSING'
        END = rdis.IdeaIndicatorCode
    AND CASE WHEN (f.AgeCode >= 6 AND f.AgeCode <= 21)
                OR (f.AgeCode = 5 and f.GradeLevelCode NOT IN ('MISSING','PK'))
                    THEN f.IdeaEducationalEnvironmentCode 
            ELSE 'MISSING'
        END = rdis.IdeaEducationalEnvironmentForSchoolAgeCode
    AND CASE WHEN (f.AgeCode < 5 AND f.AgeCode >= 3)
                OR (f.AgeCode = 5 and f.GradeLevelCode IN ('MISSING','PK'))
                    THEN f.IdeaEducationalEnvironmentCode 
            ELSE 'MISSING'
        END = rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode
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
LEFT JOIN RDS.DimK12AcademicAwardStatuses rdkaas   -- Will probably change to DimK12AcademicAwardStatuses since this is the only field in DimK12StudentStatuses.  
    ON f.HighSchoolDiplomaTypeCode = rdkaas.HighSchoolDiplomaTypeEdFactsCode -- Codeset has completely changed, but the old codes map were the EDFacts Codes & there are only 3 with a value != 'MISSING', so this mapping works. 
LEFT JOIN RDS.DimLanguages rdlang
    ON f.Iso6392LanguageCode = rdlang.Iso6392LanguageCodeCode
LEFT JOIN RDS.DimMigrantStatuses rdms
	ON  f.MigrantStatusCode = rdms.MigrantStatusCode --Codes are the same
	AND 'MISSING' = rdms.MigrantEducationProgramEnrollmentTypeCode
	AND CASE f.ContinuationOfServicesReasonCode
            WHEN 'CONTINUED' THEN '01' -- The best we can do. NOTE: This data may not be used, so may not need to be upgraded. 
            ELSE 'MISSING'
        END = rdms.ContinuationOfServicesReasonCode
	AND f.ConsolidatedMepFundsStatusCode = rdms.ConsolidatedMepFundsStatusCode --Codes are the same
	AND 'MISSING' = rdms.MigrantEducationProgramServicesTypeCode
	AND CASE f.MigrantPrioritizedForServicesCode
            WHEN 'PS' THEN 'Yes'
            ELSE 'MISSING'
        END = rdms.MigrantPrioritizedForServicesCode
LEFT JOIN RDS.DimNOrDStatuses rdnords
	ON  CASE f.NeglectedOrDelinquentProgramTypeCode
            WHEN 'ADLTCORR' THEN 'AdultCorrection'
            WHEN 'ATRISK' THEN 'AtRiskPrograms'
            WHEN 'JUVCORR' THEN 'JuvenileCorrection'
            WHEN 'JUVDET' THEN 'JuvenileDetention'
            WHEN 'NEGLECT' THEN 'NeglectedPrograms'
            WHEN 'OTHER' THEN 'OtherPrograms'
            ELSE 'MISSING'
        END = rdnords.NeglectedOrDelinquentProgramTypeCode
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
	ON  f.TitleiiiProgramParticipationCode = rdtiiis.ProgramParticipationTitleIIILiepCode
	AND f.TitleIIIImmigrantParticipationStatusCode = rdtiiis.TitleIIIImmigrantParticipationStatusCode
	AND f.ProficiencyStatusCode = rdtiiis.ProficiencyStatusCode
	AND f.TitleiiiAccountabilityProgressStatusCode = rdtiiis.TitleIIIAccountabilityProgressStatusCode
	AND f.TitleiiiLanguageInstructionCode = rdtiiis.TitleIIILanguageInstructionProgramTypeCode
