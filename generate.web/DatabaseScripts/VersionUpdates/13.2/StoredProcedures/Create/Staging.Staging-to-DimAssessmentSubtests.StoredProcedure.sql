CREATE PROCEDURE [Staging].[Staging-to-DimAssessmentSubtests]
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION

		IF NOT EXISTS (SELECT 1 FROM RDS.DimAssessmentSubtests WHERE DimAssessmentSubtestId = -1)
		BEGIN

			SET IDENTITY_INSERT RDS.DimAssessmentSubtests ON

			INSERT INTO RDS.DimAssessmentSubtests
				(DimAssessmentSubtestId)
			VALUES
				(-1)
	
			SET IDENTITY_INSERT RDS.DimAssessmentSubtests off
		END

		IF OBJECT_ID(N'tempdb..#AssessmentSubtests') IS NOT NULL DROP TABLE #AssessmentSubtests
		CREATE TABLE #AssessmentSubtests (
			AssessmentFormNumber							nvarchar(30)	NULL
			, AssessmentAcademicSubjectCode					nvarchar(100)	NULL
			, AssessmentAcademicSubjectDescription			nvarchar(400)	NULL
			, AssessmentSubtestIdentifierInternal			nvarchar(40)	NULL
			, AssessmentSubtestTitle						nvarchar(40)	NULL
			, AssessmentSubtestAbbreviation 				nvarchar(40)	NULL
			, AssessmentSubtestDescription					nvarchar(40)	NULL
			, AssessmentSubtestVersion						nvarchar(40)	NULL
			, AssessmentLevelForWhichDesigned				nvarchar(40)	NULL
			, AssessmentEarlyLearningDevelopmentalDomain	nvarchar(40)	NULL
			, AssessmentSubtestPublishedDate				datetime		NULL
			, AssessmentSubtestMinimumValue 				nvarchar(40)	NULL
			, AssessmentSubtestMaximumValue					nvarchar(40)	NULL
			, AssessmentSubtestScaleOptimalValue			nvarchar(40)	NULL
			, AssessmentContentStandardType 				nvarchar(40)	NULL
			, AssessmentPurpose								nvarchar(40)	NULL
			, AssessmentSubtestRules						nvarchar(40)	NULL
			, AssessmentFormSubtestTier						nvarchar(40)	NULL
			, AssessmentFormSubtestContainerOnly			nvarchar(40)	NULL
		)
		
		INSERT INTO #AssessmentSubtests (
			AssessmentFormNumber						
			, AssessmentAcademicSubjectCode				
			, AssessmentAcademicSubjectDescription		
			, AssessmentSubtestIdentifierInternal		
			, AssessmentSubtestTitle					
			, AssessmentSubtestAbbreviation 			
			, AssessmentSubtestDescription				
			, AssessmentSubtestVersion					
			, AssessmentLevelForWhichDesigned			
			, AssessmentEarlyLearningDevelopmentalDomain
			, AssessmentSubtestPublishedDate			
			, AssessmentSubtestMinimumValue 			
			, AssessmentSubtestMaximumValue				
			, AssessmentSubtestScaleOptimalValue		
			, AssessmentContentStandardType 			
			, AssessmentPurpose							
			, AssessmentSubtestRules					
			, AssessmentFormSubtestTier					
			, AssessmentFormSubtestContainerOnly		
		)		
		SELECT DISTINCT
			NULL as AssessmentFormNumber						
			, sssrd1.OutputCode						as AssessmentAcademicSubjectCode
			, NULL									as AssessmentAcademicSubjectDescription		
			, AssessmentIdentifier					as AssessmentSubtestIdentifierInternal		
			, NULL									as AssessmentSubtestTitle					
			, NULL									as AssessmentSubtestAbbreviation 			
			, NULL									as AssessmentSubtestDescription				
			, NULL									as AssessmentSubtestVersion					
			, NULL									as AssessmentLevelForWhichDesigned			
			, NULL									as AssessmentEarlyLearningDevelopmentalDomain
			, NULL									as AssessmentSubtestPublishedDate			
			, NULL									as AssessmentSubtestMinimumValue 			
			, NULL									as AssessmentSubtestMaximumValue				
			, NULL									as AssessmentSubtestScaleOptimalValue		
			, NULL									as AssessmentContentStandardType 			
			, sssrd2.OutputCode						as AssessmentPurpose	
			, NULL									as AssessmentSubtestRules					
			, NULL									as AssessmentFormSubtestTier					
			, NULL									as AssessmentFormSubtestContainerOnly		
		FROM Staging.Assessment sa
		CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
		LEFT JOIN staging.SourceSystemReferenceData sssrd1
			ON sa.AssessmentAcademicSubject = sssrd1.InputCode
			AND sssrd1.TableName = 'RefAcademicSubject'
			AND rsy.SchoolYear = sssrd1.SchoolYear
		LEFT JOIN staging.SourceSystemReferenceData sssrd2
			ON sa.AssessmentTypeAdministered = sssrd2.InputCode
			AND sssrd2.TableName = 'RefAssessmentPurpose'
			AND rsy.SchoolYear = sssrd2.SchoolYear

	--Add the AssessmentAcademicSubject Description and EDFacts Code	
		UPDATE a
		SET AssessmentAcademicSubjectDescription = ccosm.CedsOptionSetDescription
		FROM #AssessmentSubtests a
			INNER JOIN CEDS.CedsOptionSetMapping ccosm
				ON a.AssessmentAcademicSubjectCode = ccosm.CedsOptionSetCode


		MERGE RDS.DimAssessmentSubtests AS trgt
		USING #AssessmentSubtests AS src
				ON  ISNULL(trgt.AssessmentSubtestIdentifierInternal, '') = ISNULL(src.AssessmentSubtestIdentifierInternal, '')
				AND ISNULL(trgt.AssessmentAcademicSubjectCode, '') = ISNULL(src.AssessmentAcademicSubjectCode, '')
				AND ISNULL(trgt.AssessmentPurpose, '') = ISNULL(src.AssessmentPurpose, '')
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but NOT in Target
		INSERT (
			AssessmentFormNumber
			, AssessmentAcademicSubjectCode				
			, AssessmentAcademicSubjectDescription		
			, AssessmentSubtestIdentifierInternal		
			, AssessmentSubtestTitle					
			, AssessmentSubtestAbbreviation 			
			, AssessmentSubtestDescription				
			, AssessmentSubtestVersion					
			, AssessmentLevelForWhichDesigned			
			, AssessmentEarlyLearningDevelopmentalDomain
			, AssessmentSubtestPublishedDate			
			, AssessmentSubtestMinimumValue 			
			, AssessmentSubtestMaximumValue				
			, AssessmentSubtestScaleOptimalValue		
			, AssessmentContentStandardType 			
			, AssessmentPurpose							
			, AssessmentSubtestRules					
			, AssessmentFormSubtestTier					
			, AssessmentFormSubtestContainerOnly			)
		VALUES (
			src.AssessmentFormNumber
			, src.AssessmentAcademicSubjectCode				
			, src.AssessmentAcademicSubjectDescription		
			, src.AssessmentSubtestIdentifierInternal		
			, src.AssessmentSubtestTitle					
			, src.AssessmentSubtestAbbreviation 			
			, src.AssessmentSubtestDescription				
			, src.AssessmentSubtestVersion					
			, src.AssessmentLevelForWhichDesigned			
			, src.AssessmentEarlyLearningDevelopmentalDomain
			, src.AssessmentSubtestPublishedDate			
			, src.AssessmentSubtestMinimumValue 			
			, src.AssessmentSubtestMaximumValue				
			, src.AssessmentSubtestScaleOptimalValue		
			, src.AssessmentContentStandardType 			
			, src.AssessmentPurpose							
			, src.AssessmentSubtestRules					
			, src.AssessmentFormSubtestTier					
			, src.AssessmentFormSubtestContainerOnly		
		);

		ALTER INDEX ALL ON RDS.DimAssessmentSubtests REBUILD

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

END