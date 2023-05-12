SET NOCOUNT ON;
GO 

DECLARE @factTableId as INT, @dimensionTableId as INT, @newDimensionTableId as INT

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12ProgramParticipations'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimIdeaStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12ProgramParticipations'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimK12Demographics'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12ProgramParticipations'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimK12ProgramTypes'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StaffCounts'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimK12Staff'
SELECT @newDimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimPeople'

Update app.FactTable_DimensionTables SET DimensionTableId = @newDimensionTableId WHERE FactTableId = @factTableId AND DimensionTableId = @dimensionTableId

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentCounts'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimEconomicallyDisadvantagedStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentCounts'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimEnglishLearnerStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentCounts'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimHomelessnessStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentCounts'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimFosterCareStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentCounts'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimImmigrantStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentCounts'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimIdeaDisabilityTypes'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentCounts'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimMilitaryStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentCounts'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimDisabilityStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END


SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentDisciplines'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimDisabilityStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentDisciplines'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimEconomicallyDisadvantagedStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentDisciplines'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimEnglishLearnerStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentDisciplines'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimFosterCareStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentDisciplines'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimHomelessnessStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentDisciplines'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimImmigrantStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentDisciplines'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimIncidentStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentDisciplines'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimTitleIStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentDisciplines'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimTitleIIIStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentDisciplines'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimIdeaDisabilityTypes'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END

SELECT @factTableId = FactTableId FROM app.FactTables WHERE FactTableName = 'FactK12StudentDisciplines'
SELECT @dimensionTableId= DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimMilitaryStatuses'

IF NOT EXISTS(SELECT 1 FROM app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
AND ISNULL(@factTableId, '') <> '' 
AND ISNULL(@dimensionTableId, '') <> ''
BEGIN
	INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
END