-- Release-Specific table changes for the ODS schema
-- e.g. new fact/dimension tables/fields
----------------------------------
set nocount on
begin try
	begin transaction
		
		

		EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService'
		EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'RefTitleIProgramTypeId'
		EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'RefTitleIInstructionalServicesId'
		EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'ProgramInMultiplePurposeFacility'
		EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'RefMepProjectTypeId'
		EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'RefMepSessionTypeId'
		EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'RefProgramGiftedEligibilityId'
		EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'RefKindergartenDailyLengthId'
		EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'RefPrekindergartenDailyLengthId'
		EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'OrganizationId'
		ALTER TABLE [ODS].[K12ProgramOrService] DROP CONSTRAINT [FK_K12LEAProgramOrService_RefTitleIProgramType]
		ALTER TABLE [ODS].[K12ProgramOrService] DROP CONSTRAINT [FK_K12LEAProgramOrService_RefTitleIInstructServices]
		ALTER TABLE [ODS].[K12ProgramOrService] DROP CONSTRAINT [FK_K12LEAProgramOrService_RefProgramGiftedEligibility]
		ALTER TABLE [ODS].[K12ProgramOrService] DROP CONSTRAINT [FK_K12LEAProgramOrService_RefProgramDayLength1]
		ALTER TABLE [ODS].[K12ProgramOrService] DROP CONSTRAINT [FK_K12LEAProgramOrService_RefProgramDayLength]
		ALTER TABLE [ODS].[K12ProgramOrService] DROP CONSTRAINT [FK_K12LEAProgramOrService_RefMEPSessionType]
		ALTER TABLE [ODS].[K12ProgramOrService] DROP CONSTRAINT [FK_K12LEAProgramOrService_RefMEPProjectType]
		ALTER TABLE [ODS].[K12ProgramOrService] DROP CONSTRAINT [FK_K12LeaProgramOrService_Organization]

		DROP TABLE [ODS].[K12ProgramOrService]


		CREATE TABLE [ODS].[K12ProgramOrService](
			K12ProgramOrServiceId int IDENTITY(1,1) NOT NULL,
			[OrganizationId] [int] NOT NULL,
			[RefPrekindergartenDailyLengthId] [int] NULL,
			[RefKindergartenDailyLengthId] [int] NULL,
			[RefProgramGiftedEligibilityId] [int] NULL,
			[RefMepSessionTypeId] [int] NULL,
			[RefMepProjectTypeId] [int] NULL,
			[ProgramInMultiplePurposeFacility] [bit] NULL,
			[RefTitleIInstructionalServicesId] [int] NULL,
			[RefTitleIProgramTypeId] [int] NULL,
			RecordStartDateTime DateTime NOT NULL,
			RecordEndDateTime DateTime NULL
		 CONSTRAINT [PK_K12LEAProgram] PRIMARY KEY CLUSTERED 
		(
			K12ProgramOrServiceId ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]

		ALTER TABLE [ODS].[K12ProgramOrService]  WITH CHECK ADD  CONSTRAINT [FK_K12LeaProgramOrService_Organization] FOREIGN KEY([OrganizationId])
		REFERENCES [ODS].[Organization] ([OrganizationId])
	
		ALTER TABLE [ODS].[K12ProgramOrService] CHECK CONSTRAINT [FK_K12LeaProgramOrService_Organization]
		
		ALTER TABLE [ODS].[K12ProgramOrService]  WITH CHECK ADD  CONSTRAINT [FK_K12LEAProgramOrService_RefMEPProjectType] FOREIGN KEY([RefMepProjectTypeId])
		REFERENCES [ODS].[RefMepProjectType] ([RefMepProjectTypeId])
		
		ALTER TABLE [ODS].[K12ProgramOrService] CHECK CONSTRAINT [FK_K12LEAProgramOrService_RefMEPProjectType]
		
		ALTER TABLE [ODS].[K12ProgramOrService]  WITH CHECK ADD  CONSTRAINT [FK_K12LEAProgramOrService_RefMEPSessionType] FOREIGN KEY([RefMepSessionTypeId])
		REFERENCES [ODS].[RefMepSessionType] ([RefMepSessionTypeId])
		
		ALTER TABLE [ODS].[K12ProgramOrService] CHECK CONSTRAINT [FK_K12LEAProgramOrService_RefMEPSessionType]
		
		ALTER TABLE [ODS].[K12ProgramOrService]  WITH CHECK ADD  CONSTRAINT [FK_K12LEAProgramOrService_RefProgramDayLength] FOREIGN KEY([RefPrekindergartenDailyLengthId])
		REFERENCES [ODS].[RefProgramDayLength] ([RefProgramDayLengthId])
		
		ALTER TABLE [ODS].[K12ProgramOrService] CHECK CONSTRAINT [FK_K12LEAProgramOrService_RefProgramDayLength]
		
		ALTER TABLE [ODS].[K12ProgramOrService]  WITH CHECK ADD  CONSTRAINT [FK_K12LEAProgramOrService_RefProgramDayLength1] FOREIGN KEY([RefKindergartenDailyLengthId])
		REFERENCES [ODS].[RefProgramDayLength] ([RefProgramDayLengthId])
		
		ALTER TABLE [ODS].[K12ProgramOrService] CHECK CONSTRAINT [FK_K12LEAProgramOrService_RefProgramDayLength1]
		
		ALTER TABLE [ODS].[K12ProgramOrService]  WITH CHECK ADD  CONSTRAINT [FK_K12LEAProgramOrService_RefProgramGiftedEligibility] FOREIGN KEY([RefProgramGiftedEligibilityId])
		REFERENCES [ODS].[RefProgramGiftedEligibility] ([RefProgramGiftedEligibilityId])
		
		ALTER TABLE [ODS].[K12ProgramOrService] CHECK CONSTRAINT [FK_K12LEAProgramOrService_RefProgramGiftedEligibility]
		
		ALTER TABLE [ODS].[K12ProgramOrService]  WITH CHECK ADD  CONSTRAINT [FK_K12LEAProgramOrService_RefTitleIInstructServices] FOREIGN KEY([RefTitleIInstructionalServicesId])
		REFERENCES [ODS].[RefTitleIInstructionalServices] ([RefTitleIInstructionalServicesId])
		
		ALTER TABLE [ODS].[K12ProgramOrService] CHECK CONSTRAINT [FK_K12LEAProgramOrService_RefTitleIInstructServices]
		
		ALTER TABLE [ODS].[K12ProgramOrService]  WITH CHECK ADD  CONSTRAINT [FK_K12LEAProgramOrService_RefTitleIProgramType] FOREIGN KEY([RefTitleIProgramTypeId])
		REFERENCES [ODS].[RefTitleIProgramType] ([RefTitleIProgramTypeId])
		
		ALTER TABLE [ODS].[K12ProgramOrService] CHECK CONSTRAINT [FK_K12LEAProgramOrService_RefTitleIProgramType]
		
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Surrogate key from K12LEA.' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'OrganizationId'
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The portion of a day that a pre-kindergarten program is provided to the students it serves. [CEDS Element: Prekindergarten Daily Length, ID:000490]  (Foreign key - RefProgramDayLength)' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'RefPrekindergartenDailyLengthId'
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The portion of a day that a kindergarten program is provided to the students it serves. [CEDS Element: Kindergarten Daily Length, ID:000491]  (Foreign key - RefProgramDayLength)' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'RefKindergartenDailyLengthId'
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'State/local code used to determine a student''s eligibility for Gifted/Talented program. [CEDS Element: Program Gifted Eligibility Criteria, ID:001244]' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'RefProgramGiftedEligibilityId'
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The time of year that a Migrant Education Program operates. [CEDS Element: Migrant Education Program Session Type, ID:000187]  (Foreign key - RefMepSessionType)' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'RefMepSessionTypeId'
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type of project funded in whole or in part by MEP funds. [CEDS Element: Migrant Education Program Project Type, ID:000463]  (Foreign key - RefMepProjectType)' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'RefMepProjectTypeId'
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'An institution/facility/program that serves more than one programming purpose.  For example, the same facility may run both a juvenile correction program and a juvenile detention program. [CEDS Element: Program in Multiple Purpose Facility, ID:000485]' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'ProgramInMultiplePurposeFacility'
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The type of instructional services provided to students in ESEA Title I programs. [CEDS Element: Title I Instructional Services, ID:000282]  (Foreign key - RefTitleIInstuctionalServices)' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'RefTitleIInstructionalServicesId'
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The type of Title I program offered in the school or district. [CEDS Element: Title I Program Type, ID:000284]  (Foreign key - RefTitleIProgramType)' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService', @level2type=N'COLUMN',@level2name=N'RefTitleIProgramTypeId'
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Information on the programs and services offered by an LEA or school.' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12ProgramOrService'
	

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'ODS.K12LeaTitleISupportService'))
		BEGIN
			ALTER TABLE ODS.K12LeaTitleISupportService
			Add RecordStartDateTime DateTime Not NULL default getdate(), RecordEndDateTime DateTime NULL 
		END

		IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'RefAcademicCareerAndTechnicalOutcomesInProgram' AND Type = N'U')
		BEGIN
			CREATE TABLE [ODS].[RefAcademicCareerAndTechnicalOutcomesInProgram](
				[RefAcademicCareerAndTechnicalOutcomesInProgramId] [int] IDENTITY(1,1) NOT NULL,
				[Description] [nvarchar](100) NOT NULL,
				[Code] [nvarchar](50) NULL,
				[Definition] [nvarchar](4000) NULL,
				[RefJurisdictionId] [int] NULL,
				[SortOrder] [decimal](5, 2) NULL,
			 CONSTRAINT [PK_RefAcademicCareerAndTechnicalOutcomesInProgram] PRIMARY KEY CLUSTERED 
			(
				[RefAcademicCareerAndTechnicalOutcomesInProgramId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]

			ALTER TABLE [ODS].[RefAcademicCareerAndTechnicalOutcomesInProgram]  WITH CHECK ADD  CONSTRAINT [FK_RefAcademicCareerAndTechnicalOutcomesInProgram_Organization] FOREIGN KEY([RefJurisdictionId])
			REFERENCES [ODS].[Organization] ([OrganizationId])

			ALTER TABLE [ODS].[RefAcademicCareerAndTechnicalOutcomesInProgram] CHECK CONSTRAINT [FK_RefAcademicCareerAndTechnicalOutcomesInProgram_Organization]

		END

		IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'RefAcademicCareerAndTechnicalOutcomesExitedProgram' AND Type = N'U')
		BEGIN
			CREATE TABLE [ODS].[RefAcademicCareerAndTechnicalOutcomesExitedProgram](
				[RefAcademicCareerAndTechnicalOutcomesExitedProgramId] [int] IDENTITY(1,1) NOT NULL,
				[Description] [nvarchar](100) NOT NULL,
				[Code] [nvarchar](50) NULL,
				[Definition] [nvarchar](4000) NULL,
				[RefJurisdictionId] [int] NULL,
				[SortOrder] [decimal](5, 2) NULL,
				CONSTRAINT [PK_RefAcademicCareerAndTechnicalOutcomesExitedProgram] PRIMARY KEY CLUSTERED 
			(
				[RefAcademicCareerAndTechnicalOutcomesExitedProgramId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]

			ALTER TABLE [ODS].[RefAcademicCareerAndTechnicalOutcomesExitedProgram]  WITH CHECK ADD  CONSTRAINT [FK_RefAcademicCareerAndTechnicalOutcomesExitedProgram_Organization] 
			FOREIGN KEY([RefJurisdictionId])
			REFERENCES [ODS].[Organization] ([OrganizationId])

			ALTER TABLE [ODS].[RefAcademicCareerAndTechnicalOutcomesExitedProgram] CHECK CONSTRAINT [FK_RefAcademicCareerAndTechnicalOutcomesExitedProgram_Organization]

		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RefAcademicCareerAndTechnicalOutcomesInProgramId'  AND Object_ID = Object_ID(N'ODS.ProgramParticipationNeglected'))
		BEGIN
			ALTER TABLE ODS.ProgramParticipationNeglected
			Add RefAcademicCareerAndTechnicalOutcomesInProgramId int NULL

			ALTER TABLE [ODS].[ProgramParticipationNeglected]  WITH CHECK ADD  CONSTRAINT [FK_ProgramParticipationNeglected_RefAcademicCareerAndTechnicalOutcomesInProgram] 
			FOREIGN KEY([RefAcademicCareerAndTechnicalOutcomesInProgramId])
			REFERENCES [ODS].[RefAcademicCareerAndTechnicalOutcomesInProgram] ([RefAcademicCareerAndTechnicalOutcomesInProgramId])

			ALTER TABLE [ODS].[ProgramParticipationNeglected] CHECK CONSTRAINT [FK_ProgramParticipationNeglected_RefAcademicCareerAndTechnicalOutcomesInProgram]
		END


		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RefAcademicCareerAndTechnicalOutcomesExitedProgramId'  AND Object_ID = Object_ID(N'ODS.ProgramParticipationNeglected'))
		BEGIN
			ALTER TABLE ODS.ProgramParticipationNeglected
			Add RefAcademicCareerAndTechnicalOutcomesExitedProgramId int NULL

			ALTER TABLE [ODS].[ProgramParticipationNeglected]  WITH CHECK ADD  CONSTRAINT [FK_ProgramParticipationNeglected_RefAcademicCareerAndTechnicalOutcomesExitedProgram] 
			FOREIGN KEY([RefAcademicCareerAndTechnicalOutcomesExitedProgramId])
			REFERENCES [ODS].[RefAcademicCareerAndTechnicalOutcomesExitedProgram] ([RefAcademicCareerAndTechnicalOutcomesExitedProgramId])

			ALTER TABLE [ODS].[ProgramParticipationNeglected] CHECK CONSTRAINT [FK_ProgramParticipationNeglected_RefAcademicCareerAndTechnicalOutcomesExitedProgram]
		END

		IF NOT (EXISTS (SELECT * 
					 FROM INFORMATION_SCHEMA.TABLES 
					 WHERE TABLE_SCHEMA = 'ODS' 
					 AND  TABLE_NAME = 'RefVirtualSchoolStatus'))
		BEGIN
			   CREATE TABLE [ODS].[RefVirtualSchoolStatus](
			[RefVirtualSchoolStatusId] [int] IDENTITY(1,1) NOT NULL,
			[Description] [nvarchar](100) NOT NULL,
			[Code] [nvarchar](60) NULL,
			[Definition] [nvarchar](4000) NULL,
			[RefJurisdictionId] [int] NULL,
			[SortOrder] [decimal](6, 2) NULL,
			 CONSTRAINT [PK_RefVirtualSchoolStatus] PRIMARY KEY CLUSTERED 
			(
			 [RefVirtualSchoolStatusId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]

		END

		IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'RefVirtualSchoolStatusId'
          AND Object_ID = Object_ID(N'ODS.K12SchoolStatus'))
		BEGIN
		 ALTER TABLE ODS.K12SchoolStatus ADD RefVirtualSchoolStatusId INT NULL;
		END



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