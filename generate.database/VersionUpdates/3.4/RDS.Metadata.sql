-- Metadata changes for the RDS schema
----------------------------------
set nocount on
begin try
	begin transaction

		declare @DimFactTypeId int, @DimensionTableId int
		declare @spedid as int
		select @spedid = max(StaffCategoryCCDId) + 1 from rds.DimPersonnelCategories

		if not exists(select 1 from rds.DimPersonnelCategories where StaffCategoryCCDCode = 'SpecialEducationTeachers')
		BEGIN
			INSERT INTO [RDS].[DimPersonnelCategories]
					   ([StaffCategoryCCDCode]
					   ,[StaffCategoryCCDDescription]
					   ,[StaffCategoryCCDEdFactsCode]
					   ,[StaffCategoryCCDId]
					   ,[StaffCategorySpecialEdCode]
					   ,[StaffCategorySpecialEdDescription]
					   ,[StaffCategorySpecialEdEdFactsCode]
					   ,[StaffCategorySpecialEdId]
					   ,[StaffCategoryTitle1Code]
					   ,[StaffCategoryTitle1Description]
					   ,[StaffCategoryTitle1EdFactsCode]
					   ,[StaffCategoryTitle1Id])
			select 'SpecialEducationTeachers', 'Special Education Teachers', NULL, @spedid, 
			b.StaffCategorySpecialEdCode, b.StaffCategorySpecialEdDescription, b.StaffCategorySpecialEdEdFactsCode, b.StaffCategorySpecialEdId, 
			a.StaffCategoryTitle1Code, a.StaffCategoryTitle1Description, a.StaffCategoryTitle1EdFactsCode, a.StaffCategoryTitle1Id
			from
			(SELECT distinct StaffCategorySpecialEdCode, StaffCategorySpecialEdDescription, StaffCategorySpecialEdEdFactsCode, StaffCategorySpecialEdId
			FROM rds.DimPersonnelCategories) b
			cross join
			(SELECT distinct StaffCategoryTitle1Code, StaffCategoryTitle1Description, StaffCategoryTitle1EdFactsCode, StaffCategoryTitle1Id
			FROM rds.DimPersonnelCategories) a
		END

		select @DimensionTableId = DimensionTableId from app.DimensionTables where DimensionTableName = 'DimProgramStatuses'
		select @DimFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = 'chronic'

		IF NOT EXISTS(SELECT 1 FROM [RDS].[DimFactType_DimensionTables] WHERE DimFactTypeId = @DimFactTypeId AND DimensionTableId = @DimensionTableId)
		insert into [RDS].[DimFactType_DimensionTables]	values(@DimFactTypeId, @DimensionTableId)

		 

	    if not exists(select 1 from rds.DimOrganizationStatus where McKinneyVentoSubgrantRecipientCode = 'YES')
	BEGIN
		Update rds.DimOrganizationStatus set McKinneyVentoSubgrantRecipientId = -1, McKinneyVentoSubgrantRecipientCode = 'MISSING',
											 McKinneyVentoSubgrantRecipientDescription = 'Missing', 
											 McKinneyVentoSubgrantRecipientEdFactsCode = 'MISSING'

		INSERT INTO [RDS].[DimOrganizationStatus]
			   ([REAPAlternativeFundingStatusId]
			   ,[REAPAlternativeFundingStatusCode]
			   ,[REAPAlternativeFundingStatusDescription]
			   ,[REAPAlternativeFundingStatusEdFactsCode]
			   ,[GunFreeStatusId]
			   ,[GunFreeStatusCode]
			   ,[GunFreeStatusDescription]
			   ,[GunFreeStatusEdFactsCode]
			   ,[GraduationRateId]
			   ,[GraduationRateCode]
			   ,[GraduationRateDescription]
			   ,[GraduationRateEdFactsCode]
			   ,[McKinneyVentoSubgrantRecipientId]
			   ,[McKinneyVentoSubgrantRecipientCode]
			   ,[McKinneyVentoSubgrantRecipientDescription]
			   ,[McKinneyVentoSubgrantRecipientEdFactsCode])
		select b.REAPAlternativeFundingStatusId, b.REAPAlternativeFundingStatusCode, b.REAPAlternativeFundingStatusDescription,
			   b.REAPAlternativeFundingStatusEdFactsCode,
			   a.GunFreeStatusId, a.GunFreeStatusCode, a.GunFreeStatusDescription, a.GunFreeStatusEdFactsCode,
			   c.GraduationRateId, c.GraduationRateCode, c.GraduationRateDescription, c.GraduationRateEdFactsCode,
			   d.McKinneyVentoSubgrantRecipientId, d.McKinneyVentoSubgrantRecipientCode, d.McKinneyVentoSubgrantRecipientDescription,
			   d.McKinneyVentoSubgrantRecipientEdFactsCode
		from
		(SELECT distinct [REAPAlternativeFundingStatusId],[REAPAlternativeFundingStatusCode],[REAPAlternativeFundingStatusDescription]
							,[REAPAlternativeFundingStatusEdFactsCode]
		 FROM rds.DimOrganizationStatus) b
		cross join
		(SELECT distinct [GunFreeStatusId],[GunFreeStatusCode],[GunFreeStatusDescription],[GunFreeStatusEdFactsCode]
		FROM rds.DimOrganizationStatus) a
		cross join
		(SELECT distinct [GraduationRateId],[GraduationRateCode],[GraduationRateDescription],[GraduationRateEdFactsCode]
		FROM rds.DimOrganizationStatus) c
		cross join
		(SELECT 1 as McKinneyVentoSubgrantRecipientId, 'YES' as McKinneyVentoSubgrantRecipientCode, 
		'McKinneyVento Recipient' as McKinneyVentoSubgrantRecipientDescription, 'YES' as McKinneyVentoSubgrantRecipientEdFactsCode
		 UNION
		 SELECT 2 as McKinneyVentoSubgrantRecipientId, 'NO' as McKinneyVentoSubgrantRecipientCode, 
		'Not a McKinneyVento Recipient' as McKinneyVentoSubgrantRecipientDescription, 'NO' as McKinneyVentoSubgrantRecipientEdFactsCode
		 ) d

		 END

		if not exists(select 1 from rds.DimIdeaStatuses where IDEAIndicatorCode = 'IDEA')
		BEGIN
			Update rds.DimIdeaStatuses set IDEAIndicatorId = -1, IDEAIndicatorCode = 'MISSING', IDEAIndicatorDescription = 'Missing', IDEAIndicatorEdFactsCode = 'MISSING'

			INSERT INTO [RDS].[DimIdeaStatuses]
				([BasisOfExitCode]
				,[BasisOfExitDescription]
				,[BasisOfExitEdFactsCode]
				,[BasisOfExitId]
				,[DisabilityCode]
				,[DisabilityDescription]
				,[DisabilityEdFactsCode]
				,[DisabilityId]
				,[EducEnvCode]
				,[EducEnvDescription]
				,[EducEnvEdFactsCode]
				,[EducEnvId]
				,IDEAIndicatorCode
				,IDEAIndicatorDescription
				,IDEAIndicatorEdFactsCode
				,IDEAIndicatorId)
			select b.BasisOfExitCode, b.BasisOfExitDescription, b.BasisOfExitEdFactsCode, b.BasisOfExitId,
					a.DisabilityCode, a.DisabilityDescription, a.DisabilityEdFactsCode, a.DisabilityId,
					c.EducEnvCode, c.EducEnvDescription, c.EducEnvEdFactsCode, c.EducEnvId,
					d.IDEAIndicatorCode, d.IDEAIndicatorDescription, d.IDEAIndicatorEdFactsCode, d.IDEAIndicatorId
			from
			(SELECT distinct [BasisOfExitCode],[BasisOfExitDescription],[BasisOfExitEdFactsCode],[BasisOfExitId]
				FROM rds.DimIdeaStatuses) b
			cross join
			(SELECT distinct [DisabilityCode],[DisabilityDescription],[DisabilityEdFactsCode],[DisabilityId]
			FROM rds.DimIdeaStatuses) a
			cross join
			(SELECT distinct [EducEnvCode],[EducEnvDescription],[EducEnvEdFactsCode],[EducEnvId]
			FROM rds.DimIdeaStatuses) c
			cross join
			(SELECT 1 as IDEAIndicatorId, 'IDEA' as IDEAIndicatorCode, 'IDEA Indicator' as IDEAIndicatorDescription, 'IDEA' as IDEAIndicatorEdFactsCode
			) d
		END

		DECLARE @DIMDATEID INT = -1;

		IF NOT EXISTS(SELECT 1 FROM [RDS].[DimDates] WHERE SubmissionYear = '2019-20')
		BEGIN
			INSERT INTO [RDS].[DimDates]([DateValue],[Day],[DayOfWeek],[DayOfYear],[Month],[MonthName],[SubmissionYear],[Year])
			Values('2019-11-01 00:00:00.0000000',1,'Friday',365,11,'November','2019-20','2019')

			SET @DIMDATEID =  SCOPE_IDENTITY();
		END
		ELSE
		BEGIN
			SET @DIMDATEID =  ( SELECT DIMDATEID FROM [RDS].[DimDates] WHERE SubmissionYear = '2019-20')
		END		

		IF NOT EXISTS(SELECT 1 FROM [RDS].[DimDateDataMigrationTypes] WHERE DimDateId = @DIMDATEID)
		BEGIN
			INSERT INTO [RDS].[DimDateDataMigrationTypes] ([DimDateID],[DataMigrationTypeId],[IsSelected])
			Values	   (@DIMDATEID,1,0),
					   (@DIMDATEID,2,0),
					   (@DIMDATEID,3,0)
		END

		select @DimensionTableId = DimensionTableId from app.DimensionTables where DimensionTableName = 'DimGradeLevels'
		select @DimFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = 'childcount'

		IF NOT EXISTS(SELECT 1 FROM [RDS].[DimFactType_DimensionTables] WHERE DimFactTypeId = @DimFactTypeId AND DimensionTableId = @DimensionTableId)
		insert into [RDS].[DimFactType_DimensionTables]	values(@DimFactTypeId, @DimensionTableId)

		delete from rds.FactOrganizationCounts
		Where DimSchoolStatusId in (
		select st.DimSchoolStatusId  from
		(select [MagnetStatusCode], [NSLPStatusCode],[SharedTimeStatusCode],[VirtualSchoolStatusCode], 
		[ImprovementStatusCode], [PersistentlyDangerousStatusCode], [StatePovertyDesignationCode],
		[ProgressAchievingEnglishLanguageCode],
		min(DimSchoolStatusId) as DimSchoolStatusId	
		from rds.DimSchoolStatuses
		group by [MagnetStatusCode], [NSLPStatusCode],[SharedTimeStatusCode],[VirtualSchoolStatusCode], 
		[ImprovementStatusCode], [PersistentlyDangerousStatusCode], [StatePovertyDesignationCode],
		[ProgressAchievingEnglishLanguageCode]) statuses
		right outer join (select * from rds.DimSchoolStatuses) st on statuses.DimSchoolStatusId = st.DimSchoolStatusId
		where statuses.DimSchoolStatusId IS NULL)

		delete from rds.DimSchoolStatuses
		where DimSchoolStatusId in (
		select st.DimSchoolStatusId  from
		(select [MagnetStatusCode], [NSLPStatusCode],[SharedTimeStatusCode],[VirtualSchoolStatusCode], 
		[ImprovementStatusCode], [PersistentlyDangerousStatusCode], [StatePovertyDesignationCode],
		[ProgressAchievingEnglishLanguageCode],
		min(DimSchoolStatusId) as DimSchoolStatusId	
		from rds.DimSchoolStatuses
		group by [MagnetStatusCode], [NSLPStatusCode],[SharedTimeStatusCode],[VirtualSchoolStatusCode], 
		[ImprovementStatusCode], [PersistentlyDangerousStatusCode], [StatePovertyDesignationCode],
		[ProgressAchievingEnglishLanguageCode]) statuses
		right outer join (select * from rds.DimSchoolStatuses) st on statuses.DimSchoolStatusId = st.DimSchoolStatusId
		where statuses.DimSchoolStatusId IS NULL)

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