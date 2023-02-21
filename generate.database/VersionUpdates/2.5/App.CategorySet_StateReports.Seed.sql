set nocount off;

begin try
	begin transaction

		declare @reportId Int, @levelId int, @categoryId int, @catSetId int 
		declare @submissionYear varchar(10), @reportCode varchar(100), @catSetCode varchar(50)
delete from app.CategoryOptions
Where CategorySetId in (Select CategorySetId from app.CategorySets
Where GenerateReportId in (Select GenerateReportId from app.GenerateReports
where GenerateReportTypeId in (Select GenerateReportTypeId from app.GenerateReportTypes Where ReportTypeCode = 'statereport')))

delete from app.CategorySet_Categories
Where CategorySetId in (Select CategorySetId from app.CategorySets
Where GenerateReportId in (Select GenerateReportId from app.GenerateReports
where GenerateReportTypeId in (Select GenerateReportTypeId from app.GenerateReportTypes Where ReportTypeCode = 'statereport')))

delete from app.CategorySets
Where GenerateReportId in (Select GenerateReportId from app.GenerateReports
where GenerateReportTypeId in (Select GenerateReportTypeId from app.GenerateReportTypes Where ReportTypeCode = 'statereport'))

			--------------------------------------------------Category Sets------------------------------------------------------------------------

			DECLARE report_cursor CURSOR FOR 
			select GenerateReportId, ReportCode from app.GenerateReports
			where GenerateReportTypeId in (Select GenerateReportTypeId from app.GenerateReportTypes Where ReportTypeCode = 'statereport')

			OPEN report_cursor
			FETCH NEXT FROM report_cursor INTO @reportId,@reportCode

			WHILE @@FETCH_STATUS = 0
			BEGIN

				DECLARE year_cursor CURSOR FOR 
				SELECT distinct SubmissionYear FROM app.CategorySets order by SubmissionYear
					
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

							IF(@reportCode = 'exitspecialeducation')
							BEGIN
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear],[IncludeOnFilter])
								VALUES('disabilitystatus','Disability Status',1,0,@reportId,@levelId,@submissionYear,'AllStudents')

								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear],[IncludeOnFilter])
								VALUES('disabilitytype','Disability Type',2,0,@reportId,@levelId,@submissionYear,'SWD')

								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('gender','Gender',3,0,@reportId,@levelId,@submissionYear)

								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('raceethnicity','Race/Ethnicity',4,0,@reportId,@levelId,@submissionYear)			
			
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('lepstatus','EL Status',5,0,@reportId,@levelId,@submissionYear)				
			
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('cteparticipation','CTE Participation',6,0,@reportId,@levelId,@submissionYear)	
			
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('title1','Title 1',7,0,@reportId,@levelId,@submissionYear)	
			
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('ecodis','Economically Disadvantaged',8,0,@reportId,@levelId,@submissionYear)	
			
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('migrant','Migrant',9,0,@reportId,@levelId,@submissionYear)		
			
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('homeless','Homeless',10,0,@reportId,@levelId,@submissionYear)																					

						END
						IF(@reportCode = 'studentfederalprogramsparticipation' or @reportCode = 'studentmultifedprogsparticipation')
						BEGIN
							  INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
							  VALUES('CatSetA','Category Set A',1,0,@reportId,@levelId,@submissionYear)

						END
						IF(@reportCode = 'disciplinaryremovals')
						BEGIN
							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
							VALUES('disabilitytype','Disability Type',1,0,@reportId,@levelId,@submissionYear)

							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
							VALUES('gender','Gender',2,0,@reportId,@levelId,@submissionYear)

							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
							VALUES('raceethnicity','Race/Ethnicity',3,0,@reportId,@levelId,@submissionYear)			
			
							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
							VALUES('cteparticipation','CTE Participation',4,0,@reportId,@levelId,@submissionYear)	
			
							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
							VALUES('exitingspeceducation','Exiting Special Education',5,0,@reportId,@levelId,@submissionYear)

						END

						IF(@reportCode = 'stateassessmentsperformance')
						BEGIN
							 INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
							 VALUES('All','All Students',1,0,@reportId,@levelId,@submissionYear)

							 INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
							 VALUES('WDIS','Students With Disabilities',2,0,@reportId,@levelId,@submissionYear)

							 INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
							 VALUES('WODIS','Students Without Disabilities',3,0,@reportId,@levelId,@submissionYear)

						END

						IF(@reportCode = 'edenvironmentdisabilitiesage3-5')
						BEGIN
					
							 INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
							 VALUES('raceethnicity','Race/Ethnicity',1,0,@reportId,@levelId,@submissionYear)		
					
							 INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
							 VALUES('sex','Sex',2,0,@reportId,@levelId,@submissionYear)	

							 INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
							 VALUES('disabilitytype','Disability Type',3,0,@reportId,@levelId,@submissionYear)


						END

						IF(@reportCode = 'edenvironmentdisabilitiesage6-21')
						BEGIN
					
							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
							VALUES('raceethnicity','Race/Ethnicity',1,0,@reportId,@levelId,@submissionYear)		
					
							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
							VALUES('sex','Sex',2,0,@reportId,@levelId,@submissionYear)	

							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
							VALUES('disabilitytype','Disability Type',3,0,@reportId,@levelId,@submissionYear)

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

			DECLARE @currentYear as int , @i as int, @cohortYear as int

			SELECT @reportId = GenerateReportId from app.GenerateReports where ReportCode = 'cohortgraduationrate'
			SELECT @currentYear = Convert(int, MAX(Year)) + 1 FROM rds.DimDates

			SET @i = 1
			While @i < 7
			BEGIN 

				SET @cohortYear = @currentYear + @i
	
				DECLARE level_cursor CURSOR FOR 
				select OrganizationLevelId from app.GenerateReport_OrganizationLevels
				where GenerateReportId = @reportId
					
				OPEN level_cursor
				FETCH NEXT FROM level_cursor INTO @levelId

				WHILE @@FETCH_STATUS = 0
				BEGIN

					INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
												,[OrganizationLevelId],[SubmissionYear],[IncludeOnFilter])
					VALUES('disabilitystatus','Disability Status',1,0,@reportId,@levelId,convert(varchar(10),@cohortYear),'AllStudents')

					INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
												,[OrganizationLevelId],[SubmissionYear],[IncludeOnFilter])
					VALUES('disabilitytype','Disability Type',2,0,@reportId,@levelId,convert(varchar(10),@cohortYear),'WDIS')

					INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
												,[OrganizationLevelId],[SubmissionYear])
					VALUES('gender','Gender',3,0,@reportId,@levelId,convert(varchar(10),@cohortYear))

					INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
												,[OrganizationLevelId],[SubmissionYear])
					VALUES('raceethnicity','Race/Ethnicity',4,0,@reportId,@levelId,convert(varchar(10),@cohortYear))			
			
					INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
												,[OrganizationLevelId],[SubmissionYear])
					VALUES('cteparticipation','CTE Participation',5,0,@reportId,@levelId,convert(varchar(10),@cohortYear))	
			
					INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
												,[OrganizationLevelId],[SubmissionYear],[IncludeOnFilter])
					VALUES('exitingspeceducation','Exiting Special Education',6,0,@reportId,@levelId,convert(varchar(10),@cohortYear),'WDIS')	

				FETCH NEXT FROM level_cursor INTO @levelId
				END

				CLOSE level_cursor
				DEALLOCATE level_cursor

				SET @i = @i + 1
			END

									
			DECLARE catset_cursor CURSOR FOR 
			select CategorySetId,CategorySetCode,r.ReportCode
			from app.CategorySets cs
			inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
			Where cs.GenerateReportId in (Select GenerateReportId from app.GenerateReports
			where GenerateReportTypeId in (Select GenerateReportTypeId from app.GenerateReportTypes Where ReportTypeCode = 'statereport'))

			OPEN catset_cursor
			FETCH NEXT FROM catset_cursor INTO @catSetId, @catSetCode, @reportCode

			WHILE @@FETCH_STATUS = 0
			BEGIN

				SET @categoryId = 0

				IF(@catSetCode = 'disabilitystatus')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'DISABSTATIDEA'
				END
				IF(@catSetCode = 'disabilitytype')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'DISABCATIDEA'
				END
				IF(@catSetCode = 'gender')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'SEX'
				END
				IF(@catSetCode = 'raceethnicity')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'RACEETHNIC'
				END
				IF(@catSetCode = 'lepstatus')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'LEPBOTH'
				END
				IF(@catSetCode = 'title1')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'TITLEISCHSTATUS'
				END
				IF(@catSetCode = 'ecodis')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'ECODIS'
				END
				IF(@catSetCode = 'migrant')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'MIGRNTSTATUS'
				END
				IF(@catSetCode = 'homeless')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'HOMELSENRLSTAT'
				END
				IF(@catSetCode = 'sex')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'SEX'
				END
				IF(@catSetCode = 'gradelevel')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'GRADELVL'
				END
				IF(@catSetCode = 'age3-5')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'AGEEC'
				END
				IF(@catSetCode = 'age6-21')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'AGESA'
				END
				IF(@catSetCode = 'agegroup')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'AGEGROUP'
				END
				IF(@catSetCode = 'cteparticipation')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'CTEPROGPARTICIPATION'
				END
				IF(@catSetCode = 'exitingspeceducation')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'BASISEXIT'
				END
				IF(@catSetCode = 'lepstatus')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'LEPBOTH'
				END

				IF(@categoryId > 0 AND @reportCode not in ('studentfederalprogramsparticipation','studentmultifedprogsparticipation'))
				BEGIN
					IF(@catSetCode = 'cteparticipation')
					BEGIN
						INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
						VALUES(@categoryId,'CTEPART','CTE Participant',@catSetId,0)
			
						INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
						VALUES(@categoryId,'NONCTEPART','Non CTE Participant',@catSetId,0)
			
					END
					ELSE IF(@catSetCode = 'lepstatus')
					BEGIN
						INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
						VALUES(@categoryId,'LEP','English Learner Status',@catSetId,0)
			
						INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
						VALUES(@categoryId,'NLEP','Non-English learner',@catSetId,0)
			
					END
					ELSE
					BEGIN
						INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
						SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
						from app.CategoryOptions where CategoryId = @categoryId 
					END
				END

				
				IF(@reportCode = 'studentfederalprogramsparticipation' or @reportCode = 'studentmultifedprogsparticipation')
				BEGIN
					print @reportcode
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'TITLEISCHSTATUS'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 
					
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'MISSING','Missing',@catSetId,0)
	

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'MIGRNTSTATUS'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId
					
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'LEPBOTH'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'LEP','English Learner Status',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'MISSING','Missing',@catSetId,0)

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'SEC504STATUS'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'SECTION504','SECTION 504',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'MISSING','Missing',@catSetId,0)

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'HOMELSSTATUS'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'HOMELSENRL','Homeless',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'MISSING','Missing',@catSetId,0)

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'CTEPROGPARTICIPATION'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)

					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'CTEPART','CTE Participant',@catSetId,0)

					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'MISSING','Missing',@catSetId,0)

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'IMGNTTITLIIIPROG'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'IMMIGNTTTLIII','Immigrant Title III',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'MISSING','Missing',@catSetId,0)

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'FREELUNCH'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'FREE','Free and Reduced Lunch',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'MISSING','Missing',@catSetId,0)

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'FOSTERCARE'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'FOSTERCARE','Foster Care',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'MISSING','Missing',@catSetId,0)

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'DISABSTATIDEA'
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 
					
				END
				ELSE IF(@categoryId > 0)
				BEGIN
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)
				END

				IF(@reportCode = 'exitspecialeducation')
				BEGIN
					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'BASISEXIT'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)

					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'MISSING','Missing',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'D','Died',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'DROPOUT','Dropped out',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'GHS','Graduated with regular high school diploma',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'MKC','Moved, known to be continuing',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'RC','Received a certificate',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'RMA','Reached maximum age',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'TRAN','Transferred to regular education',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'PartCNoLongerEligible','No longer eligible for Part C prior to reaching age three.',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'PartBEligibleExitingPartC','Part B eligible, exiting Part C.',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'PartBEligibleContinuingPartC','Part B eligible, continuing in Part C.',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'NotPartBElgibleExitingPartCWithReferrrals','Not eligible for Part B, exit with referrals to other programs.',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'NotPartBElgibleExitingPartCWithoutReferrrals','Not eligible for Part B, exit with no referrals.',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'PartBEligibilityNotDeterminedExitingPartC','Part B eligibility not determined.',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'WithdrawalByParent','Withdrawal by parent (or guardian).',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'MovedOutOfState','Moved out of State',@catSetId,0)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					VALUES(@categoryId,'Unreachable','Attempts to contact the parent and or child were unsuccessful.',@catSetId,0)

				END

				IF(@reportCode = 'disciplinaryremovals')
				BEGIN

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'REMOVALTYPE'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)

					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'REMOVEREASON'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)

					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'DSCPLMETHOD'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)

					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'REMOVALLENIDEA'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)

					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 
				END

				IF(@reportCode = 'stateassessmentsperformance')
				BEGIN

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'ASMTADMNSTRD'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)

					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'GRADELVLASS'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)

					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'PERFLVL'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)

					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'ASSESSMENTSUBJECT'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)

					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 
					and CategoryOptionCode in ('MATH','RLA')

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'PARTSTATUS'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)

					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					Values(@categoryId,'PART','Participated',@catSetId,8402)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					Values(@categoryId,'NPART','Did Not Participate',@catSetId,8403)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					Values(@categoryId,'MISSING','Missing',@catSetId,-1)


					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'RACEETHNIC'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)

					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'ECODIS'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)

					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 

					IF(@catSetCode = 'All')
					BEGIN
						SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'DISABSTATIDEA'		
						INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)

						INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
						SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
						from app.CategoryOptions where CategoryId = @categoryId 
					END

					IF(@catSetCode = 'WDIS')
					BEGIN
						SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'DISABCATIDEA'		
						INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)

						INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
						SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
						from app.CategoryOptions where CategoryId = @categoryId 
					END

					IF(@catSetCode = 'WODIS')
					BEGIN

						SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'SEX'		
						INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)

						INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
						SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
						from app.CategoryOptions where CategoryId = @categoryId 
					END
				END

				IF(@reportCode = 'edenvironmentdisabilitiesage3-5')
				BEGIN
					print @reportcode

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'EDENVIDEAEC'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 
				END

				IF(@reportCode = 'edenvironmentdisabilitiesage6-21')
				BEGIN
					print @reportcode

					SELECT @categoryId = categoryId from app.Categories Where CategoryCode = 'EDENVIRIDEASA'		
					INSERT INTO app.CategorySet_Categories(CategorySetId,CategoryId) VALUES(@catSetId,@categoryId)
					INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
					SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@catSetId,0
					from app.CategoryOptions where CategoryId = @categoryId 
				END

			FETCH NEXT FROM catset_cursor INTO @catSetId, @catSetCode, @reportCode
			END

			CLOSE catset_cursor
			DEALLOCATE catset_cursor

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

set nocount on;