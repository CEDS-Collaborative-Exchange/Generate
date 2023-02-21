CREATE OR ALTER PROCEDURE [App].[FS178_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN


	DECLARE @UnitTestName VARCHAR(100) = 'FS178_UnitTestCase'
	DECLARE @AssessmentAcademicSubject VARCHAR(10) = '13373' 
	DECLARE @StoredProcedureName VARCHAR(100) = 'FS178_TestCase'
	DECLARE @TestScope VARCHAR(1000) = 'FS178'
	DECLARE @ReportCode VARCHAR(20) = 'C178' 
	DECLARE @SubjectAbbrv VARCHAR(20) = 'RLA'
	DECLARE @AssessmentPurpose VARCHAR(10) = '03458'
	DECLARE @AssessmentType VARCHAR(100) = 'PerformanceAssessment'
 
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
	

	--DROP TABLE IF EXISTS #staging 

	IF OBJECT_ID('tempdb..#staging') IS NOT NULL
		DROP TABLE #staging
		IF OBJECT_ID('tempdb..#asr') IS NOT NULL
		DROP TABLE #asr

		IF OBJECT_ID('tempdb..#a') IS NOT NULL
		DROP TABLE #a

		IF OBJECT_ID('tempdb..#dgl') IS NOT NULL
		DROP TABLE #dgl

		IF OBJECT_ID('tempdb..#ds') IS NOT NULL
		DROP TABLE #ds

		IF OBJECT_ID('tempdb..#rdr') IS NOT NULL
		DROP TABLE #rdr

		IF OBJECT_ID('tempdb..#ske') IS NOT NULL
		DROP TABLE #ske

		IF OBJECT_ID('tempdb..#spr') IS NOT NULL
		DROP TABLE #spr

		IF OBJECT_ID('tempdb..#sps') IS NOT NULL
		DROP TABLE #sps

		IF OBJECT_ID('tempdb..#ta') IS NOT NULL
		DROP TABLE #ta

		IF OBJECT_ID('tempdb..#sy') IS NOT NULL
		DROP TABLE #sy

	DECLARE @ChildCountDate DATETIME
	
	-- Get Custom Child Count Date
	SELECT @ChildCountDate = CAST('10/01/' + cast(@SchoolYear - 1 AS Varchar(4)) AS DATETIME)

	SELECT [Student_Identifier_State]
		,[LEA_Identifier_State]
		,[School_Identifier_State]
		,[GradeLevelWhenAssessed]
		,AssessmentTitle
		,AssessmentAcademicSubject
		,AssessmentPurpose
		,AssessmentPerformanceLevelIdentifier
		,AssessmentTypeAdministeredToChildrenWithDisabilities
		,SchoolYear
		,AssessmentAdministrationStartDate
		,AssessmentAdministrationFinishDate
	INTO #asr
	FROM Staging.AssessmentResult
	WHERE AssessmentAcademicSubject = @AssessmentAcademicSubject
	AND SchoolYear = @SchoolYear
	--AND AssessmentPurpose = @AssessmentPurpose
	--AND AssessmentType = @AssessmentType

	CREATE NONCLUSTERED INDEX IX_asr ON #asr (Student_Identifier_State,LEA_Identifier_State,School_Identifier_State,SchoolYear,GradeLevelWhenAssessed,AssessmentTitle,AssessmentAcademicSubject,AssessmentPurpose,AssessmentPerformanceLevelIdentifier,AssessmentTypeAdministeredToChildrenWithDisabilities)

	SELECT [AssessmentTitle]
		,[AssessmentAcademicSubject]
		,[AssessmentPurpose]
		,AssessmentPerformanceLevelIdentifier
		,[AssessmentTypeAdministeredToChildrenWithDisabilities]
	INTO #a
	FROM Staging.Assessment
	WHERE [AssessmentAcademicSubject] = @AssessmentAcademicSubject
	AND AssessmentType = @AssessmentType

	CREATE NONCLUSTERED INDEX IX_a ON #a (AssessmentTitle,AssessmentAcademicSubject,AssessmentPurpose,AssessmentPerformanceLevelIdentifier,AssessmentTypeAdministeredToChildrenWithDisabilities)

	SELECT IDEAIndicator
		,EnglishLearnerStatus
		,EconomicDisadvantageStatus
		,MigrantStatus
		,HomelessnessStatus
		,ProgramType_FosterCare
		,MilitaryConnectedStudentIndicator
		,Student_Identifier_State
		,LEA_Identifier_State
		,School_Identifier_State
	INTO #sps
	FROM Staging.PersonStatus

	CREATE NONCLUSTERED INDEX IX_sps ON #sps (Student_Identifier_State,LEA_Identifier_State,School_Identifier_State)

	SELECT [Sex]
		,Student_Identifier_State
		,LEA_Identifier_State
		,School_Identifier_State
		,HispanicLatinoEthnicity
	INTO #ske
	FROM Staging.K12Enrollment
    
	CREATE NONCLUSTERED INDEX IX_ske ON #ske (Student_Identifier_State,LEA_Identifier_State,School_Identifier_State,HispanicLatinoEthnicity)

	SELECT Student_Identifier_State
		,SchoolYear
		,RaceType
		,RecordStartDateTime
		,RecordEndDateTime
	INTO #spr
	FROM Staging.PersonRace
	WHERE SchoolYear = @SchoolYear

	CREATE NONCLUSTERED INDEX IX_spr ON #spr (Student_Identifier_State,SchoolYear,RaceType,RecordStartDateTime,RecordEndDateTime)

	SELECT 
		RaceEdFactsCode
		,RaceCode
	INTO #rdr
	FROM RDS.DimRaces

	CREATE NONCLUSTERED INDEX IX_rdr ON #rdr (RaceEdFactsCode,RaceCode)

	SELECT
		GradeLevelCode
	INTO #dgl
	FROM rds.DimGradeLevels

	SELECT DISTINCT
		AssessmentSubjectCode,AssessmentSubjectEdFactsCode,
		AssessmentTypeCode,AssessmentTypeEdFactsCode,
		PerformanceLevelCode,PerformanceLevelEdFactsCode
	INTO #ds
	FROM rds.DimAssessments

	CREATE NONCLUSTERED INDEX IX_ds ON #ds (AssessmentSubjectCode,AssessmentTypeCode,PerformanceLevelCode,AssessmentTypeEdFactsCode)

	SELECT 
		AssessmentTypeCode
		,[Subject]
		,Grade
		,ProficientOrAboveLevel
	INTO #ta
	FROM App.ToggleAssessments


	CREATE NONCLUSTERED INDEX IX_ta ON #ta (AssessmentTypeCode,Grade,[Subject])

	SELECT 
		SchoolYear
			,SessionBeginDate
			,SessionEndDate
	INTO #sy
	FROM RDS.DimSchoolYears
	WHERE SchoolYear = @SchoolYear

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
		[RaceEdFactsCode] = CASE rdr.[RaceEdFactsCode]
							WHEN 'AM7' THEN 'MAN'
							WHEN 'AS7' THEN 'MA'
							WHEN 'BL7' THEN 'MB'
							WHEN 'HI7' THEN 'MHL'
							WHEN 'MU7' THEN 'MM'
							WHEN 'PI7' THEN 'MNP'
							WHEN 'WH7' THEN 'MW'
							END,
		ske.[Sex],
		[DisabilityStatusEdFactsCode] = CASE WHEN sps.IDEAIndicator = 1 THEN 'WDIS' ELSE 'MISSING' END,
		[EnglishLearnerStatusEdFactsCode] = CASE WHEN sps.EnglishLearnerStatus = 1 THEN 'LEP' ELSE 'MISSING' END,
		[EconomicDisadvantageStatusEdFactsCode] = CASE WHEN sps.EconomicDisadvantageStatus = 1 THEN 'ECODIS' ELSE 'MISSING' END,
		[MigrantStatusEdFactsCode] = CASE WHEN sps.MigrantStatus = 1 THEN 'MS' ELSE 'MISSING' END,
		[HomelessnessStatusEdFactsCode] = CASE WHEN sps.HomelessnessStatus = 1 THEN 'HOMELSENRL' ELSE 'MISSING' END,
		[ProgramType_FosterCareEdFactsCode] = CASE WHEN sps.ProgramType_FosterCare = 1 THEN 'FCS' ELSE 'MISSING' END,
		[MilitaryConnectedStudentIndicatorEdFactsCode] = CASE WHEN  sps.MilitaryConnectedStudentIndicator is not null AND sps.MilitaryConnectedStudentIndicator NOT IN ('Unknown', 'NotMilitaryConnected')
															  THEN 'MILCNCTD' ELSE 'MISSING' END 
	INTO #staging
	FROM Staging.Assessment a		
	INNER JOIN #asr asr 
		ON a.AssessmentTitle = asr.AssessmentTitle
	AND a.AssessmentAcademicSubject = asr.AssessmentAcademicSubject
	AND a.AssessmentPurpose = asr.AssessmentPurpose
	AND a.AssessmentPerformanceLevelIdentifier = asr.AssessmentPerformanceLevelIdentifier
	AND a.AssessmentTypeAdministeredToChildrenWithDisabilities = asr.AssessmentTypeAdministeredToChildrenWithDisabilities
	INNER JOIN #sps sps
		ON sps.Student_Identifier_State = asr.Student_Identifier_State
	AND sps.LEA_Identifier_State = asr.LEA_Identifier_State
	AND sps.School_Identifier_State = asr.School_Identifier_State
	INNER JOIN #ske ske
		ON sps.Student_Identifier_State = ske.Student_Identifier_State
	AND sps.LEA_Identifier_State = ske.LEA_Identifier_State
	AND sps.School_Identifier_State = ske.School_Identifier_State
	INNER JOIN #sy sy
		ON sy.SessionBeginDate <= a.AssessmentAdministrationStartDate
		AND sy.SessionBeginDate <= asr.AssessmentAdministrationStartDate
		AND sy.SessionEndDate >= asr.AssessmentAdministrationFinishDate
	AND sy.SessionEndDate >= a.AssessmentAdministrationFinishDate
	LEFT JOIN #spr spr
		ON spr.Student_Identifier_State = asr.Student_Identifier_State
	AND spr.SchoolYear = asr.SchoolYear
	AND (sy.SessionBeginDate <= spr.RecordEndDateTime
	AND sy.SessionEndDate >= spr.RecordEndDateTime)	
	LEFT JOIN #rdr rdr
		ON (ske.HispanicLatinoEthnicity = 1 and rdr.RaceEdFactsCode = 'HI7')
				OR (ske.HispanicLatinoEthnicity = 0 AND spr.RaceType = rdr.RaceCode)
	LEFT JOIN #dgl dgl
		ON dgl.GradeLevelCode = asr.GradeLevelWhenAssessed
	INNER JOIN #ds ds
		ON a.AssessmentAcademicSubject = ds.AssessmentSubjectCode
	AND a.AssessmentTypeAdministeredToChildrenWithDisabilities = ds.AssessmentTypeCode
	--AND CASE sps.IDEAIndicator WHEN 1 THEN a.AssessmentTypeAdministeredToChildrenWithDisabilities ELSE 'REGASSWOACC' END = ds.AssessmentTypeCode
	AND a.AssessmentPerformanceLevelIdentifier = ds.PerformanceLevelCode
	INNER JOIN #ta ta
		ON ds.AssessmentTypeEdFactsCode = ta.AssessmentTypeCode
	AND asr.GradeLevelWhenAssessed = ta.Grade
	AND asr.AssessmentAcademicSubject = CASE ta.[Subject] WHEN @SubjectAbbrv THEN @AssessmentAcademicSubject ELSE 'NOMATCH' END
	WHERE asr.SchoolYear = @SchoolYear
	AND ta.[Subject] = @SubjectAbbrv

	--DROP TABLE IF EXISTS #asr
	--DROP TABLE IF EXISTS #a
	--DROP TABLE IF EXISTS #dgl
	--DROP TABLE IF EXISTS #ds
	--DROP TABLE IF EXISTS #rdr
	--DROP TABLE IF EXISTS #ske
	--DROP TABLE IF EXISTS #spr
	--DROP TABLE IF EXISTS #sps
	--DROP TABLE IF EXISTS #ta
	--DROP TABLE IF EXISTS #sy
	


/* aggregate data from report table */

			--CSA
			SELECT ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,RACE
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,[AssessmentCount] = SUM(AssessmentCount)
			 INTO #csa
			 FROM RDS.FactK12StudentAssessmentReports
			 WHERE CategorySetCode = 'CSA'
			 AND ReportYear = @SchoolYear
			 AND ReportCode = @ReportCode
			 GROUP BY ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,RACE
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			 --CSB
			SELECT ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,[SEX] = CASE SEX WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,[AssessmentCount] = SUM(AssessmentCount)
			 INTO #csb
			 FROM RDS.FactK12StudentAssessmentReports 
			 WHERE CategorySetCode = 'CSB'
			 AND ReportYear = @SchoolYear
			 AND ReportCode = @ReportCode
			 GROUP BY ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,SEX
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			 --CSC
			SELECT ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,IDEAINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,[AssessmentCount] = SUM(AssessmentCount)
			 INTO #csc
			 FROM RDS.FactK12StudentAssessmentReports
			 WHERE CategorySetCode = 'CSC'
			 AND ReportYear = @SchoolYear
			 AND ReportCode = @ReportCode
			 AND IDEAINDICATOR IN ('WDIS','MISSING')
			 GROUP BY ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,IDEAINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			 --CSD
			SELECT ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,ENGLISHLEARNERSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,[AssessmentCount] = SUM(AssessmentCount)
			 INTO #csd
			 FROM RDS.FactK12StudentAssessmentReports
			 WHERE CategorySetCode = 'CSD'
			 AND ReportYear = @SchoolYear
			 AND ReportCode = @ReportCode
			 AND ENGLISHLEARNERSTATUS IN ('LEP','MISSING')
			 GROUP BY ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,ENGLISHLEARNERSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			 --CSE
			SELECT ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,ECONOMICDISADVANTAGESTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,[AssessmentCount] = SUM(AssessmentCount)
			 INTO #cse
			 FROM RDS.FactK12StudentAssessmentReports
			 WHERE CategorySetCode = 'CSE'
			 AND ReportYear = @SchoolYear
			 AND ReportCode = @ReportCode
			 AND ECONOMICDISADVANTAGESTATUS IN ('ECODIS','MISSING')
			 GROUP BY ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,ECONOMICDISADVANTAGESTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			 --CSF
			SELECT ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,MIGRANTSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,[AssessmentCount] = SUM(AssessmentCount)
			 INTO #csf
			 FROM RDS.FactK12StudentAssessmentReports
			 WHERE CategorySetCode = 'CSF'
			 AND ReportYear = @SchoolYear
			 AND ReportCode = @ReportCode
			 AND MIGRANTSTATUS IN ('MS','MISSING')
			 GROUP BY ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,MIGRANTSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			 --CSG
			SELECT ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,HOMElESSNESSSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,[AssessmentCount] = SUM(AssessmentCount)
			 INTO #csg
			 FROM RDS.FactK12StudentAssessmentReports
			 WHERE CategorySetCode = 'CSG'
			 AND ReportYear = @SchoolYear
			 AND ReportCode = @ReportCode
			 AND HOMElESSNESSSTATUS IN ('HOMELSENRL','MISSING')
			 GROUP BY ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,HOMElESSNESSSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			 --CSH
			SELECT ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,FOSTERCAREPROGRAM
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,[AssessmentCount] = SUM(AssessmentCount)
			 INTO #csh
			 FROM RDS.FactK12StudentAssessmentReports
			 WHERE CategorySetCode = 'CSH'
			 AND ReportYear = @SchoolYear
			 AND ReportCode = @ReportCode
			 AND FOSTERCAREPROGRAM IN ('FCS','MISSING')
			 GROUP BY ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,FOSTERCAREPROGRAM
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			 --CSI
			SELECT ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,MILITARYCONNECTEDSTUDENTINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,[AssessmentCount] = SUM(AssessmentCount)
			 INTO #csi
			 FROM RDS.FactK12StudentAssessmentReports
			 WHERE CategorySetCode = 'CSI'
			 AND ReportYear = @SchoolYear
			 AND ReportCode = @ReportCode
			 AND MILITARYCONNECTEDSTUDENTINDICATOR IN ('MILCNCTD','MISSING')
			 GROUP BY ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,MILITARYCONNECTEDSTUDENTINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			--ST1
			 SELECT ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,[AssessmentCount] = SUM(AssessmentCount)
			 INTO #st1
			 FROM RDS.FactK12StudentAssessmentReports
			 WHERE CategorySetCode = 'ST1'
			 AND ReportYear = @SchoolYear
			 AND ReportCode = @ReportCode
			 GROUP BY ASSESSMENTTYPE
				,[ProficiencyStatus]
				,GRADELEVEL
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode



----------------------------------------------------------------------------------------------------
		/* Test Case 1: 
			CSA  */

		SELECT 
			 AssessmentTypeEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,RaceEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC1
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
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
			,'CSA ' + UPPER(sar.ReportLevel) + ' Match All'
			,'CSA ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.AssessmentTypeEdFactsCode +  '; '
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed  
								  + '; Race Ethnicity: ' + s.RaceEdFactsCode  
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC1 s
		JOIN #csa sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.[ProficiencyStatus] = sar.[ProficiencyStatus]
			AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
			AND s.RaceEdFactsCode = sar.RACE
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.CategorySetCode = 'CSA'
	
		DROP TABLE #TC1

		/* Test Case 2: 
			CSB  */

		SELECT 
			 AssessmentTypeEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,Sex
			, COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC2
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
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
			,'CSB ' + UPPER(sar.ReportLevel) + ' Match All'
			,'CSB ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.AssessmentTypeEdFactsCode 
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed  
								  + '; Sex Membership: ' + s.Sex 
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC2 s
		JOIN #csb sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.[ProficiencyStatus] = sar.[ProficiencyStatus]
			AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
			AND s.Sex = sar.SEX
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.CategorySetCode = 'CSB'
	
		DROP TABLE #TC2

		/* Test Case 3: 
			CSC  */

		SELECT 
			 AssessmentTypeEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,DisabilityStatusEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC3
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
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
			,'CSC ' + UPPER(sar.ReportLevel) + ' Match All'
			,'CSC ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.AssessmentTypeEdFactsCode 
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed 
								  + '; Disability Status ' + S.DisabilityStatusEdFactsCode
								  
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC3 s
		JOIN #csc sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.[ProficiencyStatus] = sar.[ProficiencyStatus]
			AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
			AND s.DisabilityStatusEdFactsCode = sar.IDEAINDICATOR
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.CategorySetCode = 'CSC'
	
		DROP TABLE #TC3

		/* Test Case 4: 
			CSD  */

		SELECT 
			 AssessmentTypeEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,EnglishLearnerStatusEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC4
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
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
			,'CSD ' + UPPER(sar.ReportLevel) + ' Match All'
			,'CSD ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.AssessmentTypeEdFactsCode 
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed 
								  + '; EnglishLearner Status: ' + s.EnglishLearnerStatusEdFactsCode 
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC4 s
		JOIN #csd sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.[ProficiencyStatus] = sar.[ProficiencyStatus]
			AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
			AND s.EnglishLearnerStatusEdFactsCode = sar.ENGLISHLEARNERSTATUS
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.CategorySetCode = 'CSD'
	
		DROP TABLE #TC4

		/* Test Case 5: 
			CSE  */

		SELECT 
			 AssessmentTypeEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,EconomicDisadvantageStatusEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC5
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
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
			,'CSE ' + UPPER(sar.ReportLevel) + ' Match All'
			,'CSE ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.AssessmentTypeEdFactsCode 
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed 
								  + '; Economic Disadvantage Status: ' + s.EconomicDisadvantageStatusEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC5 s
		JOIN #cse sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.[ProficiencyStatus] = sar.[ProficiencyStatus]
			AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
			AND s.EconomicDisadvantageStatusEdFactsCode = sar.ECONOMICDISADVANTAGESTATUS
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.CategorySetCode = 'CSE'
	
		DROP TABLE #TC5

		/* Test Case 6: 
			CSF  */

		SELECT 
			 AssessmentTypeEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,MigrantStatusEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC6
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
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
			,'CSF ' + UPPER(sar.ReportLevel) + ' Match All'
			,'CSF ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.AssessmentTypeEdFactsCode 
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
								  + '; Migrant Status: ' + s.MigrantStatusEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC6 s
		JOIN #csf sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.[ProficiencyStatus] = sar.[ProficiencyStatus]
			AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
			AND s.MigrantStatusEdFactsCode = sar.MIGRANTSTATUS
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.CategorySetCode = 'CSF'
	
		DROP TABLE #TC6

		/* Test Case 7: 
			CSG  */

		SELECT 
			 AssessmentTypeEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,HomelessnessStatusEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC7
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
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
			,'CSG ' + UPPER(sar.ReportLevel) + ' Match All'
			,'CSG ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.AssessmentTypeEdFactsCode 
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
								  + '; Homelessness Status: ' + s.HomelessnessStatusEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC7 s
		JOIN #csg sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.[ProficiencyStatus] = sar.[ProficiencyStatus]
			AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
			AND s.HomelessnessStatusEdFactsCode = sar.HOMElESSNESSSTATUS
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.CategorySetCode = 'CSG'
	
		DROP TABLE #TC7
		
		/* Test Case 8: 
			CSH  */

		SELECT 
			 AssessmentTypeEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,ProgramType_FosterCareEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC8
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
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
			,'CSH ' + UPPER(sar.ReportLevel) + ' Match All'
			,'CSH ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.AssessmentTypeEdFactsCode 
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
								  + '; Foster Care: ' + s.ProgramType_FosterCareEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC8 s
		JOIN #csh sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.[ProficiencyStatus] = sar.[ProficiencyStatus]
			AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
			AND s.ProgramType_FosterCareEdFactsCode = sar.FOSTERCAREPROGRAM
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.CategorySetCode = 'CSH'
	
		DROP TABLE #TC8

		/* Test Case 9: 
			CSI  */

		SELECT 
			 AssessmentTypeEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,MilitaryConnectedStudentIndicatorEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC9
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
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
			,'CSI ' + UPPER(sar.ReportLevel) + ' Match All'
			,'CSI ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.AssessmentTypeEdFactsCode 
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
								  + '; Military Connected Student: ' + s.MilitaryConnectedStudentIndicatorEdFactsCode
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC9 s
		JOIN #csi sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.[ProficiencyStatus] = sar.[ProficiencyStatus]
			AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
			AND s.MilitaryConnectedStudentIndicatorEdFactsCode = sar.MILITARYCONNECTEDSTUDENTINDICATOR
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.CategorySetCode = 'CSI'
	
		DROP TABLE #TC9

		/* Test Case 28: 
			ST1  */

		SELECT 
			 AssessmentTypeEdFactsCode
			,ProficiencyStatus
			,GradeLevelWhenAssessed
			,COUNT(DISTINCT Student_Identifier_State) AS AssessmentCount
		INTO #TC10
		FROM #staging 
		GROUP BY AssessmentTypeEdFactsCode
				,ProficiencyStatus
				,GradeLevelWhenAssessed

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
			,'ST1 ' + UPPER(sar.ReportLevel) + ' Match All'
			,'ST1 ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.AssessmentTypeEdFactsCode 
								  + '; Proficiency Status: ' + s.ProficiencyStatus + '; Grade Level: ' + s.GradeLevelWhenAssessed
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC10 s
		JOIN #st1 sar 
			ON s.AssessmentTypeEdFactsCode = sar.ASSESSMENTTYPE
			AND s.[ProficiencyStatus] = sar.[ProficiencyStatus]
			And s.GradeLevelWhenAssessed = sar.GRADELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.CategorySetCode = 'ST1'
	
		DROP TABLE #TC10

	
	   DROP TABLE #csa
	   DROP TABLE #csb
	   DROP TABLE #csc
	   DROP TABLE #csd
	   DROP TABLE #cse
	   DROP TABLE #csf
	   DROP TABLE #csg
	   DROP TABLE #csh
	   DROP TABLE #csi
	   DROP TABLE #st1
	   DROP TABLE #staging



END