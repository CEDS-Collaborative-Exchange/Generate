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
			, AssessmentTypeEdFactsCode									VARCHAR (100) 	NULL
			, AssessmentAcademicSubjectCode								VARCHAR (100) 	NULL
			, AssessmentAcademicSubjectDescription						VARCHAR (300) 	NULL
			, AssessmentAcademicSubjectEdFactsCode						VARCHAR (50) 	NULL
			, AssessmentTypeAdministeredCode							VARCHAR (100) 	NULL
			, AssessmentTypeAdministeredDescription						VARCHAR (300) 	NULL
			, AssessmentTypeAdministeredEdFactsCode						VARCHAR (100) 	NULL
			, AssessmentTypeAdministeredToEnglishLearnersCode			VARCHAR (100) 	NULL
			, AssessmentTypeAdministeredToEnglishLearnersDescription	VARCHAR (300) 	NULL
			, AssessmentTypeAdministeredToEnglishLearnersEdFactsCode	VARCHAR (100) 	NULL
		)
		
		INSERT INTO #Assessments (
			AssessmentIdentifier						
			, AssessmentFamilyShortName					
			, AssessmentTitle							
			, AssessmentShortName						
			, AssessmentTypeCode									
			, AssessmentTypeDescription	
			, AssessmentTypeEdFactsCode							
			, AssessmentAcademicSubjectCode							
			, AssessmentAcademicSubjectDescription	
			, AssessmentAcademicSubjectEdFactsCode				
			, AssessmentTypeAdministeredCode						
			, AssessmentTypeAdministeredDescription
			, AssessmentTypeAdministeredEdFactsCode					
			, AssessmentTypeAdministeredToEnglishLearnersCode		
			, AssessmentTypeAdministeredToEnglishLearnersDescription
			, AssessmentTypeAdministeredToEnglishLearnersEdFactsCode
		)		
		SELECT DISTINCT
			AssessmentIdentifier
			, AssessmentFamilyShortName
			, AssessmentTitle
			, AssessmentShortName
			, sssrd1.OutputCode					as AssessmentTypeCode
			, NULL								as AssessmentTypeDescription
			, sssrd1.OutputCode					as AssessmentTypeEdFactsCode
			, sssrd2.OutputCode					as AssessmentAcademicSubjectCode
			, NULL								as AssessmentAcademicSubjectDescription
			, NULL								as AssessmentAcademicSubjecteEdFactsCode
			, sssrd3.OutputCode					as AssessmentTypeAdministeredCode
			, NULL								as AssessmentTypeAdministeredDescription
			, NULL								as AssessmentTypeAdministeredEdFactsCode
			, sssrd4.OutputCode					as AssessmentTypeAdministeredToEnglishLearnersCode
			, NULL								as AssessmentTypeAdministeredToEnglishLearnersDescription
			, NULL								as AssessmentTypeAdministeredToEnglishLearnersEdFactsCode
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
		--AssessmentType EDFacts Code is handled in the code above by using the CEDS Output code from SSRD
		UPDATE a
		SET AssessmentTypeDescription = ccosm.CedsOptionSetDescription
		FROM #Assessments a
			INNER JOIN CEDS.CedsOptionSetMapping ccosm
				ON a.AssessmentTypeCode = ccosm.CedsOptionSetCode

	--Add the AssessmentAcademicSubject Description and EDFacts Code	
		UPDATE a
		SET AssessmentAcademicSubjectDescription = ccosm.CedsOptionSetDescription,
			assessmentAcademicSubjectEdFactsCode = 
				CASE AssessmentAcademicSubjectCode
					WHEN '01166' THEN 'M'
					WHEN '13373' THEN 'RLA'
					ELSE 'MISSING'
				END
		FROM #Assessments a
			INNER JOIN CEDS.CedsOptionSetMapping ccosm
				ON a.AssessmentAcademicSubjectCode = ccosm.CedsOptionSetCode

	--Add the AssessmentTypeAdministered Description and EDFacts Code	
		UPDATE a
		SET AssessmentTypeAdministeredDescription = ccosm.CedsOptionSetDescription,
			AssessmentTypeAdministeredEdFactsCode = 
				CASE AssessmentTypeAdministeredCode
					WHEN 'REGASSWOACC'		THEN 'REGASSWOACC'
					WHEN 'REGASSWACC'		THEN 'REGASSWACC'	
					WHEN 'ALTASSALTACH'		THEN 'ALTASSALTACH'
					WHEN 'HSREGASMTIWOACC'	THEN 'HSREGASMTIWOACC'
					WHEN 'HSREGASMTIWACC'	THEN 'HSREGASMTIWACC'	
					WHEN 'HSREGASMT2WOACC'	THEN 'HSREGASMT2WOACC'	
					WHEN 'HSREGASMT2WACC'	THEN 'HSREGASMT2WACC'	
					WHEN 'HSREGASMT3WOACC'	THEN 'HSREGASMT3WOACC'	
					WHEN 'HSREGASMT3WACC'	THEN 'HSREGASMT3WACC'	
					WHEN 'LSNRHSASMTWOACC'	THEN 'LSNRHSASMTWOACC'	
					WHEN 'LSNRHSASMTWACC'	THEN 'LSNRHSASMTWACC'	
					ELSE 'MISSING'
				END
		FROM #Assessments a
			INNER JOIN CEDS.CedsOptionSetMapping ccosm
				ON a.AssessmentTypeAdministeredCode = ccosm.CedsOptionSetCode

	--Add the AssessmentTypeAdministeredToEnglishLearners Description and EDFacts Code	
		UPDATE a
		SET AssessmentTypeAdministeredToEnglishLearnersDescription = ccosm.CedsOptionSetDescription,
			AssessmentTypeAdministeredToEnglishLearnersEdFactsCode =
				CASE AssessmentTypeAdministeredToEnglishLearnersCode
					WHEN 'REGELPASMNT' THEN 'REGELPASMNT'
					WHEN 'ALTELPASMNTALT' THEN 'ALTELPASMNTALT'
					ELSE 'MISSING'
				END
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
				AND ISNULL(trgt.AssessmentAcademicSubjectCode, '') = ISNULL(src.AssessmentAcademicSubjectCode, '')
				AND ISNULL(trgt.AssessmentTypeAdministeredCode, '') = ISNULL(src.AssessmentTypeAdministeredCode, '')
				AND ISNULL(trgt.AssessmentTypeAdministeredToEnglishLearnersCode, '') = ISNULL(src.AssessmentTypeAdministeredToEnglishLearnersCode, '')
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but NOT in Target
		INSERT (
			AssessmentIdentifierState
			, AssessmentFamilyShortName
			, AssessmentTitle
			, AssessmentShortName
			, AssessmentTypeCode									
			, AssessmentTypeDescription
			, AssessmentTypeEdFactsCode
			, AssessmentAcademicSubjectCode							
			, AssessmentAcademicSubjectDescription
			, AssessmentAcademicSubjectEdFactsCode
			, AssessmentTypeAdministeredCode						
			, AssessmentTypeAdministeredDescription
			, AssessmentTypeAdministeredEdFactsCode
			, AssessmentTypeAdministeredToEnglishLearnersCode		
			, AssessmentTypeAdministeredToEnglishLearnersDescription
			, AssessmentTypeAdministeredToEnglishLearnersEdFactsCode
		)
		VALUES (
			  src.AssessmentIdentifier
			, src.AssessmentFamilyShortName
			, src.AssessmentTitle
			, src.AssessmentShortName
			, src.AssessmentTypeCode									
			, src.AssessmentTypeDescription
			, src.AssessmentTypeEdFactsCode
			, src.AssessmentAcademicSubjectCode							
			, src.AssessmentAcademicSubjectDescription
			, src.AssessmentAcademicSubjectEdFactsCode
			, src.AssessmentTypeAdministeredCode						
			, src.AssessmentTypeAdministeredDescription
			, src.AssessmentTypeAdministeredEdFactsCode
			, src.AssessmentTypeAdministeredToEnglishLearnersCode		
			, src.AssessmentTypeAdministeredToEnglishLearnersDescription
			, src.AssessmentTypeAdministeredToEnglishLearnersEdFactsCode
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