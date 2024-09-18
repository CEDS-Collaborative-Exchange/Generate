-- Set ViewDefinition on App.CategorySets

set nocount on
begin try
 
	begin transaction
 
	declare @sppaprSubmissionReportTypeId int, @edfactsSubmissionReportTypeId int , @dataPopulationReportTypeId int, @seaId int, @leaId int, @schId int
	select @seaId=OrganizationLevelId from app.OrganizationLevels where LevelCode='sea'
	select @leaId=OrganizationLevelId from app.OrganizationLevels where LevelCode='lea'
	select @schId=OrganizationLevelId from app.OrganizationLevels where LevelCode='sch'
	declare @generateReportTypeId int
	declare @generateReportId int, @categorySetId int, @organizationLevel int
	declare @factFieldName nvarchar(max), @updatedFactFieldName nvarchar(max)
	declare @factField nvarchar(max)
	declare @viewDefinitiationStart nvarchar(max)
	declare @cattId int
	declare @valueFields nvarchar(max)
	declare @dimensionFieldName nvarchar(max)
	declare @reportFileds nvarchar(max)
	declare @categoryCode nvarchar(max), @categoryName nvarchar(max)
	declare @fieldsStart nvarchar(max), @fields nvarchar(max), @fieldsEnd nvarchar(max), @rowFields nvarchar(max), @colFields nvarchar(max), @filterFields nvarchar(max), @viewDefEnd nvarchar(max)
	declare @catCntr int
	declare @rowFieldsCounter int
	declare @columnFieldsCounter int
	DECLARE @reportCode nvarchar(max)
	DECLARE @viewDefi nvarchar(max)
	declare @myFil nvarchar(max)
	DECLARE @myFilters nvarchar(max)
	DECLARE @filterName NVARCHAR(MAX)
	DECLARE @filterCode NVARCHAR(MAX)
	declare @categorySetCode nvarchar(max)
	declare @filters nvarchar(max)
	declare @filterLists nvarchar(max)
	DECLARE @fil nvarchar(max)
	declare @categorySets nvarchar(max)
	declare @repCode nvarchar(max), @repName nvarchar(max), @catIddd int
	declare @rowCounter int
	declare @columnCounter int
	declare @reportTypeId int
	declare @displayType varchar(100)

	declare @existingViewDefinition as nvarchar(max)
	declare @changeCount as int
	set @changeCount = 0
	declare @newCount as int
	set @newCount = 0


	--------------Fetching Report types from Generate Report types table
		DECLARE GenerateReports_cursor CURSOR FOR
			SELECT DISTINCT GenerateReportTypeId FROM app.GenerateReportTypes where GenerateReportTypeId = 3
		OPEN GenerateReports_cursor 
		FETCH NEXT FROM GenerateReports_cursor INTO @reportTypeId
		WHILE @@FETCH_STATUS =0
		BEGIN
		--print @reportTypeId
	---------------Filtering CategorySets base on Report type and iterating to build categoryset ViewDefinition for reports 
			DECLARE CategorySets_cursor CURSOR FOR
			SELECT distinct A.GenerateReportId, a.CategorySetId, a.CategorySetCode, OrganizationLevelId, c.GenerateReportTypeId, c.ReportCode FROM app.CategorySets a
				LEFT JOIN app.CategorySet_Categories b ON a.CategorySetId=b.CategorySetId 
				INNER JOIN app.GenerateReports c on c.GenerateReportId=a.GenerateReportId 
				WHERE GenerateReportTypeId= @reportTypeId or c.ReportCode = 'exitspecialeducation'
			OPEN CategorySets_cursor
			FETCH NEXT FROM CategorySets_cursor INTO @generateReportId, @categorySetId, @categorySets, @organizationLevel, @generateReportTypeId, @reportCode
			WHILE @@FETCH_STATUS = 0
			BEGIN	

	-------------Initializing variables for each category set
					SET @rowFieldsCounter=0
					SET @columnFieldsCounter=0
					SET @rowCounter=0
					SET @columnCounter=0
					--SET @catCntr=1
					SET @filters=''
					SET @fil=''		
					SET @myFil=''
					SET @myFilters=''
					SET @viewDefi=''
					SET @fieldsStart='"fields":['
					SET @fields=''
					SET @fieldsEnd='],'
					SET @rowFields='"rowFields":{"items":[]},'
					SET @colFields='"columnFields":{"items":['
					SET @filterFields=',"filterFields":{"items":[]}'
					SET @viewDefEnd='}'
					SET @filterLists=''
					IF(@reportTypeId=@generateReportTypeId)
						BEGIN
						SET @viewDefinitiationStart='{"showColumnTotals":1,"showRowTotals":1,"defaultFilterType":3,'	
						END
					ELSE
						BEGIN
						SET @viewDefinitiationStart='{"showColumnTotals":0,"showRowTotals":1,"defaultFilterType":3,'
					END

	--------------Identifying FactFieldName for the CategorySet	
						SELECT TOP(1) @factFieldName=E.FactFieldName  from app.GenerateReports D LEFT JOIN App.FactTables E ON E.FactTableId=D.FactTableId WHERE D.GenerateReportId=@generateReportId
						IF(@factFieldName IS NOT NULL)
						BEGIN
							IF (@reportCode='c067')
							BEGIN
								SET @factFieldName='personnelCount'
							END
							ELSE IF (@reportCode='c150')
							BEGIN
								SET @factFieldName='studentRate'
							END
						END
						else
						begin
									SET @factFieldName='studentCount'
						end
				SET @updatedFactFieldName=	LOWER(LEFT( @factFieldName, 1))+SUBSTRING(@factFieldName,2,Len(@factFieldName)) 
					
					--SET @catCntr=1

	-------------Initializing row fields based on report types
					IF @organizationLevel=@seaId
						BEGIN
						IF(@reportTypeId=@generateReportTypeId)
							BEGIN
								IF (@reportCode='c151' OR @reportCode='c150')
								BEGIN
									SET @rowFields='"rowFields":{"items":["SEA","SEA ID","Table Type"'
								END	
								ELSE
								BEGIN
									SET @rowFields='"rowFields":{"items":["SEA","SEA ID"'	
								END
						END
						ELSE
							BEGIN
								SET @rowFields='"rowFields":{"items":["SEA ID"'
						END							
				
					SET @fields=@fields+'{"binding":"organizationStateId","header":"SEA ID","dataType":1,"aggregate":1,"showAs":0,"descending":false,"format":"D","isContentHtml":false},'
					SET @fields=@fields+'{"binding":"organizationName","header":"SEA","dataType":1,"aggregate":0,"showAs":0,"descending":false,"format":"","width":250,"wordWrap":true,"isContentHtml":false},'
					
					END
					ELSE IF @organizationLevel=@leaId
						BEGIN
						
							IF(@reportTypeId = @generateReportTypeId)
								BEGIN
								
								IF (@reportCode='c151' OR @reportCode='c150')
								BEGIN
									SET @rowFields='"rowFields":{"items":["LEA","LEA ID","Table Type"'
								END	
								ELSE
								BEGIN
									SET @rowFields='"rowFields":{"items":["LEA","LEA ID"'	
								END
							END
							ELSE
								BEGIN

									SET @rowFields='"rowFields":{"items":["LEA ID"'
							END			
						SET @fields=@fields+'{"binding":"organizationStateId","header":"LEA ID","dataType":1,"aggregate":1,"showAs":0,"descending":false,"format":"D","isContentHtml":false},'
						SET @fields=@fields+'{"binding":"organizationName","header":"LEA","dataType":1,"aggregate":0,"showAs":0,"descending":false,"format":"","width":250,"wordWrap":true,"isContentHtml":false},'
					END
					ELSE IF @organizationLevel=@schId
						BEGIN
							IF(@reportTypeId=@generateReportTypeId)
							BEGIN
								IF (@reportCode='c151' OR @reportCode='c150')
								BEGIN
									SET @rowFields='"rowFields":{"items":["School","School ID","Table Type"'
								END	
								ELSE
								BEGIN
									SET @rowFields='"rowFields":{"items":["School","School ID"'	
								END
							END
							ELSE
								BEGIN
									SET @rowFields='"rowFields":{"items":["School ID"'
							END			
						SET @fields=@fields+'{"binding":"organizationStateId","header":"School ID","dataType":1,"aggregate":2,"showAs":0,"descending":false,"format":"D","isContentHtml":false},'
						SET @fields=@fields+'{"binding":"organizationName","header":"School","dataType":1,"aggregate":0,"showAs":0,"descending":false,"format":"","width":250,"wordWrap":true,"isContentHtml":false},'
					END
					IF (@reportCode='c151' OR @reportCode='c150')
					BEGIN
						SET @fields=@fields+'{"binding":"tableTypeAbbrv","header":"Table Type","dataType":1,"aggregate":0,"showAs":0,"descending":false,"format":"","width":250,"wordWrap":true,"isContentHtml":false},'
					END	

	-----------------Adding filters to reports
					SET @filterLists=''
					SET @myFil=''
					SET @myFil=',"filter":{ "type":"value","filterText":"","showValues":{ "'
				
					IF(@reportCode='indicator4b' or @reportCode='indicator9' or @reportCode='indicator10')				
						BEGIN
							SET @filterLists= ',"filterFields":{"items":[ "Disability Category (IDEA)"]}'					
					END
					IF(@reportCode='indicator9')
						BEGIN		
							IF(@categorySets='ALL')
							BEGIN
								SET @myFil=@myFil+'"AUT":true, "DB":true, "DD":true, "EMN":true, "HI":true, "MD":true, "MR":true, "OHI":true, "OI":true, "SLD":true, "SLI":true, "TBI":true, "VI":true'
							END
					END

	--------------- Building filter lists for indicator10 report
					IF(@reportCode='indicator10')
						BEGIN
							SET @myFil=@myFil+ @categorySets+ '":true'
					END	
						SET @catCntr=1
	---------------- Filtering categories based on categorysetid and iterating based on each category to bind to ViewDefinition
					DECLARE Categories_cursor CURSOR FOR
						SELECT CategoryId, CategoryName, CategoryCode FROM app.Categories WHERE CategoryId in (
								SELECT b.CategoryId FROM app.CategorySets a inner join app.CategorySet_Categories b 
													ON a.CategorySetId=b.CategorySetId WHERE a.CategorySetId=@categorySetId)  
						
					OPEN Categories_cursor
						FETCH NEXT FROM Categories_cursor into @cattId,  @categoryName, @categoryCode
						WHILE @@FETCH_STATUS=0
						BEGIN
						set @dimensionFieldName=''
							SELECT TOP(1) @dimensionFieldName=bb.DimensionFieldName FROM app.Category_Dimensions aa
							inner join app.Dimensions bb ON aa.DimensionId=bb.DimensionId WHERE aa.CategoryId=@cattId
							IF(@dimensionFieldName <>'')
								BEGIN
								SET @reportFileds=LOWER(@dimensionFieldName)
							END
							ELSE if(@dimensionFieldName='')
								BEGIN
								SET @reportFileds=Lower(@categoryCode)
							END
							-----binding categories to be viewed
							--print @updatedFactFieldName
							--IF(@updatedFactFieldName<>'personnelFTE')
							--begin
							--	SET @fields=@fields+ '{"binding":"' + @reportFileds + '","header":"'+@categoryName+'","dataType":2,"aggregate":0,"showAs":0,"descending":false,"format":"n2","wordWrap":true,"isContentHtml":false},'					
							--end
							--else
							--begin
								SET @fields=@fields+ '{"binding":"' + @reportFileds + '","header":"'+@categoryName+'","dataType":2,"aggregate":0,"showAs":0,"descending":false,"format":"n0","wordWrap":true,"isContentHtml":false},'					
							--end
						SET @catCntr =@catCntr+1
						FETCH NEXT FROM Categories_cursor INTO @cattId, @categoryName, @categoryCode
						END
					CLOSE Categories_cursor
					DEALLOCATE Categories_cursor
				
					IF(@reportCode='indicator4' or @reportCode='indicator9' or @reportCode='indicator10')
					BEGIN
						SET @fil=@myFil+ '}}}, '
						SELECT @fields= SUBSTRING(@fields, 1, lEN(@fields)-2)

						SET @fields= @fields +@fil
					END
					SET @catCntr=1

	-------------------- Filtering and binding categories to row and/or columns 
					DECLARE Categories_cursor CURSOR FOR
							select c.CategoryId, c.CategoryName, c.CategoryCode, ISNULL(d.GenerateReportDisplayTypeName, '') as displayType
							from app.CategorySet_Categories csc
							inner join app.Categories c on csc.CategoryId = c.CategoryId
							left outer join app.GenerateReportDisplayTypes d on csc.GenerateReportDisplayTypeID = d.GenerateReportDisplayTypeId
							WHERE csc.CategorySetId = @categorySetId 			
			
					OPEN Categories_cursor
					FETCH NEXT FROM Categories_cursor into @cattId,  @categoryName, @categoryCode, @displayType
					WHILE @@FETCH_STATUS=0
					BEGIN

					IF(@displayType <> '')
					BEGIN
						print @categorySetId
						IF(@displayType = 'row')
						BEGIN
							SET @rowFields= @rowFields + ',"' + @categoryName + '"'	
						END

						IF(@displayType = 'column')
						BEGIN
							IF(@columnCounter <> 0)
								BEGIN
									SET @colFields=@colFields + ',"' + @categoryName + '"'
								END
								ELSE
								BEGIN
									IF(@columnCounter=0)
									BEGIN
										SET @colFields=@colFields+'"'+@categoryName + '"'
									END
								END					
							SET @columnCounter+=1
						END
					END
					ELSE
					BEGIN
	---------------------assigning even number categories to rows
						IF (@catCntr%2=0)
						BEGIN
							SET @rowFields= @rowFields + ',"' + @categoryName + '"'						
						END
					
	-----------------------assigining odd number categories to columns
						ELSE
						BEGIN
							IF(@catCntr<>1)
							BEGIN
								SET @colFields=@colFields + ',"' + @categoryName + '"'
							END
							ELSE
							BEGIN
								IF(@columnCounter=0)
								BEGIN
									SET @colFields=@colFields+'"'+@categoryName + '"'
								END
							END					
						SET @columnCounter+=1
						END
						
					END
					set @catCntr += 1

					FETCH NEXT FROM Categories_cursor into @cattId,  @categoryName, @categoryCode, @displayType
					END
					CLOSE Categories_cursor
					DEALLOCATE Categories_cursor

					IF (@reportCode='c204')
					begin
					set @reportFileds='tableTypeAbbrv'
					set @categoryName='Title III English Learners'
					 SET @fields=@fields+ '{"binding":"' + @reportFileds + '","header":"'+@categoryName+'","dataType":2,"aggregate":0,"showAs":0,"descending":false,"format":"n0","wordWrap":true,"isContentHtml":false},'					
					set @rowFields=@rowFields+',"Title III English Learners"'	
					end
					if(@updatedFactFieldName='studentRate')
					begin
						SET @fields=@fields+ '{"binding":"' + @updatedFactFieldName + '","header":"Rate","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n2","isContentHtml":false}'	
						set @valueFields=',"valueFields":{"items":["Rate"]}'
					end
					else if(@updatedFactFieldName='personnelFTE')
					begin
						SET @fields=@fields+ '{"binding":"' + @updatedFactFieldName + '","header":"Count","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n2","isContentHtml":false}'	
						set @valueFields=',"valueFields":{"items":["Count"]}'
					end
					else
					begin				
					SET @fields=@fields+ '{"binding":"' + @updatedFactFieldName + '","header":"Count","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n0","isContentHtml":false}'	
					set @valueFields=',"valueFields":{"items":["Count"]}'
					end
					
					set @colFields =@colFields+']}'
						SET @rowFields=@rowFields+']},'

	--------------------------Finalizing viewDefinition for reports
						IF(@reportCode='indicator4' or @reportCode='indicator9' or @reportCode='indicator10')
						BEGIN
							SET @viewDefi= @viewDefinitiationStart+@fieldsStart+@fields+@fieldsEnd+@rowFields+@colFields+@filterLists+@valueFields+@viewDefEnd					
						END
						ELSE
						BEGIN
							SET @viewDefi= @viewDefinitiationStart+@fieldsStart+@fields+@fieldsEnd+@rowFields+@colFields+@filterFields+@valueFields+@viewDefEnd					
						END

					-- Figure out if 
					select @existingViewDefinition = ViewDefinition from App.CategorySets where CategorySetId = @categorySetId
					--print @viewDefi
					
					if not @existingViewDefinition is null
					begin
						if (@existingViewDefinition <> @viewDefi)
						begin
							--print 'CategorySetId = ' + convert(varchar(20), @categorySetId)
							--print '---------------------'
							--print 'Existing --'
							--print '---------------------'
							--print @existingViewDefinition
							--print '---------------------'
							--print 'New --'
							--print '---------------------'
							--print @viewDefi
							--print '---------------------'
							--print ''
							--print ''
							set @changeCount = @changeCount + 1
							update app.CategorySets set ViewDefinition=@viewDefi where CategorySetId=@categorySetId 					
						end
					end
					else
					begin
						set @newCount = @newCount + 1
						update app.CategorySets set ViewDefinition=@viewDefi where CategorySetId=@categorySetId 					
					end

				FETCH NEXT FROM CategorySets_cursor INTO @generateReportId, @categorySetId, @categorySets, @organizationLevel, @generateReportTypeId, @reportCode
				END
			CLOSE CategorySets_cursor
			DEALLOCATE CategorySets_cursor
		FETCH NEXT FROM GenerateReports_cursor INTO @reportTypeId
		END

	CLOSE GenerateReports_cursor
	DEALLOCATE GenerateReports_cursor
	
	--print ''
	--print '---------------------'
	--print 'Total New Count = ' + convert(varchar(20), @newCount)
	--print 'Total Change Count = ' + convert(varchar(20), @changeCount)

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
