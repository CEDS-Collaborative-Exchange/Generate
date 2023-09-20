CREATE PROCEDURE [Staging].[Staging-to-DimAssessments]
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION

		IF NOT EXISTS (SELECT 1 FROM RDS.DimAssessments WHERE DimAssessmentId = -1)
		BEGIN

			SET IDENTITY_INSERT RDS.DimAssessments ON

			INSERT INTO RDS.DimAssessments
				(DimAssessmentId)
			VALUES
				(-1)
	
			SET IDENTITY_INSERT RDS.DimAssessments off
		END

		IF OBJECT_ID(N'tempdb..#Assessments') IS NOT NULL DROP TABLE #Assessments
		CREATE TABLE #Assessments (
			AssessmentIdentifier										VARCHAR (50) 	NULL
			, AssessmentFamilyShortName									VARCHAR (100) 	NULL
			, AssessmentTitle											VARCHAR (100) 	NULL
			, AssessmentShortName										VARCHAR (100) 	NULL
			, AssessmentTypeCode										VARCHAR (100) 	NULL
			, AssessmentTypeDescription									VARCHAR (300) 	NULL
			, AssessmentAcademicSubjectCode								VARCHAR (100) 	NULL
			, AssessmentAcademicSubjectDescription						VARCHAR (300) 	NULL
			, AssessmentTypeAdministeredCode							VARCHAR (100) 	NULL
			, AssessmentTypeAdministeredDescription						VARCHAR (300) 	NULL
			, AssessmentTypeAdministeredToEnglishLearnersCode			VARCHAR (100) 	NULL
			, AssessmentTypeAdministeredToEnglishLearnersDescription	VARCHAR (300) 	NULL
		)
		
		INSERT INTO #Assessments (
			AssessmentIdentifier						
			, AssessmentFamilyShortName					
			, AssessmentTitle							
			, AssessmentShortName						
			, AssessmentTypeCode									
			, AssessmentTypeDescription								
			, AssessmentAcademicSubjectCode							
			, AssessmentAcademicSubjectDescription					
			, AssessmentTypeAdministeredCode						
			, AssessmentTypeAdministeredDescription					
			, AssessmentTypeAdministeredToEnglishLearnersCode		
			, AssessmentTypeAdministeredToEnglishLearnersDescription
		)		
		SELECT DISTINCT
			AssessmentIdentifier
			, AssessmentFamilyShortName
			, AssessmentTitle
			, AssessmentShortName
			, sssrd1.OutputCode					as AssessmentTypeCode
			, NULL								as AssessmentTypeDescription
			, sssrd2.OutputCode					as AssessmentAcademicSubjectCode
			, NULL								as AssessmentAcademicSubjectDescription
			, sssrd3.OutputCode					as AssessmentTypeAdministeredCode
			, NULL								as AssessmentTypeAdministeredDescription
			, sssrd4.OutputCode					as AssessmentTypeAdministeredToEnglishLearnersCode
			, NULL								as AssessmentTypeAdministeredToEnglishLearnersDescription
		FROM Staging.Assessment sa
		CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
		LEFT JOIN staging.SourceSystemReferenceData sssrd1
			ON sa.AssessmentType = sssrd1.InputCode
			AND sssrd1.TableName = 'RefAssessmentType'
			AND rsy.SchoolYear = sssrd1.SchoolYear
		LEFT JOIN staging.SourceSystemReferenceData sssrd2
			ON sa.AssessmentAcademicSubject = sssrd2.InputCode
			AND sssrd2.TableName = 'RefAcademicSubject'
			AND rsy.SchoolYear = sssrd2.SchoolYear
		LEFT JOIN staging.SourceSystemReferenceData sssrd3
			ON sa.AssessmentTypeAdministered = sssrd3.InputCode
			AND sssrd3.TableName = 'RefAssessmentTypeAdministered'
			AND rsy.SchoolYear = sssrd3.SchoolYear
		LEFT JOIN staging.SourceSystemReferenceData sssrd4
			ON sa.AssessmentTypeAdministeredToEnglishLearners = sssrd4.InputCode
			AND sssrd4.TableName = 'RefAssessmentTypeAdministeredToEnglishLearners'
			AND rsy.SchoolYear = sssrd4.SchoolYear

	--Add the AssessmentType Description	
		UPDATE a
		SET AssessmentTypeDescription = ccosm.CedsOptionSetDescription
		FROM #Assessments a
			INNER JOIN CEDS.CedsOptionSetMapping ccosm
				ON a.AssessmentTypeCode = ccosm.CedsOptionSetCode

	--Add the AssessmentAcademicSubject Description	
		UPDATE a
		SET AssessmentAcademicSubjectDescription = ccosm.CedsOptionSetDescription
		FROM #Assessments a
			INNER JOIN CEDS.CedsOptionSetMapping ccosm
				ON a.AssessmentAcademicSubjectCode = ccosm.CedsOptionSetCode

	--Add the AssessmentTypeAdministered Description	
		UPDATE a
		SET AssessmentTypeAdministeredDescription = ccosm.CedsOptionSetDescription
		FROM #Assessments a
			INNER JOIN CEDS.CedsOptionSetMapping ccosm
				ON a.AssessmentTypeAdministeredCode = ccosm.CedsOptionSetCode

	--Add the AssessmentTypeAdministeredToEnglishLearners Description	
		UPDATE a
		SET AssessmentTypeAdministeredToEnglishLearnersDescription = ccosm.CedsOptionSetDescription
		FROM #Assessments a
			INNER JOIN CEDS.CedsOptionSetMapping ccosm
				ON a.AssessmentTypeAdministeredToEnglishLearnersCode = ccosm.CedsOptionSetCode


		MERGE RDS.DimAssessments AS trgt
		USING #Assessments AS src
				ON  ISNULL(trgt.AssessmentIdentifierState, '') = ISNULL(src.AssessmentIdentifier, '')
				AND ISNULL(trgt.AssessmentFamilyShortName, '') = ISNULL(src.AssessmentFamilyShortName, '')
				AND ISNULL(trgt.AssessmentTitle, '') = ISNULL(src.AssessmentTitle, '')
				AND ISNULL(trgt.AssessmentShortName, '') = ISNULL(src.AssessmentShortName, '')
				AND ISNULL(trgt.AssessmentTypeCode, '') = ISNULL(src.AssessmentTypeCode, '')
				AND ISNULL(trgt.AssessmentTypeDescription, '') = ISNULL(src.AssessmentTypeDescription, '')
				AND ISNULL(trgt.AssessmentAcademicSubjectCode, '') = ISNULL(src.AssessmentAcademicSubjectCode, '')
				AND ISNULL(trgt.AssessmentAcademicSubjectDescription, '') = ISNULL(src.AssessmentAcademicSubjectDescription, '')
				AND ISNULL(trgt.AssessmentTypeAdministeredCode, '') = ISNULL(src.AssessmentTypeAdministeredCode, '')
				AND ISNULL(trgt.AssessmentTypeAdministeredDescription, '') = ISNULL(src.AssessmentTypeAdministeredDescription, '')
				AND ISNULL(trgt.AssessmentTypeAdministeredToEnglishLearnersCode, '') = ISNULL(src.AssessmentTypeAdministeredToEnglishLearnersCode, '')
				AND ISNULL(trgt.AssessmentTypeAdministeredToEnglishLearnersDescription, '') = ISNULL(src.AssessmentTypeAdministeredToEnglishLearnersDescription, '')
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but NOT in Target
		INSERT (
			AssessmentIdentifierState
			, AssessmentFamilyShortName
			, AssessmentTitle
			, AssessmentShortName
			, AssessmentTypeCode									
			, AssessmentTypeDescription								
			, AssessmentAcademicSubjectCode							
			, AssessmentAcademicSubjectDescription					
			, AssessmentTypeAdministeredCode						
			, AssessmentTypeAdministeredDescription					
			, AssessmentTypeAdministeredToEnglishLearnersCode		
			, AssessmentTypeAdministeredToEnglishLearnersDescription
		)
		VALUES (
			  src.AssessmentIdentifier
			, src.AssessmentFamilyShortName
			, src.AssessmentTitle
			, src.AssessmentShortName
			, src.AssessmentTypeCode									
			, src.AssessmentTypeDescription								
			, src.AssessmentAcademicSubjectCode							
			, src.AssessmentAcademicSubjectDescription					
			, src.AssessmentTypeAdministeredCode						
			, src.AssessmentTypeAdministeredDescription					
			, src.AssessmentTypeAdministeredToEnglishLearnersCode		
			, src.AssessmentTypeAdministeredToEnglishLearnersDescription
		);

		ALTER INDEX ALL ON RDS.DimAssessments REBUILD

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