-- Metadata changes for the RDS schema
----------------------------------
set nocount on
begin try
	begin transaction	

	/*CIID-4446 Add ADDLTSIEXIT to FS206*/
		
		--TRUNCATE TABLE rds.DimComprehensiveAndTargetedSupports
				
				
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
		(2,'NOTADDLTSI','Not Additional Targeted Support and Improvement','NOTADDLTSI '),
		(3,'ADDLTSIEXIT','Additional Targeted Support and Improvement - Exit Status','ADDLTSIEXIT'), /*added per CIID-4445*/
		(-1,'MISSING','MISSING','MISSING')


--2019-20
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
			CROSS JOIN @ComprehensiveSupport
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

--2021-22
	WITH CTE AS ( 
			SELECT 
					-1		AS [ComprehensiveAndTargetedSupportId], 
				'MISSING'	AS [ComprehensiveAndTargetedSupportCode], 
				'MISSING'	AS [ComprehensiveAndTargetedSupportDescription],
				'MISSING'	AS [ComprehensiveAndTargetedSupportEdFactsCode],
				[ComprehensiveSupportId],
				[ComprehensiveSupportCode],
				[ComprehensiveSupportDescription],
				[ComprehensiveSupportEdFactsCode],
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
			CROSS JOIN @ComprehensiveSupport
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

		    /*CIID-4447 Add USETH to subgroups*/
			IF NOT EXISTS
			(
			   SELECT 1 FROM   [RDS].[DimSubgroups] [d] WHERE [d].[SubgroupCode] = 'MISSING'
			)
			   BEGIN
				  SET IDENTITY_INSERT [RDS].[DimSubgroups] ON

				  INSERT INTO [RDS].[DimSubgroups]
				  ([DimSubgroupId]
				  ,[SubgroupId]
				  ,[SubgroupCode]
				  ,[SubgroupDescription]
				  ,[SubgroupEdFactsCode]
				  )
				  VALUES
				  (-1
				  ,-1
				  ,'MISSING'
				  ,'MISSING'
				  ,'MISSING'
				  )

				  SET IDENTITY_INSERT [RDS].[DimSubgroups] OFF
			END

			DECLARE @Subgroup TABLE
			(
			   [SubgroupId]          INT
			  ,[SubgroupCode]        VARCHAR(50)
			  ,[SubgroupDescription] VARCHAR(200)
			  ,[SubgroupEdFactsCode] VARCHAR(50)
			)

			INSERT INTO @Subgroup
			([SubgroupId]
			,[SubgroupCode]
			,[SubgroupDescription]
			,[SubgroupEdFactsCode]
			)
			SELECT [SubgroupId] = RefSubgroupID
			   ,[SubgroupCode] = Code
			   ,[SubgroupDescription] = Description
			   ,[SubgroupEdFactsCode] = CASE Code 
									 WHEN 'EconomicDisadvantage' THEN 'ECODIS'
									 WHEN 'IDEA' THEN 'WDIS'
									 WHEN 'LEP' THEN 'LEP'
									 WHEN 'AmericanIndianorAlaskaNative' THEN 'MAN'
									 WHEN 'Asian' THEN 'Asian'
									 WHEN 'AsianPacificIslander' THEN 'MAP'
									 WHEN 'BlackorAfricanAmerican' THEN 'MB'
									 WHEN 'Filipino' THEN 'MF'
									 WHEN 'HispanicNotPurtoRican' THEN 'MHN'
									 WHEN 'HispanicLatino' THEN 'MHL'
									 WHEN 'TwoorMoreRaces' THEN 'MM'
									 WHEN 'NativeHawaiianorOtherPacificIslander' THEN 'MNP'
									 WHEN 'PuertoRican' THEN 'MPR'
									 WHEN 'White' THEN 'MW'
									 WHEN 'UnderservedRaceEthnicity' THEN 'USETH' /*Added per CIID-4447*/
								  END
			FROM dbo.RefSubgroup

			INSERT INTO [RDS].[DimSubgroups]
			([SubgroupId]
			,[SubgroupCode]
			,[SubgroupDescription]
			,[SubgroupEdFactsCode]
			)
			SELECT [sg].[SubgroupId]
				,[sg].[SubgroupCode]
				,[sg].[SubgroupDescription]
				,[sg].[SubgroupEdFactsCode]
			FROM   @Subgroup [sg]
				 LEFT JOIN [RDS].[DimSubgroups] [d] ON [sg].[SubgroupCode] = [d].[SubgroupCode]
			WHERE  [d].[DimSubgroupId] IS NULL

			INSERT INTO [RDS].[DimK12StudentStatuses]
			([HighSchoolDiplomaTypeCode]
			,[HighSchoolDiplomaTypeDescription]
			,[HighSchoolDiplomaTypeEdFactsCode]
			,[HighSchoolDiplomaTypeId]
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
			,[NSLPDirectCertificationIndicatorId])
			select correctData.HighSchoolDiplomaTypeCode, correctData.HighSchoolDiplomaTypeDescription, correctData.HighSchoolDiplomaTypeEdFactsCode, correctData.HighSchoolDiplomaTypeId,
			correctData.MobilityStatus12moCode, correctData.MobilityStatus12moDescription, correctData.MobilityStatus12moEdFactsCode, correctData.MobilityStatus12moId,
			correctData.MobilityStatusSYCode,correctData.MobilityStatusSYDescription, correctData.MobilityStatusSYEdFactsCode,correctData.MobilityStatusSYId,
			correctData.ReferralStatusCode, correctData.ReferralStatusDescription, correctData.ReferralStatusEdFactsCode, correctData.ReferralStatusId,
			correctData.MobilityStatus36moCode, correctData.MobilityStatus36moDescription,correctData.MobilityStatus36moEdFactsCode,correctData.MobilityStatus36moId,
			correctData.PlacementStatusCode, correctData.PlacementStatusDescription, correctData.PlacementStatusEdFactsCode, correctData.PlacementStatusId,
			correctData.PlacementTypeCode, correctData.PlacementTypeDescription,correctData.PlacementTypeEdFactsCode,correctData.PlacementTypeId,
			correctData.NSLPDirectCertificationIndicatorCode, correctData.NSLPDirectCertificationIndicatorDescription, correctData.NSLPDirectCertificationIndicatorEdFactsCode, correctData.NSLPDirectCertificationIndicatorId
			from
			(select * from
			(select distinct HighSchoolDiplomaTypeCode, HighSchoolDiplomaTypeDescription, HighSchoolDiplomaTypeEdFactsCode, HighSchoolDiplomaTypeId from rds.DimK12StudentStatuses) a
			Cross Join (select distinct MobilityStatus12moCode, MobilityStatus12moDescription, MobilityStatus12moEdFactsCode, MobilityStatus12moId from rds.DimK12StudentStatuses) b
			Cross Join (select distinct MobilityStatusSYCode, MobilityStatusSYDescription, MobilityStatusSYEdFactsCode, MobilityStatusSYId from rds.DimK12StudentStatuses) c
			Cross Join (select distinct ReferralStatusCode, ReferralStatusDescription, ReferralStatusEdFactsCode, ReferralStatusId from rds.DimK12StudentStatuses) d
			Cross Join (select distinct MobilityStatus36moCode, MobilityStatus36moDescription, MobilityStatus36moEdFactsCode, MobilityStatus36moId from rds.DimK12StudentStatuses) e
			Cross Join (select distinct PlacementStatusCode, PlacementStatusDescription, PlacementStatusEdFactsCode, PlacementStatusId from rds.DimK12StudentStatuses) f
			Cross Join (select distinct PlacementTypeCode, PlacementTypeDescription, PlacementTypeEdFactsCode, PlacementTypeId from rds.DimK12StudentStatuses) g
			Cross Join (select distinct NSLPDirectCertificationIndicatorCode, NSLPDirectCertificationIndicatorDescription, NSLPDirectCertificationIndicatorEdFactsCode, NSLPDirectCertificationIndicatorId from rds.DimK12StudentStatuses) h) correctData
			left outer join
			(select * from rds.DimK12StudentStatuses) existingData
			on correctData.HighSchoolDiplomaTypeCode = existingData.HighSchoolDiplomaTypeCode
			and correctData.MobilityStatus12moCode = existingData.MobilityStatus12moCode
			and correctData.MobilityStatusSYCode = existingData.MobilityStatusSYCode
			and correctData.ReferralStatusCode = existingData.ReferralStatusCode
			and correctData.MobilityStatus36moCode = existingData.MobilityStatus36moCode
			and correctData.PlacementStatusCode = existingData.PlacementStatusCode
			and correctData.PlacementTypeCode = existingData.PlacementTypeCode
			and correctData.NSLPDirectCertificationIndicatorCode = existingData.NSLPDirectCertificationIndicatorCode
			where existingData.HighSchoolDiplomaTypeCode IS NULL
			or existingData.MobilityStatus12moCode IS NULL
			or existingData.MobilityStatusSYCode IS NULL
			or existingData.ReferralStatusCode IS NULL
			or existingData.MobilityStatus36moCode IS NULL
			or existingData.PlacementStatusCode IS NULL
			or existingData.PlacementTypeCode IS NULL
			or existingData.NSLPDirectCertificationIndicatorCode IS NULL



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