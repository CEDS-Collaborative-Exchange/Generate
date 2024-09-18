-- Metadata changes for the RDS schema
----------------------------------
set nocount on
begin try
	begin transaction

		declare @factTypeId as int, @dimensionTableId as int
				
		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'datapopulation'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END


		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimTitle1Statuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimGradeLevels'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDisciplines'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'submission'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDisciplines'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimAges'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimGradeLevels'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimFirearms'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimFirearmsDiscipline'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimNorDProgramStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimAssessmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimAssessmentS'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimTitleiiiStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimProgramStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimStudentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimPersonnelStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimPersonnelCategories'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'childcount'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimAges'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDisciplines'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'specedexit'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimAges'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimProgramStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimTitle1Statuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'cte'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimProgramStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimStudentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'membership'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimGradeLevels'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimProgramStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'dropout'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimGradeLevels'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'grad'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimStudentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimAges'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimLanguages'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimProgramStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'titleIIIELOct'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimGradeLevels'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimTitleiiiStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimLanguages'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'titleIIIELSY'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimTitleiiiStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'sppapr'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimAges'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'titleI'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimGradeLevels'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimTitle1Statuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'mep'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimGradeLevels'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimMigrants'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimStudentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'immigrant'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimMigrants'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'nord'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimNorDProgramStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimAges'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollment'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'homeless'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimGradeLevels'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimAges'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END
		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'chronic'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimAttendance'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'gradrate'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimProgramStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimCohortStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'hsgradenroll'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollment'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'other'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchools'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimDemographics'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimTitle1Statuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimProgramStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimAges'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

			
		


		  if not exists(select 1 from rds.DimLanguages where DimLanguageId = -1)
		  BEGIN

			  set identity_insert rds.DimLanguages ON

			  INSERT INTO [RDS].[DimLanguages]([DimLanguageId],LanguageCode,[LanguageDescription],[LanguageEdFactsCode],[LanguageId]) VALUES(-1, 'MISSING', 'Missing', 'MISSING', -1)

			  set identity_insert rds.DimLanguages OFF

			  Update r set r.DimLanguageId = -1 
			  from rds.FactStudentCounts r
			  inner join rds.DimLanguages l on r.DimLanguageId = l.DimLanguageId
			  where l.LanguageId = -1
		  END
  
		  delete from rds.DimLanguages where LanguageId = -1 and DimLanguageId > 0
		

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
