DECLARE @dimensionTableId as INT, @categoryId as INT, @dimensionId as INT, @factTableId as INT

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'EdFactsCertificationStatus'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'CERTSTATUSIDEA'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END


update App.FileColumns set DimensionId = @dimensionId where ColumnName = 'CertificationStatusID'