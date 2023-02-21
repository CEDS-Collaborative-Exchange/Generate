CREATE OR ALTER PROCEDURE [App].[FS141_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

BEGIN TRY
	BEGIN TRANSACTION

	DECLARE @UnitTestName VARCHAR(100) = 'FS141_UnitTestCase'
	DECLARE @StoredProcedureName VARCHAR(100) = 'FS141_TestCase'
	DECLARE @TestScope VARCHAR(1000) = 'FS141'
	DECLARE @ReportCode VARCHAR(20) = 'C141' 
 
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

	DECLARE @ELDate DATETIME
	
	-- Get EL Date
	SELECT @ELDate = CAST('10/01/' + cast(@SchoolYear - 1 AS Varchar(4)) AS DATETIME)

	-- Get Custom EL Date
	DECLARE @cutOffMonth INT, @cutOffDay INT, @customFactTypeDate VARCHAR(10)
	set @cutOffMonth = 10
	set @cutOffDay = 1

	select @customFactTypeDate = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'ELDTE'

	if not @customFactTypeDate is null
	begin
		if CHARINDEX('/', @customFactTypeDate) > 0
		begin
			select @cutOffMonth = SUBSTRING(@customFactTypeDate, 1, 2)
			select @cutOffDay = SUBSTRING(@customFactTypeDate, 4, 2)
		end			

		SELECT @ELDate = DATEFROMPARTS(CASE WHEN @cutOffMonth >= 7 THEN sy.SchoolYear - 1 ELSE sy.SchoolYear END, @cutOffMonth, @cutOffDay)
		FROM rds.DimSchoolYears sy
		Where sy.SchoolYear = @SchoolYear
	end


	SELECT	 IDEAIndicator
		,[IDEA_StatusStartDate]
		,[IDEA_StatusEndDate]
		,EnglishLearnerStatus
		,[EnglishLearner_StatusStartDate]
		,[EnglishLearner_StatusEndDate]
		,ISO_639_2_NativeLanguage
		,Student_Identifier_State
		,LEA_Identifier_State
		,School_Identifier_State
	INTO #sps
	FROM Staging.PersonStatus

	CREATE NONCLUSTERED INDEX IX_sps ON #sps (Student_Identifier_State,LEA_Identifier_State,School_Identifier_State)

	SELECT 
		Student_Identifier_State
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

	
	SELECT 
		SchoolYear
		,SessionBeginDate
		,SessionEndDate
	INTO #sy
	FROM RDS.DimSchoolYears
	WHERE SchoolYear = @SchoolYear



	SELECT 
		enr.Student_Identifier_State,
		enr.LEA_Identifier_State,
		enr.School_Identifier_State,
		[RaceEdFactsCode] = rdr.[RaceEdFactsCode],
		[DisabilityStatusEdFactsCode] = CASE WHEN idea.IDEAIndicator = 1 THEN 'WDIS' ELSE 'MISSING' END,
		[EnglishLearnerStatusEdFactsCode] = CASE WHEN el.EnglishLearnerStatus = 1 THEN 'LEP' ELSE 'MISSING' END,
		[ISO6392Language] = ISNULL(lang.ISO_639_2_NativeLanguage, 'MISSING'),
		dgl.GradeLevelCode,
		spr.RecordStartDateTime
		,spr.RecordEndDateTime
		,sy.SessionBeginDate
		,sy.SessionEndDate
	INTO #staging
	FROM Staging.K12Enrollment enr		
	INNER JOIN #ske ske
		ON enr.Student_Identifier_State = ske.Student_Identifier_State
		AND enr.LEA_Identifier_State = ske.LEA_Identifier_State
		AND enr.School_Identifier_State = ske.School_Identifier_State
	INNER JOIN #sy sy
		ON sy.SessionBeginDate <= enr.EnrollmentEntryDate
		AND @ELDate BETWEEN enr.EnrollmentEntryDate AND ISNULL(enr.EnrollmentExitDate, GETDATE())
	LEFT JOIN #sps idea
		ON idea.Student_Identifier_State = enr.Student_Identifier_State
		   AND idea.LEA_Identifier_State = enr.LEA_Identifier_State
		   AND idea.School_Identifier_State = enr.School_Identifier_State
		   AND idea.IDEA_StatusStartDate <= @ELDate AND (idea.IDEA_StatusEndDate >= @ELDate OR idea.IDEA_StatusEndDate IS NULL)
		   AND idea.IDEAIndicator = 1
     LEFT JOIN #sps el
		ON el.Student_Identifier_State = enr.Student_Identifier_State
		   AND el.LEA_Identifier_State = enr.LEA_Identifier_State
		   AND el.School_Identifier_State = enr.School_Identifier_State
		   and el.EnglishLearnerStatus = 1
	LEFT JOIN #sps lang
		ON lang.Student_Identifier_State = enr.Student_Identifier_State
		   AND lang.LEA_Identifier_State = enr.LEA_Identifier_State
		   AND lang.School_Identifier_State = enr.School_Identifier_State
		   and lang.ISO_639_2_NativeLanguage IS NOT NULL
    LEFT JOIN #spr spr
        ON spr.Student_Identifier_State = ske.Student_Identifier_State
        AND spr.SchoolYear = sy.SchoolYear
		AND ISNULL(enr.EnrollmentEntryDate, spr.RecordStartDateTime)
        BETWEEN spr.RecordStartDateTime
        AND @ELDate
       	AND (sy.SessionBeginDate <= @ELDate
	AND sy.SessionEndDate >= @ELDate)
	LEFT JOIN #rdr rdr
		ON (ske.HispanicLatinoEthnicity = 1 and rdr.RaceEdFactsCode = 'HI7')
				OR (ske.HispanicLatinoEthnicity = 0 AND spr.RaceType = rdr.RaceCode)
	LEFT JOIN #dgl dgl
		ON dgl.GradeLevelCode = enr.GradeLevel
	WHERE  enr.GradeLevel not in ('PK','AE', 'ABE') and el.EnglishLearnerStatus = 1

	DROP TABLE IF EXISTS #rdr
	DROP TABLE IF EXISTS #ske
	DROP TABLE IF EXISTS #spr
	DROP TABLE IF EXISTS #sps
	DROP TABLE IF EXISTS #dgl
	DROP TABLE IF EXISTS #sy
		

			--CSA
			SELECT 
				 GRADELEVEL
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,[StudentCount] = SUM(StudentCount)
			 INTO #csa
			 FROM RDS.ReportEDFactsK12StudentCounts
			 WHERE CategorySetCode = 'CSA'
			 AND ReportYear = @SchoolYear
			 AND ReportCode = @ReportCode
			 GROUP BY GRADELEVEL
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			 --CSB
			SELECT 
				 ISO6392LANGUAGE
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,[StudentCount] = SUM(StudentCount)
			 INTO #csb
			 FROM RDS.ReportEDFactsK12StudentCounts
			 WHERE CategorySetCode = 'CSB'
			 AND ReportYear = @SchoolYear
			 AND ReportCode = @ReportCode
			 GROUP BY ISO6392LANGUAGE
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			 --CSC
			SELECT 
				 RACE
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,[StudentCount] = SUM(StudentCount)
			 INTO #csc
			 FROM RDS.ReportEDFactsK12StudentCounts
			 WHERE CategorySetCode = 'CSC'
			 AND ReportYear = @SchoolYear
			 AND ReportCode = @ReportCode
			 GROUP BY RACE
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			 --CSD
			SELECT 
				 IDEAINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,[StudentCount] = SUM(StudentCount)
			 INTO #csd
			 FROM RDS.ReportEDFactsK12StudentCounts
			 WHERE CategorySetCode = 'CSD'
			 AND ReportYear = @SchoolYear
			 AND ReportCode = @ReportCode
			 GROUP BY IDEAINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			
			--TOT
			 SELECT 
				 ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,[StudentCount] = SUM(StudentCount)
			 INTO #tot
			 FROM RDS.ReportEDFactsK12StudentCounts
			 WHERE CategorySetCode = 'TOT'
			 AND ReportYear = @SchoolYear
			 AND ReportCode = @ReportCode
			 GROUP BY ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode



----------------------------------------------------------------------------------------------------
		/* Test Case 1: 
			CSA  */

		SELECT 
			 GradeLevelCode
			,COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC1
		FROM #staging 
		GROUP BY GradeLevelCode



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
			,'CSA ' + UPPER(sar.ReportLevel) + ' Match All - Grade Level: ' + s.GradeLevelCode
			,s.StudentCount
			,sar.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(sar.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC1 s
		JOIN #csa sar 
			ON s.GradeLevelCode = sar.GRADELEVEL

	
		DROP TABLE #TC1

		/* Test Case 2: 
			CSB  */


		SELECT 
			 ISO6392Language
			,COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC2
		FROM #staging 
		GROUP BY ISO6392Language



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
			,'CSB ' + UPPER(sar.ReportLevel) + ' Match All - Language: ' + s.ISO6392Language
			,s.StudentCount
			,sar.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(sar.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC2 s
		JOIN #csb sar 
			ON s.ISO6392Language = sar.ISO6392LANGUAGE

	
		DROP TABLE #TC2

		/* Test Case 3: 
			CSC  */

		SELECT 
			 RaceEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC3
		FROM #staging 
		GROUP BY RaceEdFactsCode



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
			,'CSC ' + UPPER(sar.ReportLevel) + ' Match All - Race: ' + s.RaceEdFactsCode
			,s.StudentCount
			,sar.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(sar.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC3 s
		JOIN #csc sar 
			ON s.RaceEdFactsCode = sar.Race

	
		DROP TABLE #TC3

		/* Test Case 4: 
			CSD  */

		SELECT 
			 DisabilityStatusEdFactsCode
			,COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC4
		FROM #staging 
		GROUP BY DisabilityStatusEdFactsCode

	
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
			,'CSD ' + UPPER(sar.ReportLevel) + ' Match All - Disability: ' + sar.IDEAINDICATOR
			,s.StudentCount
			,sar.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(sar.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC4 s
		JOIN #csd sar 
		ON s.DisabilityStatusEdFactsCode = sar.IDEAINDICATOR


	
		DROP TABLE #TC4


		
		/* Test Case 5: 
			TOT  */

		SELECT 
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC5
		FROM #staging 


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
			,'TOT ' + UPPER(sar.ReportLevel) + ' Match All'
			,'TOT ' + UPPER(sar.ReportLevel) + ' Match All'
			,s.StudentCount
			,sar.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(sar.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC5 s
		JOIN #tot sar 
			ON sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.CategorySetCode = 'TOT'

	
		DROP TABLE #TC5

	
	   DROP TABLE #csa
	   DROP TABLE #csb
	   DROP TABLE #csc
	   DROP TABLE #csd
	   DROP TABLE #tot
	   DROP TABLE #staging

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