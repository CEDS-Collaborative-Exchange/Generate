BEGIN TRY
    BEGIN TRANSACTION

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

    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
	   BEGIN
		  ROLLBACK TRANSACTION
    END;
    THROW;
END CATCH