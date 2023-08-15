-- Release-Specific table changes for the ODS schema
-- e.g. new fact/dimension tables/fields
----------------------------------
set nocount on
begin try
	begin transaction
		
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA ='ODS' AND TABLE_NAME='ProgramParticipationNeglectedProgressLevel') 
		BEGIN
			CREATE TABLE [ODS].ProgramParticipationNeglectedProgressLevel
			(
				ProgramParticipationNeglectedProgressLevelId INT PRIMARY KEY IDENTITY NOT NULL,
				PersonProgramParticipationId INT NULL,
				RefAcademicSubjectId INT NULL,
				RefProgressLevelId INT NULL
			)

			ALTER TABLE [ODS].[ProgramParticipationNeglectedProgressLevel]  WITH CHECK ADD  CONSTRAINT [FK_ProgramParticipationNeglectedProgressLevel_PersonProgramParticipation] FOREIGN KEY([PersonProgramParticipationId])
			REFERENCES [ODS].[PersonProgramParticipation] ([PersonProgramParticipationId])


			ALTER TABLE [ODS].[ProgramParticipationNeglectedProgressLevel]  WITH CHECK ADD  CONSTRAINT [FK_ProgramParticipationNeglectedProgressLevel_RefAcademicSubject] FOREIGN KEY([RefAcademicSubjectId])
			REFERENCES [ODS].[RefAcademicSubject] ([RefAcademicSubjectId])


			ALTER TABLE [ODS].[ProgramParticipationNeglectedProgressLevel]  WITH CHECK ADD  CONSTRAINT [FK_ProgramParticipationNeglectedProgressLevel_RefProgressLevel] FOREIGN KEY
			([RefProgressLevelId])
			REFERENCES [ODS].[RefProgressLevel] ([RefProgressLevelId])

		END

		IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA ='ODS' AND TABLE_NAME='K12StudentAcademicRecord' AND COLUMN_NAME = 'RefProgressLevelId') 
		BEGIN
			ALTER TABLE ODS.K12StudentAcademicRecord
			DROP CONSTRAINT FK_K12StudentAcademicRecord_RefProgressLevel

			ALTER TABLE ODS.K12StudentAcademicRecord DROP COLUMN RefProgressLevelId
		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_PersonIdentifier_Person' 
				AND t.name = 'PersonIdentifier')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_PersonIdentifier_Person
			ON [ODS].[PersonIdentifier] ([PersonId])
			INCLUDE ([Identifier])
		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_OrganizationRelationship_Parent' 
						AND t.name = 'OrganizationRelationship')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_OrganizationRelationship_Parent ON [ODS].[OrganizationRelationship] ([Parent_OrganizationId])
		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_OrganizationDetail_Organization' 
						AND t.name = 'OrganizationDetail')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_OrganizationDetail_Organization ON [ODS].[OrganizationDetail] ([OrganizationId])
		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_OrganizationDetail_OrganizationType' 
						AND t.name = 'OrganizationDetail')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_OrganizationDetail_OrganizationType ON [ODS].[OrganizationDetail] ([RefOrganizationTypeId]) INCLUDE ([OrganizationId])
		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_OrganizationType_EndDate' 
						AND t.name = 'OrganizationDetail')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_OrganizationType_EndDate ON [ODS].[OrganizationDetail] ([RefOrganizationTypeId],[RecordEndDateTime]) INCLUDE ([Name])
		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_K12School_Organization' 
						AND t.name = 'K12School')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_K12School_Organization ON [ODS].[K12School] ([OrganizationId]) INCLUDE ([K12SchoolId])
		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_K12School_K12SchoolGradeOffered' 
						AND t.name = 'K12SchoolGradeOffered')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_K12School_K12SchoolGradeOffered ON [ODS].[K12SchoolGradeOffered] ([K12SchoolId]) INCLUDE ([RefGradeLevelId])

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_OrganizationIdentificationSystem_OrganizationIdentifierType' 
						AND t.name = 'OrganizationIdentifier')
		BEGIN
	
			CREATE NONCLUSTERED INDEX IX_OrganizationIdentificationSystem_OrganizationIdentifierType
			ON [ODS].[OrganizationIdentifier] ([RefOrganizationIdentificationSystemId],[RefOrganizationIdentifierTypeId])
			INCLUDE ([Identifier],[OrganizationId])

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_OrganizationRelationship_Organization' 
						AND t.name = 'OrganizationRelationship')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_OrganizationRelationship_Organization ON [ODS].[OrganizationRelationship] ([OrganizationId])
		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_OrganizationIdentifier_Organization_IdentifierSystem' 
						AND t.name = 'OrganizationIdentifier')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_OrganizationIdentifier_Organization_IdentifierSystem 
			ON [ODS].[OrganizationIdentifier] ([RefOrganizationIdentificationSystemId],[OrganizationId],[RefOrganizationIdentifierTypeId],[RecordEndDateTime])
		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_OrganizationLocation_Organization' 
						AND t.name = 'OrganizationLocation')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_OrganizationLocation_Organization ON [ODS].[OrganizationLocation] ([OrganizationId],[RefOrganizationLocationTypeId])
		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_OrganizationLocation_Organization' 
						AND t.name = 'OrganizationLocation')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_OrganizationLocation_Organization ON [ODS].[OrganizationLocation] ([OrganizationId],[RefOrganizationLocationTypeId])
		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_CalendarSession_BeginDate' 
						AND t.name = 'OrganizationCalendarSession')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_CalendarSession_BeginDate	ON [ODS].[OrganizationCalendarSession] ([BeginDate]) INCLUDE ([OrganizationCalendarSessionId],[OrganizationCalendarId])
		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_CalendarSession_SessionType' 
						AND t.name = 'OrganizationCalendarSession')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_CalendarSession_SessionType ON [ODS].[OrganizationCalendarSession] ([RefSessionTypeId]) 
			INCLUDE ([OrganizationCalendarSessionId],[BeginDate],[EndDate],[OrganizationCalendarId])
		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_CalendarSession_BeginDate_SessionType' 
						AND t.name = 'OrganizationCalendarSession')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_CalendarSession_BeginDate_SessionType ON [ODS].[OrganizationCalendarSession] ([BeginDate])
			INCLUDE ([OrganizationCalendarSessionId],[RefSessionTypeId],[OrganizationCalendarId])
		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_Calendar_Organization' 
						AND t.name = 'OrganizationCalendar')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_Calendar_Organization ON [ODS].[OrganizationCalendar] ([OrganizationId])
		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_K12FederalFundAllocation_CalendarSession' 
						AND t.name = 'K12FederalFundAllocation')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_K12FederalFundAllocation_CalendarSession ON [ODS].[K12FederalFundAllocation] ([OrganizationCalendarSessionId])
			INCLUDE ([FederalProgramCode],[RefFederalProgramFundingAllocationTypeId],[FederalProgramsFundingAllocation])
		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_FederalAccountability_Organization' 
						AND t.name = 'OrganizationFederalAccountability')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_FederalAccountability_Organization ON [ODS].[OrganizationFederalAccountability] ([OrganizationId]) INCLUDE ([RefReconstitutedStatusId])

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_FederalAccountability_Organizaton_GunFreeSchoolsActStatus' 
						AND t.name = 'OrganizationFederalAccountability')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_FederalAccountability_Organizaton_GunFreeSchoolsActStatus ON [ODS].[OrganizationFederalAccountability] ([OrganizationId])
			INCLUDE ([RefGunFreeSchoolsActStatusReportingId])

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_FederalAccountability_Organizaton_ReconstitutedStatus' 
						AND t.name = 'OrganizationFederalAccountability')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_FederalAccountability_Organizaton_ReconstitutedStatus ON [ODS].[OrganizationFederalAccountability] ([OrganizationId])
			INCLUDE ([RefReconstitutedStatusId])

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_FederalAccountability_Organizaton_GunFreeSchoolsActStatus_HighSchoolGraduationRate' 
						AND t.name = 'OrganizationFederalAccountability')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_FederalAccountability_Organizaton_GunFreeSchoolsActStatus_HighSchoolGraduationRate ON [ODS].[OrganizationFederalAccountability] ([OrganizationId])
			INCLUDE ([RefGunFreeSchoolsActStatusReportingId],[RefHighSchoolGraduationRateIndicator])

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_K12SchoolStatus_MagnetSpecialProgram' 
						AND t.name = 'K12SchoolStatus')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_K12SchoolStatus_MagnetSpecialProgram ON [ODS].[K12SchoolStatus] ([K12SchoolId]) INCLUDE ([RefMagnetSpecialProgramId])

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_K12SchoolStatus_TitleISchoolStatus' 
						AND t.name = 'K12SchoolStatus')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_K12SchoolStatus_TitleISchoolStatus ON [ODS].[K12SchoolStatus] ([K12SchoolId]) INCLUDE ([RefTitleISchoolStatusId])

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_K12SchoolStatus_Statuses' 
						AND t.name = 'K12SchoolStatus')
		BEGIN
			CREATE NONCLUSTERED INDEX IX_K12SchoolStatus_Statuses ON [ODS].[K12SchoolStatus] ([K12SchoolId],[RecordStartDateTime])
			INCLUDE ([RecordEndDateTime],[RefComprehensiveAndTargetedSupportId],[RefComprehensiveSupportId],[RefTargetedSupportId])

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_AssessmentResult_AssessmentRegistration' 
						AND t.name = 'AssessmentResult')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_AssessmentResult_AssessmentRegistration] ON [ODS].[AssessmentResult]
			(
				[AssessmentRegistrationId] ASC
			)
			INCLUDE ( [AssessmentResultId])

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_AssessmentResult_PerformanceLevel_AssessmentResult' 
						AND t.name = 'AssessmentResult_PerformanceLevel')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_AssessmentResult_PerformanceLevel_AssessmentResult] ON [ODS].[AssessmentResult_PerformanceLevel]
			(
				[AssessmentResultId] ASC
			)
			INCLUDE ([AssessmentPerformanceLevelId])

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_Incident_OrganizationPersonRole_FirearmType' 
						AND t.name = 'Incident')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_Incident_OrganizationPersonRole_FirearmType] ON [ODS].[Incident]
			(
				[OrganizationPersonRoleId] ASC,
				[IncidentDate] ASC
			)
			INCLUDE ([RefFirearmTypeId]) 

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_K12StudentDiscipline_DisciplinaryAction' 
						AND t.name = 'K12StudentDiscipline')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_K12StudentDiscipline_DisciplinaryAction] ON [ODS].[K12StudentDiscipline]
			(
				[OrganizationPersonRoleId] ASC
			)
			INCLUDE ( 	[RefDisciplinaryActionTakenId],
				[DisciplinaryActionStartDate],
				[DisciplinaryActionEndDate],
				[DurationOfDisciplinaryAction],
				[RefIdeaInterimRemovalId],
				[RefIdeaInterimRemovalReasonId])

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_K12StudentDiscipline_Firearms' 
						AND t.name = 'K12StudentDiscipline')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_K12StudentDiscipline_Firearms] ON [ODS].[K12StudentDiscipline]
			(
				[OrganizationPersonRoleId] ASC
			)
			INCLUDE ( 	[RefDisciplineMethodFirearmsId],
				[RefIDEADisciplineMethodFirearmId])

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_K12StudentDiscipline_RefDisciplineMethodFirearms_IDEADisciplineMethodFirearm' 
						AND t.name = 'K12StudentDiscipline')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_K12StudentDiscipline_RefDisciplineMethodFirearms_IDEADisciplineMethodFirearm] ON [ODS].[K12StudentDiscipline]
			(
				[OrganizationPersonRoleId] ASC
			)
			INCLUDE ( 	[RefDisciplineMethodFirearmsId],
				[RefIDEADisciplineMethodFirearmId])

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_OrganizationCalendarSession_Columns' 
						AND t.name = 'OrganizationCalendarSession')
		BEGIN
				CREATE NONCLUSTERED INDEX [IX_OrganizationCalendarSession_Columns] ON [ODS].[OrganizationCalendarSession]
				(
					[EndDate] ASC
				)
				INCLUDE ( 	[OrganizationCalendarSessionId],
					[Designator],
					[BeginDate],
					[RefSessionTypeId],
					[InstructionalMinutes],
					[Code],
					[Description],
					[MarkingTermIndicator],
					[SchedulingTermIndicator],
					[AttendanceTermIndicator],
					[OrganizationCalendarId],
					[DaysInSession],
					[FirstInstructionDate],
					[LastInstructionDate],
					[MinutesPerDay],
					[SessionStartTime],
					[SessionEndTime])

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_OrganizationCalendarSession_Designator' 
						AND t.name = 'OrganizationCalendarSession')
		BEGIN
				CREATE NONCLUSTERED INDEX [IX_OrganizationCalendarSession_Designator] ON [ODS].[OrganizationCalendarSession]
				(
					[EndDate] ASC
				)
				INCLUDE ( [Designator])

		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_OrganizationPersonRole_Entries' 
						AND t.name = 'OrganizationPersonRole')
		BEGIN
		
				CREATE NONCLUSTERED INDEX [IX_OrganizationPersonRole_Entries] ON [ODS].[OrganizationPersonRole]
				(
					[RoleId] ASC
				)
				INCLUDE ( [OrganizationId],
					[PersonId],
					[EntryDate],
					[ExitDate])


		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_OrganizationPersonRole_Role_Organization_Person_Entry_Exit' 
						AND t.name = 'OrganizationPersonRole')
		BEGIN
		
				CREATE NONCLUSTERED INDEX [IX_OrganizationPersonRole_Role_Organization_Person_Entry_Exit] ON [ODS].[OrganizationPersonRole]
				(
					[RoleId] ASC
				)
				INCLUDE ( [OrganizationPersonRoleId],
					[OrganizationId],
					[PersonId],
					[EntryDate],
					[ExitDate])


		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_PersonProgramParticipation_ExitReason' 
						AND t.name = 'PersonProgramParticipation')
		BEGIN
		
		
				CREATE NONCLUSTERED INDEX [IX_PersonProgramParticipation_ExitReason] ON [ODS].[PersonProgramParticipation]
				(
					[RefProgramExitReasonId] ASC
				)
				INCLUDE ( [OrganizationPersonRoleId],
					[RefParticipationTypeId],
					[RecordStartDateTime],
					[RecordEndDateTime],
					[PersonProgramParticipationId])


		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_ProgramParticipationSpecialEducation_EducationalEnvironment' 
						AND t.name = 'ProgramParticipationSpecialEducation')
		BEGIN
		
		
				CREATE NONCLUSTERED INDEX [IX_ProgramParticipationSpecialEducation_EducationalEnvironment] ON [ODS].[ProgramParticipationSpecialEducation]
				(
					[PersonProgramParticipationId] ASC
				)
				INCLUDE ( [RefIDEAEducationalEnvironmentECId],
					[RefIDEAEdEnvironmentSchoolAgeId],
					[RefSpecialEducationExitReasonId])


		END

		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_OrganizationPersonRole_Attendance' AND t.name = 'RoleAttendance')
		BEGIN
				
				CREATE NONCLUSTERED INDEX [IX_OrganizationPersonRole_Attendance] ON [ODS].[RoleAttendance]
				(
					[OrganizationPersonRoleId] ASC
				)
				INCLUDE ( [AttendanceRate])


		END


		if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_PersonDisability_PrimaryDisabilityType_DisabilityStatus' 
					AND t.name = 'PersonDisability')
		BEGIN
				
		
			CREATE NONCLUSTERED INDEX [IX_PersonDisability_PrimaryDisabilityType_DisabilityStatus] ON [ODS].[PersonDisability]
			(
				[PersonId] ASC
			)
			INCLUDE ( [PrimaryDisabilityTypeId],
				[DisabilityStatus],
				[RecordStartDateTime],
				[RecordEndDateTime])


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