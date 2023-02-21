-- Metadata changes for the RDS schema
----------------------------------
set nocount on
begin try
	begin transaction

		declare @DimFactTypeId int, @DimensionTableId int
		declare @factTypeId as int
		declare @spedid as int
		select @spedid = max(StaffCategoryCCDId) + 1 from rds.DimPersonnelCategories

		if not exists(select 1 from rds.DimPersonnelCategories where StaffCategoryCCDCode = 'SchoolPsychologist')
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
			select 'SchoolPsychologist', 'School Psychologist', 'SCHPSYCH', @spedid, 
			b.StaffCategorySpecialEdCode, b.StaffCategorySpecialEdDescription, b.StaffCategorySpecialEdEdFactsCode, b.StaffCategorySpecialEdId, 
			a.StaffCategoryTitle1Code, a.StaffCategoryTitle1Description, a.StaffCategoryTitle1EdFactsCode, a.StaffCategoryTitle1Id
			from
			(SELECT distinct StaffCategorySpecialEdCode, StaffCategorySpecialEdDescription, StaffCategorySpecialEdEdFactsCode, StaffCategorySpecialEdId
			FROM rds.DimPersonnelCategories) b
			cross join
			(SELECT distinct StaffCategoryTitle1Code, StaffCategoryTitle1Description, StaffCategoryTitle1EdFactsCode, StaffCategoryTitle1Id
			FROM rds.DimPersonnelCategories) a
		END

		select @spedid = max(StaffCategoryCCDId) + 1 from rds.DimPersonnelCategories

		if not exists(select 1 from rds.DimPersonnelCategories where StaffCategoryCCDCode = 'StudentSupportServicesStaff(w/oPsychology)')
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
			select 'StudentSupportServicesStaff(w/oPsychology)', 'Student Support Services Staff (w/o Psychology)', 'STUSUPWOPSYCH', @spedid, 
			b.StaffCategorySpecialEdCode, b.StaffCategorySpecialEdDescription, b.StaffCategorySpecialEdEdFactsCode, b.StaffCategorySpecialEdId, 
			a.StaffCategoryTitle1Code, a.StaffCategoryTitle1Description, a.StaffCategoryTitle1EdFactsCode, a.StaffCategoryTitle1Id
			from
			(SELECT distinct StaffCategorySpecialEdCode, StaffCategorySpecialEdDescription, StaffCategorySpecialEdEdFactsCode, StaffCategorySpecialEdId
			FROM rds.DimPersonnelCategories) b
			cross join
			(SELECT distinct StaffCategoryTitle1Code, StaffCategoryTitle1Description, StaffCategoryTitle1EdFactsCode, StaffCategoryTitle1Id
			FROM rds.DimPersonnelCategories) a

		END

		select @spedid = max(StaffCategoryCCDId) + 1 from rds.DimPersonnelCategories

		if not exists(select 1 from rds.DimPersonnelCategories where StaffCategoryCCDCode = 'Pre-KindergartenTeachers')
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
			select 'Pre-KindergartenTeachers', 'Pre-Kindergarten Teachers', 'PKTCH', @spedid, 
			b.StaffCategorySpecialEdCode, b.StaffCategorySpecialEdDescription, b.StaffCategorySpecialEdEdFactsCode, b.StaffCategorySpecialEdId, 
			a.StaffCategoryTitle1Code, a.StaffCategoryTitle1Description, a.StaffCategoryTitle1EdFactsCode, a.StaffCategoryTitle1Id
			from
			(SELECT distinct StaffCategorySpecialEdCode, StaffCategorySpecialEdDescription, StaffCategorySpecialEdEdFactsCode, StaffCategorySpecialEdId
			FROM rds.DimPersonnelCategories) b
			cross join
			(SELECT distinct StaffCategoryTitle1Code, StaffCategoryTitle1Description, StaffCategoryTitle1EdFactsCode, StaffCategoryTitle1Id
			FROM rds.DimPersonnelCategories) a
		END

		IF EXISTS (select 1 from rds.DimPersonnelCategories where StaffCategoryCCDEdFactsCode = 'STUSUPWOPSYCH')
		BEGIN
			UPDATE rds.DimPersonnelCategories 
			SET StaffCategoryCCDCode = 'StudentSupportServicesStaff' , StaffCategoryCCDDescription = 'Student Support Services Staff'
			WHERE  StaffCategoryCCDEdFactsCode = 'STUSUPWOPSYCH'	
		END

		
		TRUNCATE TABLE rds.DimComprehensiveAndTargetedSupports
				
				
	IF NOT EXISTS(SELECT 1 
				  FROM RDS.DimComprehensiveAndTargetedSupports 
				  WHERE DimComprehensiveAndTargetedSupportId = -1
				  AND ComprehensiveAndTargetedSupportId=-1 
				  AND ComprehensiveSupportId=-1
				  AND TargetedSupportId= -1
				  AND AdditionalTargetedSupportandImprovementId= -1
				  AND ComprehensiveSupportImprovementId=-1
				  AND TargetedSupportImprovementId = -1)		
	BEGIN
			SET IDENTITY_INSERT RDS.DimComprehensiveAndTargetedSupports ON
			
			INSERT INTO [RDS].[DimComprehensiveAndTargetedSupports]
           (
			   DimComprehensiveAndTargetedSupportId
			   ,[ComprehensiveAndTargetedSupportId]
			   ,[ComprehensiveAndTargetedSupportCode]
			   ,[ComprehensiveAndTargetedSupportDescription]
			   ,[ComprehensiveAndTargetedSupportEdFactsCode]
			   ,[ComprehensiveSupportId]
			   ,[ComprehensiveSupportCode]
			   ,[ComprehensiveSupportDescription]
			   ,[ComprehensiveSupportEdFactsCode]
			   ,[TargetedSupportId]
			   ,[TargetedSupportCode]
			   ,[TargetedSupportDescription]
			   ,[TargetedSupportEdFactsCode]
			   ,[AdditionalTargetedSupportandImprovementId]
			   ,[AdditionalTargetedSupportandImprovementCode]
			   ,[AdditionalTargetedSupportandImprovementDescription]
			   ,[AdditionalTargetedSupportandImprovementEdFactsCode]
			   ,[ComprehensiveSupportImprovementId]
			   ,[ComprehensiveSupportImprovementCode]
			   ,[ComprehensiveSupportImprovementDescription]
			   ,[ComprehensiveSupportImprovementEdFactsCode]
			   ,[TargetedSupportImprovementId]
			   ,[TargetedSupportImprovementCode]
			   ,[TargetedSupportImprovementDescription]
			   ,[TargetedSupportImprovementEdFactsCode]
			)
			VALUES
			(
				-1,-1,'MISSING','MISSING','MISSING',-1,'MISSING','MISSING','MISSING',-1,'MISSING','MISSING','MISSING',
				-1,'MISSING','MISSING','MISSING',-1,'MISSING','MISSING','MISSING',-1,'MISSING','MISSING','MISSING'
			)	
			
			SET IDENTITY_INSERT RDS.DimComprehensiveAndTargetedSupports OFF
	END

	DECLARE @ComprehensiveSupportImprovement TABLE
	(
		[ComprehensiveSupportImprovementId] [int] NULL,
		[ComprehensiveSupportImprovementCode] [varchar](50) NULL,
		[ComprehensiveSupportImprovementDescription] [varchar](200) NULL,
		[ComprehensiveSupportImprovementEdFactsCode] [varchar](50) NULL
	)

	INSERT INTO @ComprehensiveSupportImprovement VALUES  
		(1,'CSI','Comprehensive Support and Improvement','CSI'),
		(2,'CSIEXIT','Comprehensive Support and Improvement - Exit Status','CSIEXIT'),
		(3,'NOTCSI','Not Comprehensive Support and Improvement','NOTCSI'),
		(-1,'MISSING','MISSING','MISSING')

	DECLARE @TargetedSupportImprovement TABLE
	(
		[TargetedSupportImprovementId] [int] NULL,
		[TargetedSupportImprovementCode] [varchar](50) NULL,
		[TargetedSupportImprovementDescription] [varchar](200) NULL,
		[TargetedSupportImprovementEdFactsCode] [varchar](50) NULL
	)

	INSERT INTO @TargetedSupportImprovement VALUES  
		(1,'TSI','Targeted Support and Improvement','TSI'),
		(2,'TSIEXIT','Targeted Support and Improvement - Exit Status','TSIEXIT'),
		(3,'NOTTSI','Not Targeted Support and Improvement','NOTTSI'),
		(-1,'MISSING','MISSING','MISSING')
 
 	DECLARE @TargetedSupport TABLE
	(
		[TargetedSupportId] [int] NULL,
		[TargetedSupportCode] [varchar](50) NULL,
		[TargetedSupportDescription] [varchar](200) NULL,
		[TargetedSupportEdFactsCode] [varchar](50) NULL
	)

	INSERT INTO @TargetedSupport VALUES  
		(1,'TSIUNDER','Consistently underperforming subgroups school','TSIUNDER'),
		(2,'TSIOTHER','Additional targeted support and improvement school','TSIOTHER'),			
		(-1,'MISSING','MISSING','MISSING')


	DECLARE @ComprehensiveSupport TABLE
	(
		[ComprehensiveSupportId] [int] NULL,
		[ComprehensiveSupportCode] [varchar](50) NULL,
		[ComprehensiveSupportDescription] [varchar](200) NULL,
		[ComprehensiveSupportEdFactsCode] [varchar](50) NULL
	)

	INSERT INTO @ComprehensiveSupport VALUES  
		(1,'CSILOWPERF','Lowest-performing school','CSILOWPERF'),
		(2,'CSILOWGR','Low graduation rate high school','CSILOWGR'),	
		(3,'CSIOTHER','Additional targeted support school not exiting such status','CSIOTHER'),		
		(-1,'MISSING','MISSING','MISSING')

	DECLARE @AdditionalTargetedSupportandImprovement TABLE
	(
		[AdditionalTargetedSupportandImprovementId] [int] NULL,
		[AdditionalTargetedSupportandImprovementCode] [varchar](50) NULL,
		[AdditionalTargetedSupportandImprovementDescription] [varchar](200) NULL,
		[AdditionalTargetedSupportandImprovementEdFactsCode] [varchar](50) NULL
	)

	INSERT INTO @AdditionalTargetedSupportandImprovement VALUES 
		(1,'ADDLTSI','Additional Targeted Support and Improvement','ADDLTSI'),
		(2,'NOTADDLTSI ','Not Additional Targeted Support and Improvement','NOTADDLTSI '),
		(-1,'MISSING','MISSING','MISSING')

--2018-19
	;WITH CTE AS ( 
			SELECT 
					-1		AS [ComprehensiveAndTargetedSupportId], 
				'MISSING'	AS [ComprehensiveAndTargetedSupportCode], 
				'MISSING'	AS [ComprehensiveAndTargetedSupportDescription],
				'MISSING'	AS [ComprehensiveAndTargetedSupportEdFactsCode],
				[ComprehensiveSupportId],
				[ComprehensiveSupportCode],
				[ComprehensiveSupportDescription],
				[ComprehensiveSupportEdFactsCode],
				[TargetedSupportId],
				[TargetedSupportCode],
				[TargetedSupportDescription],
				[TargetedSupportEdFactsCode],
					-1 AS	 [AdditionalTargetedSupportandImprovementId], 
				'MISSING' AS [AdditionalTargetedSupportandImprovementCode], 
				'MISSING' AS [AdditionalTargetedSupportandImprovementDescription],
				'MISSING' AS [AdditionalTargetedSupportandImprovementEdFactsCode],
				[ComprehensiveSupportImprovementId],
				[ComprehensiveSupportImprovementCode],
				[ComprehensiveSupportImprovementDescription],
				[ComprehensiveSupportImprovementEdFactsCode],
				[TargetedSupportImprovementId],
				[TargetedSupportImprovementCode],
				[TargetedSupportImprovementDescription],
				[TargetedSupportImprovementEdFactsCode]				 
			FROM @ComprehensiveSupportImprovement
			CROSS JOIN @TargetedSupportImprovement
			CROSS JOIN @TargetedSupport
			CROSS JOIN @ComprehensiveSupport
		)
		MERGE RDS.DimComprehensiveAndTargetedSupports AS trgt
		USING CTE AS src 
			ON	(
						trgt.[ComprehensiveSupportId]				= src.[ComprehensiveSupportId]
					AND trgt.[ComprehensiveSupportCode]				= src.[ComprehensiveSupportCode]
					AND trgt.[TargetedSupportId]					= src.[TargetedSupportId]
					AND trgt.[TargetedSupportCode]					= src.[TargetedSupportCode]
					AND trgt.[ComprehensiveSupportImprovementId]	= src.[ComprehensiveSupportImprovementId]
					AND trgt.[ComprehensiveSupportImprovementCode]	= src.[ComprehensiveSupportImprovementCode]
					AND trgt.[TargetedSupportImprovementId]			= src.[TargetedSupportImprovementId]
					AND trgt.[TargetedSupportImprovementCode]		= src.[TargetedSupportImprovementCode]
				)
		WHEN NOT MATCHED BY TARGET THEN
			 INSERT 
			(
				[ComprehensiveAndTargetedSupportId]
			   ,[ComprehensiveAndTargetedSupportCode]
			   ,[ComprehensiveAndTargetedSupportDescription]
			   ,[ComprehensiveAndTargetedSupportEdFactsCode]
			   ,[ComprehensiveSupportId]
			   ,[ComprehensiveSupportCode]
			   ,[ComprehensiveSupportDescription]
			   ,[ComprehensiveSupportEdFactsCode]
			   ,[TargetedSupportId]
			   ,[TargetedSupportCode]
			   ,[TargetedSupportDescription]
			   ,[TargetedSupportEdFactsCode]
			   ,[AdditionalTargetedSupportandImprovementId]
			   ,[AdditionalTargetedSupportandImprovementCode]
			   ,[AdditionalTargetedSupportandImprovementDescription]
			   ,[AdditionalTargetedSupportandImprovementEdFactsCode]
			   ,[ComprehensiveSupportImprovementId]
			   ,[ComprehensiveSupportImprovementCode]
			   ,[ComprehensiveSupportImprovementDescription]
			   ,[ComprehensiveSupportImprovementEdFactsCode]
			   ,[TargetedSupportImprovementId]
			   ,[TargetedSupportImprovementCode]
			   ,[TargetedSupportImprovementDescription]
			   ,[TargetedSupportImprovementEdFactsCode]
			)
			VALUES 
			( 
				src.[ComprehensiveAndTargetedSupportId]
			   ,src.[ComprehensiveAndTargetedSupportCode]
			   ,src.[ComprehensiveAndTargetedSupportDescription]
			   ,src.[ComprehensiveAndTargetedSupportEdFactsCode]
			   ,src.[ComprehensiveSupportId]
			   ,src.[ComprehensiveSupportCode]
			   ,src.[ComprehensiveSupportDescription]
			   ,src.[ComprehensiveSupportEdFactsCode]
			   ,src.[TargetedSupportId]
			   ,src.[TargetedSupportCode]
			   ,src.[TargetedSupportDescription]
			   ,src.[TargetedSupportEdFactsCode]
			   ,src.[AdditionalTargetedSupportandImprovementId]
			   ,src.[AdditionalTargetedSupportandImprovementCode]
			   ,src.[AdditionalTargetedSupportandImprovementDescription]
			   ,src.[AdditionalTargetedSupportandImprovementEdFactsCode]
			   ,src.[ComprehensiveSupportImprovementId]
			   ,src.[ComprehensiveSupportImprovementCode]
			   ,src.[ComprehensiveSupportImprovementDescription]
			   ,src.[ComprehensiveSupportImprovementEdFactsCode]
			   ,src.[TargetedSupportImprovementId]
			   ,src.[TargetedSupportImprovementCode]
			   ,src.[TargetedSupportImprovementDescription]
			   ,src.[TargetedSupportImprovementEdFactsCode]
			);


--2019-20
	;WITH CTE AS ( 
			SELECT 
					-1		AS [ComprehensiveAndTargetedSupportId], 
				'MISSING'	AS [ComprehensiveAndTargetedSupportCode], 
				'MISSING'	AS [ComprehensiveAndTargetedSupportDescription],
				'MISSING'	AS [ComprehensiveAndTargetedSupportEdFactsCode],
					-1		AS [ComprehensiveSupportId],
				'MISSING'	AS [ComprehensiveSupportCode],
				'MISSING'	AS [ComprehensiveSupportDescription],
				'MISSING'	AS [ComprehensiveSupportEdFactsCode],
					-1		AS [TargetedSupportId],
				'MISSING'	AS [TargetedSupportCode],
				'MISSING'	AS [TargetedSupportDescription],
				'MISSING'	AS [TargetedSupportEdFactsCode],
				[AdditionalTargetedSupportandImprovementId], 
				[AdditionalTargetedSupportandImprovementCode], 
				[AdditionalTargetedSupportandImprovementDescription],
				[AdditionalTargetedSupportandImprovementEdFactsCode],
				[ComprehensiveSupportImprovementId],
				[ComprehensiveSupportImprovementCode],
				[ComprehensiveSupportImprovementDescription],
				[ComprehensiveSupportImprovementEdFactsCode],
				[TargetedSupportImprovementId],
				[TargetedSupportImprovementCode],
				[TargetedSupportImprovementDescription],
				[TargetedSupportImprovementEdFactsCode]
			FROM @ComprehensiveSupportImprovement
			CROSS JOIN @TargetedSupportImprovement
			CROSS JOIN @AdditionalTargetedSupportandImprovement			
		)
		MERGE RDS.DimComprehensiveAndTargetedSupports as trgt
		USING CTE AS src 
			ON	(
						trgt.[AdditionalTargetedSupportandImprovementId]	= src.[AdditionalTargetedSupportandImprovementId]
					AND trgt.[AdditionalTargetedSupportandImprovementCode]	= src.[AdditionalTargetedSupportandImprovementCode]
					AND trgt.[ComprehensiveSupportImprovementId]			= src.[ComprehensiveSupportImprovementId]
					AND trgt.[ComprehensiveSupportImprovementCode]			= src.[ComprehensiveSupportImprovementCode]
					AND trgt.[TargetedSupportImprovementId]					= src.[TargetedSupportImprovementId]
					AND trgt.[TargetedSupportImprovementCode]				= src.[TargetedSupportImprovementCode]
				)
		WHEN NOT MATCHED BY TARGET THEN
			 INSERT 
			(
				[ComprehensiveAndTargetedSupportId]
			   ,[ComprehensiveAndTargetedSupportCode]
			   ,[ComprehensiveAndTargetedSupportDescription]
			   ,[ComprehensiveAndTargetedSupportEdFactsCode]
			   ,[ComprehensiveSupportId]
			   ,[ComprehensiveSupportCode]
			   ,[ComprehensiveSupportDescription]
			   ,[ComprehensiveSupportEdFactsCode]
			   ,[TargetedSupportId]
			   ,[TargetedSupportCode]
			   ,[TargetedSupportDescription]
			   ,[TargetedSupportEdFactsCode]
			   ,[AdditionalTargetedSupportandImprovementId]
			   ,[AdditionalTargetedSupportandImprovementCode]
			   ,[AdditionalTargetedSupportandImprovementDescription]
			   ,[AdditionalTargetedSupportandImprovementEdFactsCode]
			   ,[ComprehensiveSupportImprovementId]
			   ,[ComprehensiveSupportImprovementCode]
			   ,[ComprehensiveSupportImprovementDescription]
			   ,[ComprehensiveSupportImprovementEdFactsCode]
			   ,[TargetedSupportImprovementId]
			   ,[TargetedSupportImprovementCode]
			   ,[TargetedSupportImprovementDescription]
			   ,[TargetedSupportImprovementEdFactsCode]
			)
			VALUES 
			( 
				src.[ComprehensiveAndTargetedSupportId]
			   ,src.[ComprehensiveAndTargetedSupportCode]
			   ,src.[ComprehensiveAndTargetedSupportDescription]
			   ,src.[ComprehensiveAndTargetedSupportEdFactsCode]
			   ,src.[ComprehensiveSupportId]
			   ,src.[ComprehensiveSupportCode]
			   ,src.[ComprehensiveSupportDescription]
			   ,src.[ComprehensiveSupportEdFactsCode]
			   ,src.[TargetedSupportId]
			   ,src.[TargetedSupportCode]
			   ,src.[TargetedSupportDescription]
			   ,src.[TargetedSupportEdFactsCode]
			   ,src.[AdditionalTargetedSupportandImprovementId]
			   ,src.[AdditionalTargetedSupportandImprovementCode]
			   ,src.[AdditionalTargetedSupportandImprovementDescription]
			   ,src.[AdditionalTargetedSupportandImprovementEdFactsCode]
			   ,src.[ComprehensiveSupportImprovementId]
			   ,src.[ComprehensiveSupportImprovementCode]
			   ,src.[ComprehensiveSupportImprovementDescription]
			   ,src.[ComprehensiveSupportImprovementEdFactsCode]
			   ,src.[TargetedSupportImprovementId]
			   ,src.[TargetedSupportImprovementCode]
			   ,src.[TargetedSupportImprovementDescription]
			   ,src.[TargetedSupportImprovementEdFactsCode] 
			);


	SELECT @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'membership'
	SELECT @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimStudentStatuses'

	IF NOT EXISTS (select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
	BEGIN
		INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) VALUES (@factTypeId, @dimensionTableId)
	END

	
	UPDATE rds.DimStudentStatuses
	SET	
		NSLPDirectCertificationIndicatorCode = 'MISSING',
		NSLPDirectCertificationIndicatorDescription = 'Missing',
		NSLPDirectCertificationIndicatorEdFactsCode = 'MISSING',
		NSLPDirectCertificationIndicatorId = -1
	WHERE  DimStudentStatusId = -1

	IF EXISTS(SELECT 1 FROM rds.DimStudentStatuses where NSLPDirectCertificationIndicatorCode IS NULL)
	BEGIN
		UPDATE rds.DimStudentStatuses
			SET		
				NSLPDirectCertificationIndicatorCode = 'YES',
				NSLPDirectCertificationIndicatorDescription = 'Yes',
				NSLPDirectCertificationIndicatorEdFactsCode = 'YES',
				NSLPDirectCertificationIndicatorId = 1
			WHERE	DimStudentStatusId <> -1
	END

	IF NOT EXISTS(SELECT 1 FROM rds.DimStudentStatuses WHERE NSLPDirectCertificationIndicatorCode = 'NO')
	BEGIN
		INSERT INTO [RDS].[DimStudentStatuses]
		 (
			 [DiplomaCredentialTypeCode]
			,[DiplomaCredentialTypeDescription]
			,[DiplomaCredentialTypeEdFactsCode]
			,[DiplomaCredentialTypeId]
			,[MobilityStatus12moCode]
			,[MobilityStatus12moDescription]
			,[MobilityStatus12moEdFactsCode]
			,[MobilityStatus12moId]
			,[MobilityStatusSYCode]
			,[MobilityStatusSYDescription]
			,[MobilityStatusSYEdFactsCode]
			,[MobilityStatusSYId]
			,[ReferralStatusCode]
			,[ReferralStatusDescription]
			,[ReferralStatusEdFactsCode]
			,[ReferralStatusId]
			,[MobilityStatus36moCode]
			,[MobilityStatus36moDescription]
			,[MobilityStatus36moEdFactsCode]
			,[MobilityStatus36moId]
			,[PlacementStatusCode]
			,[PlacementStatusDescription]
			,[PlacementStatusEdFactsCode]
			,[PlacementStatusId]
			,[PlacementTypeCode]
			,[PlacementTypeDescription]
			,[PlacementTypeEdFactsCode]
			,[PlacementTypeId]
			,[NSLPDirectCertificationIndicatorCode]
			,[NSLPDirectCertificationIndicatorDescription]
			,[NSLPDirectCertificationIndicatorEdFactsCode]
			,[NSLPDirectCertificationIndicatorId]
		)     
		 SELECT 
			 [DiplomaCredentialTypeCode]
			,[DiplomaCredentialTypeDescription]
			,[DiplomaCredentialTypeEdFactsCode]
			,[DiplomaCredentialTypeId]
			,[MobilityStatus12moCode]
			,[MobilityStatus12moDescription]
			,[MobilityStatus12moEdFactsCode]
			,[MobilityStatus12moId]
			,[MobilityStatusSYCode]
			,[MobilityStatusSYDescription]
			,[MobilityStatusSYEdFactsCode]
			,[MobilityStatusSYId]
			,[ReferralStatusCode]
			,[ReferralStatusDescription]
			,[ReferralStatusEdFactsCode]
			,[ReferralStatusId]
			,[MobilityStatus36moCode]
			,[MobilityStatus36moDescription]
			,[MobilityStatus36moEdFactsCode]
			,[MobilityStatus36moId]
			,[PlacementStatusCode]
			,[PlacementStatusDescription]
			,[PlacementStatusEdFactsCode]
			,[PlacementStatusId]
			,[PlacementTypeCode]
			,[PlacementTypeDescription]
			,[PlacementTypeEdFactsCode]
			,[PlacementTypeId]
			,'NO'
			,'No'
			,'NO'
			,1
		FROM rds.DimStudentStatuses
		WHERE DimStudentStatusId <> -1	
	END

	IF NOT EXISTS(select 1 from rds.DimGradeLevels where GradeLevelCode = '13')
	BEGIN
		INSERT INTO [RDS].[DimGradeLevels]
				   ([GradeLevelCode]
				   ,[GradeLevelDescription]
				   ,[GradeLevelEdFactsCode]
				   ,[GradeLevelId])
		VALUES('13', 'Grade 13', '13', 18)

	END

	select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'homeless'

	select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'

	IF NOT EXISTS(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
	BEGIN
		INSERT INTO [RDS].[DimFactType_DimensionTables]([DimFactTypeId],[DimensionTableId])
		VALUES(@factTypeId, @dimensionTableId)
	END

	IF EXISTS (select 1 from rds.DimTitleiiiStatuses where TitleiiiLanguageInstructionEdFactsCode = 'LNGINSTPRGDU')
	BEGIN
		UPDATE rds.DimTitleiiiStatuses 
		SET TitleiiiLanguageInstructionEdFactsCode = 'LNGPRGDU' WHERE  TitleiiiLanguageInstructionEdFactsCode = 'LNGINSTPRGDU'	
	END

	IF EXISTS (select 1 from rds.DimTitleiiiStatuses where TitleiiiLanguageInstructionEdFactsCode = 'LNGINSTPRGBI')
	BEGIN
		UPDATE rds.DimTitleiiiStatuses 
		SET TitleiiiLanguageInstructionEdFactsCode = 'LNGPRGBI' WHERE  TitleiiiLanguageInstructionEdFactsCode = 'LNGINSTPRGBI'	
	END

	IF EXISTS (select 1 from rds.DimTitleiiiStatuses where TitleiiiLanguageInstructionEdFactsCode = 'LNGINSTPRGESLSUPP')
	BEGIN
		UPDATE rds.DimTitleiiiStatuses 
		SET TitleiiiLanguageInstructionEdFactsCode = 'LNGPRGESLSUPP' WHERE  TitleiiiLanguageInstructionEdFactsCode = 'LNGINSTPRGESLSUPP'	
	END

	IF EXISTS (select 1 from rds.DimTitleiiiStatuses where TitleiiiLanguageInstructionEdFactsCode = 'LNGINSTPRGESLELD')
	BEGIN
		UPDATE rds.DimTitleiiiStatuses 
		SET TitleiiiLanguageInstructionEdFactsCode = 'LNGPRGESLELD' WHERE  TitleiiiLanguageInstructionEdFactsCode = 'LNGINSTPRGESLELD'	
	END

	IF EXISTS (select 1 from rds.DimTitleiiiStatuses where TitleiiiLanguageInstructionEdFactsCode = 'LNGINSTPRGOTH')
	BEGIN
		UPDATE rds.DimTitleiiiStatuses 
		SET TitleiiiLanguageInstructionEdFactsCode = 'LNGPRGOTH' WHERE  TitleiiiLanguageInstructionEdFactsCode = 'LNGINSTPRGOTH'	
	END

	IF EXISTS (SELECT 1 FROM rds.DimTitleiiiStatuses WHERE titleiiiLanguageInstructionId = 11 AND titleiiiLanguageInstructionCode = 'Other' AND titleiiiLanguageInstructionEdFactsCode = 'LNGPRGOTH')
	BEGIN
		UPDATE rds.DimTitleiiiStatuses SET titleiiiLanguageInstructionId = 12 WHERE titleiiiLanguageInstructionId = 11 AND titleiiiLanguageInstructionCode = 'Other' AND titleiiiLanguageInstructionEdFactsCode = 'LNGPRGOTH'
	END

	DECLARE @formerEnglishLearnerYearStatusTable TABLE
	(
		formerEnglishLearnerYearStatusId INT,
		formerEnglishLearnerYearStatusCode VARCHAR(50),
		formerEnglishLearnerYearStatusDescription VARCHAR(200),
		formerEnglishLearnerYearStatusEdFactsCode VARCHAR(50)
	); 
		
	INSERT INTO @formerEnglishLearnerYearStatusTable (formerEnglishLearnerYearStatusId, formerEnglishLearnerYearStatusCode, formerEnglishLearnerYearStatusDescription, formerEnglishLearnerYearStatusEdFactsCode) 
	VALUES 
		(-1,'MISSING' , 'Missing' , 'MISSING'),
		(1, '1YEAR' , 'First Year' , '1YEAR'),
		(1, '2YEAR' , 'Second Year' , '2YEAR'),
		(1, '3YEAR' , 'Third Year' , '3YEAR'),
		(1, '4YEAR' , 'Fourth Year' , '4YEAR'),
		(1, '5YEAR' , 'Fifth Year' , '5YEAR')

	DECLARE @titleiiiAccountabilityProgressStatusTable TABLE
	(	
		titleiiiAccountabilityProgressStatusId INT,
		titleiiiAccountabilityProgressStatusCode VARCHAR(50),
		titleiiiAccountabilityProgressStatusDescription VARCHAR(200),
		titleiiiAccountabilityProgressStatusEdFactsCode VARCHAR(50)
	); 

	INSERT INTO @titleiiiAccountabilityProgressStatusTable (titleiiiAccountabilityProgressStatusId, titleiiiAccountabilityProgressStatusCode, titleiiiAccountabilityProgressStatusDescription, titleiiiAccountabilityProgressStatusEdFactsCode) 
	VALUES 
		(-1,'MISSING', 'Missing', 'MISSING'),
		(1, 'PROGRESS', 'Making progress', 'PROGRESS'),
		(2, 'NOPROGRESS', 'Did not make progress', 'NOPROGRESS'),
		(3, 'PROFICIENT', 'Attained proficiency', 'PROFICIENT')


	DECLARE @titleiiiLanguageInstructionTable TABLE
	(	
		titleiiiLanguageInstructionId INT,
		titleiiiLanguageInstructionCode VARCHAR(50),
		titleiiiLanguageInstructionDescription VARCHAR(200),
		titleiiiLanguageInstructionEdFactsCode VARCHAR(50)
	); 

	INSERT INTO @titleiiiLanguageInstructionTable (titleiiiLanguageInstructionId, titleiiiLanguageInstructionCode, titleiiiLanguageInstructionDescription, titleiiiLanguageInstructionEdFactsCode) 
	VALUES 
		(11, 'NewcomerPrograms', 'Newcomer Programs', 'LNGPRGNEW')

	DECLARE @proficiencyStatusTable TABLE
	(
		proficiencyStatusId INT,
		proficiencyStatusCode VARCHAR(50),
		proficiencyStatusDescription VARCHAR(200),
		proficiencyStatusEdFactsCode VARCHAR(50)
	); 

	INSERT INTO @proficiencyStatusTable (proficiencyStatusId, proficiencyStatusCode, proficiencyStatusDescription, proficiencyStatusEdFactsCode) 
	VALUES 
		(-1,'MISSING', 'Missing', 'MISSING'),
		(1, 'Proficient', 'The student''s scores were proficient', 'PROFICIENT'),
		(2, 'NotProficient', 'The student''s scores were NOT proficient.', 'NOTPROFICIENT')

	DECLARE @formerEnglishLearnerYearStatusId AS INT
	DECLARE @formerEnglishLearnerYearStatusCode AS VARCHAR(50)
	DECLARE @formerEnglishLearnerYearStatusDescription AS VARCHAR(200)
	DECLARE @formerEnglishLearnerYearStatusEdFactsCode AS VARCHAR(50)

	DECLARE @titleiiiAccountabilityProgressStatusId AS INT
	DECLARE @titleiiiAccountabilityProgressStatusCode AS VARCHAR(50)
	DECLARE @titleiiiAccountabilityProgressStatusDescription AS VARCHAR(200)
	DECLARE @titleiiiAccountabilityProgressStatusEdFactsCode AS VARCHAR(50)

	DECLARE @titleiiiLanguageInstructionId AS INT
	DECLARE @titleiiiLanguageInstructionCode AS VARCHAR(50)
	DECLARE @titleiiiLanguageInstructionDescription AS VARCHAR(200)
	DECLARE @titleiiiLanguageInstructionEdFactsCode AS VARCHAR(50)

	DECLARE @proficiencyStatusId AS INT
	DECLARE @proficiencyStatusCode AS VARCHAR(100)
	DECLARE @proficiencyStatusDescription AS VARCHAR(500)
	DECLARE @proficiencyStatusEdFactsCode AS VARCHAR(100)
		
	DECLARE DimTitleiiiStatuses_cursor CURSOR FOR 
		SELECT FormerEnglishLearnerYearStatusId, FormerEnglishLearnerYearStatusCode, 
				FormerEnglishLearnerYearStatusDescription, FormerEnglishLearnerYearStatusEdFactsCode,
				TitleiiiAccountabilityProgressStatusId, TitleiiiAccountabilityProgressStatusCode,                  
				TitleiiiAccountabilityProgressStatusDescription, TitleiiiAccountabilityProgressStatusEdFactsCode,
				TitleiiiLanguageInstructionId, TitleiiiLanguageInstructionCode, 
				TitleiiiLanguageInstructionDescription, TitleiiiLanguageInstructionEdFactsCode,
				proficiencyStatusId, proficiencyStatusCode, proficiencyStatusDescription, proficiencyStatusEdFactsCode
		FROM   @formerEnglishLearnerYearStatusTable
		CROSS JOIN @titleiiiAccountabilityProgressStatusTable
		CROSS JOIN @titleiiiLanguageInstructionTable
		CROSS JOIN @proficiencyStatusTable

		OPEN DimTitleiiiStatuses_cursor
		FETCH NEXT FROM DimTitleiiiStatuses_cursor INTO @formerEnglishLearnerYearStatusId, @formerEnglishLearnerYearStatusCode,
													@formerEnglishLearnerYearStatusDescription, @formerEnglishLearnerYearStatusEdFactsCode,
												@titleiiiAccountabilityProgressStatusId, @titleiiiAccountabilityProgressStatusCode, 
												@titleiiiAccountabilityProgressStatusDescription, 
												@titleiiiAccountabilityProgressStatusEdFactsCode,
												@titleiiiLanguageInstructionId, @titleiiiLanguageInstructionCode, 
												@titleiiiLanguageInstructionDescription, @titleiiiLanguageInstructionEdFactsCode,
												@proficiencyStatusId, @proficiencyStatusCode, @proficiencyStatusDescription, @proficiencyStatusEdFactsCode

		WHILE @@FETCH_STATUS = 0
		BEGIN

		IF NOT EXISTS(SELECT 1 FROM rds.DimTitleiiiStatuses 
						WHERE FormerEnglishLearnerYearStatusCode = @formerEnglishLearnerYearStatusCode 
						AND ProficiencyStatusCode =  @proficiencyStatusCode
						AND TitleiiiAccountabilityProgressStatusCode = @titleiiiAccountabilityProgressStatusCode 
						AND TitleiiiLanguageInstructionCode = @titleiiiLanguageInstructionCode)
		BEGIN

				INSERT INTO rds.DimTitleiiiStatuses
				(
					FormerEnglishLearnerYearStatusId, FormerEnglishLearnerYearStatusCode, 
					FormerEnglishLearnerYearStatusDescription,FormerEnglishLearnerYearStatusEdFactsCode,
					TitleiiiAccountabilityProgressStatusId, TitleiiiAccountabilityProgressStatusCode, 
					TitleiiiAccountabilityProgressStatusDescription, TitleiiiAccountabilityProgressStatusEdFactsCode,
					TitleiiiLanguageInstructionId, TitleiiiLanguageInstructionCode, 
					TitleiiiLanguageInstructionDescription, TitleiiiLanguageInstructionEdFactsCode,
					proficiencyStatusId, proficiencyStatusCode, proficiencyStatusDescription, proficiencyStatusEdFactsCode
				)
				VALUES
				(
					@formerEnglishLearnerYearStatusId, @formerEnglishLearnerYearStatusCode, 
					@formerEnglishLearnerYearStatusDescription, @formerEnglishLearnerYearStatusEdFactsCode,
					@titleiiiAccountabilityProgressStatusId, @titleiiiAccountabilityProgressStatusCode, 
					@titleiiiAccountabilityProgressStatusDescription, @titleiiiAccountabilityProgressStatusEdFactsCode,
					@titleiiiLanguageInstructionId, @titleiiiLanguageInstructionCode, 
					@titleiiiLanguageInstructionDescription, @titleiiiLanguageInstructionEdFactsCode,
					@proficiencyStatusId, @proficiencyStatusCode, @proficiencyStatusDescription, @proficiencyStatusEdFactsCode
				)
		END
		FETCH NEXT FROM DimTitleiiiStatuses_cursor INTO @formerEnglishLearnerYearStatusId, @formerEnglishLearnerYearStatusCode,
														@formerEnglishLearnerYearStatusDescription, @formerEnglishLearnerYearStatusEdFactsCode,
													@titleiiiAccountabilityProgressStatusId, @titleiiiAccountabilityProgressStatusCode, 
													@titleiiiAccountabilityProgressStatusDescription, 
													@titleiiiAccountabilityProgressStatusEdFactsCode,
													@titleiiiLanguageInstructionId, @titleiiiLanguageInstructionCode, 
													@titleiiiLanguageInstructionDescription, @titleiiiLanguageInstructionEdFactsCode,
													@proficiencyStatusId, @proficiencyStatusCode, @proficiencyStatusDescription, @proficiencyStatusEdFactsCode
		END

		CLOSE DimTitleiiiStatuses_cursor
		DEALLOCATE DimTitleiiiStatuses_cursor

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