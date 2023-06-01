/***********************************************************************
April 11, 2023
End to End Test for FS052
************************************************************************/

CREATE PROCEDURE [app].[FS052_TestCase] 
	@SchoolYear INT
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C052Staging') IS NOT NULL
	DROP TABLE #C052Staging

	IF OBJECT_ID('tempdb..#raceTemp') IS NOT NULL
	DROP TABLE #raceTemp
	IF OBJECT_ID('tempdb..#TempRacesUpdate') IS NOT NULL
	DROP TABLE #TempRacesUpdate

	IF OBJECT_ID('tempdb..#SEA_CSA') IS NOT NULL
	DROP TABLE #SEA_CSA
	IF OBJECT_ID('tempdb..#SEA_ST1') IS NOT NULL
	DROP TABLE #SEA_ST1
	IF OBJECT_ID('tempdb..#SEA_ST2') IS NOT NULL
	DROP TABLE #SEA_ST2
	IF OBJECT_ID('tempdb..#SEA_ST3') IS NOT NULL
	DROP TABLE #SEA_ST3
	IF OBJECT_ID('tempdb..#SEA_ST4') IS NOT NULL
	DROP TABLE #SEA_ST4
	IF OBJECT_ID('tempdb..#SEA_TOT') IS NOT NULL
	DROP TABLE #SEA_TOT


	IF OBJECT_ID('tempdb..#LEA_CSA') IS NOT NULL
	DROP TABLE #LEA_CSA
	IF OBJECT_ID('tempdb..#LEA_ST1') IS NOT NULL
	DROP TABLE #LEA_ST1
	IF OBJECT_ID('tempdb..#LEA_ST2') IS NOT NULL
	DROP TABLE #LEA_ST2
	IF OBJECT_ID('tempdb..#LEA_ST3') IS NOT NULL
	DROP TABLE #LEA_ST3
	IF OBJECT_ID('tempdb..#LEA_ST4') IS NOT NULL
	DROP TABLE #LEA_ST4
	IF OBJECT_ID('tempdb..#LEA_TOT') IS NOT NULL
	DROP TABLE #LEA_TOT


	IF OBJECT_ID('tempdb..#SCH_CSA') IS NOT NULL
	DROP TABLE #SCH_CSA
	IF OBJECT_ID('tempdb..#SCH_ST1') IS NOT NULL
	DROP TABLE #SCH_ST1
	IF OBJECT_ID('tempdb..#SCH_ST2') IS NOT NULL
	DROP TABLE #SCH_ST2
	IF OBJECT_ID('tempdb..#SCH_ST3') IS NOT NULL
	DROP TABLE #SCH_ST3
	IF OBJECT_ID('tempdb..#SCH_ST4') IS NOT NULL
	DROP TABLE #SCH_ST4
	IF OBJECT_ID('tempdb..#SCH_TOT') IS NOT NULL
	DROP TABLE #SCH_TOT

	-- Define the test
	DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT

	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS052_UnitTestCase') 
	BEGIN
		SET @expectedResult = 1
		INSERT INTO App.SqlUnitTest (
			UnitTestName,
			StoredProcedureName,
			TestScope,
			IsActive
		) VALUES (
			'FS052_UnitTestCase',
			'FS052_TestCase',
			'FS052',
			1
		)
		SET @SqlUnitTestId = @@IDENTITY
	END 
	ELSE 
	BEGIN
		SELECT 
			@SqlUnitTestId = SqlUnitTestId
		FROM App.SqlUnitTest 
		WHERE UnitTestName = 'FS052_UnitTestCase'
	END
	
	-- Clear out last run
	DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId

	-- Create test data if needed & doesn't exist (should be rerunnable, but don't insert duplicate records)
	-- Get Custom Membership Date
	DECLARE @cutOffMonth INT, @cutOffDay INT, @customFactTypeDate VARCHAR(10), @MemberDate date
	set @cutOffMonth = 11
	set @cutOffDay = 1

	select @customFactTypeDate = r.ResponseValue
	from app.ToggleResponses r
	INNER join app.ToggleQuestions q 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'MEMBERDTE'

	select @cutOffMonth = SUBSTRING(@customFactTypeDate, 0, CHARINDEX('/', @customFactTypeDate))
	select @cutOffDay = SUBSTRING(@customFactTypeDate, CHARINDEX('/', @customFactTypeDate) + 1, 2)
	select @MemberDate = convert(varchar, @CutoffMonth) + '/' + convert(varchar, @CutoffDay) + '/' + convert(varchar, @SchoolYear-1)

	--Check if Grade 13, Ungraded, and/or Adult Education should be included based on Toggle responses
	declare @toggleGrade13 as bit
 	declare @toggleUngraded as bit
	declare @toggleAdultEd as bit

	select @toggleGrade13 = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end, 0 ) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CCDGRADE13'

	select @toggleUngraded = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end, 0 ) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CCDUNGRADED'

	select @toggleAdultEd = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end, 0 )  
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'ADULTEDU'

	--temp table to hold valid grades to be included 
	DECLARE @GradesList TABLE (GradeLevel varchar(3)) 
	INSERT INTO @GradesList VALUES ('PK'),('KG'),('01'),('02'),('03'),('04'),('05'),('06'),('07'),('08'),('09'),('10'),('11'),('12')

	--Add the 3 additional grade levels if they should be included
	IF @toggleGrade13 = 1
	INSERT INTO @GradesList VALUES ('13')

	IF @toggleUngraded = 1
	INSERT INTO @GradesList VALUES ('UG')

	IF @toggleAdultEd = 1
	INSERT INTO @GradesList VALUES ('ABE')


	--Get the data needed for the tests
	SELECT  
		ske.Student_Identifier_State,
		ske.LEA_Identifier_State,
		ske.School_Identifier_State,
		ske.GradeLevel,
		CASE 
			WHEN ske.HispanicLatinoEthnicity = 1 THEN 'HI7' 
			WHEN spr.RaceType = 'AmericanIndianorAlaskaNative' THEN 'AM7'
			WHEN spr.RaceType = 'Asian' THEN 'AS7'
			WHEN spr.RaceType = 'BlackorAfricanAmerican' THEN 'BL7'
			WHEN spr.RaceType = 'NativeHawaiianorOtherPacificIslander' THEN 'PI7'
			WHEN spr.RaceType = 'White' THEN 'WH7'
			WHEN spr.RaceType = 'TwoorMoreRaces' THEN 'MU7'
		END AS RaceEdFactsCode,
		CASE ske.Sex
				WHEN 'Male' THEN 'M'
				WHEN 'Female' THEN 'F'
				ELSE 'MISSING'
		END AS SexEdFactsCode

	INTO #c052Staging
	FROM Staging.K12Enrollment ske

		LEFT JOIN Staging.PersonRace spr
			ON ske.SchoolYear = spr.SchoolYear
			AND ske.Student_Identifier_State = spr.Student_Identifier_State
			AND (spr.OrganizationType = 'SEA'
				OR (ske.LEA_Identifier_State = spr.OrganizationIdentifier
					AND spr.OrganizationType = 'LEA')
				OR (ske.School_Identifier_State = spr.OrganizationIdentifier
					AND spr.OrganizationType = 'K12School'))
			AND spr.RecordStartDateTime is not null
			AND @MemberDate BETWEEN spr.RecordStartDateTime AND ISNULL(spr.RecordEndDateTime, GETDATE())
			
	WHERE @MemberDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())
	AND GradeLevel IN (SELECT GradeLevel FROM @GradesList)

	--Handle the Race records to match the unduplicated code 
	drop table if exists #tempRacesUpdate

	--Update #c052Staging records for the same Lea/School to Multiple 
	SELECT 
		Student_Identifier_State
		, OrganizationIdentifier
		, OrganizationType
		, rdr.RaceCode
		, SchoolYear
	INTO #TempRacesUpdate
	FROM (
		SELECT 
			Student_Identifier_State
			, OrganizationIdentifier
			, OrganizationType
			, CASE 
				WHEN COUNT(OutputCode) > 1 THEN 'TwoOrMoreRaces'
				ELSE MAX(OutputCode)
			END as RaceCode
			, spr.SchoolYear
		FROM Staging.PersonRace spr
		JOIN Staging.SourceSystemReferenceData sssrd
			ON spr.RaceType = sssrd.InputCode
			AND spr.SchoolYear = sssrd.SchoolYear
			AND sssrd.TableName = 'RefRace'
		WHERE @MemberDate BETWEEN spr.RecordStartDateTime AND ISNULL(spr.RecordEndDateTime, GETDATE())
		AND	OutputCode <> 'TwoOrMoreRaces'	
		GROUP BY
			Student_Identifier_State
			, OrganizationIdentifier
			, OrganizationType
			, spr.SchoolYear
	) AS stagingRaces
	JOIN RDS.DimRaces rdr
		ON stagingRaces.RaceCode = rdr.RaceCode
	WHERE stagingRaces.RaceCode = 'TwoOrMoreRaces'

	UPDATE stg 
	SET RaceEdFactsCode = 'MU7'
	FROM #c052Staging stg
		INNER JOIN #TempRacesUpdate tru
			ON stg.Student_Identifier_State = tru.Student_Identifier_State
			AND (tru.OrganizationType = 'SEA'
				OR (stg.LEA_Identifier_State = tru.OrganizationIdentifier
					AND tru.OrganizationType = 'LEA')
				OR (stg.School_Identifier_State = tru.OrganizationIdentifier
					AND tru.OrganizationType = 'K12School'))
	WHERE stg.RaceEdFactsCode <> 'HI7'

	--Capture Students with multiple Race records
	SELECT spr.Student_Identifier_State, spr.RaceType as FirstRace, spr2.RaceType as SecondRace
	INTO #raceTemp	
	FROM Staging.K12Enrollment ske
	LEFT JOIN Staging.PersonRace spr
		ON ske.SchoolYear = spr.SchoolYear
		AND ske.Student_Identifier_State = spr.Student_Identifier_State
		AND (spr.OrganizationType = 'SEA'
			OR (ske.LEA_Identifier_State = spr.OrganizationIdentifier
				AND spr.OrganizationType = 'LEA')
			OR (ske.School_Identifier_State = spr.OrganizationIdentifier
				AND spr.OrganizationType = 'K12School'))
		AND spr.RecordStartDateTime is not null
		AND @MemberDate BETWEEN spr.RecordStartDateTime AND ISNULL(spr.RecordEndDateTime, GETDATE())
	LEFT JOIN Staging.PersonRace spr2
		ON ske.SchoolYear = spr.SchoolYear
		AND ske.Student_Identifier_State = spr2.Student_Identifier_State
		AND (spr2.OrganizationType = 'SEA'
			OR (ske.LEA_Identifier_State = spr2.OrganizationIdentifier
				AND spr2.OrganizationType = 'LEA')
			OR (ske.School_Identifier_State = spr2.OrganizationIdentifier
				AND spr2.OrganizationType = 'K12School'))
		AND spr2.RecordStartDateTime is not null
		AND @MemberDate BETWEEN spr2.RecordStartDateTime AND ISNULL(spr2.RecordEndDateTime, GETDATE())
	WHERE @MemberDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())
	AND isnull(spr.RaceType, '') <> isnull(spr2.RaceType, '')
	AND isnull(ske.HispanicLatinoEthnicity, 0) <> 1

	-------------------------------------------------
	-- Gather, evaluate & record the results
	-------------------------------------------------

		/**********************************************************************
		Test Case 1:
		CSA at the SEA level
		Student Count by:
			GradeLevel
			RaceEdFactsCode
			SexEdFactsCode
		***********************************************************************/
		SELECT
			GradeLevel,
			t.RaceEdFactsCode,
			SexEdFactsCode,
			COUNT(DISTINCT c.Student_Identifier_State) AS StudentCount
		INTO #SEA_CSA
		FROM #c052staging c
			LEFT JOIN (select cs.Student_Identifier_State,
							CASE WHEN isnull(rt.Student_Identifier_State, '') <> ''
								THEN 'MU7'
								ELSE cs.RaceEdFactsCode
							END AS RaceEdFactsCode
						from #c052Staging cs
							left join #raceTemp rt 
								on cs.Student_Identifier_State = rt.Student_Identifier_State
						) t
						on t.Student_Identifier_State = c.Student_Identifier_State 
		GROUP BY 
			GradeLevel,
			t.RaceEdFactsCode,
			SexEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'CSA SEA'
			,'GradeLevel ' + s.GradeLevel
				+ ' Race: ' + convert(varchar, s.RaceEdFactsCode) + '  ' 
				+ ' Sex: ' + s.SexEdFactsCode+ '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SEA_CSA s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.GradeLevel = rreksd.GRADELEVEL
			AND s.RaceEdFactsCode = rreksd.RACE			
			AND s.SexEdFactsCode = rreksd.SEX
			AND rreksd.ReportCode = 'C052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSA'

		DROP TABLE #SEA_CSA


		/**********************************************************************
		Test Case 2:
		CSA at the LEA level
		Student Count by:
			GradeLevel
			RaceEdFactsCode
			SexEdFactsCode
		***********************************************************************/
		SELECT
			LEA_Identifier_State,
			GradeLevel,
			RaceEdFactsCode, 
			SexEdFactsCode,
			COUNT(DISTINCT c.Student_Identifier_State) AS StudentCount
		INTO #LEA_CSA
		FROM #c052staging c
		GROUP BY 
			LEA_Identifier_State,
			GradeLevel,
			RaceEdFactsCode,
			SexEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'CSA LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
				+ 'Grade Level: ' + s.GradeLevel + '  '
				+ 'Race: ' + convert(varchar, s.RaceEdFactsCode) + '  ' 
				+ 'Sex: ' + s.SexEdFactsCode + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LEA_CSA s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON
			s.LEA_Identifier_State = rreksd.OrganizationStateId			
			AND s.GradeLevel = rreksd.GRADELEVEL
			AND s.RaceEdFactsCode = rreksd.RACE
			AND s.SexEdFactsCode = rreksd.SEX
			AND rreksd.ReportCode = 'C052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSA'

		DROP TABLE #LEA_CSA

		/**********************************************************************
		Test Case 3:
		CSA at the School level
		Student Count by:
			GradeLevel
			RaceEdFactsCode
			SexEdFactsCode
		***********************************************************************/
		SELECT
			School_Identifier_State,
			GradeLevel,
			RaceEdFactsCode,
			SexEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_CSA
		FROM #c052staging
		GROUP BY 
			School_Identifier_State,
			GradeLevel,
			RaceEdFactsCode,
			SexEdFactsCode

		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'CSA School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
				+ 'Grade Level: ' + s.GradeLevel + '  '
				+ 'Race: ' + convert(varchar, s.RaceEdFactsCode) + '  ' 
				+ 'Sex: ' + s.SexEdFactsCode + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSA s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.School_Identifier_State = rreksd.OrganizationStateId			
			AND s.GradeLevel = rreksd.GRADELEVEL
			AND s.RaceEdFactsCode = rreksd.RACE
			AND s.SexEdFactsCode = rreksd.SEX
			AND rreksd.ReportCode = 'C052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'CSA'

		DROP TABLE #SCH_CSA


		/**********************************************************************
		Test Case 4:
		ST1 at the SEA level
		Student Count by:
			GradeLevel
			RaceEdFactsCode
		***********************************************************************/
		SELECT
			GradeLevel,
			t.RaceEdFactsCode,
			COUNT(DISTINCT c.Student_Identifier_State) AS StudentCount
		INTO #SEA_ST1
		FROM #c052staging c
			LEFT JOIN (select cs.Student_Identifier_State,
							CASE WHEN isnull(rt.Student_Identifier_State, '') <> ''
								THEN 'MU7'
								ELSE cs.RaceEdFactsCode
							END AS RaceEdFactsCode
						from #c052Staging cs
							left join #raceTemp rt 
								on cs.Student_Identifier_State = rt.Student_Identifier_State
						) t
						on t.Student_Identifier_State = c.Student_Identifier_State 
		GROUP BY 
			GradeLevel,
			t.RaceEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'ST1 SEA'
			,'GradeLevel ' + s.GradeLevel
				+ ' Race: ' + convert(varchar, s.RaceEdFactsCode)
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SEA_ST1 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.GradeLevel = rreksd.GRADELEVEL
			AND s.RaceEdFactsCode = rreksd.RACE			
			AND rreksd.ReportCode = 'C052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST1'

		DROP TABLE #SEA_ST1


		/**********************************************************************
		Test Case 5:
		ST2 at the LEA level
		Student Count by:
			GradeLevel
			RaceEdFactsCode
		***********************************************************************/
		SELECT
			LEA_Identifier_State,
			GradeLevel,
			RaceEdFactsCode, 
			COUNT(DISTINCT c.Student_Identifier_State) AS StudentCount
		INTO #LEA_ST1
		FROM #c052staging c
		GROUP BY 
			LEA_Identifier_State,
			GradeLevel,
			RaceEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'ST1 LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
				+ 'Grade Level: ' + s.GradeLevel + '  '
				+ 'Race: ' + convert(varchar, s.RaceEdFactsCode)
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LEA_ST1 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId			
			AND s.GradeLevel = rreksd.GRADELEVEL
			AND s.RaceEdFactsCode = rreksd.RACE
			AND rreksd.ReportCode = 'C052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST1'

		DROP TABLE #LEA_ST1

		/**********************************************************************
		Test Case 6:
		ST1 at the School level
		Student Count by:
			GradeLevel
			RaceEdFactsCode
		***********************************************************************/
		SELECT
			School_Identifier_State,
			GradeLevel,
			RaceEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_ST1
		FROM #c052staging
		GROUP BY 
			School_Identifier_State,
			GradeLevel,
			RaceEdFactsCode

		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'ST1 School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
				+ 'Grade Level: ' + s.GradeLevel + '  '
				+ 'Race: ' + convert(varchar, s.RaceEdFactsCode)
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_ST1 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.School_Identifier_State = rreksd.OrganizationStateId			
			AND s.GradeLevel = rreksd.GRADELEVEL
			AND s.RaceEdFactsCode = rreksd.RACE
			AND rreksd.ReportCode = 'C052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'ST1'

		DROP TABLE #SCH_ST1


		/**********************************************************************
		Test Case 7:
		ST2 at the SEA level
		Student Count by:
			GradeLevel
			SexEdFactsCode
		***********************************************************************/
		SELECT
			GradeLevel,
			SexEdFactsCode,
			COUNT(DISTINCT c.Student_Identifier_State) AS StudentCount
		INTO #SEA_ST2
		FROM #c052staging c
		GROUP BY 
			GradeLevel,
			SexEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'ST2 SEA'
			,'GradeLevel ' + s.GradeLevel
				+ ' Sex: ' + s.SexEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SEA_ST2 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.GradeLevel = rreksd.GRADELEVEL
			AND s.SexEdFactsCode = rreksd.SEX
			AND rreksd.ReportCode = 'C052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST2'

		DROP TABLE #SEA_ST2


		/**********************************************************************
		Test Case 8:
		CSA at the LEA level
		Student Count by:
			GradeLevel
			SexEdFactsCode
		***********************************************************************/
		SELECT
			LEA_Identifier_State,
			GradeLevel,
			SexEdFactsCode,
			COUNT(DISTINCT c.Student_Identifier_State) AS StudentCount
		INTO #LEA_ST2
		FROM #c052staging c
		GROUP BY 
			LEA_Identifier_State,
			GradeLevel,
			SexEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'ST2 LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
				+ 'Grade Level: ' + s.GradeLevel + '  '
				+ 'Sex: ' + s.SexEdFactsCode + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LEA_ST2 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId			
			AND s.GradeLevel = rreksd.GRADELEVEL
			AND s.SexEdFactsCode = rreksd.SEX
			AND rreksd.ReportCode = 'C052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST2'

		DROP TABLE #LEA_ST2

		/**********************************************************************
		Test Case 9:
		CSA at the School level
		Student Count by:
			GradeLevel
			SexEdFactsCode
		***********************************************************************/
		SELECT
			School_Identifier_State,
			GradeLevel,
			SexEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_ST2
		FROM #c052staging
		GROUP BY 
			School_Identifier_State,
			GradeLevel,
			SexEdFactsCode

		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'ST2 School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
				+ 'Grade Level: ' + s.GradeLevel + '  '
				+ 'Sex: ' + s.SexEdFactsCode + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_ST2 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.School_Identifier_State = rreksd.OrganizationStateId			
			AND s.GradeLevel = rreksd.GRADELEVEL
			AND s.SexEdFactsCode = rreksd.SEX
			AND rreksd.ReportCode = 'C052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'ST2'

		DROP TABLE #SCH_ST2


		/**********************************************************************
		Test Case 10:
		ST3 at the SEA level
		Student Count by:
			RaceEdFactsCode
			SexEdFactsCode
		***********************************************************************/
		SELECT
			t.RaceEdFactsCode,
			SexEdFactsCode,
			COUNT(DISTINCT c.Student_Identifier_State) AS StudentCount
		INTO #SEA_ST3
		FROM #c052staging c
			LEFT JOIN (select cs.Student_Identifier_State,
							CASE WHEN isnull(rt.Student_Identifier_State, '') <> ''
								THEN 'MU7'
								ELSE cs.RaceEdFactsCode
							END AS RaceEdFactsCode
						from #c052Staging cs
							left join #raceTemp rt 
								on cs.Student_Identifier_State = rt.Student_Identifier_State
						) t
						on t.Student_Identifier_State = c.Student_Identifier_State 
		GROUP BY 
			t.RaceEdFactsCode,
			SexEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'ST3 SEA'
			,'Race: ' + convert(varchar, s.RaceEdFactsCode) + '  ' 
				+ ' Sex: ' + s.SexEdFactsCode+ '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SEA_ST3 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.RaceEdFactsCode = rreksd.RACE			
			AND s.SexEdFactsCode = rreksd.SEX
			AND rreksd.ReportCode = 'C052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST3'

		DROP TABLE #SEA_ST3


		/**********************************************************************
		Test Case 11:
		ST3 at the LEA level
		Student Count by:
			RaceEdFactsCode
			SexEdFactsCode
		***********************************************************************/
		SELECT
			LEA_Identifier_State,
			RaceEdFactsCode, 
			SexEdFactsCode,
			COUNT(DISTINCT c.Student_Identifier_State) AS StudentCount
		INTO #LEA_ST3
		FROM #c052staging c
		GROUP BY 
			LEA_Identifier_State,
			RaceEdFactsCode,
			SexEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'ST3 LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
				+ 'Race: ' + convert(varchar, s.RaceEdFactsCode) + '  ' 
				+ 'Sex: ' + s.SexEdFactsCode + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LEA_ST3 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON
			s.LEA_Identifier_State = rreksd.OrganizationStateId			
			AND s.RaceEdFactsCode = rreksd.RACE
			AND s.SexEdFactsCode = rreksd.SEX
			AND rreksd.ReportCode = 'C052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST3'

		DROP TABLE #LEA_ST3

		/**********************************************************************
		Test Case 12:
		ST3 at the School level
		Student Count by:
			RaceEdFactsCode
			SexEdFactsCode
		***********************************************************************/
		SELECT
			School_Identifier_State,
			RaceEdFactsCode,
			SexEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_ST3
		FROM #c052staging
		GROUP BY 
			School_Identifier_State,
			RaceEdFactsCode,
			SexEdFactsCode

		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'ST3 School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
				+ 'Race: ' + convert(varchar, s.RaceEdFactsCode) + '  ' 
				+ 'Sex: ' + s.SexEdFactsCode + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_ST3 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.School_Identifier_State = rreksd.OrganizationStateId			
			AND s.RaceEdFactsCode = rreksd.RACE
			AND s.SexEdFactsCode = rreksd.SEX
			AND rreksd.ReportCode = 'C052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'ST3'

		DROP TABLE #SCH_ST3


		/**********************************************************************
		Test Case 13:
		ST4 at the SEA level
		Student Count by:
			GradeLevel
		***********************************************************************/
		SELECT
			GradeLevel,
			COUNT(DISTINCT c.Student_Identifier_State) AS StudentCount
		INTO #SEA_ST4
		FROM #c052staging c
		GROUP BY 
			GradeLevel

		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'ST4 SEA'
			,'GradeLevel ' + s.GradeLevel + '  ' 
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SEA_ST4 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.GradeLevel = rreksd.GRADELEVEL
			AND rreksd.ReportCode = 'C052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST4'

		DROP TABLE #SEA_ST4


		/**********************************************************************
		Test Case 14:
		CSA at the LEA level
		Student Count by:
			GradeLevel
		***********************************************************************/
		SELECT
			LEA_Identifier_State,
			GradeLevel,
			COUNT(DISTINCT c.Student_Identifier_State) AS StudentCount
		INTO #LEA_ST4
		FROM #c052staging c
		GROUP BY 
			LEA_Identifier_State,
			GradeLevel

		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'ST4 LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
				+ 'Grade Level: ' + s.GradeLevel + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LEA_ST4 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId			
			AND s.GradeLevel = rreksd.GRADELEVEL
			AND rreksd.ReportCode = 'C052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST4'

		DROP TABLE #LEA_ST4

		/**********************************************************************
		Test Case 15:
		CSA at the School level
		Student Count by:
			GradeLevel
		***********************************************************************/
		SELECT
			School_Identifier_State,
			GradeLevel,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_ST4
		FROM #c052staging
		GROUP BY 
			School_Identifier_State,
			GradeLevel

		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'ST4 School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
				+ 'Grade Level: ' + s.GradeLevel + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_ST4 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.School_Identifier_State = rreksd.OrganizationStateId			
			AND s.GradeLevel = rreksd.GRADELEVEL
			AND rreksd.ReportCode = 'C052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'ST4'

		DROP TABLE #SCH_ST4



		/**********************************************************************
		Test Case 16:
		Total at the SEA level
		***********************************************************************/
		SELECT 
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SEA_TOT
		FROM #c052staging 
		
		INSERT INTO App.SqlUnitTestCaseResult (
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT DISTINCT
			 @SqlUnitTestId
			,'TOT SEA'
			,'SEA Total'
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SEA_TOT s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON rreksd.ReportCode = 'c052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'TOT'

		DROP TABLE #SEA_TOT


		/**********************************************************************
		Test Case 17:
		Total at the LEA level
		***********************************************************************/
		SELECT 
			Lea_Identifier_State,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #LEA_TOT
		FROM #c052staging 
		GROUP BY 
			Lea_Identifier_State
		
		INSERT INTO App.SqlUnitTestCaseResult (
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT DISTINCT
			 @SqlUnitTestId
			,'TOT LEA'
			,'Lea_Identifier_State: ' + s.Lea_Identifier_State + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LEA_TOT s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.Lea_Identifier_State = rreksd.OrganizationStateId
			AND rreksd.ReportCode = 'c052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'TOT'

		DROP TABLE #LEA_TOT

		/**********************************************************************
		Test Case 18:
		Total at the SCH level
		***********************************************************************/
		SELECT 
			School_Identifier_State,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_TOT
		FROM #c052staging 
		GROUP BY 
			School_Identifier_State
		
		INSERT INTO App.SqlUnitTestCaseResult (
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT DISTINCT
			 @SqlUnitTestId
			,'TOT School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.School_Identifier_State = rreksd.OrganizationStateId
			AND rreksd.ReportCode = 'c052' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'TOT'

		DROP TABLE #SCH_TOT

END
