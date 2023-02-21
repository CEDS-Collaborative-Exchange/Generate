-- DimAssessments

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION

	DECLARE @DimAssessmentsTable TABLE(
		[AssessmentSubjectCode] [nvarchar](50) NULL,
		[AssessmentSubjectDescription] [nvarchar](200) NULL,
		[AssessmentSubjectEdFactsCode] [nvarchar](50) NULL,
		[AssessmentSubjectId] [int] NULL,
		[AssessmentTypeCode] [nvarchar](50) NULL,
		[AssessmentTypeDescription] [nvarchar](200) NULL,
		[AssessmentTypeEdFactsCode] [nvarchar](50) NULL,
		[AssessmentTypeId] [int] NULL,
		[LeaFullYearStatusCode] [nvarchar](50) NULL,
		[LeaFullYearStatusDescription] [nvarchar](200) NULL,
		[LeaFullYearStatusEdFactsCode] [nvarchar](50) NULL,
		[LeaFullYearStatusId] [int] NULL,
		[ParticipationStatusCode] [nvarchar](50) NULL,
		[ParticipationStatusDescription] [nvarchar](200) NULL,
		[ParticipationStatusEdFactsCode] [nvarchar](50) NULL,
		[ParticipationStatusId] [int] NULL,
		[PerformanceLevelCode] [nvarchar](50) NULL,
		[PerformanceLevelDescription] [nvarchar](200) NULL,
		[PerformanceLevelEdFactsCode] [nvarchar](50) NULL,
		[PerformanceLevelId] [int] NULL,
		[SchFullYearStatusCode] [nvarchar](50) NULL,
		[SchFullYearStatusDescription] [nvarchar](200) NULL,
		[SchFullYearStatusEdFactsCode] [nvarchar](50) NULL,
		[SchFullYearStatusId] [int] NULL,
		[SeaFullYearStatusCode] [nvarchar](50) NULL,
		[SeaFullYearStatusDescription] [nvarchar](200) NULL,
		[SeaFullYearStatusEdFactsCode] [nvarchar](50) NULL,
		[SeaFullYearStatusId] [int] NULL
	)

	INSERT INTO @DimAssessmentsTable
    (		[AssessmentSubjectCode]
           ,[AssessmentSubjectDescription]
           ,[AssessmentSubjectEdFactsCode]
           ,[AssessmentSubjectId]
           ,[AssessmentTypeCode]
           ,[AssessmentTypeDescription]
           ,[AssessmentTypeEdFactsCode]
           ,[AssessmentTypeId]
           ,[LeaFullYearStatusCode]
           ,[LeaFullYearStatusDescription]
           ,[LeaFullYearStatusEdFactsCode]
           ,[LeaFullYearStatusId]
           ,[ParticipationStatusCode]
           ,[ParticipationStatusDescription]
           ,[ParticipationStatusEdFactsCode]
           ,[ParticipationStatusId]
           ,[PerformanceLevelCode]
           ,[PerformanceLevelDescription]
           ,[PerformanceLevelEdFactsCode]
           ,[PerformanceLevelId]
           ,[SchFullYearStatusCode]
           ,[SchFullYearStatusDescription]
           ,[SchFullYearStatusEdFactsCode]
           ,[SchFullYearStatusId]
           ,[SeaFullYearStatusCode]
           ,[SeaFullYearStatusDescription]
           ,[SeaFullYearStatusEdFactsCode]
           ,[SeaFullYearStatusId]
    )
	(
		SELECT 
			[AssessmentSubjectCode]
		  ,[AssessmentSubjectDescription]
		  ,[AssessmentSubjectEdFactsCode]
		  ,[AssessmentSubjectId]
		  ,[AssessmentTypeCode]
		  ,[AssessmentTypeDescription]
		  ,[AssessmentTypeEdFactsCode]
		  ,[AssessmentTypeId]
		  ,[LeaFullYearStatusCode]
		  ,[LeaFullYearStatusDescription]
		  ,[LeaFullYearStatusEdFactsCode]
		  ,[LeaFullYearStatusId]
		  ,[ParticipationStatusCode]
		  ,[ParticipationStatusDescription]
		  ,[ParticipationStatusEdFactsCode]
		  ,[ParticipationStatusId]
		  ,[PerformanceLevelCode]
		  ,[PerformanceLevelDescription]
		  ,[PerformanceLevelEdFactsCode]
		  ,[PerformanceLevelId]
		  ,[SchFullYearStatusCode]
		  ,[SchFullYearStatusDescription]
		  ,[SchFullYearStatusEdFactsCode]
		  ,[SchFullYearStatusId]
		  ,[SeaFullYearStatusCode]
		  ,[SeaFullYearStatusDescription]
		  ,[SeaFullYearStatusEdFactsCode]
		  ,[SeaFullYearStatusId]
	  FROM [RDS].[DimAssessments]
	  WHERE DimAssessmentId <> -1
	)


	UPDATE [RDS].[DimAssessments] 
	SET [AssessmentTypeAdministeredToEnglishLearnersCode] = 'MISSING'
      ,[AssessmentTypeAdministeredToEnglishLearnersDescription] = 'Missing'
      ,[AssessmentTypeAdministeredToEnglishLearnersEdFactsCode] = 'MISSING'
      ,[AssessmentTypeAdministeredToEnglishLearnersId] = -1
	WHERE [DimAssessmentId] = -1

	DECLARE @AssessmentTypeAdministeredToEnglishLearnersCode AS VARCHAR(50)
	DECLARE @AssessmentTypeAdministeredToEnglishLearnersDescription AS VARCHAR(200)
	DECLARE @AssessmentTypeAdministeredToEnglishLearnersEdFactsCode AS VARCHAR(50)
	DECLARE @AssessmentTypeAdministeredToEnglishLearnersId AS INT

	DECLARE @AssessmentTypeAdministeredToEnglishLearnersTable TABLE(
		AssessmentTypeAdministeredToEnglishLearnersCode VARCHAR(50),
		AssessmentTypeAdministeredToEnglishLearnersDescription VARCHAR(200),
		AssessmentTypeAdministeredToEnglishLearnersEdFactsCode VARCHAR(50),
		AssessmentTypeAdministeredToEnglishLearnersId INT
	); 	

	INSERT INTO @AssessmentTypeAdministeredToEnglishLearnersTable 
	(
		AssessmentTypeAdministeredToEnglishLearnersCode, 
		AssessmentTypeAdministeredToEnglishLearnersDescription, 
		AssessmentTypeAdministeredToEnglishLearnersEdFactsCode, 
		AssessmentTypeAdministeredToEnglishLearnersId
	) 
	VALUES ('MISSING', 'Missing', 'MISSING',-1)

	INSERT INTO @AssessmentTypeAdministeredToEnglishLearnersTable 
	(
		AssessmentTypeAdministeredToEnglishLearnersCode, 
		AssessmentTypeAdministeredToEnglishLearnersDescription, 
		AssessmentTypeAdministeredToEnglishLearnersEdFactsCode, 
		AssessmentTypeAdministeredToEnglishLearnersId
	) 
	(
		SELECT	Code,
				[Description],
				Code,
				RefAssessmentTypeAdministeredToEnglishLearnersId
		FROM dbo.RefAssessmentTypeAdministeredToEnglishLearners
	)
		
	-- Loop through cursors
	DECLARE AssessmentTypeAdministeredToEnglishLearners_cursor CURSOR FOR 
	SELECT AssessmentTypeAdministeredToEnglishLearnersCode, 
		AssessmentTypeAdministeredToEnglishLearnersDescription, 
		AssessmentTypeAdministeredToEnglishLearnersEdFactsCode, 
		AssessmentTypeAdministeredToEnglishLearnersId
	FROM @AssessmentTypeAdministeredToEnglishLearnersTable

	OPEN AssessmentTypeAdministeredToEnglishLearners_cursor
	FETCH NEXT FROM AssessmentTypeAdministeredToEnglishLearners_cursor 
		INTO @AssessmentTypeAdministeredToEnglishLearnersCode,
			@AssessmentTypeAdministeredToEnglishLearnersDescription,
			@AssessmentTypeAdministeredToEnglishLearnersEdFactsCode,
			@AssessmentTypeAdministeredToEnglishLearnersId
																			
	WHILE @@FETCH_STATUS = 0												
	BEGIN	

	IF NOT EXISTS (SELECT 1 FROM [RDS].[DimAssessments] 
					WHERE [AssessmentTypeAdministeredToEnglishLearnersCode] = @AssessmentTypeAdministeredToEnglishLearnersCode
					AND [AssessmentTypeAdministeredToEnglishLearnersEdFactsCode] = @AssessmentTypeAdministeredToEnglishLearnersEdFactsCode
					AND [AssessmentTypeAdministeredToEnglishLearnersId] = @AssessmentTypeAdministeredToEnglishLearnersId
					AND [DimAssessmentId] <> -1)
	BEGIN

		IF @AssessmentTypeAdministeredToEnglishLearnersId = -1 
		BEGIN
			

			UPDATE [RDS].[DimAssessments]
			SET [AssessmentTypeAdministeredToEnglishLearnersCode] = @AssessmentTypeAdministeredToEnglishLearnersCode
			,[AssessmentTypeAdministeredToEnglishLearnersDescription] = @AssessmentTypeAdministeredToEnglishLearnersDescription
			,[AssessmentTypeAdministeredToEnglishLearnersEdFactsCode] = @AssessmentTypeAdministeredToEnglishLearnersEdFactsCode
			,[AssessmentTypeAdministeredToEnglishLearnersId] = @AssessmentTypeAdministeredToEnglishLearnersId
			WHERE DimAssessmentId <> -1

		END
		ELSE 
		BEGIN
			INSERT INTO [RDS].[DimAssessments]
			   ([AssessmentSubjectCode]
			   ,[AssessmentSubjectDescription]
			   ,[AssessmentSubjectEdFactsCode]
			   ,[AssessmentSubjectId]
			   ,[AssessmentTypeCode]
			   ,[AssessmentTypeDescription]
			   ,[AssessmentTypeEdFactsCode]
			   ,[AssessmentTypeId]
			   ,[LeaFullYearStatusCode]
			   ,[LeaFullYearStatusDescription]
			   ,[LeaFullYearStatusEdFactsCode]
			   ,[LeaFullYearStatusId]
			   ,[ParticipationStatusCode]
			   ,[ParticipationStatusDescription]
			   ,[ParticipationStatusEdFactsCode]
			   ,[ParticipationStatusId]
			   ,[PerformanceLevelCode]
			   ,[PerformanceLevelDescription]
			   ,[PerformanceLevelEdFactsCode]
			   ,[PerformanceLevelId]
			   ,[SchFullYearStatusCode]
			   ,[SchFullYearStatusDescription]
			   ,[SchFullYearStatusEdFactsCode]
			   ,[SchFullYearStatusId]
			   ,[SeaFullYearStatusCode]
			   ,[SeaFullYearStatusDescription]
			   ,[SeaFullYearStatusEdFactsCode]
			   ,[SeaFullYearStatusId]
			   ,[AssessmentTypeAdministeredToEnglishLearnersCode]
			   ,[AssessmentTypeAdministeredToEnglishLearnersDescription]
			   ,[AssessmentTypeAdministeredToEnglishLearnersEdFactsCode]
			   ,[AssessmentTypeAdministeredToEnglishLearnersId]
			)
		   (
				SELECT 
					[AssessmentSubjectCode]
				  ,[AssessmentSubjectDescription]
				  ,[AssessmentSubjectEdFactsCode]
				  ,[AssessmentSubjectId]
				  ,[AssessmentTypeCode]
				  ,[AssessmentTypeDescription]
				  ,[AssessmentTypeEdFactsCode]
				  ,[AssessmentTypeId]
				  ,[LeaFullYearStatusCode]
				  ,[LeaFullYearStatusDescription]
				  ,[LeaFullYearStatusEdFactsCode]
				  ,[LeaFullYearStatusId]
				  ,[ParticipationStatusCode]
				  ,[ParticipationStatusDescription]
				  ,[ParticipationStatusEdFactsCode]
				  ,[ParticipationStatusId]
				  ,[PerformanceLevelCode]
				  ,[PerformanceLevelDescription]
				  ,[PerformanceLevelEdFactsCode]
				  ,[PerformanceLevelId]
				  ,[SchFullYearStatusCode]
				  ,[SchFullYearStatusDescription]
				  ,[SchFullYearStatusEdFactsCode]
				  ,[SchFullYearStatusId]
				  ,[SeaFullYearStatusCode]
				  ,[SeaFullYearStatusDescription]
				  ,[SeaFullYearStatusEdFactsCode]
				  ,[SeaFullYearStatusId]
				  ,@AssessmentTypeAdministeredToEnglishLearnersCode
				  ,@AssessmentTypeAdministeredToEnglishLearnersDescription
				  ,@AssessmentTypeAdministeredToEnglishLearnersEdFactsCode
				  ,@AssessmentTypeAdministeredToEnglishLearnersId
			  FROM @DimAssessmentsTable
		   )
		END


	END
	


	FETCH NEXT FROM AssessmentTypeAdministeredToEnglishLearners_cursor 
		INTO @AssessmentTypeAdministeredToEnglishLearnersCode,
			@AssessmentTypeAdministeredToEnglishLearnersDescription,
			@AssessmentTypeAdministeredToEnglishLearnersEdFactsCode,
			@AssessmentTypeAdministeredToEnglishLearnersId

	END

	CLOSE AssessmentTypeAdministeredToEnglishLearners_cursor
	DEALLOCATE AssessmentTypeAdministeredToEnglishLearners_cursor





	COMMIT TRANSACTION

END TRY
BEGIN CATCH

	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION
	END

	DECLARE @msg AS NVARCHAR(MAX)
	SET @msg = ERROR_MESSAGE()

	DECLARE @sev AS INT
	SET @sev = ERROR_SEVERITY()

	RAISERROR(@msg, @sev, 1)

END CATCH

SET NOCOUNT OFF;