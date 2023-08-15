BEGIN TRY
    BEGIN TRANSACTION

    IF NOT EXISTS
    (
	   SELECT 1 FROM   [RDS].[DimComprehensiveSupportReasonApplicabilities] [d] WHERE [d].[ComprehensiveSupportReasonApplicabilityCode] = 'MISSING'
    )
	   BEGIN
		  SET IDENTITY_INSERT [RDS].[DimComprehensiveSupportReasonApplicabilities] ON

		  INSERT INTO [RDS].[DimComprehensiveSupportReasonApplicabilities]
		  ([DimComprehensiveSupportReasonApplicabilityId]
		  ,[ComprehensiveSupportReasonApplicabilityId]
		  ,[ComprehensiveSupportReasonApplicabilityCode]
		  ,[ComprehensiveSupportReasonApplicabilityDescription]
		  ,[ComprehensiveSupportReasonApplicabilityEdFactsCode]
		  )
		  VALUES
		  (-1
		  ,-1
		  ,'MISSING'
		  ,'MISSING'
		  ,'MISSING'
		  )

		  SET IDENTITY_INSERT [RDS].[DimComprehensiveSupportReasonApplicabilities] OFF
    END

    DECLARE @ReasonApplicability TABLE
    (
	   [ComprehensiveSupportReasonApplicabilityId]          INT
	  ,[ComprehensiveSupportReasonApplicabilityCode]        VARCHAR(50)
	  ,[ComprehensiveSupportReasonApplicabilityDescription] VARCHAR(200)
	  ,[ComprehensiveSupportReasonApplicabilityEdFactsCode] VARCHAR(50)
    )

    INSERT INTO @ReasonApplicability
    ([ComprehensiveSupportReasonApplicabilityId]
    ,[ComprehensiveSupportReasonApplicabilityCode]
    ,[ComprehensiveSupportReasonApplicabilityDescription]
    ,[ComprehensiveSupportReasonApplicabilityEdFactsCode]
    )
    SELECT [ComprehensiveSupportReasonApplicabilityId] = RefComprehensiveSupportReasonApplicabilityId
    ,[ComprehensiveSupportReasonApplicabilityCode] = Code
    ,[ComprehensiveSupportReasonApplicabilityDescription] = Description
    ,[ComprehensiveSupportReasonApplicabilityEdFactsCode] = CASE Code
												    WHEN 'ReasonApplies' THEN 'RESNAPPLYES'
												    WHEN 'ReasonDoesNotApply' THEN 'RESNAPPLNO'
												END
    FROM dbo.RefComprehensiveSupportReasonApplicability

    INSERT INTO [RDS].[DimComprehensiveSupportReasonApplicabilities]
    ([ComprehensiveSupportReasonApplicabilityId]
    ,[ComprehensiveSupportReasonApplicabilityCode]
    ,[ComprehensiveSupportReasonApplicabilityDescription]
    ,[ComprehensiveSupportReasonApplicabilityEdFactsCode]
    )
    SELECT [ra].[ComprehensiveSupportReasonApplicabilityId]
		,[ra].[ComprehensiveSupportReasonApplicabilityCode]
		,[ra].[ComprehensiveSupportReasonApplicabilityDescription]
		,[ra].[ComprehensiveSupportReasonApplicabilityEdFactsCode]
    FROM   @ReasonApplicability [ra]
		 LEFT JOIN [RDS].[DimComprehensiveSupportReasonApplicabilities] [d] ON [ra].[ComprehensiveSupportReasonApplicabilityCode] = [d].[ComprehensiveSupportReasonApplicabilityCode]
    WHERE  [d].[DimComprehensiveSupportReasonApplicabilityId] IS NULL

    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
	   BEGIN
		  ROLLBACK TRANSACTION
    END;
    THROW;
END CATCH