   -- Add Index on Staging.ProgramParticipationNorD -------------------------------------
if exists (
	SELECT * 
	FROM sys.indexes 
	WHERE name='IX_ProgramParticipationNOrD_Student_LEA_School_BeginDate_EndDate' 
	AND object_id = OBJECT_ID('Staging.ProgramParticipationNorD')
	)
begin
	DROP INDEX IX_ProgramParticipationNOrD_Student_LEA_School_BeginDate_EndDate ON Staging.ProgramParticipationNorD
end


CREATE NONCLUSTERED INDEX IX_ProgramParticipationNOrD_Student_LEA_School_BeginDate_EndDate 
	ON Staging.ProgramParticipationNorD (
		StudentIdentifierState,
		LeaIdentifierSeaAccountability,
		SchoolIdentifierSea,
		ProgramParticipationBeginDate,
		ProgramParticipationEndDate
	) 
  ---------------------------------------------------------------------------------------- 
   
    IF COL_LENGTH('Staging.K12Organization', 'School_TitleIPartASchoolDesignation') IS NOT NULL
    BEGIN
        EXEC sp_rename 'Staging.K12Organization.School_TitleIPartASchoolDesignation', 'School_TitleISchoolStatus', 'COLUMN';
    END
    
------------------------------------------------
--Add the columns for the N or D file specs
------------------------------------------------
    --drop extended properties and indexes
    EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
    GO

    EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
    GO

    EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
    GO

    EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
    GO

    EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
    GO

    DROP INDEX [IX_Staging_ProgramParticipationNOrD_DataCollectionName] ON [Staging].[ProgramParticipationNorD]

    --Drop DataCollectionName and RunDateTime, they are added back after the 2 new columns to keep the 
    --	structure of the table clean
    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'DataCollectionName') IS NOT NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD DROP COLUMN DataCollectionName;
    END

    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'RunDateTime') IS NOT NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD DROP COLUMN RunDateTime;
    END

    --Change the data type of the existing column
    UPDATE Staging.ProgramParticipationNorD
    SET NeglectedOrDelinquentAcademicOutcomeIndicator = NULL

    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'NeglectedOrDelinquentAcademicOutcomeIndicator') IS NOT NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD ALTER COLUMN NeglectedOrDelinquentAcademicOutcomeIndicator bit;
    END

    --Add the new columns
    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'NeglectedOrDelinquentStatus') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD ADD NeglectedOrDelinquentStatus bit;
    END

    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'NeglectedOrDelinquentProgramEnrollmentSubpart') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD ADD NeglectedOrDelinquentProgramEnrollmentSubpart nvarchar(100);
    END

    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'NeglectedOrDelinquentAcademicAchievementIndicator') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD ADD NeglectedOrDelinquentAcademicAchievementIndicator bit;
    END

    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'EdFactsAcademicOrCareerAndTechnicalOutcomeType') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD ADD EdFactsAcademicOrCareerAndTechnicalOutcomeType nvarchar(100);
    END

    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD ADD EdFactsAcademicOrCareerAndTechnicalOutcomeExitType nvarchar(100);
    END

    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'NeglectedOrDelinquentExitOutcomeDate') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD ADD NeglectedOrDelinquentExitOutcomeDate datetime;
    END

    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'NeglectedProgramType') IS  NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD ADD NeglectedProgramType nvarchar(100);
    END

    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'DelinquentProgramType') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD ADD DelinquentProgramType nvarchar(100);
    END

    --Add DataCollectionName and RunDateTime back
    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'DataCollectionName') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD ADD DataCollectionName nvarchar(100);
    END

    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'RunDateTime') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD ADD RunDateTime datetime;
    END

    --add the index
    CREATE NONCLUSTERED INDEX [IX_Staging_ProgramParticipationNOrD_DataCollectionName] ON [Staging].[ProgramParticipationNorD]
    (
        [DataCollectionName] ASC
    )
    INCLUDE([LeaIdentifierSeaAccountability],[LeaIdentifierSeaAttendance],[LeaIdentifierSeaFunding],[LeaIdentifierSeaGraduation],[LeaIdentifierSeaIndividualizedEducationProgram],[SchoolIdentifierSea],[StudentIdentifierState]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    GO

    --add the extended properties
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A human readable name used to identify the data within the collection.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Data Collection Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22923' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'Student was served by Title I, Part D, Subpart 1 of ESEA as amended for at least 90 consecutive days during the reporting period who took both a pre- and post-test.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedOrDelinquentAcademicAchievementIndicator'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Neglected or Delinquent Academic Achievement Indicator' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedOrDelinquentAcademicAchievementIndicator'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000635' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedOrDelinquentAcademicAchievementIndicator'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000635' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedOrDelinquentAcademicAchievementIndicator'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedOrDelinquentAcademicAchievementIndicator'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of academic or career and technical outcome attained up to 90 days after exiting the facility or program.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'EDFacts Academic or Career and Technical Outcome Exit Type' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001979' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/001979' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of academic or career and technical outcome attained while enrolled in the program.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'EdFactsAcademicOrCareerAndTechnicalOutcomeType'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'EDFacts Academic or Career and Technical Outcome Type' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'EdFactsAcademicOrCareerAndTechnicalOutcomeType'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001978' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'EdFactsAcademicOrCareerAndTechnicalOutcomeType'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/001978' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'EdFactsAcademicOrCareerAndTechnicalOutcomeType'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'EdFactsAcademicOrCareerAndTechnicalOutcomeType'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The date of the outcome after exiting a neglected or delinquent program' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedOrDelinquentExitOutcomeDate'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Neglected or Delinquent Exit Outcome Date' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedOrDelinquentExitOutcomeDate'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'NA' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedOrDelinquentExitOutcomeDate'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'NA' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedOrDelinquentExitOutcomeDate'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedOrDelinquentExitOutcomeDate'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of delinquent programs under Title I, Part D, Subpart 1 (State Agency) of ESEA as amended or under Title I, Part D, Subpart 2 (LEA) of ESEA, as amended.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DelinquentProgramType'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Delinquent Program Type' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DelinquentProgramType'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'002085' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DelinquentProgramType'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/002085' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DelinquentProgramType'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DelinquentProgramType'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of neglected programs under Title I, Part D, Subpart 1 (State Agency) of ESEA as amended.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedProgramType'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Neglected Program Type' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedProgramType'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'002084' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedProgramType'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/002084' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedProgramType'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedProgramType'
