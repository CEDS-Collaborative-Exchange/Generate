CREATE PROCEDURE [App].[FS175_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

BEGIN TRY
	BEGIN TRANSACTION

	DECLARE @UnitTestName VARCHAR(100) = 'FS175_UnitTestCase'
	DECLARE @AssessmentAcademicSubject VARCHAR(10) = '01166' 
	DECLARE @StoredProcedureName VARCHAR(100) = 'FS175_TestCase'
	DECLARE @TestScope VARCHAR(1000) = 'FS175'
	DECLARE @ReportCode VARCHAR(20) = 'C175'
	DECLARE @SubjectAbbrv VARCHAR(20) = 'MATH'
 
		-- Define the test
		DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
		IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = @UnitTestName) 
		BEGIN
			SET @expectedResult = 1
			INSERT INTO App.SqlUnitTest 
			(
				  [UnitTestName]
				, [StoredProcedureName]
				, [TestScope]
				, [IsActive]
			)
			VALUES 
			(
				  @UnitTestName
				, @StoredProcedureName				
				, @TestScope
				, 1
			)
			SET @SqlUnitTestId = SCOPE_IDENTITY()
		END 
		ELSE 
		BEGIN
			SELECT 
				@SqlUnitTestId = SqlUnitTestId
			--, @expectedResult = ExpectedResult 
			FROM App.SqlUnitTest 
			WHERE UnitTestName = @UnitTestName
		END

		-- Clear out last run
		DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
	
		-- Create base data set

		-- Get Custom Child Count Date

		--DROP TABLE IF EXISTS #staging 

		IF OBJECT_ID('tempdb..#staging') IS NOT NULL
		DROP TABLE #staging

		DECLARE @ChildCountDate DATETIME

		SELECT @ChildCountDate = CAST('10/01/' + cast(@SchoolYear - 1 AS Varchar(4)) AS DATETIME)


		
		SELECT 
			asr.[Student_Identifier_State],
			asr.[LEA_Identifier_State],
			asr.[School_Identifier_State],
			a.[AssessmentTitle],
			a.[AssessmentAcademicSubject],
			a.[AssessmentPurpose],
			[ProficiencyStatus] = CASE WHEN CAST(RIGHT(a.AssessmentPerformanceLevelIdentifier,1) AS INT) < ta.ProficientOrAboveLevel THEN 'NOTPROFICIENT' ELSE 'PROFICIENT' END,
			a.[AssessmentPerformanceLevelIdentifier],
			a.[AssessmentTypeAdministeredToChildrenWithDisabilities],
			asr.[GradeLevelWhenAssessed],
			ds.[AssessmentTypeEdFactsCode],
			ds.[PerformanceLevelEdFactsCode],
			rdr.[RaceEdFactsCode],
			ske.[Sex],
			[DisabilityStatusEdFactsCode] = CASE WHEN sps.IDEAIndicator = 1 THEN 'WDIS' ELSE 'MISSING' END,
			[EnglishLearnerStatusEdFactsCode] = CASE WHEN sps.EnglishLearnerStatus = 1 THEN 'LEP' ELSE 'MISSING' END,
			[EconomicDisadvantageStatusEdFactsCode] = CASE WHEN sps.EconomicDisadvantageStatus = 1 THEN 'ECODIS' ELSE 'MISSING' END,
			[MigrantStatusEdFactsCode] = CASE WHEN sps.MigrantStatus = 1 THEN 'MS' ELSE 'MISSING' END,
			[HomelessnessStatusEdFactsCode] = CASE WHEN sps.HomelessnessStatus = 1 THEN 'HOMELSENRL' ELSE 'MISSING' END,
			[ProgramType_FosterCareEdFactsCode] = CASE WHEN sps.ProgramType_FosterCare = 1 THEN 'FCS' ELSE 'MISSING' END,
			[MilitaryConnectedStudentIndicatorEdFactsCode] = CASE WHEN sps.MilitaryConnectedStudentIndicator = 1 THEN 'MILCNCTD' ELSE 'MISSING' END 
		INTO #staging
		FROM Staging.Assessment a		
		INNER JOIN Staging.AssessmentResult asr 
			ON a.AssessmentTitle = asr.AssessmentTitle
			AND a.AssessmentAcademicSubject = asr.AssessmentAcademicSubject
			AND a.AssessmentPurpose = asr.AssessmentPurpose
			AND a.AssessmentPerformanceLevelIdentifier = asr.AssessmentPerformanceLevelIdentifier
			AND a.AssessmentTypeAdministeredToChildrenWithDisabilities = asr.AssessmentTypeAdministeredToChildrenWithDisabilities
		INNER JOIN Staging.PersonStatus sps
			ON sps.Student_Identifier_State = asr.Student_Identifier_State
			AND sps.LEA_Identifier_State = asr.LEA_Identifier_State
			AND sps.School_Identifier_State = asr.School_Identifier_State
		INNER JOIN Staging.K12Enrollment ske
			ON sps.Student_Identifier_State = ske.Student_Identifier_State
			AND sps.LEA_Identifier_State = ske.LEA_Identifier_State
			AND sps.School_Identifier_State = ske.School_Identifier_State
		LEFT JOIN Staging.ProgramParticipationSpecialEducation sppse
			ON sppse.Student_Identifier_State = asr.Student_Identifier_State
			AND sppse.LEA_Identifier_State = asr.LEA_Identifier_State
			AND sppse.School_Identifier_State = asr.School_Identifier_State
		LEFT JOIN Staging.PersonRace spr
			ON spr.Student_Identifier_State = asr.Student_Identifier_State
			AND spr.SchoolYear = asr.SchoolYear
			AND sppse.ProgramParticipationEndDate BETWEEN spr.RecordStartDateTime AND ISNULL(spr.RecordEndDateTime, GETDATE())
		LEFT JOIN RDS.DimRaces rdr
			ON (ske.HispanicLatinoEthnicity = 1 and rdr.RaceEdFactsCode = 'HI7')
				OR (ske.HispanicLatinoEthnicity = 0 AND spr.RaceType = rdr.RaceCode)
		LEFT JOIN rds.DimGradeLevels dgl
			ON dgl.GradeLevelCode = asr.GradeLevelWhenAssessed
		INNER JOIN RDS.DimIdeaStatuses rdis
			ON sps.PrimaryDisabilityType = rdis.PrimaryDisabilityTypeCode
			AND sppse.SpecialEducationExitReason = rdis.SpecialEducationExitReasonCode
		INNER JOIN (
						SELECT DISTINCT 
							AssessmentSubjectCode,AssessmentSubjectEdFactsCode,
							AssessmentTypeCode,AssessmentTypeEdFactsCode,
							PerformanceLevelCode,PerformanceLevelEdFactsCode
						FROM rds.DimAssessments
					) ds
			ON a.AssessmentAcademicSubject = ds.AssessmentSubjectCode
			AND a.AssessmentTypeAdministeredToChildrenWithDisabilities = ds.AssessmentTypeCode
			AND a.AssessmentPerformanceLevelIdentifier = ds.PerformanceLevelCode
		INNER JOIN App.ToggleAssessments ta
			ON ds.AssessmentTypeEdFactsCode = ta.AssessmentTypeCode
		WHERE sppse.ProgramParticipationEndDate IS NOT NULL
			AND sppse.IDEAEducationalEnvironmentForSchoolAge <> 'PPPS'
			AND asr.SchoolYear = @SchoolYear
			AND a.AssessmentAcademicSubject = @AssessmentAcademicSubject
			AND ta.[Subject] = @SubjectAbbrv

--SEA--------------------------------------------------------------------------------------------------
		/* Test Case 1: 
			CSA at the SEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,RaceEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC1
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,RaceEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSA SEA Match All'
			,'CSA SEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed  
								  + '; Race Ethnicity: ' + s.RaceEdFactsCode  
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC1 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SEA'
			AND sar.CategorySetCode = 'CSA'
	
		DROP TABLE #TC1

		/* Test Case 2: 
			CSB at the SEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,Sex
			, COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC2
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,Sex
		

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSB SEA Match All'
			,'CSB SEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed  
								  + '; Sex Membership: ' + s.Sex 
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC2 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SEA'
			AND sar.CategorySetCode = 'CSB'
	
		DROP TABLE #TC2

		/* Test Case 3: 
			CSC at the SEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,DisabilityStatusEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC3
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,DisabilityStatusEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSC SEA Match All'
			,'CSC SEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed 
								  + '; Disability Status ' + S.DisabilityStatusEdFactsCode
								  
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC3 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SEA'
			AND sar.CategorySetCode = 'CSC'
	
		DROP TABLE #TC3

		/* Test Case 4: 
			CSD at the SEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,EnglishLearnerStatusEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC4
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,EnglishLearnerStatusEdFactsCode
		

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSD SEA Match All'
			,'CSD SEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed 
								  + '; EnglishLearner Status: ' + s.EnglishLearnerStatusEdFactsCode 
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC4 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SEA'
			AND sar.CategorySetCode = 'CSD'
	
		DROP TABLE #TC4

		/* Test Case 5: 
			CSE at the SEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,EconomicDisadvantageStatusEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC5
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,EconomicDisadvantageStatusEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSE SEA Match All'
			,'CSE SEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed 
								  + '; Economic Disadvantage Status: ' + s.EconomicDisadvantageStatusEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC5 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SEA'
			AND sar.CategorySetCode = 'CSE'
	
		DROP TABLE #TC5

		/* Test Case 6: 
			CSF at the SEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,MigrantStatusEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC6
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,MigrantStatusEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSF SEA Match All'
			,'CSF SEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
								  + '; Migrant Status: ' + s.MigrantStatusEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC6 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SEA'
			AND sar.CategorySetCode = 'CSF'
	
		DROP TABLE #TC6

		/* Test Case 7: 
			CSG at the SEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,HomelessnessStatusEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC7
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,HomelessnessStatusEdFactsCode
		

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSG SEA Match All'
			,'CSG SEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
								  + '; Homelessness Status: ' + s.HomelessnessStatusEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC7 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SEA'
			AND sar.CategorySetCode = 'CSG'
	
		DROP TABLE #TC7
		
		/* Test Case 8: 
			CSH at the SEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,ProgramType_FosterCareEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC8
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,ProgramType_FosterCareEdFactsCode
		

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSH SEA Match All'
			,'CSH SEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
								  + '; Foster Care: ' + s.ProgramType_FosterCareEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC8 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SEA'
			AND sar.CategorySetCode = 'CSG'
	
		DROP TABLE #TC8

		/* Test Case 9: 
			CSI at the SEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,MilitaryConnectedStudentIndicatorEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC9
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,MilitaryConnectedStudentIndicatorEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSI SEA Match All'
			,'CSI SEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
								  + '; Military Connected Student: ' + s.MilitaryConnectedStudentIndicatorEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC9 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SEA'
			AND sar.CategorySetCode = 'CSI'
	
		DROP TABLE #TC9

--LEA--------------------------------------------------------------------------------------------------

		/* Test Case 10: 
			CSA at the LEA level */

		SELECT 
			  AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,RaceEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC10
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,RaceEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSA LEA Match All'
			,'CSA LEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed  
								  + '; Race Ethnicity: ' + s.RaceEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC10 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'LEA'
			AND sar.CategorySetCode = 'CSA'
	
		DROP TABLE #TC10

		/* Test Case 11: 
			CSB at the LEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,Sex
			, COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC11
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,Sex
		

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSB LEA Match All'
			,'CSB LEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed  
								  + '; Sex Membership: ' + s.Sex
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC11 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'LEA'
			AND sar.CategorySetCode = 'CSB'
	
		DROP TABLE #TC11

		/* Test Case 12: 
			CSC at the LEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,DisabilityStatusEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC12
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,DisabilityStatusEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSC LEA Match All'
			,'CSC LEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed 
								  + '; Disability Status ' + S.DisabilityStatusEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC12 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'LEA'
			AND sar.CategorySetCode = 'CSC'
	
		DROP TABLE #TC12

		/* Test Case 13: 
			CSD at the LEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,EnglishLearnerStatusEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC13
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,EnglishLearnerStatusEdFactsCode
		

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSD LEA Match All'
			,'CSD LEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed 
								  + '; EnglishLearner Status: ' + s.EnglishLearnerStatusEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC13 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'LEA'
			AND sar.CategorySetCode = 'CSD'
	
		DROP TABLE #TC13

		/* Test Case 14: 
			CSE at the LEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,EconomicDisadvantageStatusEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC14
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,EconomicDisadvantageStatusEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSE LEA Match All'
			,'CSE LEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed 
								  + '; Economic Disadvantage Status: ' + s.EconomicDisadvantageStatusEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC14 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'LEA'
			AND sar.CategorySetCode = 'CSE'
	
		DROP TABLE #TC14

		/* Test Case 15: 
			CSF at the LEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,MigrantStatusEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC15
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,MigrantStatusEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSF LEA Match All'
			,'CSF LEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
								  + '; Migrant Status: ' + s.MigrantStatusEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC15 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'LEA'
			AND sar.CategorySetCode = 'CSF'
	
		DROP TABLE #TC15

		/* Test Case 16: 
			CSG at the LEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,HomelessnessStatusEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC16
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,HomelessnessStatusEdFactsCode
		

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSG LEA Match All'
			,'CSG LEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
								  + '; Homelessness Status: ' + s.HomelessnessStatusEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC16 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'LEA'
			AND sar.CategorySetCode = 'CSG'
	
		DROP TABLE #TC16
		
		/* Test Case 17: 
			CSH at the LEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,ProgramType_FosterCareEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC17
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,ProgramType_FosterCareEdFactsCode
		

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSH LEA Match All'
			,'CSH LEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
								  + '; Foster Care: ' + s.ProgramType_FosterCareEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC17 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'LEA'
			AND sar.CategorySetCode = 'CSG'
	
		DROP TABLE #TC17

		/* Test Case 18: 
			CSI at the LEA level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,MilitaryConnectedStudentIndicatorEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC18
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,MilitaryConnectedStudentIndicatorEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSI LEA Match All'
			,'CSI LEA Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
								  + '; Military Connected Student: ' + s.MilitaryConnectedStudentIndicatorEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC18 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'LEA'
			AND sar.CategorySetCode = 'CSI'
	
		DROP TABLE #TC18

--SCH------------------------------------------------------------------------------------------------------

/* Test Case 19: 
			CSA at the SCH level */

		SELECT 
			  AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,RaceEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC19
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,RaceEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSA SCH Match All'
			,'CSA SCH Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed  
								  + '; Race Ethnicity: ' + s.RaceEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC19 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SCH'
			AND sar.CategorySetCode = 'CSA'
	
		DROP TABLE #TC19

		/* Test Case 20: 
			CSB at the SCH level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,Sex
			, COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC20
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,Sex
		

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSB SCH Match All'
			,'CSB SCH Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed  
								  + '; Sex Membership: ' + s.Sex
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC20 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SCH'
			AND sar.CategorySetCode = 'CSB'
	
		DROP TABLE #TC20

		/* Test Case 21: 
			CSC at the SCH level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,DisabilityStatusEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC21
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,DisabilityStatusEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSC SCH Match All'
			,'CSC SCH Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed 
								  + '; Disability Status ' + S.DisabilityStatusEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC21 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SCH'
			AND sar.CategorySetCode = 'CSC'
	
		DROP TABLE #TC21

		/* Test Case 22: 
			CSD at the SCH level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,EnglishLearnerStatusEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC22
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,EnglishLearnerStatusEdFactsCode
		

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSD SCH Match All'
			,'CSD SCH Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed 
								  + '; EnglishLearner Status: ' + s.EnglishLearnerStatusEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC22 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SCH'
			AND sar.CategorySetCode = 'CSD'
	
		DROP TABLE #TC22

		/* Test Case 23: 
			CSE at the SCH level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,EconomicDisadvantageStatusEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC23
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,EconomicDisadvantageStatusEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSE SCH Match All'
			,'CSE SCH Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed 
								  + '; Economic Disadvantage Status: ' + s.EconomicDisadvantageStatusEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC23 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SCH'
			AND sar.CategorySetCode = 'CSE'
	
		DROP TABLE #TC23

		/* Test Case 24: 
			CSF at the SCH level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,MigrantStatusEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC24
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,MigrantStatusEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSF SCH Match All'
			,'CSF SCH Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
								  + '; Migrant Status: ' + s.MigrantStatusEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC24 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SCH'
			AND sar.CategorySetCode = 'CSF'
	
		DROP TABLE #TC24

		/* Test Case 25: 
			CSG at the SCH level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,HomelessnessStatusEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC25
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,HomelessnessStatusEdFactsCode
		

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSG SCH Match All'
			,'CSG SCH Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
								  + '; Homelessness Status: ' + s.HomelessnessStatusEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC25 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SCH'
			AND sar.CategorySetCode = 'CSG'
	
		DROP TABLE #TC25
		
		/* Test Case 26: 
			CSH at the SCH level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,ProgramType_FosterCareEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC26
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,ProgramType_FosterCareEdFactsCode
		

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSH SCH Match All'
			,'CSH SCH Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
								  + '; Foster Care: ' + s.ProgramType_FosterCareEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC26 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SCH'
			AND sar.CategorySetCode = 'CSG'
	
		DROP TABLE #TC26

		/* Test Case 27: 
			CSI at the SCH level */

		SELECT 
			 AssessmentTypeEdFactsCode
			,PerformanceLevelEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,MilitaryConnectedStudentIndicatorEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC27
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,PerformanceLevelEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed
				,MilitaryConnectedStudentIndicatorEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,'CSI SCH Match All'
			,'CSI SCH Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; PerformanceLevel: ' + s.PerformanceLevelEdFactsCode  
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
								  + '; Military Connected Student: ' + s.MilitaryConnectedStudentIndicatorEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN sar.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC27 s
		JOIN RDS.FactK12StudentAssessmentReports sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.PerformanceLevelEdFactsCode = sar.PERFORMANCELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.ReportLevel = 'SCH'
			AND sar.CategorySetCode = 'CSI'
	
		DROP TABLE #TC27


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

	END CATCH; 


END