SET NOCOUNT ON;
GO 

IF EXISTS (select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA = 'Upgrade' AND TABLE_NAME = 'FactK12StudentCounts') BEGIN
	DROP TABLE Upgrade.FactK12StudentCounts
END
GO
IF EXISTS (select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA = 'Upgrade' AND TABLE_NAME = 'FactK12StudentDisciplines') BEGIN
	DROP TABLE Upgrade.FactK12StudentDisciplines
END
GO
IF EXISTS (select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA = 'Upgrade' AND TABLE_NAME = 'FactK12StaffCounts') BEGIN
	DROP TABLE Upgrade.FactK12StaffCounts
END
GO
IF EXISTS (select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA = 'Upgrade' AND TABLE_NAME = 'FactOrganizationCounts') BEGIN
	DROP TABLE Upgrade.FactOrganizationCounts
END
GO
IF EXISTS (select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA = 'Upgrade' AND TABLE_NAME = 'FactK12StudentAssessments') BEGIN
	DROP TABLE Upgrade.FactK12StudentAssessments
END
GO
IF EXISTS (select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA = 'Upgrade' AND TABLE_NAME = 'DimK12Students') BEGIN
	DROP TABLE Upgrade.DimK12Students
END
GO
IF EXISTS (select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA = 'Upgrade' AND TABLE_NAME = 'DimK12Staff') BEGIN
	DROP TABLE Upgrade.DimK12Staff
END
GO
IF EXISTS (select * from INFORMATION_SCHEMA.SCHEMATA where schema_name = 'Upgrade') BEGIN
	DROP SCHEMA Upgrade
END
GO

CREATE SCHEMA Upgrade
GO 

CREATE TABLE Upgrade.DimK12Students (
	  FirstName NVARCHAR(200)
	, MiddleName NVARCHAR(200)
	, LastOrSurname NVARCHAR(200)
	, BirthDate DATE
	, K12StudentStudentIdentifierState NVARCHAR(200)
	, RecordStartDateTime DATE
	, RecordEndDateTime DATE NULL
)
INSERT INTO Upgrade.DimK12Students
SELECT
	  s.FirstName
	, s.MiddleName
	, s.LastName
	, s.BirthDate
	, s.StateStudentIdentifier
	, RecordStartDateTime 
	, RecordEndDateTime 
FROM RDS.DimK12Students s

GO

CREATE TABLE Upgrade.DimK12Staff (
	  FirstName NVARCHAR(200)
	, MiddleName NVARCHAR(200)
	, LastOrSurname NVARCHAR(200)
	, BirthDate DATE
	, K12StaffStaffMemberIdentifierState NVARCHAR(200)
	, RecordStartDateTime DATE
	, RecordEndDateTime DATE NULL
)

INSERT INTO Upgrade.DimK12Staff
SELECT 
	  FirstName
	, MiddleName
	, LastOrSurname
	, BirthDate
	, StaffMemberIdentifierState
	, RecordStartDateTime 
	, RecordEndDateTime 
FROM RDS.DimK12Staff s

GO


CREATE TABLE Upgrade.FactK12StudentCounts (
	  StudentCutOverStartDate DATE
	, StudentCount INT
	, AgeCode NVARCHAR(200)
	, SchoolYear SMALLINT
	, FactTypeId INT
	, SexCode NVARCHAR(200)
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
	, f.FactTypeId
	, rdkstu.SexCode
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
LEFT JOIN RDS.DimAges rda ON f.AgeId = rda.DimAgeId
LEFT JOIN RDS.DimSchoolYears rdsy ON F.SchoolYearId = rdsy.DimSchoolYearId
LEFT JOIN RDS.DimK12Demographics rdkd ON f.K12DemographicId = rdkd.DimK12DemographicId
LEFT JOIN RDS.DimFactTypes rdft ON f.FactTypeId = rdft.DimFactTypeId
LEFT JOIN RDS.DimGradeLevels rdgl ON f.GradeLevelId = rdgl.DimGradeLevelId
LEFT JOIN RDS.DimIdeaStatuses rdis ON f.IdeaStatusId = rdis.DimIdeaStatusId
LEFT JOIN RDS.DimProgramStatuses rdps ON f.ProgramStatusId = rdps.DimProgramStatusId
LEFT JOIN RDS.DimK12Schools rdksch ON f.K12SchoolId = rdksch.DimK12SchoolId
LEFT JOIN RDS.DimK12Students rdkstu ON f.K12StudentId = rdkstu.DimK12StudentId
LEFT JOIN RDS.DimLanguages rdl ON f.LanguageId = rdl.DimLanguageId
LEFT JOIN RDS.DimMigrants rdm ON f.MigrantId = rdm.DimMigrantId
LEFT JOIN RDS.DimK12StudentStatuses rdkss ON f.K12StudentStatusId = rdkss.DimK12StudentStatusId
LEFT JOIN RDS.DimTitleIStatuses rdtis ON f.TitleIStatusId = rdtis.DimTitleIStatusId
LEFT JOIN RDS.DimTitleIIIStatuses rdtiiis ON f.TitleIIIStatusId = rdtiiis.DimTitleIIIStatusId
LEFT JOIN RDS.DimLeas rdlea ON f.LeaId = rdlea.DimLeaID
LEFT JOIN RDS.DimAttendance rdatt ON f.AttendanceId = rdatt.DimAttendanceId
LEFT JOIN RDS.DimCohortStatuses rdcs ON f.CohortStatusId = rdcs.DimCohortStatusId
LEFT JOIN RDS.DimNOrDProgramStatuses rdnodps ON f.NOrDProgramStatusId = rdnodps.DimNOrDProgramStatusId
LEFT JOIN RDS.DimRaces rdr ON f.RaceId = rdr.DimRaceId
LEFT JOIN RDS.DimCteStatuses rdctes ON f.CteStatusId = rdctes.DimCteStatusId
LEFT JOIN RDS.DimK12EnrollmentStatuses rdkes ON f.K12EnrollmentStatusId = rdkes.DimK12EnrollmentStatusId
LEFT JOIN RDS.DimSeas rds ON f.SeaId = rds.DimSeaId
LEFT JOIN RDS.DimIeus rdi ON f.IeuId = rdi.DimIeuId
LEFT JOIN RDS.DimDates rdsesed ON f.SpecialEducationServicesExitDateId = rdsesed.DimDateId



/*******************************************************************************************************/

--Should LeaId be switched to the new field LeaAccountabilityId
	--from work in states, I think having both Accountability and Attending would be good
--Why is Race not in the new table
--We have other statuses but not Military Connected or Section504, is that correct

/*
CREATE TABLE [RDS].[tmp_ms_xx_FactK12StudentDisciplines] (
    [FactK12StudentDisciplineId]        INT             IDENTITY (1, 1) NOT NULL,
    [SchoolYearId]                      INT             CONSTRAINT [DF_FactK12StudentDisciplines_SchoolYearId] DEFAULT ((-1)) NOT NULL,
    [FactTypeId]                        INT             CONSTRAINT [DF_FactK12StudentDisciplines_FactTypeId] DEFAULT ((-1)) NOT NULL,
    [SeaId]                             INT             CONSTRAINT [DF_FactK12StudentDisciplines_SeaId] DEFAULT ((-1)) NOT NULL,
    [IeuId]                             INT             CONSTRAINT [DF_FactK12StudentDisciplines_IeuId] DEFAULT ((-1)) NOT NULL,
    [LeaId]                             INT             CONSTRAINT [DF_FactK12StudentDisciplines_LeaId] DEFAULT ((-1)) NOT NULL,
    [K12SchoolId]                       INT             CONSTRAINT [DF_FactK12StudentDisciplines_K12SchoolId] DEFAULT ((-1)) NOT NULL,
    [K12StudentId]                      INT             CONSTRAINT [DF_FactK12StudentDisciplines_K12StudentId] DEFAULT ((-1)) NOT NULL,
    [AgeId]                             INT             CONSTRAINT [DF_FactK12StudentDisciplines_AgeId] DEFAULT ((-1)) NOT NULL,
    [CteStatusId]                       INT             CONSTRAINT [DF_FactK12StudentDisciplines_CteStatusId] DEFAULT ((-1)) NOT NULL,
NEW    [DisabilityStatusId]                INT             CONSTRAINT [DF_FactK12StudentDisciplines_DisabilityStatusId] DEFAULT ((-1)) NOT NULL,
    [DisciplinaryActionStartDateId]     INT             CONSTRAINT [DF_FactK12StudentDisciplines_DisciplinaryActionStartDateId] DEFAULT ((-1)) NOT NULL,
NEW    [DisciplinaryActionEndDateId]       INT             CONSTRAINT [DF_FactK12StudentDisciplines_DisciplinaryActionEndDateId] DEFAULT ((-1)) NOT NULL,
    [DisciplineStatusId]                INT             CONSTRAINT [DF_FactK12StudentDisciplines_DisciplineStatusId] DEFAULT ((-1)) NOT NULL,
NEW    [EconomicallyDisadvantagedStatusId] INT             CONSTRAINT [DF_FactK12StudentDisciplines_EconomicallyDisadvantagedStatusId] DEFAULT ((-1)) NOT NULL,
NEW    [EnglishLearnerStatusId]            INT             CONSTRAINT [DF_FactK12StudentDisciplines_EnglishLearnerStatusId] DEFAULT ((-1)) NOT NULL,
    [FirearmId]                         INT             CONSTRAINT [DF_FactK12StudentDisciplines_FirearmId] DEFAULT ((-1)) NOT NULL,
    [FirearmDisciplineStatusId]         INT             CONSTRAINT [DF_FactK12StudentDisciplines_FirearmDisciplineStatusId] DEFAULT ((-1)) NOT NULL,
NEW    [FosterCareStatusId]                INT             CONSTRAINT [DF_FactK12StudentDisciplines_FosterCareStatusId] DEFAULT ((-1)) NOT NULL,
    [GradeLevelId]                      INT             CONSTRAINT [DF_FactK12StudentDisciplines_GradeLevelId] DEFAULT ((-1)) NOT NULL,
NEW    [HomelessnessStatusId]              INT             CONSTRAINT [DF_FactK12StudentDisciplines_HomelessnessStatusId] DEFAULT ((-1)) NOT NULL,
    [IdeaStatusId]                      INT             CONSTRAINT [DF_FactK12StudentDisciplines_IdeaStatusId] DEFAULT ((-1)) NOT NULL,
NEW    [ImmigrantStatusId]                 INT             CONSTRAINT [DF_FactK12StudentDisciplines_ImmigrantStatusId] DEFAULT ((-1)) NOT NULL,
NEW    [IncidentIdentifier]                NVARCHAR (40)   NULL,
NEW    [IncidentStatusId]                  INT             CONSTRAINT [DF_FactK12StudentDisciplines_IncidentStatusId] DEFAULT ((-1)) NOT NULL,
NEW    [IncidentDateId]                    INT             CONSTRAINT [DF_FactK12StudentDisciplines_IncidentDateId] DEFAULT ((-1)) NOT NULL,
    [K12DemographicId]                  INT             CONSTRAINT [DF_FactK12StudentDisciplines_K12DemographicId] DEFAULT ((-1)) NOT NULL,
NEW    [MigrantStatusId]                   INT             CONSTRAINT [DF_FactK12StudentDisciplines_MigrantId] DEFAULT ((-1)) NOT NULL,
NEW    [NOrDStatusId]                      INT             CONSTRAINT [DF_FactK12StudentDisciplines_NOrDStatusId] DEFAULT ((-1)) NOT NULL,
NEW    [PrimaryDisabilityTypeId]           INT             CONSTRAINT [DF_FactK12StudentDisciplines_PrimaryDisabilityTypeId] DEFAULT ((-1)) NOT NULL,
NEW    [SecondaryDisabilityTypeId]         INT             CONSTRAINT [DF_FactK12StudentDisciplines_SecondaryDisabilityTypeId] DEFAULT ((-1)) NOT NULL,
NEW    [TitleIStatusId]                    INT             CONSTRAINT [DF_FactK12StudentDisciplines_TitleIStatusId] DEFAULT ((-1)) NOT NULL,
NEW    [TitleIIIStatusId]                  INT             CONSTRAINT [DF_FactK12StudentDisciplines_TitleIIIStatusId] DEFAULT ((-1)) NOT NULL,
    [DurationOfDisciplinaryAction]      DECIMAL (18, 2) NULL,
    [DisciplineCount]                   INT             CONSTRAINT [DF_FactK12StudentDisciplines_Id] DEFAULT ((1)) NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_FactK12StudentDisciplines1] PRIMARY KEY CLUSTERED ([FactK12StudentDisciplineId] ASC) WITH (FILLFACTOR = 80)
);
*/

CREATE TABLE Upgrade.FactK12StudentDisciplines (
	DisciplineCount INT
	, SchoolYear SMALLINT
	, GradeLevelCode NVARCHAR(200)
	, AgeCode NVARCHAR(200)

	, DisciplinaryActionTakenCode NVARCHAR(200)
	, DisciplineMethodOfChildrenWithDisabilitiesCode NVARCHAR(200)
	, EducationalServicesAfterRemovalCode NVARCHAR(200)
	, IdeaInterimRemovalReasonCode NVARCHAR(200)
	, IdeaInterimRemovalCode NVARCHAR(200)
	, DisciplineELStatusCode NVARCHAR(200)
    , FirearmTypeCode NVARCHAR(200)
    , DisciplineMethodForFirearmsIncidentsCode NVARCHAR(200)
	, IdeaDisciplineMethodForFirearmsIncidentsCode NVARCHAR(200)
    , DisciplinaryActionStartDate DATETIME
    , DurationOfDisciplinaryAction DECIMAL(18,2)

	, SeaIdentifierState NVARCHAR(200)
	, SEA_RecordStartDateTime DATETIME
	, SEA_RecordEndDateTime	  DATETIME
	, IeuIdentifierState NVARCHAR(200)
	, IEU_RecordStartDateTime DATETIME
	, IEU_RecordEndDateTime	  DATETIME
	, SchoolIdentifierState NVARCHAR(200)
	, SCH_RecordStartDateTime DATETIME
	, SCH_RecordEndDateTime	  DATETIME
	, StateStudentIdentifier NVARCHAR(200)
	, STU_RecordStartDateTime DATETIME
	, STU_RecordEndDateTime	  DATETIME
	, LeaIdentifierState NVARCHAR(200)
	, LEA_RecordStartDateTime DATETIME
	, LEA_RecordEndDateTime	  DATETIME

	, EconomicallyDisadvantagedStatusCode NVARCHAR(200)
	, EnglishLearnerStatusCode NVARCHAR(200)
	, IdeaIndicatorCode NVARCHAR(200)
	, PrimaryDisabilityTypeCode NVARCHAR(200)

	, EligibilityStatusForSchoolFoodServiceProgramCode  NVARCHAR(200)
	, FosterCareProgramCode NVARCHAR(200)
	, HomelessServicedIndicatorCode NVARCHAR(200)
	, Section504StatusCode NVARCHAR(200)
	, TitleIIIImmigrantParticipationStatusCode NVARCHAR(200)
	, TitleiiiProgramParticipationCode NVARCHAR(200)

	, CteAeDisplacedHomemakerIndicatorCode NVARCHAR(200)
	, CteGraduationRateInclusionCode NVARCHAR(200)
	, CteNontraditionalGenderStatusCode NVARCHAR(200)
	, CteProgramCode NVARCHAR(200)
	, LepPerkinsStatusCode NVARCHAR(200)
	, RepresentationStatusCode NVARCHAR(200)
	, SingleParentOrSinglePregnantWomanCode NVARCHAR(200)
)

INSERT INTO Upgrade.FactK12StudentDisciplines
SELECT 
	f.DisciplineCount
	, rdsy.SchoolYear
	, rdgl.GradeLevelCode
	, rda.AgeCode

	, rdd.DisciplinaryActionTakenCode
	, rdd.DisciplineMethodOfChildrenWithDisabilitiesCode
	, rdd.EducationalServicesAfterRemovalCode
	, rdd.IdeaInterimRemovalReasonCode
	, rdd.IdeaInterimRemovalCode
	, rdd.DisciplineELStatusCode
    , rdf.FirearmTypeCode
    , rdfd.DisciplineMethodForFirearmsIncidentsCode
	, rdfd.IdeaDisciplineMethodForFirearmsIncidentsCode
    , f.DisciplinaryActionStartDate
    , f.DisciplineDuration

	, rds.SeaIdentifierState
	, rds.RecordStartDateTime AS SEA_RecordStartDateTime
	, rds.RecordEndDateTime   AS SEA_RecordEndDateTime
	, rdi.IeuIdentifierState
	, rdi.RecordStartDateTime AS IEU_RecordStartDateTime
	, rdi.RecordEndDateTime	  AS IEU_RecordEndDateTime
	, rdlea.LeaIdentifierState
	, rdlea.RecordStartDateTime AS LEA_RecordStartDateTime
	, rdlea.RecordEndDateTime	AS LEA_RecordEndDateTime
	, rdksch.SchoolIdentifierState
	, rdksch.RecordStartDateTime AS SCH_RecordStartDateTime
	, rdksch.RecordEndDateTime	 AS SCH_RecordEndDateTime
	, rdkstu.StateStudentIdentifier
	, rdkstu.RecordStartDateTime  AS STU_RecordStartDateTime
	, rdkstu.RecordEndDateTime	  AS STU_RecordEndDateTime

	, rdkd.EconomicDisadvantageStatusCode
	, rdkd.EnglishLearnerStatusCode
	, rdis.IdeaIndicatorCode
	, rdis.PrimaryDisabilityTypeCode

	, rdps.EligibilityStatusForSchoolFoodServiceProgramCode
	, rdps.FosterCareProgramCode
	, rdps.HomelessServicedIndicatorCode
	, rdps.Section504StatusCode
	, rdps.TitleIIIImmigrantParticipationStatusCode
	, rdps.TitleiiiProgramParticipationCode

	, rdctes.CteAeDisplacedHomemakerIndicatorCode
	, rdctes.CteGraduationRateInclusionCode
	, rdctes.CteNontraditionalGenderStatusCode
	, rdctes.CteProgramCode
	, rdctes.LepPerkinsStatusCode
	, rdctes.RepresentationStatusCode
	, rdctes.SingleParentOrSinglePregnantWomanCode

FROM RDS.FactK12StudentDisciplines f
JOIN RDS.DimSchoolYears rdsy ON f.SchoolYearId = rdsy.DimSchoolYearId
JOIN RDS.DimGradeLevels rdgl ON f.GradeLevelId = rdgl.DimGradeLevelId
JOIN RDS.DimAges rda ON f.AgeId = rda.DimAgeId
JOIN RDS.DimRaces rdr ON f.RaceId = rdr.DimRaceId
JOIN RDS.DimDisciplines rdd ON f.DisciplineId = rdd.DimDisciplineId
JOIN RDS.DimFirearms rdf ON f.FirearmsId = rdf.DimFirearmsId
JOIN RDS.DimFirearmDisciplines rdfd ON f.FirearmDisciplineId = rdfd.DimFirearmDisciplineId

JOIN RDS.DimSeas rds ON f.SeaId = rds.DimSeaId
LEFT JOIN RDS.DimIeus rdi ON f.IeuId = rdi.DimIeuId
JOIN RDS.DimLeas rdlea ON f.LeaId = rdlea.DimLeaID
JOIN RDS.DimK12Schools rdksch ON f.K12SchoolId = rdksch.DimK12SchoolId
JOIN RDS.DimK12Students rdkstu ON f.K12StudentId = rdkstu.DimK12StudentId

JOIN RDS.DimK12Demographics rdkd ON f.K12DemographicId = rdkd.DimK12DemographicId
JOIN RDS.DimIdeaStatuses rdis ON f.IdeaStatusId = rdis.DimIdeaStatusId
JOIN RDS.DimCteStatuses rdctes ON f.CteStatusId = rdctes.DimCteStatusId
JOIN RDS.DimProgramStatuses rdps ON f.ProgramStatusId = rdps.DimProgramStatusId



/*******************************************************************************************************/

/*
CREATE TABLE [RDS].[tmp_ms_xx_ReportEDFactsK12StaffCounts] (
    [ReportEDFactsK12StaffCountId]            INT             IDENTITY (1, 1) NOT NULL,
    [SPECIALEDUCATIONAGEGROUPTAUGHT]          NVARCHAR (50)   NULL,
    [CERTIFICATIONSTATUS]                     NVARCHAR (50)   NULL,
    [Categories]                              NVARCHAR (300)  NULL,
    [CategorySetCode]                         NVARCHAR (40)   NOT NULL,
    [OrganizationName]                        NVARCHAR (1000) NOT NULL,
    [OrganizationIdentifierNces]              NVARCHAR (100)  NOT NULL,
    [OrganizationIdentifierSea]               NVARCHAR (100)  NOT NULL,
    [EDFACTSTEACHERINEXPERIENCEDSTATUS]       NVARCHAR (50)   NULL,
    [ParentOrganizationIdentifierSea]         NVARCHAR (MAX)  NULL,
    [StaffCount]                              INT             NOT NULL,
    [StaffFTE]                                DECIMAL (18, 2) NOT NULL,
    [QUALIFICATIONSTATUS]                     NVARCHAR (50)   NULL,
    [ReportCode]                              NVARCHAR (40)   NOT NULL,
    [ReportLevel]                             NVARCHAR (40)   NOT NULL,
    [ReportYear]                              NVARCHAR (40)   NOT NULL,
    [SPECIALEDUCATIONSUPPORTSERVICESCATEGORY] NVARCHAR (50)   NULL,
    [StateANSICode]                           NVARCHAR (100)  NOT NULL,
    [StateAbbreviationCode]                   NVARCHAR (100)  NOT NULL,
    [StateAbbreviationDescription]            NVARCHAR (1000) NOT NULL,
    [TableTypeAbbrv]                          NVARCHAR (MAX)  NULL,
    [TotalIndicator]                          NVARCHAR (MAX)  NULL,
    [K12STAFFCLASSIFICATION]                  NVARCHAR (50)   NULL,
    [STAFFCATEGORYCCD]                        NVARCHAR (50)   NULL,
    [FORMERENGLISHLEARNERYEARSTATUS]          NVARCHAR (50)   NULL,
    [PROFICIENCYSTATUS]                       NVARCHAR (50)   NULL,
    [TITLEIIIACCOUNTABILITYPROGRESSSTATUS]    NVARCHAR (50)   NULL,
    [TITLEIIILANGUAGEINSTRUCTION]             NVARCHAR (50)   NULL,
    [EMERGENCYORPROVISIONALCREDENTIALSTATUS]  NVARCHAR (50)   NULL,
    [TITLEIPROGRAMSTAFFCATEGORY]              NVARCHAR (50)   NULL,
    [EDFACTSTEACHEROUTOFFIELDSTATUS]          NVARCHAR (50)   NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_ReportEDFactsK12StaffCounts1] PRIMARY KEY CLUSTERED ([ReportEDFactsK12StaffCountId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
);
*/

CREATE TABLE Upgrade.FactK12StaffCounts (
	StaffCount INT
	, SchoolYear SMALLINT
	, FactType NVARCHAR(200)

	, SeaIdentifierState NVARCHAR(200)
	, SEA_RecordStartDateTime DATETIME
	, SEA_RecordEndDateTime	  DATETIME
	, LeaIdentifierState NVARCHAR(200)
	, LEA_RecordStartDateTime DATETIME
	, LEA_RecordEndDateTime	  DATETIME
	, SchoolIdentifierState NVARCHAR(200)
	, SCH_RecordStartDateTime DATETIME
	, SCH_RecordEndDateTime	  DATETIME
	, StaffMemberIdentifierState NVARCHAR(200)
	, STA_RecordStartDateTime DATETIME
	, STA_RecordEndDateTime	  DATETIME
	--K12StaffStatus	
	, SpecialEducationAgeGroupTaughtCode NVARCHAR(200)
	, CertificationStatusCode NVARCHAR(200)
	, Status_K12StaffClassificationCode NVARCHAR(200)
	, QualificationStatusCode NVARCHAR(200)
	, UnexperiencedStatusCode NVARCHAR(200)
	, EmergencyOrProvisionalCredentialStatusCode NVARCHAR(200)
	, OutOfFieldStatusCode NVARCHAR(200)
	--K12StaffCategory
	, Category_K12StaffClassificationCode NVARCHAR(200)
	, SpecialEducationSupportServicesCategoryCode NVARCHAR(200)
	, TitleIProgramStaffCategoryCode NVARCHAR(200)
	--TitleIIIStatus
	, FormerEnglishLearnerYearStatusCode NVARCHAR(200)
	, ProficiencyStatusCode NVARCHAR(200)
	, TitleiiiAccountabilityProgressStatusCode NVARCHAR(200)
	, TitleiiiLanguageInstructionCode NVARCHAR(200)

	, StaffFTE DECIMAL(18,2)
)

INSERT INTO Upgrade.FactK12StaffCounts
SELECT 
	f.StaffCount
	, rdsy.SchoolYear
	, rdft.FactTypeCode

	, rds.SeaIdentifierState
	, rds.RecordStartDateTime AS SEA_RecordStartDateTime
	, rds.RecordEndDateTime   AS SEA_RecordEndDateTime
	, rdlea.LeaIdentifierState
	, rdlea.RecordStartDateTime AS LEA_RecordStartDateTime
	, rdlea.RecordEndDateTime	AS LEA_RecordEndDateTime
	, rdksch.SchoolIdentifierState
	, rdksch.RecordStartDateTime AS SCH_RecordStartDateTime
	, rdksch.RecordEndDateTime	 AS SCH_RecordEndDateTime
	, rdksta.StaffMemberIdentifierState
	, rdksta.RecordStartDateTime  AS STU_RecordStartDateTime
	, rdksta.RecordEndDateTime	  AS STU_RecordEndDateTime

	, rdkss.SpecialEducationAgeGroupTaughtCode
	, rdkss.CertificationStatusCode
	, rdkss.K12StaffClassificationCode
	, rdkss.QualificationStatusCode
	, rdkss.UnexperiencedStatusCode
	, rdkss.EmergencyOrProvisionalCredentialStatusCode
	, rdkss.OutOfFieldStatusCode

	, rdksc.K12StaffClassificationCode
	, rdksc.SpecialEducationSupportServicesCategoryCode
	, rdksc.TitleIProgramStaffCategoryCode

	, rdtiiis.FormerEnglishLearnerYearStatusCode
	, rdtiiis.ProficiencyStatusCode
	, rdtiiis.TitleiiiAccountabilityProgressStatusCode
	, rdtiiis.TitleiiiLanguageInstructionCode

	, f.StaffFTE
FROM RDS.FactK12StaffCounts f
JOIN RDS.DimSchoolYears rdsy ON f.SchoolYearId = rdsy.DimSchoolYearId
JOIN RDS.DimFactTypes rdft ON f.FactTypeId = rdft.DimFactTypeId

JOIN RDS.DimSeas rds ON f.SeaId = rds.DimSeaId
JOIN RDS.DimLeas rdlea ON f.LeaId = rdlea.DimLeaID
JOIN RDS.DimK12Schools rdksch ON f.K12SchoolId = rdksch.DimK12SchoolId
JOIN RDS.DimK12Staff rdksta ON f.K12StaffId = rdksta.DimK12StaffId

JOIN RDS.DimK12StaffStatuses rdkss ON f.K12StaffStatusId = rdkss.DimK12StaffStatusId
JOIN RDS.DimK12StaffCategories rdksc ON f.K12StaffCategoryId = rdksc.DimK12StaffCategoryId
JOIN RDS.DimTitleIIIStatuses rdtiiis ON f.TitleIIIStatusId = rdtiiis.DimTitleIIIStatusId

/*******************************************************************************************************/

CREATE TABLE Upgrade.FactK12StudentAssessments (
	  AssessmentCount	INT
	, SchoolYear SMALLINT
	, FactType NVARCHAR(200)
	, GradeLevelCode NVARCHAR(200)
	, RaceCode NVARCHAR(200)

	, SeaIdentifierState NVARCHAR(200)
	, SEA_RecordStartDateTime DATETIME
	, SEA_RecordEndDateTime	  DATETIME
	, IeuIdentifierState NVARCHAR(200)
	, IEU_RecordStartDateTime DATETIME
	, IEU_RecordEndDateTime	  DATETIME
	, LeaIdentifierState NVARCHAR(200)
	, LEA_RecordStartDateTime DATETIME
	, LEA_RecordEndDateTime	  DATETIME
	, SchoolIdentifierState NVARCHAR(200)
	, SCH_RecordStartDateTime DATETIME
	, SCH_RecordEndDateTime	  DATETIME
	, StateStudentIdentifier NVARCHAR(200)
	, STU_RecordStartDateTime DATETIME
	, STU_RecordEndDateTime	  DATETIME

	--K12Demographic
	, EconomicDisadvantageStatusCode NVARCHAR(200)
	, EnglishLearnerStatusCode NVARCHAR(200)
	, HomelessnessStatusCode NVARCHAR(200)
	, HomelessPrimaryNighttimeResidenceCode NVARCHAR(200)
	, HomelessUnaccompaniedYouthStatusCode NVARCHAR(200)
	, MigrantStatusCode NVARCHAR(200)
	, MilitaryConnectedStudentIndicatorCode NVARCHAR(200)
	--IdeaStatus
	, IdeaEducationalEnvironmentCode NVARCHAR(200)
	, IdeaIndicatorCode NVARCHAR(200)
	, PrimaryDisabilityTypeCode NVARCHAR(200)
	, SpecialEducationExitReasonCode NVARCHAR(200)
	--ProgramStatus
	, EligibilityStatusForSchoolFoodServiceProgramCode NVARCHAR(200)
	, FosterCareProgramCode NVARCHAR(200)
	, HomelessServicedIndicatorCode NVARCHAR(200)
	, Section504StatusCode NVARCHAR(200)
	, TitleIIIImmigrantParticipationStatusCode NVARCHAR(200)
	, TitleiiiProgramParticipationCode NVARCHAR(200)
	--AssessmentStatus
	, AssessedFirstTimeCode NVARCHAR(200)
	, AssessmentProgressLevelCode NVARCHAR(200)
	--TitleIIIStatus
	, FormerEnglishLearnerYearStatusCode NVARCHAR(200)
	, ProficiencyStatusCode NVARCHAR(200)
	, TitleiiiAccountabilityProgressStatusCode NVARCHAR(200)
	, TitleiiiLanguageInstructionCode NVARCHAR(200)
	--K12StudentStatus
	, HighSchoolDiplomaTypeCode NVARCHAR(200)
	, MobilityStatus12moCode NVARCHAR(200)
	, MobilityStatus36moCode NVARCHAR(200)
	, MobilityStatusSYCode NVARCHAR(200)
	, NSLPDirectCertificationIndicatorCode NVARCHAR(200)
	, PlacementStatusCode NVARCHAR(200)
	, PlacementTypeCode NVARCHAR(200)
	, ReferralStatusCode NVARCHAR(200)
	--NOrDProgramStatus
	, LongTermStatusCode NVARCHAR(200)
	, NeglectedOrDelinquentProgramTypeCode NVARCHAR(200)
	--CteStatus
	, CteAeDisplacedHomemakerIndicatorCode NVARCHAR(200)
	, CteGraduationRateInclusionCode NVARCHAR(200)
	, CteNontraditionalGenderStatusCode NVARCHAR(200)
	, CteProgramCode NVARCHAR(200)
	, LepPerkinsStatusCode NVARCHAR(200)
	, RepresentationStatusCode NVARCHAR(200)
	, SingleParentOrSinglePregnantWomanCode NVARCHAR(200)
	--EnrollmentStatus
	, AcademicOrVocationalExitOutcomeCode NVARCHAR(200)
	, AcademicOrVocationalOutcomeCode NVARCHAR(200)
	, EnrollmentStatusCode NVARCHAR(200)
	, EntryTypeCode NVARCHAR(200)
	, ExitOrWithdrawalTypeCode NVARCHAR(200)
	, PostSecondaryEnrollmentStatusCode NVARCHAR(200)
	--TitleIStatus
	, TitleIInstructionalServicesCode NVARCHAR(200)
	, TitleIProgramTypeCode NVARCHAR(200)
	, TitleISchoolStatusCode NVARCHAR(200)
	, TitleISupportServicesCode NVARCHAR(200)
)

INSERT INTO Upgrade.FactK12StudentAssessments
SELECT 
	  f.AssessmentCount
	, rdsy.SchoolYear
	, rdft.FactTypeCode
	, rdgl.GradeLevelCode
	, rdr.RaceCode

	, rds.SeaIdentifierState
	, rds.RecordStartDateTime AS SEA_RecordStartDateTime
	, rds.RecordEndDateTime   AS SEA_RecordEndDateTime
	, rdi.IeuIdentifierState
	, rdi.RecordStartDateTime AS IEU_RecordStartDateTime
	, rdi.RecordEndDateTime	AS IEU_RecordEndDateTime
	, rdlea.LeaIdentifierState
	, rdlea.RecordStartDateTime AS LEA_RecordStartDateTime
	, rdlea.RecordEndDateTime	AS LEA_RecordEndDateTime
	, rdksch.SchoolIdentifierState
	, rdksch.RecordStartDateTime AS SCH_RecordStartDateTime
	, rdksch.RecordEndDateTime	 AS SCH_RecordEndDateTime
	, rdkstu.StateStudentIdentifier
	, rdkstu.RecordStartDateTime  AS STU_RecordStartDateTime
	, rdkstu.RecordEndDateTime	  AS STU_RecordEndDateTime
	--K12Demographic
	, rdkd.EconomicDisadvantageStatusCode
	, rdkd.EnglishLearnerStatusCode
	, rdkd.HomelessnessStatusCode
	, rdkd.HomelessPrimaryNighttimeResidenceCode
	, rdkd.HomelessUnaccompaniedYouthStatusCode
	, rdkd.MigrantStatusCode
	, rdkd.MilitaryConnectedStudentIndicatorCode
	--IdeaStatus
	, rdis.IdeaEducationalEnvironmentCode
	, rdis.IdeaIndicatorCode
	, rdis.PrimaryDisabilityTypeCode
	, rdis.SpecialEducationExitReasonCode
	--ProgramStatus
	, rdps.EligibilityStatusForSchoolFoodServiceProgramCode
	, rdps.FosterCareProgramCode
	, rdps.HomelessServicedIndicatorCode
	, rdps.Section504StatusCode
	, rdps.TitleIIIImmigrantParticipationStatusCode
	, rdps.TitleiiiProgramParticipationCode
	--AssessmentStatus
	, rdas.AssessedFirstTimeCode
	, rdas.AssessmentProgressLevelCode
	--TitleIIIStatus
	, rdtiiis.FormerEnglishLearnerYearStatusCode
	, rdtiiis.ProficiencyStatusCode
	, rdtiiis.TitleiiiAccountabilityProgressStatusCode
	, rdtiiis.TitleiiiLanguageInstructionCode
	--K12StudentStatus
	, rdkss.HighSchoolDiplomaTypeCode
	, rdkss.MobilityStatus12moCode
	, rdkss.MobilityStatus36moCode
	, rdkss.MobilityStatusSYCode
	, rdkss.NSLPDirectCertificationIndicatorCode
	, rdkss.PlacementStatusCode
	, rdkss.PlacementTypeCode
	, rdkss.ReferralStatusCode
	--NOrDProgramStatus
	, rdnodps.LongTermStatusCode
	, rdnodps.NeglectedOrDelinquentProgramTypeCode
	--CteStatus
	, rdctes.CteAeDisplacedHomemakerIndicatorCode
	, rdctes.CteGraduationRateInclusionCode
	, rdctes.CteNontraditionalGenderStatusCode
	, rdctes.CteProgramCode
	, rdctes.LepPerkinsStatusCode
	, rdctes.RepresentationStatusCode
	, rdctes.SingleParentOrSinglePregnantWomanCode
	--EnrollmentStatus
	, rdkes.AcademicOrVocationalExitOutcomeCode
	, rdkes.AcademicOrVocationalOutcomeCode
	, rdkes.EnrollmentStatusCode
	, rdkes.EntryTypeCode
	, rdkes.ExitOrWithdrawalTypeCode
	, rdkes.PostSecondaryEnrollmentStatusCode
	--TitleIStatus
	, rdtis.TitleIInstructionalServicesCode
	, rdtis.TitleIProgramTypeCode
	, rdtis.TitleISchoolStatusCode
	, rdtis.TitleISupportServicesCode

FROM RDS.FactK12StudentAssessments f
JOIN RDS.DimSchoolYears rdsy ON f.SchoolYearId = rdsy.DimSchoolYearId
JOIN RDS.DimFactTypes rdft ON f.FactTypeId = rdft.DimFactTypeId
JOIN RDS.DimGradeLevels rdgl ON f.GradeLevelId = rdgl.DimGradeLevelId
JOIN RDS.DimRaces rdr ON f.RaceId = rdr.DimRaceId

JOIN RDS.DimSeas rds ON f.SeaId = rds.DimSeaId
JOIN RDS.DimIeus rdi ON f.IeuId = rdi.DimIeuId
JOIN RDS.DimLeas rdlea ON f.LeaId = rdlea.DimLeaID
JOIN RDS.DimK12Schools rdksch ON f.K12SchoolId = rdksch.DimK12SchoolId
JOIN RDS.DimK12Students rdkstu ON f.K12StudentId = rdkstu.DimK12StudentId

JOIN RDS.DimK12Demographics rdkd ON f.K12DemographicId = rdkd.DimK12DemographicId
JOIN RDS.DimIdeaStatuses rdis ON f.IdeaStatusId = rdis.DimIdeaStatusId
JOIN RDS.DimProgramStatuses rdps ON f.ProgramStatusId = rdps.DimProgramStatusId
JOIN RDS.DimAssessmentStatuses rdas ON f.AssessmentStatusId = rdas.DimAssessmentStatusId
JOIN RDS.DimTitleIIIStatuses rdtiiis ON f.TitleIIIStatusId = rdtiiis.DimTitleIIIStatusId
JOIN RDS.DimK12StudentStatuses rdkss ON f.K12StudentStatusId = rdkss.DimK12StudentStatusId
JOIN RDS.DimNOrDProgramStatuses rdnodps ON f.NOrDProgramStatusId = rdnodps.DimNOrDProgramStatusId
JOIN RDS.DimCteStatuses rdctes ON f.CteStatusId = rdctes.DimCteStatusId
JOIN RDS.DimK12EnrollmentStatuses rdkes ON f.EnrollmentStatusId = rdkes.DimK12EnrollmentStatusId
JOIN RDS.DimTitleIStatuses rdtis ON f.TitleIStatusId = rdtis.DimTitleIStatusId


/*******************************************************************************************************/

CREATE TABLE Upgrade.FactOrganizationCounts (
	-- Fact table
	  TitleIParentalInvolveRes			VARCHAR(500)
	, TitleIPartAAllocations								VARCHAR(500)
	, SchoolImprovementFunds	VARCHAR(500)
	, FederalFundAllocationType	VARCHAR(500)
	, FederalProgramCode	VARCHAR(500)
	, FederalFundAllocated	VARCHAR(500)
	--DimSchoolYears
	, SchoolYear	VARCHAR(500)
	--DimFactTypes	
	, FactTypeCode	VARCHAR(500)
	--DimLeas	
	, LeaIdentifierState	VARCHAR(500)
	, LEA_RecordStartDateTime	DATETIME
	, LEA_RecordEndDateTime	DATETIME
	--DimK12Staff
	, StaffMemberIdentifierState	VARCHAR(500)
	, STA_RecordStartDateTime	DATETIME
	, STA_RecordEndDateTime	DATETIME
	--DimK12Schools
	, SchoolIdentifierState	VARCHAR(500)
	, SCH_RecordStartDateTime	DATETIME
	, SCH_RecordEndDateTime	DATETIME
	--DimK12SchoolStatuses
	, DimK12SchoolStatusId	VARCHAR(500)
	, MagnetOrSpecialProgramEmphasisSchoolCode	VARCHAR(500)
	, NslpStatusCode	VARCHAR(500)
	, PersistentlyDangerousStatusCode	VARCHAR(500)
	, ProgressAchievingEnglishLanguageCode	VARCHAR(500)
	, SchoolImprovementStatusCode	VARCHAR(500)
	, SharedTimeIndicatorCode	VARCHAR(500)
	, StatePovertyDesignationCode	VARCHAR(500)
	, VirtualSchoolStatusCode	VARCHAR(500)
	--DimSeas
	, DimSeaId	VARCHAR(500)
	, RecordStartDateTime	DATETIME
	, RecordEndDateTime	DATETIME
	--DimTitleIStatus
	, DimTitleIStatusId	VARCHAR(500)
	, TitleIInstructionalServicesCode	VARCHAR(500)
	, TitleIProgramTypeCode	VARCHAR(500)
	, TitleISchoolStatusCode	VARCHAR(500)
	, TitleISupportServicesCode	VARCHAR(500)
	--DimCharterSchoolAuthorizers - Primary
	, CSAP_StateIdentifier	 	VARCHAR(500)
	, CSAP_RecordStartDateTime 	DATETIME
	, CSAP_RecordEndDateTime	 	DATETIME
	--DimCharterSchoolManagementOrganizations
	, CSMO_StateIdentifier	VARCHAR(500)
	, CSMO_RecordStartDateTime	DATETIME
	, CSMO_RecordEndDateTime	DATETIME
	--DimCharterSchoolAuthorizers - Secondary
	, CSAS_StateIdentifier	VARCHAR(500)
	, CSAS_RecordStartDateTime	DATETIME
	, CSAS_RecordEndDateTime	DATETIME
	--DimCharterSchoolManagementOrganizations - Updated
	, CSASU_StateIdentifier	VARCHAR(500)
	, CSASU_RecordStartDateTime	DATETIME
	, CSASU_RecordEndDateTime	DATETIME
	--DimK12OrganizationStatuses
	, GunFreeSchoolsActReportingStatusCode	VARCHAR(500)
	, HighSchoolGraduationRateIndicatorStatusCode	VARCHAR(500)
	, McKinneyVentoSubgrantRecipientCode	VARCHAR(500)
	, ReapAlternativeFundingStatusCode	VARCHAR(500)
	--DimK12SchoolStateStatuses
	, SchoolStateStatusCode	VARCHAR(500)
	--DimComprehensiveAndTargetedSupports
	, AdditionalTargetedSupportandImprovementCode	VARCHAR(500)
	, ComprehensiveAndTargetedSupportCode	VARCHAR(500)
	, ComprehensiveSupportCode	VARCHAR(500)
	, ComprehensiveSupportImprovementCode	VARCHAR(500)
	, TargetedSupportCode	VARCHAR(500)
	, TargetedSupportImprovementCode	VARCHAR(500)
	--DimSubgroups
	, SubgroupCode	VARCHAR(500)
	--DimComprehensiveSupportReasonApplicabilities
	, ComprehensiveSupportReasonApplicabilityCode	VARCHAR(500)
)

INSERT INTO Upgrade.FactOrganizationCounts
SELECT 
	-- Fact table
	  f.TitleIParentalInvolveRes
	, f.TitleIPartAAllocations
	, f.SchoolImprovementFunds
	, f.FederalFundAllocationType
	, f.FederalProgramCode
	, f.FederalFundAllocated
	--DimSchoolYears
	, rdsy.SchoolYear
	--DimFactTypes
	, rdft.FactTypeCode
	--DimLeas
	, rdl.LeaIdentifierState
	, rdl.RecordStartDateTime
	, rdl.RecordEndDateTime
	--DimK12Staff
	, rdksta.StaffMemberIdentifierState
	, rdksta.RecordStartDateTime
	, rdksta.RecordEndDateTime
	--DimK12Schools
	, rdksch.SchoolIdentifierState
	, rdksch.RecordStartDateTime
	, rdksch.RecordEndDateTime
	--DimK12SchoolStatuses
	, rdkss.DimK12SchoolStatusId
	, rdkss.MagnetOrSpecialProgramEmphasisSchoolCode
	, rdkss.NslpStatusCode
	, rdkss.PersistentlyDangerousStatusCode
	, rdkss.ProgressAchievingEnglishLanguageCode
	, rdkss.SchoolImprovementStatusCode
	, rdkss.SharedTimeIndicatorCode
	, rdkss.StatePovertyDesignationCode
	, rdkss.VirtualSchoolStatusCode
	--DimSeas
	, rds.DimSeaId
	, rds.RecordStartDateTime
	, rds.RecordEndDateTime
	--DimTitleIStatus
	, rdtis.DimTitleIStatusId
	, rdtis.TitleIInstructionalServicesCode
	, rdtis.TitleIProgramTypeCode
	, rdtis.TitleISchoolStatusCode
	, rdtis.TitleISupportServicesCode
	--DimCharterSchoolAuthorizers - Primary
	, rdcsap.StateIdentifier	 
	, rdcsap.RecordStartDateTime 
	, rdcsap.RecordEndDateTime	 
	--DimCharterSchoolManagementOrganizations
	, rdcsmo.StateIdentifier
	, rdcsmo.RecordStartDateTime
	, rdcsmo.RecordEndDateTime
	--DimCharterSchoolAuthorizers - Secondary
	, rdcsas.StateIdentifier
	, rdcsas.RecordStartDateTime
	, rdcsas.RecordEndDateTime
	--DimCharterSchoolManagementOrganizations - Updated
	, rdcsumo.StateIdentifier
	, rdcsumo.RecordStartDateTime
	, rdcsumo.RecordEndDateTime
	--DimK12OrganizationStatuses
	, rdkos.GunFreeSchoolsActReportingStatusCode
	, rdkos.HighSchoolGraduationRateIndicatorStatusCode
	, rdkos.McKinneyVentoSubgrantRecipientCode
	, rdkos.ReapAlternativeFundingStatusCode
	--DimK12SchoolStateStatuses
	, rdksss.SchoolStateStatusCode
	--DimComprehensiveAndTargetedSupports
	, rdcats.AdditionalTargetedSupportandImprovementCode
	, rdcats.ComprehensiveAndTargetedSupportCode
	, rdcats.ComprehensiveSupportCode
	, rdcats.ComprehensiveSupportImprovementCode
	, rdcats.TargetedSupportCode
	, rdcats.TargetedSupportImprovementCode
	--DimSubgroups
	, rdsub.SubgroupCode
	--DimComprehensiveSupportReasonApplicabilities
	, rdcsra.ComprehensiveSupportReasonApplicabilityCode
FROM RDS.FactOrganizationCounts f
JOIN RDS.DimSchoolYears rdsy ON f.SchoolYearId = rdsy.DimSchoolYearId
JOIN RDS.DimFactTypes rdft ON f.FactTypeId = rdft.DimFactTypeId
JOIN RDS.DimLeas rdl ON f.LeaId = rdl.DimLeaID
JOIN RDS.DimK12Staff rdksta ON f.K12StaffId = rdksta.DimK12StaffId
JOIN RDS.DimK12Schools rdksch ON f.K12SchoolId = rdksch.DimK12SchoolId
JOIN RDS.DimK12SchoolStatuses rdkss ON f.SchoolStateStatusId = rdkss.DimK12SchoolStatusId
JOIN RDS.DimSeas rds ON f.SeaId = rds.DimSeaId
JOIN RDS.DimTitleIStatuses rdtis ON f.TitleIStatusId = rdtis.DimTitleIStatusId
JOIN RDS.DimCharterSchoolAuthorizers rdcsap ON f.CharterSchoolApproverAgencyId = rdcsap.DimCharterSchoolAuthorizerId
JOIN RDS.DimCharterSchoolManagementOrganizations rdcsmo ON f.CharterSchoolManagerOrganizationId = rdcsmo.DimCharterSchoolManagementOrganizationId
JOIN RDS.DimCharterSchoolAuthorizers rdcsas ON f.CharterSchoolSecondaryApproverAgencyId = rdcsas.DimCharterSchoolAuthorizerId
JOIN RDS.DimCharterSchoolManagementOrganizations rdcsumo ON f.CharterSchoolUpdatedManagerOrganizationId = rdcsumo.DimCharterSchoolManagementOrganizationId
JOIN RDS.DimK12OrganizationStatuses rdkos ON f.OrganizationStatusId = rdkos.DimK12OrganizationStatusId
JOIN RDS.DimK12SchoolStateStatuses rdksss ON f.SchoolStateStatusId = rdksss.DimK12SchoolStateStatusId
JOIN RDS.DimComprehensiveAndTargetedSupports rdcats ON f.ComprehensiveAndTargetedSupportId = rdcats.DimComprehensiveAndTargetedSupportId
JOIN RDS.DimSubgroups rdsub ON f.DimSubgroupId = f.DimSubgroupId
JOIN RDS.DimComprehensiveSupportReasonApplicabilities rdcsra ON f.DimComprehensiveSupportReasonApplicabilityId = rdcsra.DimComprehensiveSupportReasonApplicabilityId


/*******************************************************************************************************/
