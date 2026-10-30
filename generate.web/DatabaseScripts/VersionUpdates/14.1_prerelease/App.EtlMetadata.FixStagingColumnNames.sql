-- ==========================================================================================
-- CIID-9061: Correct stale Destination_Staging_Column_Name values in App.EtlMetadata.
--
-- App.EtlMetadata is seeded from the external EDFacts/CEDS metadata database. It is read only by the
-- application's ETL Checklist mapping catalog (no stored proc / report engine references it), where
-- Destination_Staging_Column_Name supplies each CEDS element's Staging target column. Several rows
-- carried column names that don't exist in the live Staging schema (the same naming drift corrected
-- in App.GenerateStagingColumns): status/participation "EndDate" where the tables use "ExitDate", and
-- "BeginDate" where they use "StartDate". Those "phantom" targets keep valid CEDS elements from being
-- offered against the real column.
--
-- Corrects each wrong name to the real one, but ONLY where the corrected column actually exists in
-- that row's Destination Staging table -- so it is fully idempotent (a second run matches nothing) and
-- safe: it never invents a target, and skips placeholder/pending/malformed rows and any table/column
-- that doesn't exist. Nothing but the mapping catalog reads this table, so report output is unaffected.
-- ==========================================================================================
SET NOCOUNT ON;

DECLARE @fix TABLE (WrongName sysname, RightName sysname);
INSERT INTO @fix (WrongName, RightName) VALUES
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
    ('MilitaryActiveStudentIndicator',            'MilitaryActiveStatusIndicator'),
    ('MilitaryVeteranStudentIndicator',           'MilitaryVeteranStatusIndicator'),
    ('ProgramParticipationBeginDate',             'ProgramParticipationStartDate'),
    ('ProgramParticipationEndDate',               'ProgramParticipationExitDate'),
    ('School_TitleIPartASchoolDesignation',       'School_TitleISchoolStatus');

UPDATE md
    SET md.Destination_Staging_Column_Name = f.RightName
FROM App.EtlMetadata md
JOIN @fix f ON f.WrongName = md.Destination_Staging_Column_Name
WHERE md.Destination_Staging_Table_Name IS NOT NULL
  AND EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS c
    WHERE c.TABLE_SCHEMA = 'Staging'
      AND c.TABLE_NAME  = md.Destination_Staging_Table_Name
      AND c.COLUMN_NAME = f.RightName);

PRINT 'App.EtlMetadata.FixStagingColumnNames.sql: corrected ' + CAST(@@ROWCOUNT AS varchar(10)) + ' staging column name(s).';
