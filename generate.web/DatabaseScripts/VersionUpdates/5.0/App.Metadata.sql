set nocount on

begin try

	  Update app.GenerateConfigurations set GenerateConfigurationValue = '2022' where GenerateConfigurationKey = 'SchoolYear'
	  Update app.GenerateReports set ReportTypeAbbreviation = 'FEDPROG' where reportcode = 'c035'

	  
	/*CIID-4447 Add PV USETH to Targeted Support Subgroups
		This value is set by the CategorySets metadata script
		Confirm that EDENDB export provided correct values

	select * from app.CategoryOptions
	WHERE CategorySetId IN (
		SELECT cs.CategorySetId
		 FROM App.CategorySets cs 
		 INNER JOIN App.GenerateReports gr 
		 ON cs.GenerateReportId = gr.GenerateReportId 
		 inner join app.TableTypes tt 
		 ON cs.TableTypeId = tt.TableTypeId
		 WHERE gr.ReportShortName = 'c212' 
		 --AND cs.CategorySetCode = 'CSA' 
		 AND cs.SubmissionYear = 2022 
		 AND cs.OrganizationLevelId = 3
		 and tt.TableTypeAbbrv = 'TSIREASONS'
	 )
		AND CategoryOptionCode = 'USETH'
	*/
	
	 /* CIID-4448 Roll FS206 into 2022 and remove TSIEXIT from App.CategoryOptions
		This value is set in the Categories metadata script
		Confirm that EDENDB export provided correct values
	 SELECT *
	 FROM App.CategoryOptions
	 WHERE CategorySetId IN (
		 SELECT cs.CategorySetId
		 FROM App.CategorySets cs INNER JOIN App.GenerateReports gr ON cs.GenerateReportId = gr.GenerateReportId WHERE gr.ReportShortName = 'c206' AND cs.CategorySetCode = 'CSA' AND cs.SubmissionYear = 2022 AND cs.OrganizationLevelId = 3
	 )
		AND CategoryOptionCode = 'TSIEXIT'
	 */

	 /*CIID-4448 ends*/

	 /* CIID-4446 Add ADDLTSIEXIT to App.CategoryOptions
		This value is set in the Categories metadata script
		Confirm that EDENDB export provided correct values

	 SELECT *
	 FROM App.CategoryOptions
	 WHERE CategorySetId IN (
		 SELECT cs.CategorySetId
		 FROM App.CategorySets cs INNER JOIN App.GenerateReports gr ON cs.GenerateReportId = gr.GenerateReportId WHERE gr.ReportShortName = 'c206' AND cs.CategorySetCode = 'CSA' AND cs.SubmissionYear = 2022 AND cs.OrganizationLevelId = 3
	 )
		AND CategoryOptionCode = 'ADDLTSIEXIT'
	 /* CIID-4446 ends */
	 */

	/*CIID-4536 FS212 staging-to-RDS migration*/
	IF NOT EXISTS (SELECT 1 FROM App.DimensionTables WHERE DimensionTableName = 'DimSubgroups')
		INSERT App.DimensionTables (
			DimensionTableName
			,IsReportingDimension
		)
		VALUES (
			'DimSubgroups'
			,1
		)

	IF NOT EXISTS (SELECT 1 FROM App.DimensionTables WHERE DimensionTableName = 'DimComprehensiveAndTargetedSupports')
		INSERT App.DimensionTables (
			DimensionTableName
			,IsReportingDimension
		)
		VALUES (
			'DimComprehensiveAndTargetedSupports'
			,1
		)

	IF NOT EXISTS (SELECT 1 FROM App.DimensionTables WHERE DimensionTableName = 'DimComprehensiveSupportReasonApplicabilities')
		INSERT App.DimensionTables (
			DimensionTableName
			,IsReportingDimension
		)
		VALUES (
			'DimComprehensiveSupportReasonApplicabilities'
			,1
		)

	MERGE INTO App.Dimensions d
	USING (
		SELECT [DimensionFieldName] = 'Subgroup'
			,DimensionTableID
			,[IsCalculated] = 0
			,[IsOrganizationLevelSpecific] = 0
		FROM App.DimensionTables
		WHERE DimensionTableName = 'DimSubgroups'
		UNION
		SELECT [DimensionFieldName] = 'ComprehensiveSupportReasonApplicability'
			,DimensionTableID
			,[IsCalculated] = 0
			,[IsOrganizationLevelSpecific] = 0
		FROM App.DimensionTables
		WHERE DimensionTableName = 'DimComprehensiveSupportReasonApplicabilities'
		UNION
		SELECT [DimensionFieldName] = 'ComprehensiveAndTargetedSupport'
			,DimensionTableID
			,[IsCalculated] = 0
			,[IsOrganizationLevelSpecific] = 0
		FROM App.DimensionTables
		WHERE DimensionTableName = 'DimComprehensiveAndTargetedSupports'
		UNION
		SELECT [DimensionFieldName] = 'ComprehensiveSupport'
			,DimensionTableID
			,[IsCalculated] = 0
			,[IsOrganizationLevelSpecific] = 0
		FROM App.DimensionTables
		WHERE DimensionTableName = 'DimComprehensiveAndTargetedSupports'
		UNION
		SELECT [DimensionFieldName] = 'TargetedSupport'
			,DimensionTableID
			,[IsCalculated] = 0
			,[IsOrganizationLevelSpecific] = 0
		FROM App.DimensionTables
		WHERE DimensionTableName = 'DimComprehensiveAndTargetedSupports'
	) dt
	ON (d.DimensionFieldName = dt.DimensionFieldName)
	WHEN MATCHED
	THEN UPDATE
	SET d.DimensionTableID = dt.DimensionTableID
		,d.IsCalculated = dt.IsCalculated
		,d.IsOrganizationLevelSpecific = dt.IsOrganizationLevelSpecific
	WHEN NOT MATCHED
	THEN INSERT (DimensionFieldName,DimensionTableID,IsCalculated,IsOrganizationLevelSpecific)
		VALUES (dt.DimensionFieldName,dt.DimensionTableID,dt.IsCalculated,dt.IsOrganizationLevelSpecific);

	MERGE INTO App.Category_Dimensions cd
	USING (
		SELECT c.CategoryId,d.DimensionId
		FROM App.Categories c
			CROSS JOIN App.Dimensions d
		WHERE c.CategoryCode = 'TRGTIDFNSBGRPS'
			AND d.DimensionFieldName = 'Subgroup'
	) x
	ON (cd.CategoryId = x.CategoryId AND cd.DimensionId = x.DimensionId)
	WHEN NOT MATCHED
	THEN INSERT (CategoryId,DimensionId)
		VALUES(x.CategoryId,x.DimensionId);
	/*CIID-4536 ends*/


	delete fsfc from app.filesubmissions fs 
	left join app.filesubmission_filecolumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
	left join app.filecolumns fc on fsfc.filecolumnid = fc.FileColumnId
	where fs.generatereportid in (110) and submissionyear in (2018, 2019, 2020)

	delete fs from app.FileSubmissions fs 
	left join app.filesubmission_filecolumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
	left join app.filecolumns fc on fsfc.filecolumnid = fc.FileColumnId
	where fs.generatereportid in (110) and submissionyear in (2018, 2019, 2020)

	DECLARE @reportId int, @reportCode varchar(20)
	
	DECLARE generatereport_cursor CURSOR FOR 
	select GenerateReportId, ReportCode
	from  app.GenerateReports 
	where generatereportid in (110)

	OPEN generatereport_cursor
	FETCH NEXT FROM generatereport_cursor INTO @reportId, @reportCode

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		exec App.Rollover_Previous_Year_Metadata @reportCode, '2017', '2018'
		exec App.Rollover_Previous_Year_Metadata @reportCode, '2018', '2019'
		exec App.Rollover_Previous_Year_Metadata @reportCode, '2019', '2020'
		
	FETCH NEXT FROM generatereport_cursor INTO @reportId, @reportCode
	END
	CLOSE generatereport_cursor
	DEALLOCATE generatereport_cursor

--CIID-4823 - Remove duplicate metadata for Assessments

	--reset the variables from the run above
	SET @reportId = null
	SET @reportCode = null

	delete fsfc from app.filesubmissions fs 
	left join app.filesubmission_filecolumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
	left join app.filecolumns fc on fsfc.filecolumnid = fc.FileColumnId
	where fs.generatereportid in (4, 5, 6, 7, 81, 84) and submissionyear in (2020, 2021)

	delete fs from app.FileSubmissions fs 
	left join app.filesubmission_filecolumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
	left join app.filecolumns fc on fsfc.filecolumnid = fc.FileColumnId
	where fs.generatereportid in (4, 5, 6, 7, 81, 84) and submissionyear in (2020, 2021)

	DECLARE generatereport_cursor CURSOR FOR 
	select GenerateReportId, ReportCode
	from  app.GenerateReports 
	where generatereportid in (4, 5, 6, 7, 81, 84)

	OPEN generatereport_cursor
	FETCH NEXT FROM generatereport_cursor INTO @reportId, @reportCode

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		exec App.Rollover_Previous_Year_Metadata @reportCode, '2019', '2020'
		exec App.Rollover_Previous_Year_Metadata @reportCode, '2020', '2021'
		
	FETCH NEXT FROM generatereport_cursor INTO @reportId, @reportCode
	END
	CLOSE generatereport_cursor
	DEALLOCATE generatereport_cursor

--End of CIID-4823

--CIID-4822 - Remove duplicate metadata for Discipline, Exiting, and Personnel
--	report IDs - Exiting (15), Personnel (10,11,26), Discipline (8,9,14,16,17,18)

	--reset the variables from the run above
	SET @reportId = null
	SET @reportCode = null

	delete fsfc from app.filesubmissions fs 
	left join app.filesubmission_filecolumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
	left join app.filecolumns fc on fsfc.filecolumnid = fc.FileColumnId
	where fs.generatereportid in (8,9,10,11,14,15,16,17,18,26) and submissionyear in (2020, 2021)

	delete fs from app.FileSubmissions fs 
	left join app.filesubmission_filecolumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
	left join app.filecolumns fc on fsfc.filecolumnid = fc.FileColumnId
	where fs.generatereportid in (8,9,10,11,14,15,16,17,18,26) and submissionyear in (2020, 2021)

	DECLARE generatereport_cursor CURSOR FOR 
	select GenerateReportId, ReportCode
	from  app.GenerateReports 
	where generatereportid in (8,9,10,11,14,15,16,17,18,26)

	--OPEN generatereport_cursor
	--FETCH NEXT FROM generatereport_cursor INTO @reportId, @reportCode

	--WHILE @@FETCH_STATUS = 0
	--BEGIN
		
	--	exec App.Rollover_Previous_Year_Metadata @reportCode, '2019', '2020'
	--	exec App.Rollover_Previous_Year_Metadata @reportCode, '2020', '2021'
		
	--FETCH NEXT FROM generatereport_cursor INTO @reportId, @reportCode
	--END
	--CLOSE generatereport_cursor
	--DEALLOCATE generatereport_cursor

	----CIID-4873 - Reload all missing metadata
	--exec [App].[Rollover_All_Metadata_up_to_SchoolYear] 2022
	----End of CIID-4873


	--CIID-4498 - IDS Wrapper scripts
	-------------------------------------------
	--IDS migration
	-------------------------------------------
	--remove the individual SPs from the table
		delete 
		from app.DataMigrationTasks
		where DataMigrationTypeId = 1
		and StoredProcedureName like '%Migrate_StagingToIDS%'

	--order the existing wrappers
		update app.DataMigrationTasks
		set TaskSequence = 1,
			Description = '029, 035, 039, 103, 129, 130, 131, 163, 170, 190, 193, 196, 197, 198, 205, 206'
		where DataMigrationTypeId = 1
		and StoredProcedureName like '%Wrapper_Migrate_Directory%'

		update app.DataMigrationTasks
		set TaskSequence = 2,
			Description = '002, 089'
		where DataMigrationTypeId = 1
		and StoredProcedureName like '%Wrapper_Migrate_ChildCount%'

		update app.DataMigrationTasks
		set TaskSequence = 3,
			Description = '009' 
		where DataMigrationTypeId = 1
		and StoredProcedureName like '%Wrapper_Migrate_Exiting%'

		update app.DataMigrationTasks
		set TaskSequence = 4,
			Description = '005, 006, 007, 086, 088, 143, 144' 
		where DataMigrationTypeId = 1
		and StoredProcedureName like '%Wrapper_Migrate_Discipline%'

		update app.DataMigrationTasks
		set TaskSequence = 5,
			Description = '059, 065, 067, 070, 099, 112, 203' 
		where DataMigrationTypeId = 1
		and StoredProcedureName like '%Wrapper_Migrate_Personnel%'

		update app.DataMigrationTasks
		set TaskSequence = 6,
			Description = '113, 125, 126, 137, 138, 139, 142, 175, 178, 179, 185, 188, 189' 
		where DataMigrationTypeId = 1
		and StoredProcedureName like '%Wrapper_Migrate_Assessment%'

		update app.DataMigrationTasks
		set TaskSequence = 21,
			Description = '037, 134' 
		where DataMigrationTypeId = 1
		and StoredProcedureName like '%Wrapper_Migrate_TitleI%'

	--insert the new wrappers
		insert into app.DataMigrationTasks
		values 
		(1,1,0,0,'Staging.Wrapper_Migrate_Chronic_to_IDS @SchoolYear',7,0,'195',NULL),
		(1,1,0,0,'Staging.Wrapper_Migrate_CTE_to_IDS @SchoolYear',8,0,'082, 083, 132, 154, 155, 156, 158, 169',NULL),
		(1,1,0,0,'Staging.Wrapper_Migrate_Dropout_to_IDS @SchoolYear',9,0,'032',NULL),
		(1,1,0,0,'Staging.Wrapper_Migrate_Grad_to_IDS @SchoolYear',10,0,'040, cohortgraduationrate',NULL),
		(1,1,0,0,'Staging.Wrapper_Migrate_Gradrate_to_IDS @SchoolYear',11,0,'150, 151',NULL),
		(1,1,0,0,'Staging.Wrapper_Migrate_Homeless_to_IDS @SchoolYear',12,0,'118, 194',NULL),
		(1,1,0,0,'Staging.Wrapper_Migrate_HsGradEnroll_to_IDS @SchoolYear',13,0,'160',NULL),
		(1,1,0,0,'Staging.Wrapper_Migrate_Immigrant_to_IDS @SchoolYear',14,0,'165',NULL),
		(1,1,0,0,'Staging.Wrapper_Migrate_Membership_to_IDS @SchoolYear',15,0,'033, 052',NULL),
		(1,1,0,0,'Staging.Wrapper_Migrate_Mep_to_IDS @SchoolYear',16,0,'054, 121, 122, 145',NULL),
		(1,1,0,0,'Staging.Wrapper_Migrate_NorD_to_IDS @SchoolYear',17,0,'119, 127, 180, 181',NULL),
		(1,1,0,0,'Staging.Wrapper_Migrate_Other_to_IDS @SchoolYear',18,0,'195',NULL),
		(1,1,0,0,'Staging.Wrapper_Migrate_SPPAPR_to_IDS @SchoolYear',19,0,'indicator9, indicator10',NULL),
		(1,1,0,0,'Staging.Wrapper_Migrate_StudentCounts_to_IDS @SchoolYear',20,0,'N/A',NULL),
		(1,1,0,0,'Staging.Wrapper_Migrate_TitleIIIELOct_to_IDS @SchoolYear',22,0,'116, 141',NULL),
		(1,1,0,0,'Staging.Wrapper_Migrate_TitleIIIELSY_to_IDS @SchoolYear',23,0,'045, 204',NULL)

	-------------------------------------------
	--RDS migration
	-------------------------------------------
	--remove the individual SPs from the table
		delete 
		from app.DataMigrationTasks
		where DataMigrationTypeId = 2
		and StoredProcedureName not like '%Wrapper_Migrate%'

	--order the existing wrappers
		update app.DataMigrationTasks
		set TaskSequence = 1
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_Directory%'

		update app.DataMigrationTasks
		set TaskSequence = 2
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_ChildCount%'

		update app.DataMigrationTasks
		set TaskSequence = 3
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_Exiting%'

		update app.DataMigrationTasks
		set TaskSequence = 4
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_Discipline%'

		update app.DataMigrationTasks
		set TaskSequence = 5
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_Personnel%'

		update app.DataMigrationTasks
		set TaskSequence = 6
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_Assessment%'

		update app.DataMigrationTasks
		set TaskSequence = 7
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_Chronic%'

		update app.DataMigrationTasks
		set TaskSequence = 8
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_CTE%'

		update app.DataMigrationTasks
		set TaskSequence = 9
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_Dropout%'

		update app.DataMigrationTasks
		set TaskSequence = 10
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_Grad%'

		update app.DataMigrationTasks
		set TaskSequence = 11
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_Gradrate%'

		update app.DataMigrationTasks
		set TaskSequence = 12
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_Homeless%'

		update app.DataMigrationTasks
		set TaskSequence = 13
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_HsGradEnroll%'

		update app.DataMigrationTasks
		set TaskSequence = 14
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_Immigrant%'

		update app.DataMigrationTasks
		set TaskSequence = 15
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_Membership%'

		update app.DataMigrationTasks
		set TaskSequence = 16
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_Mep%'

		update app.DataMigrationTasks
		set TaskSequence = 17
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_NorD%'

		update app.DataMigrationTasks
		set TaskSequence = 18
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_Other%'

		update app.DataMigrationTasks
		set TaskSequence = 19
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_SPPAPR%'

		update app.DataMigrationTasks
		set TaskSequence = 20
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_StudentCounts%'

		update app.DataMigrationTasks
		set TaskSequence = 21
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_TitleI%'

		update app.DataMigrationTasks
		set TaskSequence = 22
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_TitleIIIELOct%'

		update app.DataMigrationTasks
		set TaskSequence = 23
		where DataMigrationTypeId = 2
		and StoredProcedureName like '%Wrapper_Migrate_TitleIIIELSY%'


		-- Resolve duplicate metadata in App.FileColumns where ColumnName = StaffCategoryId & DisplayName = Staff Category (Special Education)
		DECLARE @MinFileColumnId INT, @MaxFileColumnId INT
		select @MinFileColumnId = MIN(FileColumnId) from app.FileColumns where columnname = 'staffcategoryid' and DisplayName = 'Staff Category (Special Education)'
		select @MaxFileColumnId = MAX(FileColumnId) from app.FileColumns where columnname = 'staffcategoryid' and DisplayName = 'Staff Category (Special Education)'

		UPDATE App.FileSubmission_FileColumns
		SET FileColumnId = @MinFileColumnId
		WHERE FileColumnId = @MaxFileColumnId

		DELETE FROM App.FileColumns WHERE FileColumnId = @MaxFileColumnId
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