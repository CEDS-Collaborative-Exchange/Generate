CREATE PROCEDURE [Staging].[RUN_DMC]
	@submissionYear int = NULL
AS
BEGIN

    SET NOCOUNT ON;

		-- Completely clear the RDS
		TRUNCATE TABLE RDS.BridgeK12StudentAssessmentRaces
		TRUNCATE TABLE RDS.BridgeK12StudentAssessmentAccommodations
		TRUNCATE TABLE RDS.BridgeK12ProgramParticipationRaces
		TRUNCATE TABLE RDS.BridgeK12SchoolGradeLevels
		TRUNCATE TABLE RDS.BridgeK12StudentCourseSectionK12Staff
		TRUNCATE TABLE RDS.BridgeK12StudentCourseSectionRaces
		TRUNCATE TABLE RDS.BridgeK12StudentEnrollmentRaces
		TRUNCATE TABLE RDS.BridgeLeaGradeLevels
		TRUNCATE TABLE RDS.BridgePsStudentEnrollmentRaces
		TRUNCATE TABLE RDS.ReportEDFactsK12StaffCounts
		TRUNCATE TABLE RDS.ReportEDFactsK12StudentCounts
		TRUNCATE TABLE RDS.ReportEDFactsK12StudentDisciplines
		TRUNCATE TABLE RDS.ReportEDFactsK12StudentAssessments
		TRUNCATE TABLE RDS.ReportEDFactsK12StudentAttendance
		TRUNCATE TABLE RDS.ReportEDFactsOrganizationCounts
		TRUNCATE TABLE RDS.ReportEDFactsOrganizationStatusCounts

		DELETE FROM RDS.FactCustomCounts
		DELETE FROM RDS.FactK12ProgramParticipations
		DELETE FROM RDS.FactK12StaffCounts
		DELETE FROM RDS.FactK12StudentAssessments
		DELETE FROM RDS.FactK12StudentAttendanceRates
		DELETE FROM RDS.FactK12StudentCounts
		DELETE FROM RDS.FactK12StudentCourseSections
		DELETE FROM RDS.FactK12StudentDisciplines
		DELETE FROM RDS.FactK12StudentEnrollments
		DELETE FROM RDS.FactOrganizationCounts
		DELETE FROM RDS.FactOrganizationStatusCounts
		DELETE FROM RDS.DimSeas
		DELETE FROM RDS.DimLeas
		DELETE FROM RDS.DimK12Schools
		DELETE FROM RDS.DimPeople
		DELETE FROM RDS.DimAssessments
		DELETE FROM RDS.DimAssessmentAdministrations

		DBCC CHECKIDENT('RDS.FactCustomCounts', RESEED, 1);
		DBCC CHECKIDENT('RDS.FactK12ProgramParticipations', RESEED, 1);
		DBCC CHECKIDENT('RDS.FactK12StaffCounts', RESEED, 1);
		DBCC CHECKIDENT('RDS.ReportEDFactsK12StudentAssessments', RESEED, 1);
		DBCC CHECKIDENT('RDS.FactK12StudentAssessments', RESEED, 1);
		DBCC CHECKIDENT('RDS.FactK12StudentAttendanceRates', RESEED, 1);
		DBCC CHECKIDENT('RDS.ReportEDFactsK12StudentAttendance', RESEED, 1);
		DBCC CHECKIDENT('RDS.FactK12StudentCounts', RESEED, 1);
		DBCC CHECKIDENT('RDS.FactK12StudentCourseSections', RESEED, 1);
		DBCC CHECKIDENT('RDS.FactK12StudentDisciplines', RESEED, 1);
		DBCC CHECKIDENT('RDS.FactK12StudentEnrollments', RESEED, 1);
		DBCC CHECKIDENT('RDS.ReportEDFactsOrganizationCounts', RESEED, 1);
		DBCC CHECKIDENT('RDS.FactOrganizationCounts', RESEED, 1);
		DBCC CHECKIDENT('RDS.ReportEDFactsOrganizationStatusCounts', RESEED, 1);
		DBCC CHECKIDENT('RDS.FactOrganizationStatusCounts', RESEED, 1);
		DBCC CHECKIDENT('RDS.DimSeas', RESEED, 1);
		DBCC CHECKIDENT('RDS.DimLeas', RESEED, 1);
		DBCC CHECKIDENT('RDS.DimK12Schools', RESEED, 1);
		DBCC CHECKIDENT('RDS.DimPeople', RESEED, 1);
		DBCC CHECKIDENT('RDS.DimAssessments', RESEED, 1);
		DBCC CHECKIDENT('RDS.DimAssessmentAdministrations', RESEED, 1);

		--set the Submission Year if it wasn't provided
		if ISNULL(@submissionYear, '') = ''
		begin
			select @submissionYear = SchoolYear
			from staging.K12Enrollment	
		end

	--	--create temp table to hold stored procedures/execution flag
		if OBJECT_ID('tempdb..#RDSMigrationProcedures') IS NOT NULL
		drop table #RDSMigrationProcedures

		create table #RDSMigrationProcedures (
			SP_ID								int		
			, StoredProcedureName				nvarchar(100)
			, Executed 							bit
			, Error								nvarchar(max)
		)

		insert into #RDSMigrationProcedures
		values 
		(1, 'Staging-to-DimSeas', 0, NULL),
		(2, 'Staging-to-DimLeas', 0, NULL),
		(3, 'Staging-to-DimK12Schools', 0, NULL),
		(4, 'Staging-to-DimCharterSchoolAuthorizers', 0, NULL),
		(5, 'Staging-to-DimCharterSchoolManagementOrganizations', 0, NULL),
		(6, 'Staging-to-DimPeople_K12Students', 0, NULL),
		(7, 'Staging-to-DimPeople_K12Staff', 0, NULL),
		(8, 'Staging-to-FactOrganizationCounts', 0, NULL),
		--(9, 'Staging-to-FactOrganizationCounts_ComprehensiveAndTargetedSupport', 0, NULL),
		(10, 'Staging-to-FactK12StudentCounts_ChildCount', 0, NULL),
		(11, 'Staging-to-FactK12StudentCounts_Membership', 0, NULL),
		(12, 'Staging-to-FactK12StudentCounts_Exiting', 0, NULL),
		(13, 'Staging-to-FactK12StudentCounts_TitleIIIELOct', 0, NULL),
--		(14, 'Staging-to-FactK12StudentCounts_TitleIIIELSY', 0, NULL),
		(15, 'Staging-to-FactK12StudentDisciplines', 0, NULL),
		--(16, 'Staging-to-FactK12StudentCounts_Chronic', 0, NULL),
		--(17, 'Staging-to-FactK12StudentCounts_Dropout', 0, NULL),
		--(18, 'Staging-to-FactK12StudentCounts_GraduatesCompleters', 0, NULL),
		--(19, 'Staging-to-FactK12StudentCounts_GraduationRate', 0, NULL),
		(20, 'Staging-to-FactK12StudentCounts_Homeless', 0, NULL),
		--(21, 'Staging-to-FactK12StudentCounts_HSGradPSEnroll', 0, NULL),
		--(22, 'Staging-to-FactK12StudentCounts_Immigrant', 0, NULL),
		--(23, 'Staging-to-FactK12StudentCounts_MigrantEducationProgram', 0, NULL),
		--(24, 'Staging-to-FactK12StudentCounts_NeglectedOrDelinquent', 0, NULL),
		--(25, 'Staging-to-FactK12StudentCounts_TitleI', 0, NULL)
		(26, 'Staging-to-FactK12StaffCounts', 0, NULL),
		(27, 'Staging-to-DimAssessments', 0, NULL),
		(28, 'Staging-to-DimAssessmentAdministrations', 0, NULL),
		(29, 'Staging-to-DimAssessmentPerformanceLevels', 0, NULL),
		(30, 'Staging-to-FactK12StudentAssessments', 0, NULL)

	----------------------------------------------
	---- Staging-to-RDS
	----------------------------------------------

	--	--------------
	--	--DIM tables
	--	--------------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 1 and executed = 0)
			begin try 

				--write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-DimSeas')

				--execute the stored procedure
				exec [Staging].[Staging-to-DimSeas] 'directory', null, 0
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)
				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 1

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 1
			end catch
	--------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 2 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-DimLeas')

				--execute the stored procedure
				exec [Staging].[Staging-to-DimLeas] 'directory', null, 0	
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)
				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 2

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 2
			end catch
		--------
	
			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 3 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-DimK12Schools')

				--execute the stored procedure
				exec [Staging].[Staging-to-DimK12Schools] null, 0
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)
				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 3

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 3
			end catch
		--------
	

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 4 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-DimCharterSchoolAuthorizers')

				--execute the stored procedure
				exec [Staging].[Staging-to-DimCharterSchoolAuthorizers] NULL, 0
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)
				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 4

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 4
			end catch
		--------
	

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 5 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-DimCharterSchoolManagementOrganizations')

				--execute the stored procedure
				exec [Staging].[Staging-to-DimCharterSchoolManagementOrganizations] NULL, 0
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)
				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 5

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 5
			end catch
		--------
	
			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 6 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-DimPeople_K12Students')

				--execute the stored procedure
				exec [Staging].[Staging-to-DimPeople_K12Students] 
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)
				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 6

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 6
			end catch
		--------
	
			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 7 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-DimPeople_K12Staff')

				--execute the stored procedure
				exec [Staging].[Staging-to-DimPeople_K12Staff] 
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)
				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 7

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 7
			end catch
		--------
	
			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 8 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactOrganizationCounts')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactOrganizationCounts] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)
				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 8

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 8
			end catch
		
		--------
	
			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 9 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactOrganizationCounts_ComprehensiveAndTargetedSupport')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactOrganizationCounts_ComprehensiveAndTargetedSupport] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)
				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 9

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 9
			end catch
		--------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 10 and executed = 0)
			begin try 

				--write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentCounts_ChildCount')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentCounts_ChildCount] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 10

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 10
			end catch

		--------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 11 and executed = 0)
			begin try 

				--write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentCounts_Membership')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentCounts_Membership] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 11

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 11
			end catch
			--------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 12 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentCounts_Exiting')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentCounts_Exiting] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 12

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 12
			end catch
			--------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 13 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentCounts_TitleIIIELOct')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentCounts_TitleIIIELOct] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 13

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 13
			end catch
			--------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 14 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentCounts_TitleIIIELSY')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentCounts_TitleIIIELSY] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 14

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 14
			end catch

			--------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 15 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentDisciplines')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentDisciplines] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 15

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 15
			end catch

			--------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 16 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentCounts_Chronic')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentCounts_Chronic] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 16

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 16
			end catch
			--------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 17 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentCounts_Dropout')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentCounts_Dropout] @submissionYear

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 17

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 17
			end catch

			----------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 18 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentCounts_GraduatesCompleters')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentCounts_GraduatesCompleters] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 18

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 18
			end catch

			--------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 19 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentCounts_GraduationRate')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentCounts_GraduationRate] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 19

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 19
			end catch

			--------


			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 20 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentCounts_Homeless')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentCounts_Homeless] @submissionYear
 				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 20

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 20
			end catch

			--------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 21 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentCounts_HSGradPSEnroll')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentCounts_HSGradPSEnroll] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 21

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 21
			end catch
			------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 22 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentCounts_Immigrant')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentCounts_Immigrant] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 22

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 22
			end catch
			------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 23 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentCounts_MigrantEducationProgram')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentCounts_MigrantEducationProgram] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 23

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 23
			end catch
			------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 24 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentCounts_NeglectedOrDelinquent')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentCounts_NeglectedOrDelinquent] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 24

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 24
			end catch
			------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 25 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentCounts_TitleI')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentCounts_TitleI] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 25

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 25
			end catch
			------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 26 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StaffCounts')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StaffCounts] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 26

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 26
			end catch
			------

		-- Update App.ToggleAssessments with data from Staging
			TRUNCATE TABLE App.ToggleAssessments

			;WITH CTE AS (
				SELECT DISTINCT 
				AssessmentTitle
				, AssessmentTypeAdministered
				, AssessmentAcademicSubject
				, AssessmentPerformanceLevelLabel
			FROM Staging.Assessment sa
			)
			INSERT INTO App.ToggleAssessments
			SELECT
				sa.AssessmentTitle
				, CASE sa.AssessmentTypeAdministered
					WHEN 'ALTASSALTACH'			THEN 'Alternate assessments based on alternate achievement standards'
					WHEN 'ALTASSGRADELVL'		THEN 'Alternate assessments based on grade-level achievement standards'
					WHEN 'ALTASSMODACH'			THEN 'Alternate assessments based on modified achievement standards'
					WHEN 'REGASSWACC'			THEN 'Regular assessments based on grade-level achievement standards with accommodations'
					WHEN 'REGASSWOACC'			THEN 'Regular assessments based on grade-level achievement standards without accommodations'
					WHEN 'ADVASMTWACC'			THEN 'Advanced assessment with accommodations'
					WHEN 'ADVASMTWOACC'			THEN 'Advanced assessment without accommodations'
					WHEN 'HSREGASMTIWACC'		THEN 'High school regular assessment I, with accommodations'
					WHEN 'HSREGASMTIWOACC'		THEN 'High school regular assessment I, without accommodations'
					WHEN 'HSREGASMT2WACC'		THEN 'High school regular assessment II, with accommodations'
					WHEN 'HSREGASMT2WOACC'		THEN 'High school regular assessment II, without accommodations'
					WHEN 'HSREGASMT3WACC'		THEN 'High school regular assessment III, with accommodations'
					WHEN 'HSREGASMT3WOACC'		THEN 'High school regular assessment III, without accommodations'
					WHEN 'IADAPLASMTWOACC'		THEN 'Innovative Assessment Demonstration Authority (IADA) pilot assessment without accommodations'
					WHEN 'IADAPLASMTWACC'		THEN 'Innovative Assessment Demonstration Authority (IADA) pilot assessment with accommodations'
					WHEN 'LSNRHSASMTWOACC'		THEN 'Locally-selected nationally recognized high school assessment without accommodations'
					WHEN 'LSNRHSASMTWACC'		THEN 'Locally-selected nationally recognized high school assessment with accommodations'
					WHEN 'ALTASSALTACH_1'		THEN 'Alternate assessments based on alternate achievement standards'
					WHEN 'ALTASSGRADELVL_1'		THEN 'Alternate assessments based on grade-level achievement standards'
					WHEN 'ALTASSMODACH_1'		THEN 'Alternate assessments based on modified achievement standards'
					WHEN 'REGASSWACC_1'			THEN 'Regular assessments based on grade-level achievement standards with accommodations'
					WHEN 'REGASSWOACC_1'		THEN 'Regular assessments based on grade-level achievement standards without accommodations'
					WHEN 'ADVASMTWACC_1'		THEN 'Advanced assessment with accommodations'
					WHEN 'ADVASMTWOACC_1'		THEN 'Advanced assessment without accommodations'
					WHEN 'HSREGASMTIWACC_1'		THEN 'High school regular assessment I, with accommodations'
					WHEN 'HSREGASMTIWOACC_1'	THEN 'High school regular assessment I, without accommodations'
					WHEN 'HSREGASMT2WACC_1'		THEN 'High school regular assessment II, with accommodations'
					WHEN 'HSREGASMT2WOACC_1'	THEN 'High school regular assessment II, without accommodations'
					WHEN 'HSREGASMT3WACC_1'		THEN 'High school regular assessment III, with accommodations'
					WHEN 'HSREGASMT3WOACC_1'	THEN 'High school regular assessment III, without accommodations'
					WHEN 'IADAPLASMTWOACC_1'	THEN 'Innovative Assessment Demonstration Authority (IADA) pilot assessment without accommodations'
					WHEN 'IADAPLASMTWACC_1'		THEN 'Innovative Assessment Demonstration Authority (IADA) pilot assessment with accommodations'
					WHEN 'LSNRHSASMTWOACC_1'	THEN 'Locally-selected nationally recognized high school assessment without accommodations'
					WHEN 'LSNRHSASMTWACC_1'		THEN 'Locally-selected nationally recognized high school assessment with accommodations'
				END
				, replace(sa.AssessmentTypeAdministered, '_1', '')
				, 'End of Grade'
				, left(replace(sar.GradeLevelWhenAssessed, '_1', ''), 2) 
				, COUNT(DISTINCT sar.AssessmentPerformanceLevelLabel)
				, '3'
				, CASE sa.AssessmentAcademicSubject
					WHEN '01166'	THEN 'MATH'
					WHEN '13373'	THEN 'RLA'
					WHEN '73065'	THEN 'CTE'
					WHEN '00562'	THEN 'SCIENCE'
					WHEN '01166_1'	THEN 'MATH'
					WHEN '13373_1'	THEN 'RLA'
					WHEN '73065_1'	THEN 'CTE'
					WHEN '00562_1'	THEN 'SCIENCE'
				END
			FROM CTE sa
			JOIN Staging.AssessmentResult sar
				ON sa.AssessmentTitle = sar.AssessmentTitle
				AND sa.AssessmentAcademicSubject = sar.AssessmentAcademicSubject
				AND sa.AssessmentPerformanceLevelLabel = sar.AssessmentPerformanceLevelLabel
			LEFT JOIN App.ToggleAssessments ata
				ON sa.AssessmentTitle = ata.AssessmentName
				AND sa.AssessmentTypeAdministered = ata.AssessmentTypeCode
				AND sar.GradeLevelWhenAssessed = ata.Grade
				AND CASE sa.AssessmentAcademicSubject
					WHEN '01166' THEN 'MATH'
					WHEN '13373' THEN 'RLA'
					WHEN '73065' THEN 'CTE'
					WHEN '00562' THEN 'SCIENCE'
					WHEN '01166_1'	THEN 'MATH'
					WHEN '13373_1'	THEN 'RLA'
					WHEN '73065_1'	THEN 'CTE'
					WHEN '00562_1'	THEN 'SCIENCE'
				END = ata.Subject
			WHERE sa.AssessmentAcademicSubject NOT IN ('00256', '00256_1') -- ESL
				AND ata.ToggleAssessmentId IS NULL
				AND GradeLevelWhenAssessed NOT IN ('abe', 'abe_1')
			GROUP BY 
				sa.AssessmentTitle
				, sa.AssessmentTypeAdministered
				, sar.GradeLevelWhenAssessed
				, sa.AssessmentAcademicSubject
			------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 27 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-DimAssessments')

				--execute the stored procedure
				exec [Staging].[Staging-to-DimAssessments]
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 27

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 27
			end catch
			------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 28 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-DimAssessmentAdministrations')

				--execute the stored procedure
				exec [Staging].[Staging-to-DimAssessmentAdministrations]
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 28

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 28
			end catch
			------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 29 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-DimAssessmentPerformanceLevels')

				--execute the stored procedure
				exec [Staging].[Staging-to-DimAssessmentPerformanceLevels]
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 29

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 29
			end catch
			------

			if exists (select 1 from #RDSMigrationProcedures where SP_ID = 30 and executed = 0)
			begin try 

				----write out message to DataMigrationHistories
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RUN DMC Staging-to-FactK12StudentAssessments')

				--execute the stored procedure
				exec [Staging].[Staging-to-FactK12StudentAssessments] @submissionYear
				DBCC SHRINKFILE([generate-test], 1)
				DBCC SHRINKFILE([generate-test_log], 1)

				--update the temp table 
				update #RDSMigrationProcedures set executed = 1 where SP_ID = 30

			end try 
			begin catch 
				update #RDSMigrationProcedures set Error = ERROR_MESSAGE() where SP_ID = 30
			end catch
			------


		IF EXISTS (SELECT 1 FROM #RDSMigrationProcedures WHERE Error IS NOT NULL) BEGIN
			SELECT * FROM #RDSMigrationProcedures s WHERE s.Error IS NOT NULL
		END


	SET NOCOUNT OFF;

END
