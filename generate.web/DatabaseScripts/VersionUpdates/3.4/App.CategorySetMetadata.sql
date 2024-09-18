set nocount on;

begin try
	begin transaction

		declare @reportId Int, @levelId int, @categoryId int, @catSetId int, @generateReportId as int 
		declare @submissionYear varchar(10), @reportCode varchar(100), @catSetCode varchar(50)

		select @generateReportId = GenerateReportId from app.GenerateReports where reportcode = 'yeartoyearprogress' 

		if not exists(select 1 from app.CategorySets where GenerateReportId = @generateReportId)
		BEGIN

		DECLARE report_cursor CURSOR FOR 
		select GenerateReportId, ReportCode from app.GenerateReports
		where reportcode = 'yeartoyearprogress' 

		OPEN report_cursor
		FETCH NEXT FROM report_cursor INTO @reportId,@reportCode

		WHILE @@FETCH_STATUS = 0
		BEGIN

			DECLARE year_cursor CURSOR FOR 
			SELECT distinct SubmissionYear FROM rds.DimDates where SubmissionYear IS NOT NULL order by SubmissionYear
					
			OPEN year_cursor
			FETCH NEXT FROM year_cursor INTO @submissionYear

				WHILE @@FETCH_STATUS = 0
				BEGIN

					DECLARE level_cursor CURSOR FOR 
					select OrganizationLevelId from app.GenerateReport_OrganizationLevels
					where GenerateReportId = @reportId
					
					OPEN level_cursor
					FETCH NEXT FROM level_cursor INTO @levelId

						WHILE @@FETCH_STATUS = 0
						BEGIN

							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],
							[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
							VALUES('All','All Students',1,0,@reportId,@levelId,@submissionYear)
							 
							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],
							[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
							VALUES('raceethnicity','Race/Ethnicity',2,0,@reportId,@levelId,@submissionYear)	

							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],
							[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
							VALUES('sex','Sex',3,0,@reportId,@levelId,@submissionYear)

							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],
							[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
							VALUES('ideaindicator','IDEA Indicator',4,0,@reportId,@levelId,@submissionYear)

							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],
							[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
							VALUES('ecodis','Economically Disadvantaged',5,0,@reportId,@levelId,@submissionYear)	

							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],
							[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
							VALUES('title1','Title 1',6,0,@reportId,@levelId,@submissionYear)
										
							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],
							[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
							VALUES('lepstatus','English Learner',7,0,@reportId,@levelId,@submissionYear)				
			

			
						FETCH NEXT FROM level_cursor INTO @levelId
				END

				CLOSE level_cursor
				DEALLOCATE level_cursor

			FETCH NEXT FROM year_cursor INTO @submissionYear
			END

			CLOSE year_cursor
			DEALLOCATE year_cursor

		FETCH NEXT FROM report_cursor INTO @reportId,@reportCode
		END

		CLOSE report_cursor
		DEALLOCATE report_cursor
						
								
		DECLARE catset_cursor CURSOR FOR 
		select CategorySetId,CategorySetCode,r.ReportCode
		from app.CategorySets cs
		inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
		Where r.ReportCode = 'yeartoyearprogress'

		OPEN catset_cursor
		FETCH NEXT FROM catset_cursor INTO @catSetId, @catSetCode, @reportCode

		WHILE @@FETCH_STATUS = 0
		BEGIN

			SET @categoryId = 0

			IF(@catSetCode = 'ideaindicator')
			BEGIN
				SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'DISABSTATIDEA'
			END
			IF(@catSetCode = 'raceethnicity')
			BEGIN
				SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'RACEETHNIC'
			END
			IF(@catSetCode = 'title1')
			BEGIN
				SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'TITLEISCHSTATUS'
			END
			IF(@catSetCode = 'ecodis')
			BEGIN
				SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'ECODIS'
			END
			IF(@catSetCode = 'sex')
			BEGIN
				SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'SEX'
			END
				
			IF(@categoryId > 0)
			BEGIN
					INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
					VALUES(@catSetId, @categoryId)
						
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 
			END

			SET @categoryId = 0
			SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'ASSESSMENTSUBJECT'
			IF(@categoryId > 0)
			BEGIN
					INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
					VALUES(@catSetId, @categoryId)
						
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId and CategoryOptionCode IN ('MATH','RLA') 
			END

			SET @categoryId = 0
			SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'GRADELVLASS'
			IF(@categoryId > 0)
			BEGIN
					INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
					VALUES(@catSetId, @categoryId)
						
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 
			END

			SET @categoryId = 0
			SELECT @categoryId = min(categoryId) from app.Categories Where CategoryCode = 'PROFSTATUS'
			IF(@categoryId > 0)
			BEGIN
					INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
					VALUES(@catSetId, @categoryId)
						
					INSERT INTO [App].[CategoryOptions]([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategorySetId],[EdFactsCategoryCodeId])
					VALUES(@categoryId, 'PROFICIENT', 'Proficient', @catSetId, 0)

					INSERT INTO [App].[CategoryOptions]([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategorySetId],[EdFactsCategoryCodeId])
					VALUES(@categoryId, 'BELOWPROFICIENT', 'Below Proficient', @catSetId, 0)
			END


			IF(@catSetCode = 'lepstatus')
			BEGIN
				SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'LEPBOTH'

				INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
				VALUES(@catSetId, @categoryId)
						
				INSERT INTO [App].[CategoryOptions]([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategorySetId],[EdFactsCategoryCodeId])
				VALUES(@categoryId, 'LEP', 'English learner', @catSetId, 0)

				INSERT INTO [App].[CategoryOptions]([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategorySetId],[EdFactsCategoryCodeId])
				VALUES(@categoryId, 'NLEP', 'Non-English learner', @catSetId, 0)
			END

		FETCH NEXT FROM catset_cursor INTO @catSetId, @catSetCode, @reportCode
		END

		CLOSE catset_cursor
		DEALLOCATE catset_cursor

		END

		IF NOT EXISTS(select 1 from app.GenerateReportFilterOptions where GenerateReportId = @generateReportId)
		BEGIN
			INSERT INTO [App].[GenerateReportFilterOptions]([FilterCode],[FilterName],[FilterSequence],[GenerateReportId],[IsDefaultOption],[IsSubFilter])
			VALUES('MATH','Mathematics',1,@generateReportId,1,0)

			INSERT INTO [App].[GenerateReportFilterOptions]([FilterCode],[FilterName],[FilterSequence],[GenerateReportId],[IsDefaultOption],[IsSubFilter])
			VALUES('RLA','Reading/Language Arts',2,@generateReportId,0,0)
		END

		select @generateReportId = GenerateReportId from app.GenerateReports where reportcode = 'yeartoyearattendance' 

		if not exists(select 1 from app.CategorySets where GenerateReportId = @generateReportId)
		BEGIN

		DECLARE report_cursor CURSOR FOR 
		select GenerateReportId, ReportCode from app.GenerateReports
		where reportcode = 'yeartoyearattendance' 

		OPEN report_cursor
		FETCH NEXT FROM report_cursor INTO @reportId,@reportCode

		WHILE @@FETCH_STATUS = 0
		BEGIN

			DECLARE year_cursor CURSOR FOR 
			SELECT distinct SubmissionYear FROM rds.DimDates where SubmissionYear IS NOT NULL order by SubmissionYear
					
			OPEN year_cursor
			FETCH NEXT FROM year_cursor INTO @submissionYear

				WHILE @@FETCH_STATUS = 0
				BEGIN

					DECLARE level_cursor CURSOR FOR 
					select OrganizationLevelId from app.GenerateReport_OrganizationLevels
					where GenerateReportId = @reportId
					
					OPEN level_cursor
					FETCH NEXT FROM level_cursor INTO @levelId

						WHILE @@FETCH_STATUS = 0
						BEGIN

							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],
							[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
							VALUES('All','All Students',1,0,@reportId,@levelId,@submissionYear)
							 
							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],
							[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
							VALUES('raceethnicity','Race/Ethnicity',2,0,@reportId,@levelId,@submissionYear)	

							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],
							[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
							VALUES('sex','Sex',3,0,@reportId,@levelId,@submissionYear)

							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],
							[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
							VALUES('ideaindicator','IDEA Indicator',4,0,@reportId,@levelId,@submissionYear)

							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],
							[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
							VALUES('ecodis','Economically Disadvantaged',5,0,@reportId,@levelId,@submissionYear)	

							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],
							[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
							VALUES('title1','Title 1',6,0,@reportId,@levelId,@submissionYear)
										
							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],
							[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
							VALUES('lepstatus','English Learner',7,0,@reportId,@levelId,@submissionYear)				
			

			
						FETCH NEXT FROM level_cursor INTO @levelId
				END

				CLOSE level_cursor
				DEALLOCATE level_cursor

			FETCH NEXT FROM year_cursor INTO @submissionYear
			END

			CLOSE year_cursor
			DEALLOCATE year_cursor

		FETCH NEXT FROM report_cursor INTO @reportId,@reportCode
		END

		CLOSE report_cursor
		DEALLOCATE report_cursor
						
								
		DECLARE catset_cursor CURSOR FOR 
		select CategorySetId,CategorySetCode,r.ReportCode
		from app.CategorySets cs
		inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
		Where r.ReportCode = 'yeartoyearattendance'

		OPEN catset_cursor
		FETCH NEXT FROM catset_cursor INTO @catSetId, @catSetCode, @reportCode

		WHILE @@FETCH_STATUS = 0
		BEGIN

			SET @categoryId = 0

			IF(@catSetCode = 'ideaindicator')
			BEGIN
				SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'DISABSTATIDEA'
			END
			IF(@catSetCode = 'raceethnicity')
			BEGIN
				SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'RACEETHNIC'
			END
			IF(@catSetCode = 'title1')
			BEGIN
				SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'TITLEISCHSTATUS'
			END
			IF(@catSetCode = 'ecodis')
			BEGIN
				SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'ECODIS'
			END
			IF(@catSetCode = 'sex')
			BEGIN
				SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'SEX'
			END
				
			IF(@categoryId > 0)
			BEGIN
					INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
					VALUES(@catSetId, @categoryId)
						
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 
			END

			SET @categoryId = 0
			SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'ASSESSMENTSUBJECT'
			IF(@categoryId > 0)
			BEGIN
					INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
					VALUES(@catSetId, @categoryId)
						
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId and CategoryOptionCode IN ('MATH','RLA') 
			END

			SET @categoryId = 0
			SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'GRADELVLASS'
			IF(@categoryId > 0)
			BEGIN
					INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
					VALUES(@catSetId, @categoryId)
						
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 
			END

			SET @categoryId = 0
			SELECT @categoryId = min(categoryId) from app.Categories Where CategoryCode = 'PROFSTATUS'
			IF(@categoryId > 0)
			BEGIN
					INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
					VALUES(@catSetId, @categoryId)
						
					INSERT INTO [App].[CategoryOptions]([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategorySetId],[EdFactsCategoryCodeId])
					VALUES(@categoryId, 'PROFICIENT', 'Proficient', @catSetId, 0)

					INSERT INTO [App].[CategoryOptions]([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategorySetId],[EdFactsCategoryCodeId])
					VALUES(@categoryId, 'BELOWPROFICIENT', 'Below Proficient', @catSetId, 0)
			END


			IF(@catSetCode = 'lepstatus')
			BEGIN
				SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'LEPBOTH'

				INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
				VALUES(@catSetId, @categoryId)
						
				INSERT INTO [App].[CategoryOptions]([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategorySetId],[EdFactsCategoryCodeId])
				VALUES(@categoryId, 'LEP', 'English learner', @catSetId, 0)

				INSERT INTO [App].[CategoryOptions]([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategorySetId],[EdFactsCategoryCodeId])
				VALUES(@categoryId, 'NLEP', 'Non-English learner', @catSetId, 0)
			END

		FETCH NEXT FROM catset_cursor INTO @catSetId, @catSetCode, @reportCode
		END

		CLOSE catset_cursor
		DEALLOCATE catset_cursor

		END
			   


		Update co set co.CategoryOptionName = 'Students without Disabilities'
		from app.CategoryOptions co
		inner join app.Categories c on co.CategoryId = c.CategoryId 
		inner join app.CategorySets cs on co.CategorySetId = cs.CategorySetId
		inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
		where r.ReportCode in ('yeartoyearprogress', 'yeartoyearattendance') and cs.CategorySetCode = 'ideaindicator' and CategoryCode = 'DISABSTATIDEA'
		and co.CategoryOptionCode = 'WODIS'

		Update co set co.CategoryOptionName = 'Students with Disabilities'
		from app.CategoryOptions co
		inner join app.Categories c on co.CategoryId = c.CategoryId 
		inner join app.CategorySets cs on co.CategorySetId = cs.CategorySetId
		inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
		where r.ReportCode in ('yeartoyearprogress', 'yeartoyearattendance') and cs.CategorySetCode = 'ideaindicator' and CategoryCode = 'DISABSTATIDEA'
		and co.CategoryOptionCode = 'WDIS'

		Update co set co.CategoryOptionName = 'Economically Disadvantaged'
		from app.CategoryOptions co
		inner join app.Categories c on co.CategoryId = c.CategoryId 
		inner join app.CategorySets cs on co.CategorySetId = cs.CategorySetId
		inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
		where r.ReportCode in ('yeartoyearprogress', 'yeartoyearattendance') and cs.CategorySetCode = 'ecodis' and CategoryCode = 'ECODIS'
		and co.CategoryOptionCode = 'ECODIS'

		Update co set co.CategoryOptionName = 'Title I, Schoolwide Eligible-Title I Targeted Assistance Program'
		from app.CategoryOptions co
		inner join app.Categories c on co.CategoryId = c.CategoryId 
		inner join app.CategorySets cs on co.CategorySetId = cs.CategorySetId
		inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
		where r.ReportCode in ('yeartoyearprogress', 'yeartoyearattendance') and cs.CategorySetCode = 'title1' 
		and CategoryCode = 'TITLEISCHSTATUS'
		and co.CategoryOptionCode = 'SWELIGTGPROG'

		----------------------------Add new migrant subcategory to research reports------------------------------------------------------------------------------------

		DECLARE report_cursor CURSOR FOR 
		select GenerateReportId, ReportCode from app.GenerateReports
		where reportcode in ('yeartoyearprogress','yeartoyearattendance') 

		OPEN report_cursor
		FETCH NEXT FROM report_cursor INTO @reportId,@reportCode

		WHILE @@FETCH_STATUS = 0
		BEGIN

			DECLARE year_cursor CURSOR FOR 
			SELECT distinct SubmissionYear FROM rds.DimDates where SubmissionYear IS NOT NULL order by SubmissionYear
					
			OPEN year_cursor
			FETCH NEXT FROM year_cursor INTO @submissionYear

				WHILE @@FETCH_STATUS = 0
				BEGIN

					DECLARE level_cursor CURSOR FOR 
					select OrganizationLevelId from app.GenerateReport_OrganizationLevels
					where GenerateReportId = @reportId
					
					OPEN level_cursor
					FETCH NEXT FROM level_cursor INTO @levelId

						WHILE @@FETCH_STATUS = 0
						BEGIN

							IF NOT EXISTS(select 1 from app.CategorySets where CategorySetCode = 'migrant' and GenerateReportId = @reportId 
							and SubmissionYear = @submissionYear and OrganizationLevelId = @levelId)
							BEGIN

								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],
								[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
								VALUES('migrant','Migrant',8,0,@reportId,@levelId,@submissionYear)

								select @catSetId = CategorySetId from app.CategorySets where CategorySetCode = 'migrant' and GenerateReportId = @reportId

								SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'MIGRNTSTATUS'
								IF(@categoryId > 0)
								BEGIN
										INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
										VALUES(@catSetId, @categoryId)

										INSERT INTO [App].[CategoryOptions]([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategorySetId],[EdFactsCategoryCodeId])
										VALUES(@categoryId, 'MS', 'Migrant Students', @catSetId, 0)

										INSERT INTO [App].[CategoryOptions]([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategorySetId],[EdFactsCategoryCodeId])
										VALUES(@categoryId, 'MISSING', 'Missing', @catSetId, 0)
						
								END

								SET @categoryId = 0
								SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'ASSESSMENTSUBJECT'
								IF(@categoryId > 0)
								BEGIN
										INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
										VALUES(@catSetId, @categoryId)
						
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
										from app.CategoryOptions where CategoryId = @categoryId and CategoryOptionCode IN ('MATH','RLA') 
								END

								SET @categoryId = 0
								SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'GRADELVLASS'
								IF(@categoryId > 0)
								BEGIN
										INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
										VALUES(@catSetId, @categoryId)
						
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
										from app.CategoryOptions where CategoryId = @categoryId 
								END

								SET @categoryId = 0
								SELECT @categoryId = min(categoryId) from app.Categories Where CategoryCode = 'PROFSTATUS'
								IF(@categoryId > 0)
								BEGIN
										INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
										VALUES(@catSetId, @categoryId)
						
										INSERT INTO [App].[CategoryOptions]([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategorySetId],[EdFactsCategoryCodeId])
										VALUES(@categoryId, 'PROFICIENT', 'Proficient', @catSetId, 0)

										INSERT INTO [App].[CategoryOptions]([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategorySetId],[EdFactsCategoryCodeId])
										VALUES(@categoryId, 'BELOWPROFICIENT', 'Below Proficient', @catSetId, 0)
								END

							END
							 
			
						FETCH NEXT FROM level_cursor INTO @levelId
				END

				CLOSE level_cursor
				DEALLOCATE level_cursor

			FETCH NEXT FROM year_cursor INTO @submissionYear
			END

			CLOSE year_cursor
			DEALLOCATE year_cursor

		FETCH NEXT FROM report_cursor INTO @reportId,@reportCode
		END

		CLOSE report_cursor
		DEALLOCATE report_cursor
						
								
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

	RAISERROR(@msg, @sev, 1) with nowait

end catch

set nocount off;