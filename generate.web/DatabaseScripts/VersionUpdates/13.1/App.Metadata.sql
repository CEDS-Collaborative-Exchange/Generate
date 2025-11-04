declare @categoryId as INT, @dimensionId as INT, @dimensionTableId as INT


select @categoryId = CategoryId from app.Categories where CategoryCode = 'NEGPROGSUBPRT1'

select @dimensionTableId = DimensionTableId from app.DimensionTables where DimensionTableName like '%NorD%'

IF NOT EXISTS(Select 1 from app.Dimensions where DimensionFieldName = 'NeglectedProgramType')
BEGIN
    INSERT INTO [App].[Dimensions]
               ([DimensionFieldName]
               ,[DimensionTableId]
               ,[IsCalculated]
               ,[IsOrganizationLevelSpecific])
    VALUES('NeglectedProgramType', @dimensionTableId,0,0)
END

select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'NeglectedProgramType'


IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]
               ([CategoryId]
               ,[DimensionId])
         VALUES (@categoryId, @dimensionId)
END


select @categoryId = CategoryId from app.Categories where CategoryCode = 'DELPROG'

IF NOT EXISTS(Select 1 from app.Dimensions where DimensionFieldName = 'DelinquentProgramType')
BEGIN
    INSERT INTO [App].[Dimensions]
               ([DimensionFieldName]
               ,[DimensionTableId]
               ,[IsCalculated]
               ,[IsOrganizationLevelSpecific])
    VALUES('DelinquentProgramType', @dimensionTableId,0,0)
END

select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'DelinquentProgramType'

IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]
               ([CategoryId]
               ,[DimensionId])
         VALUES (@categoryId, @dimensionId)
END

