set nocount on;

begin try
	begin transaction

		declare @dim int, @generateReportControlTypeId int, @reportId Int, @levelId int,  @generateReportTypeId int, @factTableId int, @generateReportId int, @categorySetId int , @submissionYears varchar(10), @year varchar(10), @submissionYear varchar(10), @reportCode varchar(100), @cat int
		
	
		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'YEAR' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
		BEGIN
			Alter table rds.FactStudentDisciplineReports add YEAR nvarchar(20)
			Alter table rds.FactStudentDisciplineReportDtos add YEAR nvarchar(20)
		END

		select @generateReportTypeId=GenerateReportTypeId from app.GenerateReportTypes where ReportTypeCode='statereport'
		

		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode='studentssummary')
		BEGIN
			INSERT INTO APP.GenerateReportControlType(ControlTypeName) values('studentssummary')
			set @generateReportControlTypeId=SCOPE_IDENTITY()
			SELECT @factTableId=FactTableId from app.FactTables where FactTableName='FactStudentCounts'
			INSERT INTO APP.GenerateReports (ReportCode, ReportName, FactTableId, GenerateReportTypeId,IsActive,ShowData,ShowFilterControl,ShowGraph,ShowSubFilterControl, IsLocked, GenerateReportControlTypeId,ShowCategorySetControl,CategorySetControlCaption,CategorySetControlLabel, FilterControlLabel ) 
								VALUES ('studentssummary', 'LEA Students Summary Profile',@factTableId,@generateReportTypeId,0,1,1,1,0, 0,@generateReportControlTypeId, 1, 'Subpopulation','Subpopulation','Subcategory')		
			set @generateReportId=SCOPE_IDENTITY()
			INSERT INTO app.GenerateReport_OrganizationLevels (GenerateReportId, OrganizationLevelId) VALUES (@generateReportId,2)
			INSERT INTO app.GenerateReportFilterOptions (FilterCode, FilterName,FilterSequence,GenerateReportId, IsDefaultOption,IsSubFilter)
			values('select','Select',1,@generateReportId,1,0)
			INSERT INTO app.GenerateReportFilterOptions (FilterCode, FilterName,FilterSequence,GenerateReportId, IsDefaultOption,IsSubFilter)
			values('withdisability','Disability',2,@generateReportId,1,0)
			INSERT INTO app.GenerateReportFilterOptions (FilterCode, FilterName,FilterSequence,GenerateReportId, IsDefaultOption,IsSubFilter)
			values('withage','Age',3,@generateReportId,1,0)
			insert into app.GenerateReportFilterOptions (FilterCode, FilterName,FilterSequence,GenerateReportId, IsDefaultOption,IsSubFilter)
			values('withraceethnic','Race/Ethnic',4,@generateReportId,1,0)
			insert into app.GenerateReportFilterOptions (FilterCode, FilterName,FilterSequence,GenerateReportId, IsDefaultOption,IsSubFilter)
			values('withgender','Gender',5,@generateReportId,1,0)
			insert into app.GenerateReportFilterOptions (FilterCode, FilterName,FilterSequence,GenerateReportId, IsDefaultOption,IsSubFilter)
			values('withlepstatus','LEP Status',6,@generateReportId,1,0)
			insert into app.GenerateReportFilterOptions (FilterCode, FilterName,FilterSequence,GenerateReportId, IsDefaultOption,IsSubFilter)
			values('withearlychildhood','Educational Environment 3-5',7,@generateReportId,1,0)
			insert into app.GenerateReportFilterOptions (FilterCode, FilterName,FilterSequence,GenerateReportId, IsDefaultOption,IsSubFilter)
			values('withschoolage','Educational Environment 6-21',8,@generateReportId,1,0)

		END

		IF NOT EXISTS (select 1 from APP.GenerateReports where ReportCode='studentssummary' and IsActive=1)
		BEGIN
			UPDATE APP.GenerateReports SET IsActive=1 Where ReportCode='studentssummary'
		END

delete from app.CategoryOptions
Where CategorySetId in (Select CategorySetId from app.CategorySets
Where GenerateReportId in (select generateReportId from app.GenerateReports where ReportCode in('studentssummary')))

delete from app.CategorySet_Categories
Where CategorySetId in (Select CategorySetId from app.CategorySets
Where GenerateReportId in (select generateReportId from app.GenerateReports where ReportCode in('studentssummary')))

delete from app.CategorySets
Where GenerateReportId in (select generateReportId from app.GenerateReports where ReportCode in('studentssummary'))

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

							IF(@reportCode = 'studentssummary')
							BEGIN
--=======================================================================================DISABILITY METADATA==========================================================-----------------------
						-----CategorySets Disability select------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('disability','Disability',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								

									INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA'))
										
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA') and CategoryOptionCode<>'MISSING'

						--------------------------disability with raceethnic----------------------------------------------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('disabilitywithraceethnic','Disability',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								

									INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA'))
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC'))

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA') and CategoryOptionCode<>'MISSING'
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC') and CategoryOptionCode<>'MISSING'

						--------------------------disability with GENDER----------------------------------------------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('disabilitywithgender','Disability',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		
									INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA'))
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA') and CategoryOptionCode<>'MISSING'
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'M','Male',@categorySetId,0)
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'F','Female',@categorySetId,0)	
								
						--------------------------disability with LEP Status----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('disabilitywithlepstatus','Disability',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		
									
									INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA'))
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA') and CategoryOptionCode<>'MISSING'
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH') 
										and (CategoryOptionName='English learner' or CategoryOptionName='Non-English learner') and CategoryOptionCode<>'MISSING'

					--------------------------disability with AGE----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('disabilitywithage','Disability',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()	
								
									INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA'))
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA') and CategoryOptionCode<>'MISSING'
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21') and CategoryOptionCode<>'MISSING'

					--------------------------disability with raceethnic----------------------------------------------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('disabilitywithearlychildhood','Disability',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								

									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGEEC'))

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGEEC') AND CategoryOptionCode <>'MISSING'	
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA') and CategoryOptionCode<>'MISSING'
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC') and CategoryOptionCode<>'MISSING'
													and (CategoryOptionName not in('Services in Other Location than Regular Early Childhood Program (attend at least 10 hours)' , 'Services in Other Location than Regular Early Childhood Program (attend less than 10 hours)'))
					
									update app.CategoryOptions set CategoryOptionName='Home'
												where CategorySetId=@categorySetId and CategoryOptionName='Homeless'	
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in some other location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in some other location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend less than 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend less than 10 hours)'


					--------------------------disability with raceethnic----------------------------------------------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('disabilitywithschoolage','Disability',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								

									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGESA'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGESA') AND CategoryOptionCode <>'MISSING'									
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA') and CategoryOptionCode<>'MISSING'
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA') and CategoryOptionCode<>'MISSING'
									update app.CategoryOptions set CategoryOptionName='Correctional Facility'
												where CategorySetId=@categorySetId and CategoryOptionName='Correctional Facilities'	
--=======================================================================================AGE METADATA==========================================================-----------------------
						-----CategorySets AGE select------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('age','Age',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								

									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21'))
										
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21') and CategoryOptionCode<>'MISSING'

						--------------------------AGE with RACEETHNIC----------------------------------------------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('agewithraceethnic','Age',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								

									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC'))

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21') and CategoryOptionCode<>'MISSING'
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												From app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC') and CategoryOptionCode<>'MISSING'

						--------------------------AGE with GENDER----------------------------------------------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('agewithgender','Disability',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		

									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21') and CategoryOptionCode<>'MISSING'
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'M','Male',@categorySetId,0)
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'F','Female',@categorySetId,0)	
								
					  --------------------------AGE with LEPBOTH----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('agewithlepstatus','Age',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()	
								
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21') and CategoryOptionCode<>'MISSING'
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH') 
												and (CategoryOptionName='English learner' or CategoryOptionName='Non-English learner') and CategoryOptionCode<>'MISSING'

					 --------------------------AGE with DISABILITY----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('agewithdisability','Age',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()
								
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA') and CategoryOptionCode<>'MISSING'
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21') and CategoryOptionCode<>'MISSING'

					 --------------------------AGE with Early Childhood----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('agewithearlychildhood','Age',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		
									
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'AGEEC'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGEEC') and CategoryOptionCode<>'MISSING'
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC') and CategoryOptionCode<>'MISSING'
													and (CategoryOptionName not in('Services in Other Location than Regular Early Childhood Program (attend at least 10 hours)' , 'Services in Other Location than Regular Early Childhood Program (attend less than 10 hours)'))
					
									update app.CategoryOptions set CategoryOptionName='Home'
												where CategorySetId=@categorySetId and CategoryOptionName='Homeless'		
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in some other location.'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in some other location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend less than 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend less than 10 hours)'
					
					--------------------------AGE with School Age----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('agewithschoolage','Age',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()	
								
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'AGESA'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGESA') and CategoryOptionCode<>'MISSING'
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA') and CategoryOptionCode<>'MISSING'
									update app.CategoryOptions set CategoryOptionName='Correctional Facility'
												where CategorySetId=@categorySetId and CategoryOptionName='Correctional Facilities'	
--=======================================================================================RACEETHNIC METADATA==========================================================-----------------------
							-----CategorySets RACEETHNIC select------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('raceethnic','Race/Ethnic',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								

									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC'))
										
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC') and CategoryOptionCode<>'MISSING'

						--------------------------RACEETHNIC with AGE----------------------------------------------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('raceethnicwithage','Race/Ethnic',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								

									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC'))

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21') and CategoryOptionCode<>'MISSING'
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC') and CategoryOptionCode<>'MISSING'

						--------------------------RACEETHNIC with SEX----------------------------------------------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('raceethnicwithgender','Race/Ethnic',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()	
								
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC') and CategoryOptionCode<>'MISSING'
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'M','Male',@categorySetId,0)
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'F','Female',@categorySetId,0)	
								
						--------------------------RACEETHNIC with LEPBOTH----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('raceethnicwithlepstatus','Race/Ethnic',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		
									
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												From app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC') and CategoryOptionCode<>'MISSING'
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH') 
												and (CategoryOptionName='English learner' or CategoryOptionName='Non-English learner') and CategoryOptionCode<>'MISSING'

						--------------------------RACEETHNIC with DISABILITY----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('raceethnicwithdisability','Race/Ethnic',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()
									
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA') and CategoryOptionCode<>'MISSING'
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC') and CategoryOptionCode<>'MISSING'

						--------------------------RACEETHNIC with EARLY CHILDHOOD----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('raceethnicwithearlychildhood','Race/Ethnic',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		
								
								INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC'))
								INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC'))
								INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGEEC'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGEEC') AND CategoryOptionCode <>'MISSING'	
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC') and CategoryOptionCode<>'MISSING'
													and (CategoryOptionName not in('Services in Other Location than Regular Early Childhood Program (attend at least 10 hours)' , 'Services in Other Location than Regular Early Childhood Program (attend less than 10 hours)'))
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												From app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC') and CategoryOptionCode<>'MISSING'

									update app.CategoryOptions set CategoryOptionName='Home'
												where CategorySetId=@categorySetId and CategoryOptionName='Homeless'									
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in some other location.'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in some other location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend less than 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend less than 10 hours)'
					   --------------------------RACEETHNIC with SCHOOL AGE----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('raceethnicwithschoolage','Race/Ethnic',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()	
								
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGESA'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGESA') AND CategoryOptionCode <>'MISSING'	
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA') and CategoryOptionCode<>'MISSING'
									update app.CategoryOptions set CategoryOptionName='Correctional Facility'
												where CategorySetId=@categorySetId and CategoryOptionName='Correctional Facilities'	

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC') and CategoryOptionCode<>'MISSING'

--=======================================================================================GENDER METADATA==========================================================-----------------------
							-----CategorySets GENDER select------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('gender','Gender',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								

									INSERT INTO app.CategorySet_Categories	(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX'))
										
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'M','Male',@categorySetId,0)
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'F','Female',@categorySetId,0)	
						--------------------------GENDER with AGE----------------------------------------------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('genderwithage','Gender',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								

									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX'))

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
												from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21') and CategoryOptionCode<>'MISSING'
										INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'M','Male',@categorySetId,0)
										INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'F','Female',@categorySetId,0)	
								
								--------------------------GENDER with RACEETHNIC----------------------------------------------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('genderwithraceethnic','Race/Ethnic',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()	
								
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC') and CategoryOptionCode<>'MISSING'
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)	VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'M','Male',@categorySetId,0)
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)	VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'F','Female',@categorySetId,0)	
								
						--------------------------GENDER with LEPBOTH----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('genderwithlepstatus','Gender',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		
								
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH'))

									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'M','Male',@categorySetId,0)
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'F','Female',@categorySetId,0)	
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH') 
											and (CategoryOptionName='English learner' or CategoryOptionName='Non-English learner') and CategoryOptionCode<>'MISSING'

						--------------------------GENDER with DISABILITY----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('genderwithdisability','Gender',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		
								
									INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA'))
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA') and CategoryOptionCode<>'MISSING'
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'M','Male',@categorySetId,0)
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
											VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'F','Female',@categorySetId,0)
						
						--------------------------GENDER with EARLY CHILDHOOD----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('genderwithearlychildhood','Gender',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()			
								
								INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC'))
								INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX'))
								INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGEEC'))

								INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGEEC') AND CategoryOptionCode <>'MISSING'	
								INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC') and CategoryOptionCode<>'MISSING'
												and (CategoryOptionName not in('Services in Other Location than Regular Early Childhood Program (attend at least 10 hours)' , 'Services in Other Location than Regular Early Childhood Program (attend less than 10 hours)'))
									
									update app.CategoryOptions set CategoryOptionName='Home'
												where CategorySetId=@categorySetId and CategoryOptionName='Homeless'	
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in some other location.'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in some other location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend less than 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend less than 10 hours)'
								INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'M','Male',@categorySetId,0)
								INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'F','Female',@categorySetId,0)

						--------------------------GENDER with SCHOOL AGE----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('genderwithschoolage','Gender',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		
									
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGESA'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGESA') AND CategoryOptionCode <>'MISSING'	
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA') and CategoryOptionCode<>'MISSING'
									update app.CategoryOptions set CategoryOptionName='Correctional Facility'
												where CategorySetId=@categorySetId and CategoryOptionName='Correctional Facilities'	
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'M','Male',@categorySetId,0)
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'F','Female',@categorySetId,0)
--=======================================================================================LEP Status METADATA==========================================================-----------------------
							-----CategorySets LEPBOTH select------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('lepstatus','LEP Status',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								

									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH'))
										
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH')
											and (CategoryOptionName='English learner' or CategoryOptionName='Non-English learner') and CategoryOptionCode<>'MISSING'

						--------------------------LEPSTATUS with AGE----------------------------------------------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('lepstatuswithage','LEP Status',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								

									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21') and CategoryOptionCode<>'MISSING'
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH') 
											and (CategoryOptionName='English learner' or CategoryOptionName='Non-English learner') and CategoryOptionCode<>'MISSING'

								--------------------------LEPBOTH with GENDER----------------------------------------------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('lepstatuswithgender','LEP Status',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()	
								
									INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH'))
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
										SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
										from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH')
										and (CategoryOptionName='English learner' or CategoryOptionName='Non-English learner') and CategoryOptionCode<>'MISSING'
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'M','Male',@categorySetId,0)
									INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'F','Female',@categorySetId,0)	
								
						--------------------------LEPBOTH with DISABILITY----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('lepstatuswithdisability','Gender',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		
									
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA') and CategoryOptionCode<>'MISSING'
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH') and CategoryOptionCode<>'MISSING'
											and (CategoryOptionName='English learner' or CategoryOptionName='Non-English learner') and CategoryOptionCode<>'MISSING'
							--------------------------LEPBOTH  with RACEETHNIC----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('lepstatuswithraceethnic','Race/Ethnic',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		
								
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC') and CategoryOptionCode<>'MISSING'
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH')
											and (CategoryOptionName='English learner' or CategoryOptionName='Non-English learner') and CategoryOptionCode<>'MISSING'

						--------------------------LEPBOTH  with EARLY CHILDHOOD----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('lepstatuswithearlychildhood','Race/Ethnic',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		
									
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGEEC'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGEEC') AND CategoryOptionCode <>'MISSING'	
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC') and CategoryOptionCode<>'MISSING'
												and (CategoryOptionName not in('Services in Other Location than Regular Early Childhood Program (attend at least 10 hours)' , 'Services in Other Location than Regular Early Childhood Program (attend less than 10 hours)'))														
									
									update app.CategoryOptions set CategoryOptionName='Home'
												where CategorySetId=@categorySetId and CategoryOptionName='Homeless'	
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in some other location.'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in that locatio'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in some other location.'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend less than 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend less than 10 hours)'

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH') 
											and (CategoryOptionName='English learner' or CategoryOptionName='Non-English learner') and CategoryOptionCode<>'MISSING'

						--------------------------LEPBOTH  with SCHOOL AGE----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('lepstatuswithschoolage','Race/Ethnic',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		
									
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGESA'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGESA') AND CategoryOptionCode <>'MISSING'	
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA') and CategoryOptionCode<>'MISSING'
									update app.CategoryOptions set CategoryOptionName='Correctional Facility'
												where CategorySetId=@categorySetId and CategoryOptionName='Correctional Facilities'	
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH') 
											and (CategoryOptionName='English learner' or CategoryOptionName='Non-English learner') and CategoryOptionCode<>'MISSING'

--=======================================================================================EARLY CHILDHOOD METADATA==========================================================-----------------------
							-----CategorySets EARLY CHILDHOOD select------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear]) VALUES('earlychildhood','Educational Environment 3-5',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								

									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) vALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGEEC'))

									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGEEC') AND CategoryOptionCode <>'MISSING'	
									INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
											SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
											from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC') and CategoryOptionCode<>'MISSING'
												and (CategoryOptionName not in('Services in Other Location than Regular Early Childhood Program (attend at least 10 hours)' , 'Services in Other Location than Regular Early Childhood Program (attend less than 10 hours)'))
										
									update app.CategoryOptions set CategoryOptionName='Home'
												where CategorySetId=@categorySetId and CategoryOptionName='Homeless'	
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in some other location.'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in some other location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend less than 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend less than 10 hours)'
						--------------------------EARLY CHILDHOOD with AGE----------------------------------------------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('earlychildhoodwithage','Educational Environment 3-5',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								

									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'AGEEC'))
								
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGEEC') and CategoryOptionCode<>'MISSING'
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC') and CategoryOptionCode<>'MISSING'
														and (CategoryOptionName not in('Services in Other Location than Regular Early Childhood Program (attend at least 10 hours)' , 'Services in Other Location than Regular Early Childhood Program (attend less than 10 hours)'))
									
									update app.CategoryOptions set CategoryOptionName='Home'
												where CategorySetId=@categorySetId and CategoryOptionName='Homeless'	
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in some other location.'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in some other location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend less than 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend less than 10 hours)'
						--------------------------EARLY CHILDHOOD with GENDER----------------------------------------------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('earlychildhoodwithgender','Educational Environment 3-5',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		

									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) vALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGEEC'))

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGEEC') AND CategoryOptionCode <>'MISSING'	
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC') and CategoryOptionCode<>'MISSING'
														and (CategoryOptionName not in('Services in Other Location than Regular Early Childhood Program (attend at least 10 hours)' , 'Services in Other Location than Regular Early Childhood Program (attend less than 10 hours)'))
										
									update app.CategoryOptions set CategoryOptionName='Home'
												where CategorySetId=@categorySetId and CategoryOptionName='Homeless'	
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in some other location.'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in some other location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend less than 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend less than 10 hours)'
										INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'M','Male',@categorySetId,0)
										INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'F','Female',@categorySetId,0)	
								
						--------------------------EARLY CHILDHOOD with DISABILITY----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('earlychildhoodwithdisability','Educational Environment 3-5',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		
									
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) vALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGEEC'))

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGEEC') AND CategoryOptionCode <>'MISSING'	
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA') and CategoryOptionCode<>'MISSING'
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC') and CategoryOptionCode<>'MISSING'
														and (CategoryOptionName not in('Services in Other Location than Regular Early Childhood Program (attend at least 10 hours)' , 'Services in Other Location than Regular Early Childhood Program (attend less than 10 hours)'))
									
									update app.CategoryOptions set CategoryOptionName='Home'
												where CategorySetId=@categorySetId and CategoryOptionName='Homeless'	
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in some other location.'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in some other location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend less than 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend less than 10 hours)'--------------------------EARLY CHILDHOOD  with RACEETHNIC----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('earlychildhoodwithraceethnic','Educational Environment 3-5',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()			
								
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) vALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGEEC'))

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGEEC') AND CategoryOptionCode <>'MISSING'	
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC') and CategoryOptionCode<>'MISSING'
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC') and CategoryOptionCode<>'MISSING'
														and (CategoryOptionName not in('Services in Other Location than Regular Early Childhood Program (attend at least 10 hours)' , 'Services in Other Location than Regular Early Childhood Program (attend less than 10 hours)'))
									
									update app.CategoryOptions set CategoryOptionName='Home'
												where CategorySetId=@categorySetId and CategoryOptionName='Homeless'	
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in some other location.'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in some other location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend less than 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend less than 10 hours)'
								--------------------------EARLY CHILDHOOD  with LEP STATUS----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('earlychildhoodwithlepstatus','Educational Environment 3-5',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()			
								
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) vALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGEEC'))

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGEEC') AND CategoryOptionCode <>'MISSING'	
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH') 
													and (CategoryOptionName='English learner' or CategoryOptionName='Non-English learner') and CategoryOptionCode<>'MISSING'
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
												SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIDEAEC') and CategoryOptionCode<>'MISSING'
														and (CategoryOptionName not in('Services in Other Location than Regular Early Childhood Program (attend at least 10 hours)' , 'Services in Other Location than Regular Early Childhood Program (attend less than 10 hours)'))
					
									update app.CategoryOptions set CategoryOptionName='Home'
												where CategorySetId=@categorySetId and CategoryOptionName='Homeless'	
									update app.CategoryOptions set CategoryOptionName='Home'
												where CategorySetId=@categorySetId and CategoryOptionName='Homeless'								
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in some other location.'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program at least 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend at least 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in some other location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Location Other than Regular Early Childhood Program (attend less than 10 hours)'
									update app.CategoryOptions set CategoryOptionName='Attend regular early childhood program less than 10 hours a week and receive the majority of services in that location'
												where CategorySetId=@categorySetId and CategoryOptionName='Services in Regular Early Childhood Program (attend less than 10 hours)'
--=======================================================================================SCHOOL AGE METADATA==========================================================-----------------------
							-----CategorySets EARLY CHILDHOOD select------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('schoolage','Educational Environment 6-21',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								

									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) vALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGESA'))

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGESA') AND CategoryOptionCode <>'MISSING'	
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA') and CategoryOptionCode<>'MISSING'
										update app.CategoryOptions set CategoryOptionName='Correctional Facility'
												where CategorySetId=@categorySetId and CategoryOptionName='Correctional Facilities'	
						--------------------------SCHOOL AGE with AGE----------------------------------------------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('schoolagewithage','Educational Environment 6-21',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()								

									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21'))

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGE3TO21') and CategoryOptionCode<>'MISSING'
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA') and CategoryOptionCode<>'MISSING'
										update app.CategoryOptions set CategoryOptionName='Correctional Facility'
												where CategorySetId=@categorySetId and CategoryOptionName='Correctional Facilities'	
						--------------------------SCHOOL AGE with GENDER----------------------------------------------------------
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('schoolagewithgender','Educational Environment 6-21',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()	
								
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) vALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGESA'))

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGESA') AND CategoryOptionCode <>'MISSING'	
									
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA') and CategoryOptionCode<>'MISSING'
										update app.CategoryOptions set CategoryOptionName='Correctional Facility'
												where CategorySetId=@categorySetId and CategoryOptionName='Correctional Facilities'	

										INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
													VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'M','Male',@categorySetId,0)
										INSERT INTO APP.CategoryOptions (CategoryId,CategoryOptionCode, CategoryOptionName,CategorySetId,EdFactsCategoryCodeId) 	
													VALUES((select CategoryId from app.Categories where CategoryCode = 'SEX'),'F','Female',@categorySetId,0)	
								
						--------------------------SCHOOL AGE with DISABILITY----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('schoolagewithdisability','Educational Environment 6-21',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()	
								
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA'))
									INSERT INTO app.CategorySet_Categories (CategorySetId, CategoryId) VALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGESA'))

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGESA') AND CategoryOptionCode <>'MISSING'	
									    INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA') and CategoryOptionCode<>'MISSING'
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA') and CategoryOptionCode<>'MISSING'
										update app.CategoryOptions set CategoryOptionName='Correctional Facility'
												where CategorySetId=@categorySetId and CategoryOptionName='Correctional Facilities'	
							--------------------------EARLY CHILDHOOD  with RACEETHNIC----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('schoolagewithraceethnic','Educational Environment 6-21',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		
									
									INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC'))
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA'))
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) vALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGESA'))

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGESA') AND CategoryOptionCode <>'MISSING'	
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC') and CategoryOptionCode<>'MISSING'
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA') and CategoryOptionCode<>'MISSING'
										update app.CategoryOptions set CategoryOptionName='Correctional Facility'
												where CategorySetId=@categorySetId and CategoryOptionName='Correctional Facilities'	
													--------------------------EARLY CHILDHOOD  with RACEETHNIC----------------------------------------------------------					
								INSERT INTO app.CategorySets([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[GenerateReportId]
														,[OrganizationLevelId],[SubmissionYear])
								VALUES('schoolagewithlepstatus','Educational Environment 6-21',1,0,@reportId,@levelId,@submissionYear)
								SET @categorySetId=SCOPE_IDENTITY()		
									
									INSERT INTO app.CategorySet_Categories
										(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH'))
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) VALUES (@categorySetId, (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA'))
									INSERT INTO app.CategorySet_Categories
									(CategorySetId, CategoryId) vALUES (@categorySetId,(select CategoryId from app.Categories where CategoryCode = 'AGESA'))

										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'AGESA') AND CategoryOptionCode <>'MISSING'	
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'LEPBOTH') 
													and (CategoryOptionName='English learner' or CategoryOptionName='Non-English learner') and CategoryOptionCode<>'MISSING'
										INSERT INTO app.CategoryOptions(CategoryId,CategoryOptionCode,CategoryOptionName,CategorySetId,EdFactsCategoryCodeId)
													SELECT distinct CategoryId,CategoryOptionCode,CategoryOptionName,@categorySetId,0
													from app.CategoryOptions where CategoryId = (select CategoryId from app.Categories where CategoryCode = 'EDENVIRIDEASA') and CategoryOptionCode<>'MISSING'
										update app.CategoryOptions set CategoryOptionName='Correctional Facility'
												where CategorySetId=@categorySetId and CategoryOptionName='Correctional Facilities'	

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