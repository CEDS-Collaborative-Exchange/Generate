-- ==========================================================================================
-- CIID-9061: Correct stale StagingColumnName values in App.GenerateStagingColumns.
--
-- App.GenerateStagingColumns is seeded from the external EDFacts/CEDS metadata database and feeds
-- ONLY App.vwStagingRelationships (no stored proc or report engine reads it), which drives the ETL
-- Checklist coverage/readiness checks and the AI ETL Developer's required-column list. Several rows
-- carried column names that don't exist in the Staging schema (naming drift): status/participation
-- "EndDate" where the tables use "ExitDate", "BeginDate" where they use "StartDate", and
-- "Military*StudentIndicator" where the table uses "Military*StatusIndicator". These "phantom"
-- columns made file specs look like they required columns that can't exist, distorting coverage.
--
-- This corrects each wrong name to the real one, but ONLY where the corrected column actually exists
-- in that row's Staging table — so it is fully idempotent (a second run matches nothing) and safe
-- (it never invents a mapping, and skips tables/columns that don't exist). Because nothing but the
-- view consumes this table, it cannot change any report/migration output.
-- ==========================================================================================
SET NOCOUNT ON;

DECLARE @fix TABLE (WrongName sysname, RightName sysname);
INSERT INTO @fix (WrongName, RightName) VALUES
    -- PersonStatus: status/program-participation exit dates (table uses *ExitDate, not *EndDate)
    ('EconomicDisadvantage_StatusEndDate',        'EconomicDisadvantage_StatusExitDate'),
    ('EnglishLearner_StatusEndDate',              'EnglishLearner_StatusExitDate'),
    ('FosterCare_ProgramParticipationEndDate',    'FosterCare_ProgramParticipationExitDate'),
    ('Homelessness_StatusEndDate',                'Homelessness_StatusExitDate'),
    ('HomelessNightTimeResidence_EndDate',        'HomelessNightTimeResidence_ExitDate'),
    ('Immigrant_ProgramParticipationEndDate',     'Immigrant_ProgramParticipationExitDate'),
    ('Migrant_StatusEndDate',                     'Migrant_StatusExitDate'),
    ('MilitaryConnected_StatusEndDate',           'MilitaryConnected_StatusExitDate'),
    ('PerkinsEnglishLearnerStatus_StatusEndDate', 'PerkinsEnglishLearnerStatus_StatusExitDate'),
    ('Section504_ProgramParticipationEndDate',    'Section504_ProgramParticipationExitDate'),
    -- PersonStatus: military indicators (table uses *StatusIndicator, not *StudentIndicator)
    ('MilitaryActiveStudentIndicator',            'MilitaryActiveStatusIndicator'),
    ('MilitaryVeteranStudentIndicator',           'MilitaryVeteranStatusIndicator'),
    -- ProgramParticipation* tables: begin/end dates (tables use StartDate / ExitDate)
    ('ProgramParticipationBeginDate',             'ProgramParticipationStartDate'),
    ('ProgramParticipationEndDate',               'ProgramParticipationExitDate'),
    -- K12Organization: Title I school designation (table uses School_TitleISchoolStatus)
    ('School_TitleIPartASchoolDesignation',       'School_TitleISchoolStatus');

UPDATE gsc
    SET gsc.StagingColumnName = f.RightName
FROM app.GenerateStagingColumns gsc
JOIN app.GenerateStagingTables gst ON gst.StagingTableId = gsc.StagingTableId
JOIN @fix f ON f.WrongName = gsc.StagingColumnName
WHERE EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS c
    WHERE c.TABLE_SCHEMA = 'Staging'
      AND c.TABLE_NAME  = gst.StagingTableName
      AND c.COLUMN_NAME = f.RightName);

PRINT 'App.GenerateStagingColumns.FixColumnNames.sql: corrected ' + CAST(@@ROWCOUNT AS varchar(10)) + ' staging column name(s).';
