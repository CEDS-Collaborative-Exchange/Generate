CREATE PROCEDURE [App].[FS033_TestCase] 
@SchoolYear INT
AS
BEGIN

	--Create SY Start / SY End variables
	declare @SYStart varchar(10) = CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
	declare @SYEnd varchar(10) = CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)


	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C033Staging') IS NOT NULL
	DROP TABLE #C033Staging


	IF OBJECT_ID('tempdb..#SCH_CSA') IS NOT NULL
	DROP TABLE #SCH_CSA
	IF OBJECT_ID('tempdb..#SCH_TOT') IS NOT NULL
	DROP TABLE #SCH_TOT

	-- Define the test
	DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT

	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS033_UnitTestCase') 
	BEGIN
		SET @expectedResult = 1
		INSERT INTO App.SqlUnitTest (
			UnitTestName,
			StoredProcedureName,
			TestScope,
			IsActive
		) VALUES (
			'FS033_UnitTestCase',
			'FS033_TestCase',
			'FS033',
			1
		)
		SET @SqlUnitTestId = @@IDENTITY
	END 
	ELSE 
	BEGIN
		SELECT 
			@SqlUnitTestId = SqlUnitTestId
		FROM App.SqlUnitTest 
		WHERE UnitTestName = 'FS033_UnitTestCase'
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
		ske.StudentIdentifierState,
		ske.LEAIdentifierSeaAccountability,
		ske.SchoolIdentifierSea,
				--select distinct EligibilityStatusForSchoolFoodServicePrograms from staging.PersonStatus
				--select distinct NationalSchoolLunchProgramDirectCertificationIndicator from staging.PersonStatus
		CASE sps.EligibilityStatusForSchoolFoodServicePrograms
				WHEN 'Free_1' THEN 'FL'
				WHEN 'ReducedPrice_1' THEN 'RPL'
				ELSE 'MISSING'
		END AS FRLEdFactsCode,
		sps.EligibilityStatusForSchoolFoodServicePrograms,
		CASE when sps.NationalSchoolLunchProgramDirectCertificationIndicator = 1 then 'DIRECTCERT'
			when sps.EligibilityStatusForSchoolFoodServicePrograms in ('Free_1', 'ReducedPrice_1') then 'LUNCHFREERED'
		END as DirectCertEdFactsCode

	INTO #c033Staging
	FROM Staging.K12Enrollment ske
		LEFT JOIN RDS.vwDimGradeLevels rgls
			ON rgls.SchoolYear = ske.SchoolYear
			AND ske.GradeLevel = rgls.GradeLevelMap
			AND rgls.GradeLevelTypeDescription = 'Entry Grade Level'

	LEFT JOIN Staging.PersonStatus sps
		ON ske.StudentIdentifierState = sps.StudentIdentifierState
		AND --(ske.LEAIdentifierSeaAccountability = sps.LEAIdentifierSeaAccountability
			--OR 
			ske.SchoolIdentifierSea = sps.SchoolIdentifierSea
			--)
		--AND sps.RecordStartDateTime is not null
		--AND @MemberDate BETWEEN sps.RecordStartDateTime AND ISNULL(sps.RecordEndDateTime, @SYEnd)		
	WHERE @MemberDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEnd)
	AND rgls.GradeLevelCode IN (SELECT GradeLevel FROM @GradesList)


	-------------------------------------------------
	-- Gather, evaluate & record the results
	-------------------------------------------------

		/**********************************************************************
		Test Case 1:
		CSA at the School level
		Student Count by:
			FRLEdFactsCode
		***********************************************************************/
		SELECT
			SchoolIdentifierSea,
			FRLEdFactsCode,
			--DirectCertEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSA
		FROM #c033staging
		GROUP BY 
			SchoolIdentifierSea,
			FRLEdFactsCode--,
			--DirectCertEdFactsCode

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
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
				+ 'FRL Status: ' + s.FRLEdFactsCode + '  '
				--+ 'Direct Cert: ' + s.DirectCertEdFactsCode + '  ' 
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSA s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.SchoolIdentifierSea = rreksd.OrganizationIdentifierSea	
			AND s.FRLEdFactsCode = rreksd.ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAMS
			--AND s.DirectCertEdFactsCode = rreksd.TableTypeAbbrv
			AND rreksd.ReportCode = 'C033' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'CSA'

		DROP TABLE #SCH_CSA


		/**********************************************************************
		Test Case 2:
		Total at the SCH level
		***********************************************************************/
		SELECT
			SchoolIdentifierSea,
			'DIRECTCERT' DirectCertEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_TOT
		FROM #c033staging
		where FRLEdFactsCode in ('FL', 'RPL')
		and DirectCertEdFactsCode = 'DIRECTCERT'
		GROUP BY 
			SchoolIdentifierSea,
			DirectCertEdFactsCode

		UNION

		SELECT
			SchoolIdentifierSea,
			'LUNCHFREERED' DirectCertEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		FROM #c033staging
		where FRLEdFactsCode in ('FL', 'RPL')
		GROUP BY 
			SchoolIdentifierSea


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
			,'TOT School'
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
				+ 'Direct Cert: ' + s.DirectCertEdFactsCode + '  ' 
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.SchoolIdentifierSea = rreksd.OrganizationIdentifierSea	
			AND s.DirectCertEdFactsCode = rreksd.TableTypeAbbrv
			AND rreksd.ReportCode = 'C033' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'TOT'

		DROP TABLE #SCH_TOT

-- IF THE TEST PRODUCES NO RESULTS INSERT A RECORD TO INDICATE THIS -------------------------
if not exists(select top 1 * from app.sqlunittest t
	inner join app.SqlUnitTestCaseResult r
		on t.SqlUnitTestId = r.SqlUnitTestId
		and t.SqlUnitTestId = @SqlUnitTestId)
begin
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
			SELECT DISTINCT
				 @SqlUnitTestId
				,'NO TEST RESULTS'
				,'NO TEST RESULTS'
				,-1
				,-1
				,NULL
				,GETDATE()
end
----------------------------------------------------------------------------------	
END
