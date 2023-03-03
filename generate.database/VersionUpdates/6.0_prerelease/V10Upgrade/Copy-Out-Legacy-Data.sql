DROP TABLE IF EXISTS Upgrade.FactK12StudentCounts
GO

DROP SCHEMA IF EXISTS Upgrade
GO

CREATE SCHEMA Upgrade
GO 

CREATE TABLE Upgrade.FactK12StudentCounts (
	  StudentCutOverStartDate DATE
	, StudentCount INT
	, AgeCode NVARCHAR(200)
	, SchoolYear SMALLINT
	, EconomicDisadvantageStatusCode NVARCHAR(200)
	, EnglishLearnerStatusCode NVARCHAR(200)
	, HomelessnessStatusCode NVARCHAR(200)
	, HomelessPrimaryNighttimeResidenceCode NVARCHAR(200)
	, HomelessUnaccompaniedYouthStatusCode NVARCHAR(200)
	, MigrantStatusCode NVARCHAR(200)
	, MilitaryConnectedStudentIndicatorCode NVARCHAR(200)
	, GradeLevelCode NVARCHAR(200)
	, IdeaEducationalEnvironmentCode NVARCHAR(200)
	, IdeaIndicatorCode NVARCHAR(200)
	, PrimaryDisabilityTypeCode NVARCHAR(200)
	, SpecialEducationExitReasonCode NVARCHAR(200)
	, EligibilityStatusForSchoolFoodServiceProgramCode NVARCHAR(200)
	, FosterCareProgramCode NVARCHAR(200)
	, HomelessServicedIndicatorCode NVARCHAR(200)
	, Section504StatusCode NVARCHAR(200)
	, TitleIIIImmigrantParticipationStatusCode NVARCHAR(200)
	, TitleiiiProgramParticipationCode NVARCHAR(200)
	, SchoolIdentifierState NVARCHAR(200)
	, SCH_RecordStartDateTime DATETIME
	, SCH_RecordEndDateTime	  DATETIME
	, StateStudentIdentifier NVARCHAR(200)
	, STU_RecordStartDateTime DATETIME
	, STU_RecordEndDateTime	  DATETIME
	, Iso6392LanguageCode NVARCHAR(200)
	, ConsolidatedMepFundsStatusCode NVARCHAR(200)
	, ContinuationOfServicesReasonCode NVARCHAR(200)
	, MepEnrollmentTypeCode NVARCHAR(200)
	, MepServicesTypeCode NVARCHAR(200)
	, MigrantPrioritizedForServicesCode NVARCHAR(200)
	, HighSchoolDiplomaTypeCode NVARCHAR(200)
	, MobilityStatus12moCode NVARCHAR(200)
	, MobilityStatus36moCode NVARCHAR(200)
	, MobilityStatusSYCode NVARCHAR(200)
	, NSLPDirectCertificationIndicatorCode NVARCHAR(200)
	, PlacementStatusCode NVARCHAR(200)
	, PlacementTypeCode NVARCHAR(200)
	, ReferralStatusCode NVARCHAR(200)
	, TitleIInstructionalServicesCode NVARCHAR(200)
	, TitleIProgramTypeCode NVARCHAR(200)
	, TitleISchoolStatusCode NVARCHAR(200)
	, TitleISupportServicesCode NVARCHAR(200)
	, FormerEnglishLearnerYearStatusCode NVARCHAR(200)
	, ProficiencyStatusCode NVARCHAR(200)
	, TitleiiiAccountabilityProgressStatusCode NVARCHAR(200)
	, TitleiiiLanguageInstructionCode NVARCHAR(200)
	, LeaIdentifierState NVARCHAR(200)
	, LEA_RecordStartDateTime DATETIME
	, LEA_RecordEndDateTime	  DATETIME
	, AbsenteeismCode NVARCHAR(200)
	, CohortStatusCode NVARCHAR(200)
	, LongTermStatusCode NVARCHAR(200)
	, NeglectedOrDelinquentProgramTypeCode NVARCHAR(200)
	, RaceCode NVARCHAR(200)
	, CteAeDisplacedHomemakerIndicatorCode NVARCHAR(200)
	, CteGraduationRateInclusionCode NVARCHAR(200)
	, CteNontraditionalGenderStatusCode NVARCHAR(200)
	, CteProgramCode NVARCHAR(200)
	, LepPerkinsStatusCode NVARCHAR(200)
	, RepresentationStatusCode NVARCHAR(200)
	, SingleParentOrSinglePregnantWomanCode NVARCHAR(200)
	, AcademicOrVocationalExitOutcomeCode NVARCHAR(200)
	, AcademicOrVocationalOutcomeCode NVARCHAR(200)
	, EnrollmentStatusCode NVARCHAR(200)
	, EntryTypeCode NVARCHAR(200)
	, ExitOrWithdrawalTypeCode NVARCHAR(200)
	, PostSecondaryEnrollmentStatusCode NVARCHAR(200)
	, SeaIdentifierState NVARCHAR(200)
	, SEA_RecordStartDateTime DATETIME
	, SEA_RecordEndDateTime	  DATETIME
	, IeuIdentifierState NVARCHAR(200)
	, IEU_RecordStartDateTime DATETIME
	, IEU_RecordEndDateTime	  DATETIME
	, SpecialEducationServicesExitDate DATE
	)


INSERT INTO Upgrade.FactK12StudentCounts
SELECT 
	  f.StudentCutOverStartDate
	, f.StudentCount
	, rda.AgeCode
	, rdsy.SchoolYear
	, rdkd.EconomicDisadvantageStatusCode
	, rdkd.EnglishLearnerStatusCode
	, rdkd.HomelessnessStatusCode
	, rdkd.HomelessPrimaryNighttimeResidenceCode
	, rdkd.HomelessUnaccompaniedYouthStatusCode
	, rdkd.MigrantStatusCode
	, rdkd.MilitaryConnectedStudentIndicatorCode
	, rdgl.GradeLevelCode
	, rdis.IdeaEducationalEnvironmentCode
	, rdis.IdeaIndicatorCode
	, rdis.PrimaryDisabilityTypeCode
	, rdis.SpecialEducationExitReasonCode
	, rdps.EligibilityStatusForSchoolFoodServiceProgramCode
	, rdps.FosterCareProgramCode
	, rdps.HomelessServicedIndicatorCode
	, rdps.Section504StatusCode
	, rdps.TitleIIIImmigrantParticipationStatusCode
	, rdps.TitleiiiProgramParticipationCode
	, rdksch.SchoolIdentifierState
	, rdksch.RecordStartDateTime AS SCH_RecordStartDateTime
	, rdksch.RecordEndDateTime	 AS SCH_RecordEndDateTime
	, rdkstu.StateStudentIdentifier
	, rdkstu.RecordStartDateTime  AS STU_RecordStartDateTime
	, rdkstu.RecordEndDateTime	  AS STU_RecordEndDateTime
	, rdl.Iso6392LanguageCode
	, rdm.ConsolidatedMepFundsStatusCode
	, rdm.ContinuationOfServicesReasonCode
	, rdm.MepEnrollmentTypeCode
	, rdm.MepServicesTypeCode
	, rdm.MigrantPrioritizedForServicesCode
	, rdkss.HighSchoolDiplomaTypeCode
	, rdkss.MobilityStatus12moCode
	, rdkss.MobilityStatus36moCode
	, rdkss.MobilityStatusSYCode
	, rdkss.NSLPDirectCertificationIndicatorCode
	, rdkss.PlacementStatusCode
	, rdkss.PlacementTypeCode
	, rdkss.ReferralStatusCode
	, rdtis.TitleIInstructionalServicesCode
	, rdtis.TitleIProgramTypeCode
	, rdtis.TitleISchoolStatusCode
	, rdtis.TitleISupportServicesCode
	, rdtiiis.FormerEnglishLearnerYearStatusCode
	, rdtiiis.ProficiencyStatusCode
	, rdtiiis.TitleiiiAccountabilityProgressStatusCode
	, rdtiiis.TitleiiiLanguageInstructionCode
	, rdlea.LeaIdentifierState
	, rdlea.RecordStartDateTime AS LEA_RecordStartDateTime
	, rdlea.RecordEndDateTime	AS LEA_RecordEndDateTime
	, rdatt.AbsenteeismCode
	, rdcs.CohortStatusCode
	, rdnodps.LongTermStatusCode
	, rdnodps.NeglectedOrDelinquentProgramTypeCode
	, rdr.RaceCode
	, rdctes.CteAeDisplacedHomemakerIndicatorCode
	, rdctes.CteGraduationRateInclusionCode
	, rdctes.CteNontraditionalGenderStatusCode
	, rdctes.CteProgramCode
	, rdctes.LepPerkinsStatusCode
	, rdctes.RepresentationStatusCode
	, rdctes.SingleParentOrSinglePregnantWomanCode
	, rdkes.AcademicOrVocationalExitOutcomeCode
	, rdkes.AcademicOrVocationalOutcomeCode
	, rdkes.EnrollmentStatusCode
	, rdkes.EntryTypeCode
	, rdkes.ExitOrWithdrawalTypeCode
	, rdkes.PostSecondaryEnrollmentStatusCode
	, rds.SeaIdentifierState
	, rds.RecordStartDateTime AS SEA_RecordStartDateTime
	, rds.RecordEndDateTime   AS SEA_RecordEndDateTime
	, rdi.IeuIdentifierState
	, rdi.RecordStartDateTime AS IEU_RecordStartDateTime
	, rdi.RecordEndDateTime	  AS IEU_RecordEndDateTime
	, rdsesed.DateValue AS SpecialEducationServicesExitDate
FROM RDS.FactK12StudentCounts f
JOIN RDS.DimAges rda ON f.AgeId = rda.DimAgeId
JOIN RDS.DimSchoolYears rdsy ON F.SchoolYearId = rdsy.DimSchoolYearId
JOIN RDS.DimK12Demographics rdkd ON f.K12DemographicId = rdkd.DimK12DemographicId
JOIN RDS.DimFactTypes rdft ON f.FactTypeId = rdft.DimFactTypeId
JOIN RDS.DimGradeLevels rdgl ON f.GradeLevelId = rdgl.DimGradeLevelId
JOIN RDS.DimIdeaStatuses rdis ON f.IdeaStatusId = rdis.DimIdeaStatusId
JOIN RDS.DimProgramStatuses rdps ON f.ProgramStatusId = rdps.DimProgramStatusId
JOIN RDS.DimK12Schools rdksch ON f.K12SchoolId = rdksch.DimK12SchoolId
JOIN RDS.DimK12Students rdkstu ON f.K12StudentId = rdkstu.DimK12StudentId
JOIN RDS.DimLanguages rdl ON f.LanguageId = rdl.DimLanguageId
JOIN RDS.DimMigrants rdm ON f.MigrantId = rdm.DimMigrantId
JOIN RDS.DimK12StudentStatuses rdkss ON f.K12StudentStatusId = rdkss.DimK12StudentStatusId
JOIN RDS.DimTitleIStatuses rdtis ON f.TitleIStatusId = rdtis.DimTitleIStatusId
JOIN RDS.DimTitleIIIStatuses rdtiiis ON f.TitleIIIStatusId = rdtiiis.DimTitleIIIStatusId
JOIN RDS.DimLeas rdlea ON f.LeaId = rdlea.DimLeaID
JOIN RDS.DimAttendance rdatt ON f.AttendanceId = rdatt.DimAttendanceId
JOIN RDS.DimCohortStatuses rdcs ON f.CohortStatusId = rdcs.DimCohortStatusId
JOIN RDS.DimNOrDProgramStatuses rdnodps ON f.NOrDProgramStatusId = rdnodps.DimNOrDProgramStatusId
JOIN RDS.DimRaces rdr ON f.RaceId = rdr.DimRaceId
JOIN RDS.DimCteStatuses rdctes ON f.CteStatusId = rdctes.DimCteStatusId
JOIN RDS.DimK12EnrollmentStatuses rdkes ON f.K12EnrollmentStatusId = rdkes.DimK12EnrollmentStatusId
JOIN RDS.DimSeas rds ON f.SeaId = rds.DimSeaId
JOIN RDS.DimIeus rdi ON f.IeuId = rdi.DimIeuId
JOIN RDS.DimDates rdsesed ON f.SpecialEducationServicesExitDateId = rdsesed.DimDateId
