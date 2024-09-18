set nocount on;

begin try
	begin transaction

		declare @dim int, @generateReportControlTypeId int, @reportId Int, @levelId int,  @generateReportTypeId int, @factTableId int, @generateReportId int, @categorySetId int , @submissionYears varchar(10), @year varchar(10), @submissionYear varchar(10), @reportCode varchar(100), @cat int
		
	
		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'YEAR' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
		BEGIN
			Alter table rds.FactStudentDisciplineReports add YEAR nvarchar(20)
			Alter table rds.FactStudentDisciplineReportDtos add YEAR nvarchar(20)
		END

		select @generateReportTypeId=GenerateReportTypeId from app.GenerateReportTypes where ReportTypeCode='statereport'
		

		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode='yeartoyearremovalcount')
		BEGIN
			INSERT INTO APP.GenerateReportControlType(ControlTypeName) values('yeartoyearremovalcount')
			set @generateReportControlTypeId=SCOPE_IDENTITY()
			SELECT @factTableId=FactTableId from app.FactTables where FactTableName='FactStudentDisciplines'
			INSERT INTO APP.GenerateReports (ReportCode, ReportName, FactTableId, GenerateReportTypeId,IsActive,ShowData,ShowFilterControl,ShowGraph,ShowSubFilterControl, IsLocked, GenerateReportControlTypeId,ShowCategorySetControl,CategorySetControlCaption,CategorySetControlLabel, FilterControlLabel ) 
								VALUES ('yeartoyearremovalcount', 'Year to Year Student Removal Report',@factTableId,@generateReportTypeId,0,1,1,1,0, 0,@generateReportControlTypeId, 1, 'Subpopulation','Subpopulation','Subcategory')		
			set @generateReportId=SCOPE_IDENTITY()
			INSERT INTO app.GenerateReport_OrganizationLevels (GenerateReportId, OrganizationLevelId) VALUES (@generateReportId,1)
			INSERT INTO app.GenerateReport_OrganizationLevels (GenerateReportId, OrganizationLevelId) VALUES (@generateReportId,2)
			INSERT INTO app.GenerateReport_OrganizationLevels (GenerateReportId, OrganizationLevelId) VALUES (@generateReportId,3)
			INSERT INTO app.GenerateReportFilterOptions (FilterCode, FilterName,FilterSequence,GenerateReportId, IsDefaultOption,IsSubFilter)
			values('select','Select',1,@generateReportId,1,0)
			INSERT INTO app.GenerateReportFilterOptions (FilterCode, FilterName,FilterSequence,GenerateReportId, IsDefaultOption,IsSubFilter)
			values('withgender','Gender',2,@generateReportId,1,0)
			INSERT INTO app.GenerateReportFilterOptions (FilterCode, FilterName,FilterSequence,GenerateReportId, IsDefaultOption,IsSubFilter)
			values('withdisabilitytype','Disability Type',3,@generateReportId,1,0)
			insert into app.GenerateReportFilterOptions (FilterCode, FilterName,FilterSequence,GenerateReportId, IsDefaultOption,IsSubFilter)
			values('withlepstatus','LEP Status',4,@generateReportId,1,0)
			insert into app.GenerateReportFilterOptions (FilterCode, FilterName,FilterSequence,GenerateReportId, IsDefaultOption,IsSubFilter)
			values('withage','Age',5,@generateReportId,1,0)
			insert into app.GenerateReportFilterOptions (FilterCode, FilterName,FilterSequence,GenerateReportId, IsDefaultOption,IsSubFilter)
			values('withraceethnic','Race/Ethnic',6,@generateReportId,1,0)

		END

		IF NOT EXISTS (select 1 from APP.GenerateReports where ReportCode='yeartoyearremovalcount' and IsActive=1)
		BEGIN
			UPDATE APP.GenerateReports SET IsActive=1 Where ReportCode='yeartoyearremovalcount'
		END
		-------------------------------------------------------------------------------------------------------------------------------

delete from app.CategoryOptions
Where CategorySetId in (Select CategorySetId from app.CategorySets
Where GenerateReportId in (select generateReportId from app.GenerateReports where ReportCode in('yeartoyearremovalcount')))

delete from app.CategorySet_Categories
Where CategorySetId in (Select CategorySetId from app.CategorySets
Where GenerateReportId in (select generateReportId from app.GenerateReports where ReportCode in('yeartoyearremovalcount')))

delete from app.CategorySets
Where GenerateReportId in (select generateReportId from app.GenerateReports where ReportCode in('yeartoyearremovalcount'))
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

							IF(@reportCode = 'yeartoyearremovalcount')
							BEGIN

								-----CategorySets ------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('removaltype','Removal Type',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								
									-----CategorySet_Categories ------------------
									INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'REMOVALTYPE' AND CategoryName='Interim Removal (IDEA)' ))
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'YEAR'))								
											
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'REMOVALTYPE' AND CategoryName='Interim Removal (IDEA)') and CategoryOptionCode<>'MISSING'
										
										IF(@submissionYear = '2014-15')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2013','2013-14',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2015-16')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2016-17')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2017-18')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2018-19')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2018','2018-19',@categorySetId,0)										
										END

								-----CategorySets ------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('removaltypewithgender','Removal Type',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								
									-----CategorySet_Categories ------------------
									INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'REMOVALTYPE' AND CategoryName='Interim Removal (IDEA)' ))
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'YEAR'))									
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX'))

										-----Category Options ------------------

										INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'M','Male',@categorySetId,0)
										INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'F','Female',@categorySetId,0)	
											
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'REMOVALTYPE' AND CategoryName='Interim Removal (IDEA)') and CategoryOptionCode<>'MISSING'
	
										IF(@submissionYear = '2014-15')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2013','2013-14',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2015-16')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2016-17')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2017-18')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2018-19')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2018','2018-19',@categorySetId,0)										
										END


								-----CategorySets ------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('removaltypewithdisabilitytype','Removal Type',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								
									-----CategorySet_Categories ------------------
									INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'REMOVALTYPE' AND CategoryName='Interim Removal (IDEA)' ))
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'YEAR'))
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA'))
									
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA') and CategoryOptionCode<>'MISSING'
											
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'REMOVALTYPE' AND CategoryName='Interim Removal (IDEA)') and CategoryOptionCode<>'MISSING'

										
										IF(@submissionYear = '2014-15')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2013','2013-14',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2015-16')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2016-17')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2017-18')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2018-19')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2018','2018-19',@categorySetId,0)										
										END

										-----CategorySets ------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('removaltypewithraceethnic','Removal Type',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								
									-----CategorySet_Categories ------------------
									INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'REMOVALTYPE' AND CategoryName='Interim Removal (IDEA)' ))

									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'YEAR'))

									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC'))
									
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC') and CategoryOptionCode<>'MISSING'
											
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'REMOVALTYPE' AND CategoryName='Interim Removal (IDEA)') and CategoryOptionCode<>'MISSING'

										
										IF(@submissionYear = '2014-15')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2013','2013-14',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2015-16')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2016-17')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2017-18')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2018-19')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2018','2018-19',@categorySetId,0)										
										END

							INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('removaltypewithlepstatus','Removal Type',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								
									-----CategorySet_Categories ------------------
								INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'REMOVALTYPE' AND CategoryName='Interim Removal (IDEA)' ))
								
								INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'YEAR'))
									INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH'))
									
										INSERT INTO app.CategoryOptions(CategoryOptionCode,CategoryId,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryOptionCode, CategoryId,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH') 
																	and (CategoryOptionName='Limited English Proficient (LEP) Student' or CategoryOptionName='Non-limited English proficient (non-LEP) Student')
																	
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'REMOVALTYPE' AND CategoryName='Interim Removal (IDEA)') and CategoryOptionCode<>'MISSING'

										
										IF(@submissionYear = '2014-15')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2013','2013-14',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2015-16')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2016-17')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2017-18')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2018-19')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2018','2018-19',@categorySetId,0)										
										END

										-----CategorySets ------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('removaltypewithage','Removal Type',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								
									-----CategorySet_Categories ------------------
									INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'REMOVALTYPE' AND CategoryName='Interim Removal (IDEA)' ))

									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'YEAR'))
										INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21'))

												-----Category Options ------------------										
										INSERT INTO app.CategoryOptions(CategoryOptionCode,CategoryId,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryOptionCode, CategoryId,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21') 

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'REMOVALTYPE' AND CategoryName='Interim Removal (IDEA)') and CategoryOptionCode<>'MISSING'

										
										IF(@submissionYear = '2014-15')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2013','2013-14',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2015-16')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2016-17')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2017-18')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2018-19')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2018','2018-19',@categorySetId,0)										
										END

								-----CategorySets ------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('disabilitytype','Disability Type',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								
									-----CategorySet_Categories ------------------
									INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA'))
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'YEAR'))

										-----Category Options ------------------
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA') and CategoryOptionCode<>'MISSING'
										IF(@submissionYear = '2014-15')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2013','2013-14',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2015-16')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2016-17')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2017-18')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2018-19')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2018','2018-19',@categorySetId,0)										
										END

										
								-----Category sets ------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('raceethnic','Race/Ethnicity',4,0,@reportId,@levelId,@submissionYear)		
								SET @categorySetId=SCOPE_IDENTITY()
									-----CategorySet_Categories ------------------
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) 
									VALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC'))
									INSERT INTO app.CategorySet_Categories 
									(CategorySetId, CategoryId) VALUES (@categorySetId,  (select CategoryId from app.Categories where CategoryCode = 'YEAR'))

										-----Category Options ------------------
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC')  and CategoryOptionCode<>'MISSING'
										
										IF(@submissionYear = '2014-15')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2013','2013-14',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2015-16')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2016-17')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2017-18')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2018-19')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2018','2018-19',@categorySetId,0)										
										END
								-----Category sets ------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('gender','Gender',3,0,@reportId,@levelId,@submissionYear)

								SET @categorySetId=SCOPE_IDENTITY()
									-----CategorySet_Categories ------------------
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) 
									VALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'SEX'))
									INSERT INTO app.CategorySet_Categories 
									(CategorySetId, CategoryId) VALUES (@categorySetId,  (select CategoryId from app.Categories where CategoryCode = 'YEAR'))	

										-----Category Options ------------------

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'SEX') 
										

											IF(@submissionYear = '2014-15')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2013','2013-14',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2015-16')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2016-17')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2017-18')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2018-19')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2018','2018-19',@categorySetId,0)										
										END 

								-----Category sets ------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('lepstatus','LEP Status',5,0,@reportId,@levelId,@submissionYear)	

								SET @categorySetId=SCOPE_IDENTITY()

									-----CategorySet_Categories ------------------
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) 
									VALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'LEPBOTH'))
									INSERT INTO app.CategorySet_Categories 
									(CategorySetId, CategoryId) VALUES (@categorySetId,  (select CategoryId from app.Categories where CategoryCode = 'YEAR'))

										-----Category Options ------------------

										INSERT INTO app.CategoryOptions(CategoryOptionCode,CategoryId,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryOptionCode, CategoryId,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH') 
																		and (CategoryOptionName='Limited English Proficient (LEP) Student' or CategoryOptionName='Non-limited English proficient (non-LEP) Student')
																	
										
										IF(@submissionYear = '2014-15')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2013','2013-14',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2015-16')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2016-17')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2017-18')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2018-19')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2018','2018-19',@categorySetId,0)										
										END

								-----Category sets ------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('age','Age',6,0,@reportId,@levelId,@submissionYear)	
								SET @categorySetId=SCOPE_IDENTITY()

									-----CategorySet_Categories ------------------
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) 
									VALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGE3TO21'))
									INSERT INTO app.CategorySet_Categories 
									(CategorySetId, CategoryId) VALUES (@categorySetId,  (select CategoryId from app.Categories where CategoryCode = 'YEAR'))

										-----Category Options ------------------										
										INSERT INTO app.CategoryOptions(CategoryOptionCode,CategoryId,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryOptionCode, CategoryId,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21') 
																	
											

										IF(@submissionYear = '2014-15')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2013','2013-14',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2015-16')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2014','2014-15',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2016-17')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2015','2015-16',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2017-18')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2016','2016-17',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)										
										END
										ELSE IF(@submissionYear = '2018-19')
										BEGIN
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2017','2017-18',@categorySetId,0)
											INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'YEAR'),'2018','2018-19',@categorySetId,0)										
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