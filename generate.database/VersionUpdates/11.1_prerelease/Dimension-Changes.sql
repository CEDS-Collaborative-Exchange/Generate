SET NOCOUNT ON;

DECLARE @dimensionTableId as INT, @categoryId as INT, @dimensionId as INT

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'GRADELEVEL'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'GRADELVLLG'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END


SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'GRADELEVEL'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'GRADELVLHS'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'AssessmentTypeAdministered'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'ASMTADMNMTHLG'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'AssessmentTypeAdministered'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'ASMTADMNMTHHS'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'AssessmentTypeAdministered'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'ASMTADMNMTHLG'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'AssessmentTypeAdministered'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'ASMTADMNRLAHS'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'AssessmentTypeAdministered'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'ASMTADMNRLALG'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END