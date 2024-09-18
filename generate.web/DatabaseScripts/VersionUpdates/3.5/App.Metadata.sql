-- Metadata changes for the App schema
----------------------------------
set nocount on
begin try
	begin transaction		

	declare @factTableId as int, @dimensionId as int, @categoryId int
	DECLARE @generatereportcontroltypeId INT


	UPDATE A
	SET A.CategorySetCode = 'CSA' 
	FROM [App].[CategorySets] A
	WHERE  CategorySetId = (SELECT TOP 1 CategorySetId FROM [App].[CategorySets] 
	WHERE GenerateReportId = (SELECT GenerateReportId FROM APP.GenerateReports WHERE ReportCode = 'C206')
	AND  [SubmissionYear] = '2019-20')
	
	IF NOT EXISTS(SELECT 1 FROM app.GenerateReportControlType WHERE ControlTypeName = 'c207')
	BEGIN	
		INSERT INTO [App].[GenerateReportControlType] ([ControlTypeName]) VALUES  ('c207')
	END

	SELECT @generatereportcontroltypeId = GenerateReportControlTypeId FROM [App].[GenerateReportControlType]  WHERE [ControlTypeName] = 'c207'
	select @factTableId = FactTableId from app.FactTables where FactTableName = 'FactOrganizationCounts'

	UPDATE app.GenerateReports 
	SET IsActive = 1, 
		FactTableId = @factTableId, 
		ShowCategorySetControl = 0,
		GenerateReportControlTypeId = @GenerateReportControlTypeId,
		ReportTypeAbbreviation = 'CHARSAPRM'
	WHERE ReportCode in ('c207')

	select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'TitleiiiLanguageInstruction'
	select @categoryId = CategoryId from app.Categories Where CategoryCode = 'LNGINSTPRGTYPE'

	IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
	BEGIN
		INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
	END

	UPDATE app.CategorySets SET TableTypeId = (SELECT TableTypeId FROM App.TableTypes WHERE EdFactsTableTypeId = cs.EdFactsTableTypeId )
	FROM App.CategorySets cs
	WHERE (cs.TableTypeId IS NULL OR cs.TableTypeId IN  
		(SELECT DISTINCT tabletypeid FROM app.CategorySets cs WHERE GenerateReportId IN 
			(SELECT GenerateReportId FROM app.GenerateReports WHERE reportcode = 'c116' ))) and cs.EdFactsTableTypeId = (SELECT EdFactsTableTypeId FROM app.tabletypes WHERE TableTypeAbbrv = 'TTLIIILIEPSTDSRV')

	IF NOT EXISTS (SELECT 1 FROM app.GenerateReports WHERE ReportCode ='c035'  AND CedsConnectionId IS NOT NULL)
	BEGIN
		UPDATE app.GenerateReports SET CedsConnectionId =(SELECT CedsConnectionId FROM App.CedsConnections WHERE CedsConnectionName LIKE '%FS035%') WHERE ReportCode='c035'
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