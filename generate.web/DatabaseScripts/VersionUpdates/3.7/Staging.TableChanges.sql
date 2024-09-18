-- Staging table changes
----------------------------------
set nocount on
begin try
	begin transaction

	DROP TABLE Staging.PersonRace

	CREATE TABLE Staging.PersonRace (
		[ID]                       INT           IDENTITY (1, 1) NOT NULL,
		[Student_Identifier_State] VARCHAR (100) NULL,
		[Lea_Identifier_State]     VARCHAR (100) NULL,
		[School_Identifier_State]  VARCHAR (100) NULL,
		[RaceType]                 VARCHAR (100) NULL,
		[RecordStartDateTime]      DATETIME      NULL,
		[RecordEndDateTime]        DATETIME      NULL,
		[PersonDemographicRaceId]  INT           NULL,
		[RunDateTime]              DATETIME      NULL
		)

	exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonRace', @level2type = N'Column', @level2name = 'Student_Identifier_State' 
	exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonRace', @level2type = N'Column', @level2name = 'Lea_Identifier_State' 
	exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonRace', @level2type = N'Column', @level2name = 'School_Identifier_State' 
	exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonRace', @level2type = N'Column', @level2name = 'RaceType' 
	exec sp_addextendedproperty @name = N'Lookup', @value = N'RefRace', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonRace', @level2type = N'Column', @level2name = 'RaceType' 
	exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonRace', @level2type = N'Column', @level2name = 'RecordStartDateTime' 

	DROP TABLE Staging.PersonStatus

	CREATE TABLE [Staging].[PersonStatus] (
    [Student_Identifier_State]                               VARCHAR (100) NULL,
    [LEA_Identifier_State]                                   VARCHAR (100) NULL,
    [School_Identifier_State]                                VARCHAR (100) NULL,
    [HomelessnessStatus]                                     BIT           NULL,
    [Homelessness_StatusStartDate]                           DATE          NULL,
    [Homelessness_StatusEndDate]                             DATE          NULL,
    [HomelessNightTimeResidence]                             VARCHAR (100) NULL,
    [HomelessNightTimeResidence_StartDate]                   DATE          NULL,
    [HomelessNightTimeResidence_EndDate]                     DATE          NULL,
    [HomelessUnaccompaniedYouth]                             BIT           NULL,
    [HomelessServicedIndicator]                              BIT           NULL,
    [EconomicDisadvantageStatus]                             BIT           NULL,
    [EconomicDisadvantage_StatusStartDate]                   DATE          NULL,
    [EconomicDisadvantage_StatusEndDate]                     DATE          NULL,
    [EligibilityStatusForSchoolFoodServicePrograms]          VARCHAR (100) NULL,
    [NationalSchoolLunchProgramDirectCertificationIndicator] BIT           NULL,
    [MigrantStatus]                                          BIT           NULL,
    [Migrant_StatusStartDate]                                DATE          NULL,
    [Migrant_StatusEndDate]                                  DATE          NULL,
    [MilitaryConnectedStudentIndicator]                      VARCHAR (100) NULL,
    [MilitaryConnected_StatusStartDate]                      DATE          NULL,
    [MilitaryConnected_StatusEndDate]                        DATE          NULL,
    [ProgramType_FosterCare]                                 BIT           NULL,
    [FosterCare_ProgramParticipationStartDate]               DATE          NULL,
    [FosterCare_ProgramParticipationEndDate]                 DATE          NULL,
    [ProgramType_Section504]                                 BIT           NULL,
    [Section504_ProgramParticipationStartDate]               DATE          NULL,
    [Section504_ProgramParticipationEndDate]                 DATE          NULL,
    [ProgramType_Immigrant]                                  BIT           NULL,
    [Immigrant_ProgramParticipationStartDate]                DATE          NULL,
    [Immigrant_ProgramParticipationEndDate]                  DATE          NULL,
    [EnglishLearnerStatus]                                   BIT           NULL,
    [EnglishLearner_StatusStartDate]                         DATE          NULL,
    [EnglishLearner_StatusEndDate]                           DATE          NULL,
    [ISO_639_2_NativeLanguage]                               VARCHAR (100) NULL,
    [PerkinsLEPStatus]                                       VARCHAR (100) NULL,
    [PerkinsLEPStatus_StatusStartDate]                       DATE          NULL,
    [PerkinsLEPStatus_StatusEndDate]                         DATE          NULL,
    [IDEAIndicator]                                          BIT           NULL,
    [IDEA_StatusStartDate]                                   DATE          NULL,
    [IDEA_StatusEndDate]                                     DATE          NULL,
    [PrimaryDisabilityType]                                  VARCHAR (100) NULL,
    [PersonId]                                               INT           NULL,
    [OrganizationID_LEA]                                     INT           NULL,
    [OrganizationPersonRoleID_LEA]                           INT           NULL,
    [OrganizationID_School]                                  INT           NULL,
    [OrganizationID_Program_Foster]                          INT           NULL,
    [OrganizationPersonRoleID_School]                        INT           NULL,
    [OrganizationID_LEA_Program_Foster]                      INT           NULL,
    [OrganizationPersonRoleID_LEA_Program_Foster]            INT           NULL,
    [OrganizationID_School_Program_Foster]                   INT           NULL,
    [OrganizationPersonRoleID_School_Program_Foster]         INT           NULL,
    [OrganizationID_Program_Section504]                      INT           NULL,
    [OrganizationID_LEA_Program_Section504]                  INT           NULL,
    [OrganizationPersonRoleID_LEA_Program_Section504]        INT           NULL,
    [OrganizationID_School_Program_Section504]               INT           NULL,
    [OrganizationPersonRoleID_School_Program_Section504]     INT           NULL,
    [OrganizationID_Program_Immigrant]                       INT           NULL,
    [OrganizationID_LEA_Program_Immigrant]                   INT           NULL,
    [OrganizationPersonRoleID_LEA_Program_Immigrant]         INT           NULL,
    [OrganizationID_School_Program_Immigrant]                INT           NULL,
    [OrganizationPersonRoleID_School_Program_Immigrant]      INT           NULL,
    [OrganizationPersonRoleID_LEA_SPED]                      INT           NULL,
    [OrganizationPersonRoleID_School_SPED]                   INT           NULL,
    [OrganizationID_LEA_Program_Homeless]                    INT           NULL,
    [OrganizationID_School_Program_Homeless]                 INT           NULL,
    [OrganizationPersonRoleID_LEA_Program_Homeless]          INT           NULL,
    [OrganizationPersonRoleID_School_Program_Homeless]       INT           NULL,
    [PersonStatusId_Homeless]                                INT           NULL,
    [PersonHomelessNightTimeResidenceId]                     INT           NULL,
    [PersonStatusId_EconomicDisadvantage]                    INT           NULL,
    [PersonStatusId_IDEA]                                    INT           NULL,
    [PersonStatusId_EnglishLearner]                          INT           NULL,
    [PersonLanguageId]                                       INT           NULL,
    [PersonStatusId_Migrant]                                 INT           NULL,
    [PersonMilitaryId]                                       INT           NULL,
    [PersonHomelessnessId]                                   INT           NULL,
    [OrganizationPersonRoleID_Program_Foster]                INT           NULL,
    [RunDateTime]                                            DATETIME      NULL
	);

	CREATE NONCLUSTERED INDEX [IX_PersonStatus_IDEAIndicator]
		ON [Staging].[PersonStatus]([IDEAIndicator] ASC)
		INCLUDE([IDEA_StatusStartDate], [IDEA_StatusEndDate], [PersonId], [OrganizationID_School]);

	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantage_StatusEndDate';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantage_StatusStartDate';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatus';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'EnglishLearner_StatusEndDate';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'EnglishLearner_StatusStartDate';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'EnglishLearnerStatus';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'FosterCare_ProgramParticipationEndDate';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'FosterCare_ProgramParticipationStartDate';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'Homelessness_StatusEndDate';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'Homelessness_StatusStartDate';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'HomelessnessStatus';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'HomelessNightTimeResidence';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'HomelessNightTimeResidence_EndDate';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'HomelessNightTimeResidence_StartDate';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'HomelessUnaccompaniedYouth';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'IDEA_StatusEndDate';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'IDEA_StatusStartDate';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'IDEAIndicator';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'ISO_639_2_NativeLanguage';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'LEA_Identifier_State';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'Migrant_StatusEndDate';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'Migrant_StatusStartDate';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'MigrantStatus';
	EXECUTE sp_addextendedproperty @name = N'Lookup', @value = N'RefMilitaryConnectedStudentIndicator', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'MilitaryConnectedStudentIndicator';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'MilitaryConnectedStudentIndicator';
	EXECUTE sp_addextendedproperty @name = N'Lookup', @value = N'RefDisabilityType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'PrimaryDisabilityType';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'PrimaryDisabilityType';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'ProgramType_FosterCare';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'School_Identifier_State';
	EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'Student_Identifier_State';

	CREATE NONCLUSTERED INDEX [IX_ProgramParticipationSpecialEducation_PersonId_LeaOrganizationID_Program]
		ON [Staging].[ProgramParticipationSpecialEducation]([PersonID] ASC, [LEAOrganizationID_Program] ASC)
		INCLUDE([ProgramParticipationBeginDate], [ProgramParticipationEndDate]);

	CREATE NONCLUSTERED INDEX [IX_ProgramParticipationSpecialEducation_PersonId_SchoolOrganizationID_Program]
		ON [Staging].[ProgramParticipationSpecialEducation]([PersonID] ASC, [SchoolOrganizationID_Program] ASC)
		INCLUDE([ProgramParticipationBeginDate], [ProgramParticipationEndDate]);

	DROP TABLE staging.Enrollment
	



	commit transaction
end try
 
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch
 
set nocount off