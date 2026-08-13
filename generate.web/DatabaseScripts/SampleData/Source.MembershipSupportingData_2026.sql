/*
    Source.MembershipSupportingData_2026.sql
    ----------------------------------------
    Creates and populates the THREE supporting Source datasets the "membership" file spec
    (EDFacts report codes 033 / 052 / 226) needs but that the FS052 map did not yet cover:

        Source.StateDetailExtract2026     -> Staging.StateDetail       (1 SEA row)
        Source.OrganizationExtract2026    -> Staging.K12Organization   (IEU + LEA + School)
        Source.PersonStatusExtract2026    -> Staging.PersonStatus       (per-student subgroup flags)

    All keys are derived from the existing Source.MembershipExtract2026 (PupilNbr / RespDistCd /
    RespBldgCd / RptYr), so they JOIN cleanly to the already-mapped K12Enrollment + K12PersonRace.

    Values are the STATE'S natural source codes (e.g. 'Regular school', 'Free') — the ETL Checklist
    mapper translates them to CEDS via the accompanying data-dictionary upload. Idempotent: safe to
    re-run (drops and reloads the three tables only).
*/
SET NOCOUNT ON;
DECLARE @SchoolYear SMALLINT = 2026;

------------------------------------------------------------------------------------------
-- 1) State detail — one row describing the SEA.
------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Source.StateDetailExtract2026;
CREATE TABLE Source.StateDetailExtract2026 (
    StateAbbreviationCode           char(2)         NOT NULL,
    SeaOrganizationName             nvarchar(250)   NULL,
    SeaOrganizationShortName        nvarchar(20)    NULL,
    SeaOrganizationIdentifierSea    nvarchar(7)     NULL,
    SeaWebSiteAddress               nvarchar(300)   NULL,
    SeaContactFirstName             nvarchar(100)   NULL,
    SeaContactLastOrSurname         nvarchar(100)   NULL,
    SeaContactPersonalTitleOrPrefix nvarchar(100)   NULL,
    SeaContactElectronicMailAddress nvarchar(127)   NULL,
    SeaContactPhoneNumber           nvarchar(100)   NULL,
    SeaContactIdentifier            nvarchar(100)   NULL,
    SeaContactPositionTitle         nvarchar(100)   NULL,
    CteGraduationRateInclusion      nvarchar(100)   NULL,
    SchoolYear                      smallint        NULL
);

INSERT INTO Source.StateDetailExtract2026
SELECT 'NJ', 'New Jersey Department of Education', 'NJDOE', '3400000',
       'https://www.nj.gov/education',
       'Pat', 'Reilly', 'Ms.', 'edfacts.coordinator@doe.nj.gov', '609-555-0100', 'SEA-CONTACT-001',
       'EDFacts State Coordinator',
       'All CTE concentrators are included', @SchoolYear;

------------------------------------------------------------------------------------------
-- 2) Organization — one row per school, carrying its LEA and the single statewide IEU.
--    (Derived from the distinct district/school codes in the membership extract.)
------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Source.OrganizationExtract2026;
CREATE TABLE Source.OrganizationExtract2026 (
    IeuIdentifierSea                nvarchar(50)    NULL,
    IeuOrganizationName             nvarchar(256)   NULL,
    IeuOrganizationOperationalStatus varchar(100)   NULL,
    IeuOperationalStatusEffectiveDate date          NULL,
    IeuWebSiteAddress               varchar(300)    NULL,
    LeaIdentifierSea                nvarchar(50)    NOT NULL,
    LeaIdentifierNCES               nvarchar(50)    NULL,
    LeaOrganizationName             varchar(256)    NULL,
    LeaOperationalStatus            varchar(100)    NULL,
    LeaOperationalStatusEffectiveDate date          NULL,
    LeaType                         varchar(100)    NULL,
    LeaCharterSchoolIndicator       bit             NULL,
    LeaCharterLeaStatus             varchar(100)    NULL,
    LeaWebSiteAddress               varchar(300)    NULL,
    LeaIsReportedFederally          bit             NULL,
    SchoolIdentifierSea             nvarchar(50)    NOT NULL,
    SchoolIdentifierNCES            nvarchar(50)    NULL,
    SchoolOrganizationName          varchar(256)    NULL,
    SchoolOperationalStatus         varchar(100)    NULL,
    SchoolOperationalStatusEffectiveDate date       NULL,
    SchoolType                      varchar(100)    NULL,
    SchoolCharterSchoolIndicator    bit             NULL,
    SchoolVirtualSchoolStatus       varchar(100)    NULL,
    SchoolTitleISchoolStatus        varchar(100)    NULL,
    SchoolNationalSchoolLunchProgramStatus varchar(100) NULL,
    SchoolWebSiteAddress            varchar(300)    NULL,
    SchoolIsReportedFederally       bit             NULL,
    SchoolYear                      smallint        NULL
);

INSERT INTO Source.OrganizationExtract2026
SELECT DISTINCT
       '34IEU01', 'New Jersey Statewide Intermediate Unit', 'Open', '2025-07-01', 'https://www.nj.gov/education',
       m.RespDistCd,
       '34' + RIGHT('00000' + CAST(ABS(CHECKSUM(m.RespDistCd)) % 100000 AS varchar(5)), 5),
       'District ' + m.RespDistCd + ' Public Schools',
       'Open', '2025-07-01', 'Regular local school district', 0, 'Not a charter LEA',
       'https://www.district' + m.RespDistCd + '.k12.nj.us', 1,
       m.RespBldgCd,
       '34' + RIGHT('0000000' + CAST(ABS(CHECKSUM(m.RespBldgCd)) % 10000000 AS varchar(7)), 7),
       'School ' + m.RespBldgCd,
       'Open', '2025-07-01', 'Regular school', 0, 'Not a virtual school',
       'Not a Title I school',
       'No participation in the National School Lunch Program',
       'https://school' + m.RespBldgCd + '.k12.nj.us', 1,
       @SchoolYear
FROM Source.MembershipExtract2026 m
WHERE m.RespDistCd IS NOT NULL AND m.RespBldgCd IS NOT NULL;

------------------------------------------------------------------------------------------
-- 3) Person status — one row per student, with realistic (deterministic) subgroup flags.
--    Bucket 0-99 from CHECKSUM(PupilNbr) drives the distribution so re-runs are stable.
------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Source.PersonStatusExtract2026;
CREATE TABLE Source.PersonStatusExtract2026 (
    StudentIdentifierState          nvarchar(40)    NOT NULL,
    LeaIdentifierSeaAccountability  nvarchar(50)    NULL,
    LeaIdentifierSeaAttendance      nvarchar(50)    NULL,
    LeaIdentifierSeaFunding         nvarchar(50)    NULL,
    SchoolIdentifierSea             nvarchar(50)    NULL,
    ResponsibleSchoolTypeAccountability bit         NULL,
    ResponsibleSchoolTypeAttendance bit             NULL,
    ResponsibleSchoolTypeFunding    bit             NULL,
    EnrollmentEntryDate             date            NULL,
    EnrollmentExitDate              date            NULL,
    HomelessnessStatus              bit             NULL,
    HomelessnessStatusStartDate     date            NULL,
    HomelessNightTimeResidence      nvarchar(100)   NULL,
    HomelessUnaccompaniedYouth      bit             NULL,
    HomelessServicedIndicator       bit             NULL,
    EconomicDisadvantageStatus      bit             NULL,
    EconomicDisadvantageStatusStartDate date        NULL,
    EligibilityStatusForSchoolFoodServicePrograms nvarchar(100) NULL,
    NationalSchoolLunchProgramDirectCertificationIndicator bit NULL,
    MigrantStatus                   bit             NULL,
    EnglishLearnerStatus            bit             NULL,
    EnglishLearnerStatusStartDate   date            NULL,
    HomeLanguage                    nvarchar(100)   NULL,
    NativeLanguage                  nvarchar(100)   NULL,
    ProgramType_FosterCare          bit             NULL,
    ProgramType_Section504          bit             NULL,
    ProgramType_Immigrant           bit             NULL,
    SchoolYear                      smallint        NULL
);

;WITH s AS (
    SELECT m.PupilNbr, m.RespDistCd, m.RespBldgCd, m.EnrDt, m.WdrawDt,
           ABS(CHECKSUM(m.PupilNbr)) % 100 AS bucket,
           ROW_NUMBER() OVER (PARTITION BY m.PupilNbr ORDER BY m.EnrDt DESC) AS rn
    FROM Source.MembershipExtract2026 m
    WHERE m.PupilNbr IS NOT NULL
)
INSERT INTO Source.PersonStatusExtract2026
SELECT s.PupilNbr,
       s.RespDistCd, s.RespDistCd, s.RespDistCd,
       s.RespBldgCd,
       1, 1, 1,                                              -- responsible school = this school
       s.EnrDt, s.WdrawDt,
       CASE WHEN s.bucket < 8  THEN 1 ELSE 0 END,            -- ~8% homeless
       CASE WHEN s.bucket < 8  THEN s.EnrDt END,
       CASE WHEN s.bucket < 8  THEN 'Doubled-up' END,
       CASE WHEN s.bucket < 3  THEN 1 ELSE 0 END,            -- some homeless are unaccompanied
       CASE WHEN s.bucket < 8  THEN 1 ELSE 0 END,
       CASE WHEN s.bucket < 45 THEN 1 ELSE 0 END,            -- ~45% economically disadvantaged
       CASE WHEN s.bucket < 45 THEN s.EnrDt END,
       CASE WHEN s.bucket < 35 THEN 'Free' WHEN s.bucket < 45 THEN 'Reduced price' ELSE 'Full price' END,
       CASE WHEN s.bucket < 20 THEN 1 ELSE 0 END,            -- direct-cert subset
       CASE WHEN s.bucket % 33 = 0 THEN 1 ELSE 0 END,        -- ~3% migrant
       CASE WHEN s.bucket % 7  = 0 THEN 1 ELSE 0 END,        -- ~14% English learner
       CASE WHEN s.bucket % 7  = 0 THEN s.EnrDt END,
       CASE WHEN s.bucket % 7  = 0 THEN 'spa' ELSE 'eng' END,
       CASE WHEN s.bucket % 7  = 0 THEN 'spa' ELSE 'eng' END,
       CASE WHEN s.bucket % 50 = 0 THEN 1 ELSE 0 END,        -- ~2% foster care
       CASE WHEN s.bucket % 11 = 0 THEN 1 ELSE 0 END,        -- ~9% Section 504
       CASE WHEN s.bucket % 20 = 0 THEN 1 ELSE 0 END,        -- ~5% immigrant
       @SchoolYear
FROM s
WHERE s.rn = 1;

------------------------------------------------------------------------------------------
-- Row-count summary
------------------------------------------------------------------------------------------
SELECT 'Source.StateDetailExtract2026'  AS TableName, COUNT(*) AS Rows FROM Source.StateDetailExtract2026
UNION ALL SELECT 'Source.OrganizationExtract2026',  COUNT(*) FROM Source.OrganizationExtract2026
UNION ALL SELECT 'Source.PersonStatusExtract2026',  COUNT(*) FROM Source.PersonStatusExtract2026;
