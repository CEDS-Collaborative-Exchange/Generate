
-- Release-Specific table changes for the RDS schema
-- e.g. new fact/dimension tables/fields
----------------------------------
set nocount on
begin try
	begin transaction

		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DimLeaId' AND Object_ID = Object_ID(N'RDS.[FactPersonnelCounts]'))
		BEGIN
			ALTER TABLE  [RDS].[FactPersonnelCounts] 
			ADD [DimLeaId] INT NOT NULL DEFAULT (-1)
		END
	
		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DimSeaId' AND Object_ID = Object_ID(N'RDS.[FactPersonnelCounts]'))
		BEGIN
			ALTER TABLE  [RDS].[FactPersonnelCounts] 
			ADD [DimSeaId] INT NOT NULL DEFAULT (-1)	
		END

		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'RDS.FK_FactPersonnelCounts_DimLeas_DimLeaId') AND parent_object_id = OBJECT_ID(N'RDS.FactPersonnelCounts'))
		BEGIN
			ALTER TABLE [RDS].[FactPersonnelCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactPersonnelCounts_DimLeas_DimLeaId] FOREIGN KEY([DimLeaId])
			REFERENCES [RDS].[DimLeas] ([DimLeaId])

			ALTER TABLE [RDS].[FactPersonnelCounts] CHECK CONSTRAINT [FK_FactPersonnelCounts_DimLeas_DimLeaId]
		END

		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'RDS.FK_FactPersonnelCounts_DimLeas_DimLeaId') AND parent_object_id = OBJECT_ID(N'RDS.FactPersonnelCounts'))
		BEGIN
			ALTER TABLE [RDS].[FactPersonnelCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactPersonnelCounts_DimSeas_DimSeaId] FOREIGN KEY([DimSeaId])
			REFERENCES [RDS].[DimSeas] ([DimSeaId])

			ALTER TABLE [RDS].[FactPersonnelCounts] CHECK CONSTRAINT [FK_FactPersonnelCounts_DimSeas_DimSeaId]
		END

		
		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DimSeaId' AND Object_ID = Object_ID(N'RDS.[FactStudentAssessments]'))
		BEGIN
			ALTER TABLE  [RDS].[FactStudentAssessments] 
			ADD [DimSeaId] INT NOT NULL DEFAULT (-1)	
		END

		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'RDS.FK_FactStudentAssessments_DimSeas_DimSeaId') AND parent_object_id = OBJECT_ID(N'RDS.FactStudentAssessments'))
		BEGIN
			ALTER TABLE [RDS].[FactStudentAssessments]  WITH CHECK ADD  CONSTRAINT [FK_FactStudentAssessments_DimSeas_DimSeaId] FOREIGN KEY([DimSeaId])
			REFERENCES [RDS].[DimSeas] ([DimSeaId])

			ALTER TABLE [RDS].[FactStudentAssessments] CHECK CONSTRAINT [FK_FactStudentAssessments_DimSeas_DimSeaId]
		END

		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DimSeaId' AND Object_ID = Object_ID(N'RDS.[FactStudentCounts]'))
		BEGIN
			ALTER TABLE  [RDS].[FactStudentCounts] 
			ADD [DimSeaId] INT NOT NULL DEFAULT (-1)	
		END

		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'RDS.FK_FactStudentCounts_DimSeas_DimSeaId') AND parent_object_id = OBJECT_ID(N'RDS.FactStudentCounts'))
		BEGIN
			ALTER TABLE [RDS].[FactStudentCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactStudentCounts_DimSeas_DimSeaId] FOREIGN KEY([DimSeaId])
			REFERENCES [RDS].[DimSeas] ([DimSeaId])

			ALTER TABLE [RDS].[FactStudentCounts] CHECK CONSTRAINT [FK_FactStudentCounts_DimSeas_DimSeaId]
		END

		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DimSeaId' AND Object_ID = Object_ID(N'RDS.[FactStudentDisciplines]'))
		BEGIN
			ALTER TABLE  [RDS].[FactStudentDisciplines] 
			ADD [DimSeaId] INT NOT NULL DEFAULT (-1)	
		END

		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'RDS.FK_FactStudentDisciplines_DimSeas_DimSeaId') AND parent_object_id = OBJECT_ID(N'RDS.FactStudentDisciplines'))
		BEGIN
			ALTER TABLE [RDS].[FactStudentDisciplines]  WITH CHECK ADD  CONSTRAINT [FK_FactStudentDisciplines_DimSeas_DimSeaId] FOREIGN KEY([DimSeaId])
			REFERENCES [RDS].[DimSeas] ([DimSeaId])

			ALTER TABLE [RDS].[FactStudentDisciplines] CHECK CONSTRAINT [FK_FactStudentDisciplines_DimSeas_DimSeaId]
		END
		
		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DimSeaId' AND Object_ID = Object_ID(N'RDS.[FactK12StudentAttendance]'))
		BEGIN
			ALTER TABLE  [RDS].[FactK12StudentAttendance] 
			ADD [DimSeaId] INT NOT NULL DEFAULT (-1)	
		END

		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'RDS.FK_FactK12StudentAttendance_DimSeas_DimSeaId') AND parent_object_id = OBJECT_ID(N'RDS.FactK12StudentAttendance'))
		BEGIN
			ALTER TABLE [RDS].[FactK12StudentAttendance]  WITH CHECK ADD  CONSTRAINT [FK_FactK12StudentAttendance_DimSeas_DimSeaId] FOREIGN KEY([DimSeaId])
			REFERENCES [RDS].[DimSeas] ([DimSeaId])

			ALTER TABLE [RDS].[FactK12StudentAttendance] CHECK CONSTRAINT [FK_FactK12StudentAttendance_DimSeas_DimSeaId]
		END

		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DimSeaId' AND Object_ID = Object_ID(N'RDS.[FactPersonnelCounts]'))
		BEGIN
			ALTER TABLE  [RDS].[FactPersonnelCounts] 
			ADD [DimSeaId] INT NOT NULL DEFAULT (-1)	
		END

		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'RDS.FK_FactPersonnelCounts_DimSeas_DimSeaId') AND parent_object_id = OBJECT_ID(N'RDS.FactPersonnelCounts'))
		BEGIN
			ALTER TABLE [RDS].[FactPersonnelCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactPersonnelCounts_DimSeas_DimSeaId] FOREIGN KEY([DimSeaId])
			REFERENCES [RDS].[DimSeas] ([DimSeaId])

			ALTER TABLE [RDS].[FactPersonnelCounts] CHECK CONSTRAINT [FK_FactPersonnelCounts_DimSeas_DimSeaId]
		END

		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DimLeaId' AND Object_ID = Object_ID(N'RDS.[FactPersonnelCounts]'))
		BEGIN
			ALTER TABLE  [RDS].[FactPersonnelCounts] 
			ADD [DimLeaId] INT NOT NULL DEFAULT (-1)	
		END

		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'RDS.FK_FactPersonnelCounts_DimLeas_DimLeaId') AND parent_object_id = OBJECT_ID(N'RDS.FactPersonnelCounts'))
		BEGIN
			ALTER TABLE [RDS].[FactPersonnelCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactPersonnelCounts_DimLeas_DimLeaId] FOREIGN KEY([DimLeaId])
			REFERENCES [RDS].[DimLeas] ([DimLeaId])

			ALTER TABLE [RDS].[FactPersonnelCounts] CHECK CONSTRAINT [FK_FactPersonnelCounts_DimLeas_DimLeaId]
		END

		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'MailingAddressStreet2' AND Object_ID = Object_ID(N'RDS.[DimSeas]'))
		BEGIN
			ALTER TABLE  [RDS].[DimSeas] 
			ADD  [MailingAddressStreet2] VARCHAR(40) NULL
		END

		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'PhysicalAddressStreet2' AND Object_ID = Object_ID(N'RDS.[DimSeas]'))
		BEGIN
			ALTER TABLE  [RDS].[DimSeas] 
			ADD  [PhysicalAddressStreet2] VARCHAR(40) NULL
		END

		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'MailingAddressStreet2' AND Object_ID = Object_ID(N'RDS.[DimLeas]'))
		BEGIN
			ALTER TABLE  [RDS].[DimLeas] 
			ADD  [MailingAddressStreet2] VARCHAR(40) NULL
		END

		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'PhysicalAddressStreet2' AND Object_ID = Object_ID(N'RDS.[DimLeas]'))
		BEGIN
			ALTER TABLE  [RDS].[DimLeas] 
			ADD  [PhysicalAddressStreet2] VARCHAR(40) NULL
		END

		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'MailingAddressStreet2' AND Object_ID = Object_ID(N'RDS.[DimSchools]'))
		BEGIN
			ALTER TABLE  [RDS].[DimSchools] 
			ADD  [MailingAddressStreet2] VARCHAR(40) NULL
		END

		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'PhysicalAddressStreet2' AND Object_ID = Object_ID(N'RDS.[DimSchools]'))
		BEGIN
			ALTER TABLE  [RDS].[DimSchools] 
			ADD  [PhysicalAddressStreet2] VARCHAR(40) NULL
		END

		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'MailingAddressStreet2' AND Object_ID = Object_ID(N'RDS.[FactOrganizationCountReports]'))
		BEGIN
			ALTER TABLE  [RDS].[FactOrganizationCountReports] 
			ADD  [MailingAddressStreet2] VARCHAR(100) NULL
		END

		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'PhysicalAddressStreet2' AND Object_ID = Object_ID(N'RDS.[FactOrganizationCountReports]'))
		BEGIN
			ALTER TABLE  [RDS].[FactOrganizationCountReports] 
			ADD  [PhysicalAddressStreet2] VARCHAR(100) NULL
		END

		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'MailingAddressStreet2' AND Object_ID = Object_ID(N'RDS.[FactOrganizationCountReportDtos]'))
		BEGIN
			ALTER TABLE  [RDS].[FactOrganizationCountReportDtos] 
			ADD  [MailingAddressStreet2] VARCHAR(100) NULL
		END

		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'PhysicalAddressStreet2' AND Object_ID = Object_ID(N'RDS.[FactOrganizationCountReportDtos]'))
		BEGIN
			ALTER TABLE  [RDS].[FactOrganizationCountReportDtos] 
			ADD  [PhysicalAddressStreet2] VARCHAR(100) NULL
		END


	DECLARE @sql nvarchar(max)

	--CIID-2223 - Create Wrapper Stored Procedures for RDS Migrations (Procedures & Parameters)

		-------------------------------
		--NOTE: The following code is meant to ensure that the new wrappers display first in the list.

			--Task CIID-3882 will sort the list by TaskSequence and make this unnecessary.  When that
			--ticket is completed we can replace the delete from DataMigrationTasks with the update below, 
			--leave the insert of new SPs, and remove the insert of the 'old' SPs.  
			
			--Update [App].[DataMigrationTasks]
			--set tasksequence = tasksequence + 25
			--where DataMigrationTypeId = 2
		-------------------------------

		--remove all the tasks for the RDS migration type
		IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DataMigrationTasks' AND Type = N'U')
		BEGIN
			delete from [App].[DataMigrationTasks]
			where DataMigrationTypeId = 2
		END 

		--add the new rows for the wrapper migration SPs
		IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DataMigrationTasks' AND Type = N'U')
		BEGIN
			insert into [App].[DataMigrationTasks]
			values 
			(2,1,0,0,'App.Wrapper_Migrate_Chronic_to_RDS',1,0,'195',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_CTE_to_RDS',2,0,'082, 083, 132, 154, 155, 156, 158, 169',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_Directory_to_RDS',3,0,'029, 035, 039, 103, 129, 130, 131, 163, 170, 190, 193, 196, 197, 198, 205, 206',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_Dropout_to_RDS',4,0,'032',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_Grad_to_RDS',5,0,'040, cohortgraduationrate',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_Gradrate_to_RDS',6,0,'150, 151',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_Homeless_to_RDS',7,0,'118, 194',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_HsGradEnroll_to_RDS',8,0,'160',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_Immigrant_to_RDS',9,0,'165',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_Membership_to_RDS',10,0,'033, 052',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_Mep_to_RDS',11,0,'054, 121, 122, 145',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_NorD_to_RDS',12,0,'119, 127, 180, 181',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_Other_to_RDS',13,0,'edenvironmentdisabilitiesage3-5, edenvironmentdisabilitiesage6-21, studentfederalprogramsparticipation, studentmultifedprogsparticipation',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_Assessments_to_RDS',14,0,'113, 125, 126, 137, 138, 139, 142, 175, 178, 179, 185, 188, 189',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_ChildCount_to_RDS',15,0,'002, 089',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_Discipline_to_RDS',16,0,'005, 006, 007, 086, 088, 143, 144',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_Exiting_to_RDS',17,0,'009',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_Personnel_to_RDS',18,0,'059, 065, 067, 070, 099, 112, 203',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_SPPAPR_to_RDS',19,0,'indicator9, indicator10',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_StudentCounts_to_RDS',20,0,'Used for Data Population Reports. Not specific to an EDFacts File Specification.',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_TitleI_to_RDS',21,0,'037, 134',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_TitleIIIELOct_to_RDS',22,0,'116, 141',NULL),
			(2,1,0,0,'App.Wrapper_Migrate_TitleIIIELSY_to_RDS',23,0,'045, 204',NULL)
		END

		--add the previous rows back in after the wrapper migration SPs
		IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DataMigrationTasks' AND Type = N'U')
		BEGIN
			insert into [App].[DataMigrationTasks]
			values 
			(2,	1,	0,	0,	'rds.Migrate_DimStudents',	30,	0, 'Load the base student population to DimStudents.',NULL),
			(2,	1,	0,	0,	'rds.Migrate_DimPersonnel',	31,	0, 'Load the base personnel population into DimPersonnel',NULL),
			(2,	1,	0,	0,	'rds.Migrate_OrganizationCounts ''directory'', 0',	32,	0, 'Load organization data into FactOrganizationCounts',NULL),
			(2,	1,	0,	0,	'rds.Migrate_OrganizationStatusCounts ''organizationstatus'', 0',	33,	0, 'Load organization rate data into FactOrganizationIndicatorStatusReports',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''datapopulation'', ''studentcounts''',	34,	0, 'Delete student count data from FactStudentCounts (datapopulation)',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''datapopulation'', 0',	35,	0, 'Load student count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''datapopulation'', ''disciplinecounts''',	36,	0, 'Delete student discipline count data from FactStudentDiscipline (datapopulation)',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentDisciplines ''datapopulation'', 0',	37,	0, 'Load student discipline data into FactStudentDiscipline',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''submission'', ''studentcounts''',	38,	0, 'Delete student count data from FactStudentCounts (submission)',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''submission'', 0',	39,	0, 'Load student count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''submission'', ''disciplinecounts''',	40,	0, 'Delete student discipline count data from FactStudentDiscipline (submission)',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentDisciplines ''submission'', 0',	41,	0, 'Load student discipline data into FactStudentDiscipline',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''submission'', ''studentassessments''',	42,	0, 'Delete student assessment data from FactStudentAssessment (submission)',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentAssessments ''submission'', 0',	43,	0, 'Load student discipline data into FactStudentAssessment',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''submission'', ''personnelcounts''',	44,	0, 'Delete personnel data from FactPersonnelCounts (submission)',NULL),
			(2,	1,	0,	0,	'rds.Migrate_PersonnelCounts ''submission'', 0',	45,	0, 'Load personnel data into FactPersonnelCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''childcount''',	46,	0, 'Delete child count data from FactStudentCounts (submission)',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''childcount'', 0',	47,	0, 'Load child count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''specedexit''',	48,	0, 'Delete students specedexit  count data from FactStudentCounts (submission)',NULL),
			(2,	1,	0,	0,	'rds.Migrate_SpecialEdStudentCounts ''specedexit'', 0',	49,	0, 'Load Students specedexit count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''cte''',	50,	0, 'Delete CTE students count data from FactStudentCounts (submission)',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''cte'', 0',	51,	0, 'Load CTE Students count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''membership''',	52,	0, 'Delete Membership students count data from FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''membership'', 0',	53,	0, 'Load Membership Students count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''dropout''',	54,	0, 'Delete dropout students count data from FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''dropout'', 0',	55,	0, 'Load dropout Students count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''grad''',	56,	0, 'Delete Graduaters or Completers students count data from FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''grad'', 0',	57,	0, 'Load  Graduaters or Completers Students count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''titleIIIELOct''',	58,	0, 'Delete Title III EL October students count data from FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''titleIIIELOct'', 0',	59,	0, 'Load  Title III EL October Students count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''titleIIIELSY''',	60,	0, 'Delete Title III EL SY students count data from FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''titleIIIELSY'', 0',	61,	0, 'Load  Title III EL SY Students count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''titleI''',	62,	0, 'Delete TitleI students count data from FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''titleI'', 0',	63,	0, 'Load  TitleI Students count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''mep''',	64,	0, 'Delete MEP students count data from FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''mep'', 0',	65,	0, 'Load  MEP Students count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''immigrant''',	66,	0, 'Delete Immigrant students count data from FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''immigrant'', 0',	67,	0, 'Load  Immigrant Students count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''nord''',	68,	0, 'Delete N or D students count data from FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''nord'', 0',	69,	0, 'Load N or D Students count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''homeless''',	70,	0, 'Delete Homeless students count data from FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''homeless'', 0',	71,	0, 'Load Homeless Students count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''chronic''',	72,	0, 'Delete Chronic Absenteeism students count data from FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''chronic'', 0',	73,	0, 'Load Chronic Absenteeism Students count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''gradrate''',	74,	0, 'Delete Grad Rate students count data from FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''gradrate'', 0',	75,	0, 'Load Grad Rate Students count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''hsgradenroll''',	76,	0, 'Delete HS Grad PS Enrollment students count data from FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''hsgradenroll'', 0',	77,	0, 'Load HS Grad PS Enrollment Students count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''other''',	78,	0, 'Delete Other students count data from FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''other'', 0',	79,	0, 'Load Other Students count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''sppapr''',	80,	0, 'Delete SPP/APR students count data from FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentCounts ''sppapr'', 0',	81,	0, 'Load SPP/APR Students count data into FactStudentCounts',NULL),
			(2,	1,	0,	0,	'rds.Empty_RDS ''submission'', ''studentattendance''',	82,	0, 'Delete student attendance data from FactK12StudentAttendance (submission)',NULL),
			(2,	1,	0,	0,	'rds.Migrate_StudentAttendance ''submission'', 0',	83,	0, 'Load student attendance data into FactK12StudentAttendance',NULL)
		END

	--End of CIID-2223 changes
	
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