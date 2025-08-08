
declare @categoryId as INT, @dimensionId as INT

Update app.GenerateConfigurations set GenerateConfigurationValue = '2025' where GenerateConfigurationKey = 'SchoolYear'

select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'ISO6392LanguageCode'
select @categoryId = CategoryId from app.Categories where CategoryCode = 'LANGHOME'

IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]
               ([CategoryId]
               ,[DimensionId])
         VALUES (@categoryId, @dimensionId)
END

exec App.UpdateViewDefinitions