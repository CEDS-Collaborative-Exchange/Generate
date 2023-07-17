CREATE PROCEDURE [App].[FS116_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#staging') IS NOT NULL
	DROP TABLE #staging

	IF OBJECT_ID('tempdb..#S_CSA') IS NOT NULL
	DROP TABLE #S_CSA
	IF OBJECT_ID('tempdb..#S_CSB') IS NOT NULL
	DROP TABLE #S_CSB
	IF OBJECT_ID('tempdb..#S_TOT') IS NOT NULL
	DROP TABLE #S_TOT
	IF OBJECT_ID('tempdb..#S_CSA1') IS NOT NULL
	DROP TABLE #S_CSA1

	IF OBJECT_ID('tempdb..#L_CSA') IS NOT NULL
	DROP TABLE #L_CSA
	IF OBJECT_ID('tempdb..#L_CSB') IS NOT NULL
	DROP TABLE #L_CSB
	IF OBJECT_ID('tempdb..#L_TOT') IS NOT NULL
	DROP TABLE #L_TOT
	IF OBJECT_ID('tempdb..#L_CSA1') IS NOT NULL
	DROP TABLE #L_CSA1


		DECLARE 
		@SYStartDate DATE,
		@SYEndDate DATE
		
		SET @SYStartDate = staging.GetFiscalYearStartDate(@SchoolYear)
		SET @SYEndDate = staging.GetFiscalYearEndDate(@SchoolYear)


	if not exists (select * from sys.indexes where name = 'ix_K12PersonRace_StudentLEASCH' and object_id = object_id('Staging.K12PersonRace'))
		begin
			CREATE NONCLUSTERED INDEX [ix_K12PersonRace_StudentLEASCH] ON [Staging].[K12PersonRace]
			(
				[StudentIdentifierState] ASC,
				[LeaIdentifierSeaAccountability] ASC,
				[SchoolIdentifierSea] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		end

	-- Define the test
	DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS116_UnitTestCase') 
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
			'FS116_UnitTestCase'
			, 'FS116_TestCase'				
			, 'FS116'
			, 1
		)
		SET @SqlUnitTestId = @@IDENTITY
	END 
	ELSE 
	BEGIN
		SELECT 
			@SqlUnitTestId = SqlUnitTestId
		--, @expectedResult = ExpectedResult 
		FROM App.SqlUnitTest 
		WHERE UnitTestName = 'FS116_UnitTestCase'
	END
	

	-- Clear out last run
	DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId

	-- Populate temp table
	SELECT DISTINCT
		ske.StudentIdentifierState
		, ske.LeaIdentifierSeaAccountability
		, ske.SchoolIdentifierSea
		, ske.GradeLevel
		,CASE 
			WHEN ske.HispanicLatinoEthnicity = 1 THEN 'HI7' 
			WHEN spr.RaceType = 'AmericanIndianorAlaskaNative' THEN 'AM7'
			WHEN spr.RaceType = 'Asian' THEN 'AS7'
			WHEN spr.RaceType = 'BlackorAfricanAmerican' THEN 'BL7'
			WHEN spr.RaceType = 'NativeHawaiianorOtherPacificIslander' THEN 'PI7'
			WHEN spr.RaceType = 'White' THEN 'WH7'
			WHEN spr.RaceType = 'TwoorMoreRaces' THEN 'MU7'
		END AS RaceEdFactsCode
		, rdgl.GradeLevelEdFactsCode
		, sppt3.TitleIIILanguageInstructionProgramType
		, rdt3s.TitleIIILanguageInstructionProgramTypeEdFactsCode
	INTO #staging
	FROM Staging.K12Enrollment ske

	JOIN Staging.ProgramParticipationTitleIII sppt3
		ON sppt3.StudentIdentifierState = ske.StudentIdentifierState
		AND sppt3.LeaIdentifierSeaAccountability = ske.LeaIdentifierSeaAccountability
		AND sppt3.SchoolIdentifierSea = ske.SchoolIdentifierSea
		and convert(date, sppt3.ProgramParticipationBeginDate) <= @SYEndDate
		and ISNULL(convert(date, sppt3.ProgramParticipationEndDate), @SYEndDate) >= @SYStartDate


	JOIN RDS.DimGradeLevels rdgl
		ON ske.GradeLevel = rdgl.GradeLevelCode
	JOIN RDS.DimTitleIIIStatuses rdt3s
		ON sppt3.TitleIIILanguageInstructionProgramType = rdt3s.TitleIIILanguageInstructionProgramTypeCode
		AND rdt3s.ProgramParticipationTitleIIILiepCode = 'MISSING'
		AND rdt3s.TitleIIIImmigrantParticipationStatusCode = 'MISSING'
		AND rdt3s.ProficiencyStatusCode = 'MISSING'
		AND rdt3s.TitleIIIAccountabilityProgressStatusCode = 'MISSING'

	LEFT JOIN Staging.K12PersonRace spr
		ON ske.SchoolYear = spr.SchoolYear
		AND ske.StudentIdentifierState = spr.StudentIdentifierState
		AND (isnull(ske.LeaIdentifierSeaAccountability,'') = isnull(spr.LeaIdentifierSeaAccountability,'')
			OR isnull(ske.SchoolIdentifierSea,'') = isnull(spr.SchoolIdentifierSea,''))

	WHERE isnull(rdt3s.TitleIIILanguageInstructionProgramTypeCode,'MISSING') <> 'MISSING'
		and convert(date, ske.EnrollmentEntryDate) <= @SYEndDate
		and ISNULL(convert(date, ske.EnrollmentExitDate), @SYEndDate) >= @SYStartDate

--select * from #staging
--return
		/**********************************************************************
		Test Case 1:
		CSA at the SEA level
		Student Count by:
			GradeLevel
		***********************************************************************/
		SELECT
			GradeLevel,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_CSA
		FROM #staging 
		GROUP BY 
			GradeLevel

--select * from #s_csa
--return
		
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
			,'CSA SEA'
			,'Grade: ' + convert(varchar, s.GradeLevel) + '  ' 
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSA s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.GradeLevel = rreksd.GRADELEVEL			
			AND rreksd.ReportCode = 'C116' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSA'
			and rreksd.Categories = '|GRADELVBASICW13|'

--select * from app.SqlUnitTestCaseResult
--where sqlunittestid = 34
--return

		DROP TABLE #S_CSA

		/**********************************************************************
		Test Case 2:
		CSA at the LEA level
		Student Count by:
			GradeLevel
		***********************************************************************/
		SELECT
			LeaIdentifierSeaAccountability,
			GradeLevel,
			COUNT(StudentIdentifierState) AS StudentCount
		INTO #L_CSA
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			GradeLevel

		
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
			,'CSA LEA'
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			 + 'Grade: ' + convert(varchar, s.GradeLevel) + '  ' 
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSA s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			AND s.GradeLevel = rreksd.GRADELEVEL			
			AND rreksd.ReportCode = 'C116' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSA'
			and rreksd.Categories = '|GRADELVBASICW13|'

		DROP TABLE #L_CSA


		/**********************************************************************
		Test Case 3:
		CSA at the SEA level
		Student Count by:
			Race
		***********************************************************************/
		SELECT
			RaceEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_CSB
		FROM #staging 
		GROUP BY 
			RaceEdFactsCode

		
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
			,'CSB SEA'
			,'Race: ' + convert(varchar, s.RaceEdFactsCode) + '  ' 
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSB s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.RaceEdFactsCode = rreksd.RACE			
			AND rreksd.ReportCode = 'C116' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSB'

		DROP TABLE #S_CSB

		/**********************************************************************
		Test Case 4:
		CSA at the LEA level
		Student Count by:
			Race
		***********************************************************************/
		SELECT
			LeaIdentifierSeaAccountability,
			RaceEdFactsCode,
			COUNT(StudentIdentifierState) AS StudentCount
		INTO #L_CSB
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			RaceEdFactsCode

		
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
			,'CSB LEA'
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			 + 'Race: ' + convert(varchar, s.RaceEdFactsCode) + '  ' 
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSB s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			AND s.RaceEdFactsCode = rreksd.RACE			
			AND rreksd.ReportCode = 'C116' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSA'

		DROP TABLE #L_CSB

		/**********************************************************************
		Test Case 5:
		Total at the SEA level
		***********************************************************************/
		SELECT 
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_TOT
		FROM #staging s
		
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
			,'TOT SEA'
			,'Total Student'
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_TOT s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON rreksd.ReportCode = 'C116' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'TOT'

		DROP TABLE #S_TOT



		/**********************************************************************
		Test Case 6:
		Total at the LEA level
		***********************************************************************/
		SELECT 
			LeaIdentifierSeaAccountability,
			COUNT(StudentIdentifierState) AS StudentCount
		INTO #L_TOT
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability
		
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
			,'TOT LEA'
			,'Total Student ' +
			'LeaIdentifierSeaAccountability: ' + isnull(s.LeaIdentifierSeaAccountability,'') + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			AND rreksd.ReportCode = 'C116' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'TOT'

		DROP TABLE #L_TOT

		/**********************************************************************
		Test Case 7:
		CSA at the SEA level
		Student Count by:
			GradeLevel
			Language Instruction Educational Program Type
		***********************************************************************/
		SELECT
			GradeLevel,
			TitleIIILanguageInstructionProgramTypeEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_CSA1
		FROM #staging 
		GROUP BY 
			GradeLevel,
			TitleIIILanguageInstructionProgramTypeEdFactsCode

		
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
			,'CSA SEA'
			,'Grade: ' + convert(varchar, s.GradeLevel) + '  ' 
			+ 'LIEPType: ' + convert(varchar, s.TitleIIILanguageInstructionProgramTypeEdFactsCode)
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSA1 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.GradeLevel = rreksd.GRADELEVEL			
			AND s.TitleIIILanguageInstructionProgramTypeEdFactsCode = rreksd.TITLEIIILANGUAGEINSTRUCTIONPROGRAMTYPE
			AND rreksd.ReportCode = 'C116' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSA'
			AND rreksd.Categories = '|GRADELVBASICW13|,|LNGINSTPRGTYPE|'

		DROP TABLE #S_CSA1

		/**********************************************************************
		Test Case 8:
		CSA at the LEA level
		Student Count by:
			GradeLevel
			Language Instruction Educational Program Type
	***********************************************************************/
		SELECT
			LeaIdentifierSeaAccountability,
			GradeLevel,
			TitleIIILanguageInstructionProgramTypeEdFactsCode,
			COUNT(StudentIdentifierState) AS StudentCount
		INTO #L_CSA1
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			GradeLevel,
			TitleIIILanguageInstructionProgramTypeEdFactsCode
	

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
			,'CSA LEA'
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			 + 'Grade: ' + convert(varchar, s.GradeLevel) + '  ' 
     		 + 'LIEPType: ' + convert(varchar, s.TitleIIILanguageInstructionProgramTypeEdFactsCode)

			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSA1 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			AND s.GradeLevel = rreksd.GRADELEVEL	
			AND s.TitleIIILanguageInstructionProgramTypeEdFactsCode = rreksd.TITLEIIILANGUAGEINSTRUCTIONPROGRAMTYPE
			AND rreksd.ReportCode = 'C116' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSA'
			AND rreksd.Categories = '|GRADELVBASICW13|,|LNGINSTPRGTYPE|'

		DROP TABLE #L_CSA1




	
END