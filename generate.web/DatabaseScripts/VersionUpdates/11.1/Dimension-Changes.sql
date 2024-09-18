SET NOCOUNT ON;

DECLARE @dimensionTableId as INT, @categoryId as INT, @dimensionId as INT, @factTableId as INT

 UPDATE app.[FactTables] SET FactReportTableIdName = 'ReportEDFactsK12StudentAssessmentId', FactReportTableName = 'ReportEDFactsK12StudentAssessments' WHERE [FactTableName] = 'FactK12StudentAssessments'

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

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'GRADELEVEL'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'GRADELVLLGSCI'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END


SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'GRADELEVEL'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'GRADELVLHSSCI'

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

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'AssessmentTypeAdministered'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'ASMTADMNSCIHS'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'AssessmentTypeAdministered'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'ASMTADMNSCILG'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'AssessmentRegistrationParticipationIndicator'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'PARTSTATUSMTHLG'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'AssessmentRegistrationParticipationIndicator'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'PARTSTATUSMTHHS'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'AssessmentRegistrationParticipationIndicator'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'PARTSTATUSRLAHS'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'AssessmentRegistrationParticipationIndicator'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'PARTSTATUSRLALG'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'AssessmentRegistrationParticipationIndicator'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'PARTSTATUSSCIHS'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'AssessmentRegistrationParticipationIndicator'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'PARTSTATUSSCILG'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimAssessments'
Update app.Dimensions SET DimensionTableId = @dimensionTableId WHERE DimensionFieldName = 'AssessmentTypeAdministered'

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimEconomicallyDisadvantagedStatuses'
SELECT @factTableId = FactTableId from app.FactTables WHERE FactTableName = 'FactK12StudentAssessments'

IF NOT EXISTS(SELECT 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
BEGIN
    INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId])
    VALUES (@factTableId, @dimensionTableId)
END

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimMigrantStatuses'
IF NOT EXISTS(SELECT 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
BEGIN
    INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId])
    VALUES (@factTableId, @dimensionTableId)
END

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimFosterCareStatuses'
IF NOT EXISTS(SELECT 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
BEGIN
    INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId])
    VALUES (@factTableId, @dimensionTableId)
END

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimHomelessnessStatuses'
IF NOT EXISTS(SELECT 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
BEGIN
    INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId])
    VALUES (@factTableId, @dimensionTableId)
END

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimEnglishLearnerStatuses'
IF NOT EXISTS(SELECT 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
BEGIN
    INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId])
    VALUES (@factTableId, @dimensionTableId)
END

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimMilitaryStatuses'
IF NOT EXISTS(SELECT 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
BEGIN
    INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId])
    VALUES (@factTableId, @dimensionTableId)
END

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimAssessmentRegistrations'
IF NOT EXISTS(SELECT 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
BEGIN
    INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId])
    VALUES (@factTableId, @dimensionTableId)
END

update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'AssessmentTypeAdministered') 
where ColumnName = 'AssessAdministeredID'

delete from app.Dimensions where DimensionFieldName in ('LeaFullAcademicYear','SchoolFullAcademicYear','StateFullAcademicYear')