CREATE PROCEDURE [App].[FS118_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C118Staging') IS NOT NULL DROP TABLE #C118Staging

	IF OBJECT_ID('tempdb..#S_CSA') IS NOT NULL DROP TABLE #S_CSA
	IF OBJECT_ID('tempdb..#S_CSB') IS NOT NULL DROP TABLE #S_CSB
	IF OBJECT_ID('tempdb..#S_CSC') IS NOT NULL DROP TABLE #S_CSC
	IF OBJECT_ID('tempdb..#S_CSD') IS NOT NULL DROP TABLE #S_CSD
	IF OBJECT_ID('tempdb..#S_CSE') IS NOT NULL DROP TABLE #S_CSE
	IF OBJECT_ID('tempdb..#S_CSF') IS NOT NULL DROP TABLE #S_CSF
	IF OBJECT_ID('tempdb..#S_CSG') IS NOT NULL DROP TABLE #S_CSG
	IF OBJECT_ID('tempdb..#S_CSH') IS NOT NULL DROP TABLE #S_CSH
	IF OBJECT_ID('tempdb..#S_TOT') IS NOT NULL DROP TABLE #S_TOT

	IF OBJECT_ID('tempdb..#L_CSA') IS NOT NULL DROP TABLE #L_CSA
	IF OBJECT_ID('tempdb..#L_CSB') IS NOT NULL DROP TABLE #L_CSB
	IF OBJECT_ID('tempdb..#L_CSC') IS NOT NULL DROP TABLE #L_CSC
	IF OBJECT_ID('tempdb..#L_CSD') IS NOT NULL DROP TABLE #L_CSD
	IF OBJECT_ID('tempdb..#L_CSE') IS NOT NULL DROP TABLE #L_CSE
	IF OBJECT_ID('tempdb..#L_CSF') IS NOT NULL DROP TABLE #L_CSF
	IF OBJECT_ID('tempdb..#L_CSG') IS NOT NULL DROP TABLE #L_CSG
	IF OBJECT_ID('tempdb..#L_CSH') IS NOT NULL DROP TABLE #L_CSH
	IF OBJECT_ID('tempdb..#L_TOT') IS NOT NULL DROP TABLE #L_TOT

	--performance 
	IF OBJECT_ID(N'tempdb..#tempELStatus') IS NOT NULL DROP TABLE #tempELStatus
	IF OBJECT_ID(N'tempdb..#tempMigrantStatus') IS NOT NULL DROP TABLE #tempMigrantStatus
	IF OBJECT_ID(N'tempdb..#tempStudents') IS NOT NULL DROP TABLE #tempStudents

	-- Define the test
	DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS118_UnitTestCase') 

	BEGIN
		SET @expectedResult = 1
		INSERT INTO App.SqlUnitTest (
			[UnitTestName]
			, [StoredProcedureName]
			, [TestScope]
			, [IsActive]
		)
		VALUES (
			'FS118_UnitTestCase'
			, 'FS118_TestCase'				
			, 'FS118'
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
		WHERE UnitTestName = 'FS118_UnitTestCase'
	END
	
	-- Clear out last run
	DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
	
	--Create SY Start / SY End variables
	declare @SYStart varchar(10) = CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
	declare @SYEnd varchar(10) = CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)

	-- Get Custom Child Count Date
	DECLARE @cutOffMonth INT, @cutOffDay INT, @customFactTypeDate VARCHAR(10), @childCountDate date
	set @cutOffMonth = 11
	set @cutOffDay = 1

	select @customFactTypeDate = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CHDCTDTE'

	select @cutOffMonth = SUBSTRING(@customFactTypeDate, 0, CHARINDEX('/', @customFactTypeDate))
	select @cutOffDay = SUBSTRING(@customFactTypeDate, CHARINDEX('/', @customFactTypeDate) + 1, 2)

    select @ChildCountDate = convert(varchar, @CutoffMonth) + '/' + convert(varchar, @CutoffDay) + '/' + convert(varchar, @SchoolYear -1)
		
	--Pull the EL Status into a temp table
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, EnglishLearnerStatus
			, EnglishLearner_StatusStartDate
			, EnglishLearner_StatusEndDate
		INTO #tempELStatus
		FROM Staging.PersonStatus

	-- Create Index for #tempELStatus 
		CREATE INDEX IX_tempELStatus ON #tempELStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Englishlearner_StatusStartDate, EnglishLearner_StatusEndDate)

	--Pull the Migrant Status into a temp table
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, MigrantStatus
			, Migrant_StatusStartDate
			, Migrant_StatusEndDate
		INTO #tempMigrantStatus
		FROM Staging.PersonStatus

	-- Create Index for #tempMigrantStatus 
		CREATE INDEX IX_tempMigrantStatus ON #tempMigrantStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Migrant_StatusStartDate, Migrant_StatusEndDate)


	--Get the LEAs that should not be reported against
	IF OBJECT_ID('tempdb..#excludedLeas') IS NOT NULL DROP TABLE #excludedLeas

	CREATE TABLE #excludedLeas (
		LeaIdentifierSeaAccountability		VARCHAR(20)
	)

	INSERT INTO #excludedLeas 
	SELECT DISTINCT LEAIdentifierSea
	FROM Staging.K12Organization sko
	LEFT JOIN Staging.OrganizationPhone sop
			ON sko.LEAIdentifierSea = sop.OrganizationIdentifier
			AND sop.OrganizationType in (	SELECT InputCode
										FROM Staging.SourceSystemReferenceData 
										WHERE TableName = 'RefOrganizationType' 
											AND TableFilter = '001156'
											AND OutputCode = 'LEA' AND SchoolYear = @SchoolYear)
	WHERE LEA_IsReportedFederally = 0
		OR LEA_OperationalStatus in ('Closed', 'FutureAgency', 'Inactive', 'Closed_1', 'FutureAgency_1', 'Inactive_1', 'MISSING')
		OR sop.OrganizationIdentifier IS NULL

	-- Gather, evaluate & record the results
	SELECT  
		ske.StudentIdentifierState
		, ske.LeaIdentifierSeaAccountability
		, ske.SchoolIdentifierSea
		, ske.EnrollmentEntryDate
		, ske.HispanicLatinoEthnicity
		, ske.Sex
		, CASE ske.Sex
			WHEN 'Male'		THEN 'M'
			WHEN 'Female'	THEN 'F'
			WHEN 'Male_1'	THEN 'M'
			WHEN 'Female_1'	THEN 'F'
			ELSE 'MISSING'
		END AS SexEdFactsCode
		, idea.ProgramParticipationEndDate
		--, spr.RaceMap
		, rdr.RaceEdFactsCode
	--English Learner Status
		, ISNULL(el.EnglishLearnerStatus, 0) AS EnglishLearnerStatus
		, CASE
			WHEN el.EnglishLearnerStatus = 1 THEN 'LEP'
			ELSE 'MISSING'
		END AS EnglishLearnerStatusEdFactsCode
	--Homelessness
		, hmStatus.HomelessUnaccompaniedYouth
		, CASE WHEN hmStatus.HomelessUnaccompaniedYouth = 1 THEN 'UY'
				ELSE 'MISSING'
		END AS HomelessUnaccompaniedYouthEdFactsCode		

		, hmNight.HomelessNighttimeResidence
		, CASE ISNULL(hmNight.HomelessNighttimeResidence, '')
			WHEN 'DoubledUp'					THEN 'D'
			WHEN 'HotelMotel'					THEN 'HM'
			WHEN 'Shelter'						THEN 'STH'
			WHEN 'SheltersTransitionalHousing'	THEN 'STH'
			WHEN 'Transitional Housing'			THEN 'STH'
			WHEN 'Unsheltered'					THEN 'U'
			WHEN 'DoubledUp_1'					THEN 'D'
			WHEN 'HotelMotel_1'					THEN 'HM'
			WHEN 'Shelter_1'					THEN 'STH'
			WHEN 'SheltersTransitionalHousing_1'THEN 'STH'
			WHEN 'Transitional Housing_1'		THEN 'STH'
			WHEN 'Unsheltered_1'				THEN 'U'
			ELSE 'MISSING'
		END AS HomelessPrimaryNighttimeResidenceEdFactsCode

	--Age/Grade
		, CASE WHEN rds.Get_Age(ske.Birthdate, @SYStart) >= 3
					AND rds.Get_Age(ske.Birthdate, @SYStart) <= 5
					AND ISNULL(ske.GradeLevel, 'PK') in ('PK', 'PK_1')
				THEN '3TO5NOTK'
				ELSE ISNULL(ske.GradeLevel, 'MISSING')
		END AS GradeLevelEdFactsCode	

	--Disability Status
		, ISNULL(IdeaIndicator, 0) AS DisabilityStatus
		, CASE
			WHEN IdeaIndicator = 1 THEN 'WDIS' 
			ELSE 'MISSING'
		END AS DisabilityStatusEdFactsCode
	--Migratory Status
		, ISNULL(migrant.MigrantStatus, 0) AS MigrantStatus
		, CASE 
			WHEN migrant.MigrantStatus = 1 THEN 'MS'
			ELSE 'MISSING'
		END AS MigrantStatusEdFactsCode
	INTO #C118Staging
	FROM Staging.K12Enrollment ske
	--homeless
	JOIN Staging.PersonStatus hmStatus
		ON ske.StudentIdentifierState = hmStatus.StudentIdentifierState
		AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(hmStatus.LeaIdentifierSeaAccountability, '')
		AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(hmStatus.SchoolIdentifierSea, '')
		AND hmStatus.Homelessness_StatusStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEnd)
	--homeless nighttime residence
	LEFT JOIN Staging.PersonStatus hmNight
		ON ske.StudentIdentifierState = hmNight.StudentIdentifierState
		AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(hmNight.LeaIdentifierSeaAccountability, '')
		AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(hmNight.SchoolIdentifierSea, '')
		AND hmNight.HomelessNightTimeResidence_StartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEnd)
	--disability status
	LEFT JOIN Staging.ProgramParticipationSpecialEducation idea
		ON ske.StudentIdentifierState = idea.StudentIdentifierState
		AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(idea.LeaIdentifierSeaAccountability, '')
		AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(idea.SchoolIdentifierSea, '')
		AND hmStatus.Homelessness_StatusStartDate BETWEEN idea.ProgramParticipationBeginDate AND ISNULL(idea.ProgramParticipationEndDate, @SYEnd)
		AND idea.IDEAIndicator = 1
	--idea disability type			
	LEFT JOIN Staging.IdeaDisabilityType sidt	
		ON ske.SchoolYear = sidt.SchoolYear
		AND sidt.StudentIdentifierState = idea.StudentIdentifierState
		AND ISNULL(sidt.LeaIdentifierSeaAccountability, '') = ISNULL(idea.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sidt.SchoolIdentifierSea, '') = ISNULL(idea.SchoolIdentifierSea, '')
		AND sidt.IsPrimaryDisability = 1
		AND hmStatus.Homelessness_StatusStartDate BETWEEN sidt.RecordStartDateTime AND ISNULL(sidt.RecordEndDateTime, @SYEnd)
	--english learner
	LEFT JOIN #tempELStatus el 
		ON hmStatus.StudentIdentifierState = el.StudentIdentifierState
		AND ISNULL(hmStatus.LeaIdentifierSeaAccountability, '') = ISNULL(el.LeaIdentifierSeaAccountability, '') 
		AND ISNULL(hmStatus.SchoolIdentifierSea, '') = ISNULL(el.SchoolIdentifierSea, '')
		AND hmStatus.Homelessness_StatusStartDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, @SYEnd)
	--migratory status	
	LEFT JOIN #tempMigrantStatus migrant
		ON hmStatus.StudentIdentifierState = migrant.StudentIdentifierState
		AND ISNULL(hmStatus.LeaIdentifierSeaAccountability, '') = ISNULL(migrant.LeaIdentifierSeaAccountability, '')
		AND ISNULL(hmStatus.SchoolIdentifierSea, '') = ISNULL(migrant.SchoolIdentifierSea, '')
		AND hmStatus.Homelessness_StatusStartDate BETWEEN migrant.Migrant_StatusStartDate AND ISNULL(migrant.Migrant_StatusEndDate, @SYEnd)
	--race	
	LEFT JOIN Staging.K12PersonRace spr
		ON spr.StudentIdentifierState = ske.StudentIdentifierState
		AND ISNULL(spr.LeaIdentifierSeaAccountability, '') = ISNULL(ske.LeaIdentifierSeaAccountability, '')
		AND ISNULL(spr.SchoolIdentifierSea, '') = ISNULL(ske.SchoolIdentifierSea, '')
		AND spr.SchoolYear = ske.SchoolYear
		AND CAST(ISNULL(hmStatus.Homelessness_StatusStartDate, '1900-01-01') AS DATE) BETWEEN spr.RecordStartDateTime AND ISNULL(spr.RecordEndDateTime, @SYEnd)
	--race (rds)
	LEFT JOIN RDS.DimRaces rdr
		ON (ske.HispanicLatinoEthnicity = 1 and rdr.RaceEdFactsCode = 'HI7')
			OR (ske.HispanicLatinoEthnicity = 0 AND replace(spr.RaceType, '_1', '') = rdr.RaceCode)

	WHERE hmStatus.HomelessnessStatus = 1 
			AND hmStatus.Homelessness_StatusStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEnd)
			AND isnull(ske.GradeLevel, 'xx') not in ('AE', 'ABE', '13', 'UG', 'AE_1', 'ABE_1', '13_1', 'UG_1')
			AND ske.StudentIdentifierState not like ('%CI%')

	/**********************************************************************
		Test Case 1:
		CSA at the SEA level - Student Count by Age/Grade (Basic)
	***********************************************************************/
	;with cte as (
	select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState ORDER BY EnrollmentEntryDate) as 'rownum' 
	from #C118Staging
	)
	SELECT 
		GradeLevelEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSA
	FROM cte 
	WHERE GradeLevelEdFactsCode not in ('PK', 'PK_1','MISSING')
		AND rownum = 1
	GROUP BY GradeLevelEdFactsCode

	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT 
		@SqlUnitTestId
		, 'CSA SEA Match All'
		, 'CSA SEA Match All - Age/Grade: ' +  s.GradeLevelEdFactsCode
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON replace(s.GradeLevelEdFactsCode, '_1', '') = rreksc.GRADELEVEL
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'SEA'
		AND rreksc.CategorySetCode = 'CSA'
	
	DROP TABLE #S_CSA

	/**********************************************************************
		Test Case 2:
		CSB at the SEA level - Student Count by Homeless Primary Nighttime Residence
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		HomelessPrimaryNighttimeResidenceEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSB
	FROM cte 
	WHERE HomelessPrimaryNighttimeResidenceEdFactsCode <> 'MISSING'
		AND rownum = 1
	GROUP BY HomelessPrimaryNighttimeResidenceEdFactsCode

	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT DISTINCT
		@SqlUnitTestId
		, 'CSB SEA Match All'
		, 'CSB SEA Match All - Homeless Primary Nighttime Residence: ' + HomelessPrimaryNighttimeResidenceEdFactsCode 
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSB s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.HomelessPrimaryNighttimeResidenceEdFactsCode = rreksc.HOMELESSPRIMARYNIGHTTIMERESIDENCE
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'SEA'
		AND rreksc.CategorySetCode = 'CSB'

	DROP TABLE #S_CSB

	/**********************************************************************
		Test Case 3:
		CSC at the SEA level - Student Count by Disability Status (Only)
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		DisabilityStatusEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSC
	FROM cte 
	WHERE DisabilityStatusEdFactsCode <> 'MISSING'
		AND rownum = 1
	GROUP BY DisabilityStatusEdFactsCode
		
	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT DISTINCT
		@SqlUnitTestId
		, 'CSC SEA Match All'
		, 'CSC SEA Match All - Disability Status: ' + s.DisabilityStatusEdFactsCode
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSC s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.DisabilityStatusEdFactsCode = rreksc.IDEAINDICATOR
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'SEA'
		AND rreksc.CategorySetCode = 'CSC'

	DROP TABLE #S_CSC


	/**********************************************************************
		Test Case 4:
		CSD at the SEA level - Student Count by English Learner Status (Only)
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		EnglishLearnerStatusEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSD
	FROM cte
	WHERE EnglishLearnerStatusEdFactsCode = 'LEP'
		AND rownum = 1
	GROUP BY EnglishLearnerStatusEdFactsCode
		
	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT DISTINCT
		@SqlUnitTestId
		, 'CSD SEA Match All'
		, 'CSD SEA Match All - EL Status: ' + s.EnglishLearnerStatusEdFactsCode
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSD s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.EnglishLearnerStatusEdFactsCode  = rreksc.ENGLISHLEARNERSTATUS
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'SEA'
		AND rreksc.CategorySetCode = 'CSD'
			
	DROP TABLE #S_CSD


	/**********************************************************************
		Test Case 5:
		CSE at the SEA level - Student Count by Migratory Status
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		MigrantStatusEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSE
	FROM cte
	WHERE MigrantStatusEdFactsCode <> 'MISSING'
		AND rownum = 1
	GROUP BY MigrantStatusEdFactsCode
		
	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT DISTINCT
		@SqlUnitTestId
		, 'CSE SEA Match All'
		, 'CSE SEA Match All - Migratory Status: ' + s.MigrantStatusEdFactsCode
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSE s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.MigrantStatusEdFactsCode = rreksc.MIGRANTSTATUS
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'SEA'
		AND rreksc.CategorySetCode = 'CSE'
			
	DROP TABLE #S_CSE

	/**********************************************************************
		Test Case 6:
		CSF at the SEA level - Student Count by Homeless Unaccompanied Youth Status
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		HomelessUnaccompaniedYouthEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSF
	FROM cte
	WHERE HomelessUnaccompaniedYouthEdFactsCode <> 'MISSING'
		AND rownum = 1
	GROUP BY HomelessUnaccompaniedYouthEdFactsCode
		
	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT DISTINCT
		@SqlUnitTestId
		, 'CSF SEA Match All'
		, 'CSF SEA Match All - Homeless Unaccompanied Youth: ' + s.HomelessUnaccompaniedYouthEdFactsCode
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSF s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.HomelessUnaccompaniedYouthEdFactsCode = rreksc.HOMELESSUNACCOMPANIEDYOUTHSTATUS
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'SEA'
		AND rreksc.CategorySetCode = 'CSF'

	/**********************************************************************
		Test Case 7:
		CSG at the SEA level - Student Count by Homeless Unaccompanied Youth Status 
								by Homeless Primary Nighttime Residence
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		HomelessUnaccompaniedYouthEdFactsCode
		, HomelessPrimaryNighttimeResidenceEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSG
	FROM cte
	WHERE HomelessUnaccompaniedYouthEdFactsCode <> 'MISSING'
	AND HomelessPrimaryNighttimeResidenceEdFactsCode <> 'MISSING'
		AND rownum = 1
	GROUP BY HomelessUnaccompaniedYouthEdFactsCode
			, HomelessPrimaryNighttimeResidenceEdFactsCode

	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT DISTINCT
		@SqlUnitTestId
		, 'CSG SEA Match All'
		, 'CSG SEA Match All - Unaccompanied Youth: ' + s.HomelessUnaccompaniedYouthEdFactsCode
			+ '; Primary Nighttime Residence: ' + s.HomelessPrimaryNighttimeResidenceEdFactsCode
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSG s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.HomelessUnaccompaniedYouthEdFactsCode = rreksc.HOMELESSUNACCOMPANIEDYOUTHSTATUS
		AND s.HomelessPrimaryNighttimeResidenceEdFactsCode = rreksc.HOMELESSPRIMARYNIGHTTIMERESIDENCE
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'SEA'
		AND rreksc.CategorySetCode = 'CSG'
			
	DROP TABLE #S_CSG

	/**********************************************************************
		Test Case 8:
		CSH at the SEA level - Student Count by Racial Ethnic
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		RaceEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSH
	FROM cte
	WHERE RaceEdFactsCode is not null -- JW 4/5/2024
		AND rownum = 1
	GROUP BY RaceEdFactsCode
		
	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT DISTINCT
		@SqlUnitTestId
		, 'CSH SEA Match All'
		, 'CSH SEA Match All - Race: ' + s.RaceEdFactsCode
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSH s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON replace(s.RaceEdFactsCode, '_1', '') = rreksc.RACE
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'SEA'
		AND rreksc.CategorySetCode = 'CSH'
			
	DROP TABLE #S_CSH

	/**********************************************************************
		Test Case 9:
		TOT at the SEA level
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_TOT
	FROM cte
	WHERE rownum = 1
		
	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT DISTINCT
		@SqlUnitTestId
		, 'TOT SEA Match All'
		, 'TOT SEA Match All'
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_TOT s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'SEA'
		AND rreksc.CategorySetCode = 'TOT'
			
	DROP TABLE #S_TOT


	----------------------------------------
	--- LEA level tests					 ---
	----------------------------------------
	/**********************************************************************
		Test Case 1:
		CSA at the LEA level - Student Count by Age/Grade (Basic)
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState, LeaIdentifierSeaAccountability ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		GradeLevelEdFactsCode
		, s.LeaIdentifierSeaAccountability
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSA 
	FROM cte s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		AND GradeLevelEdFactsCode not in ('PK', 'PK_1','MISSING')
		AND rownum = 1
	GROUP BY GradeLevelEdFactsCode
		, s.LeaIdentifierSeaAccountability
		
	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT 
		@SqlUnitTestId
		, 'CSA LEA Match All'
		, 'CSA LEA Match All - Age/Grade: ' +  s.GradeLevelEdFactsCode
			+ '; LEA Identifier: ' + s.LeaIdentifierSeaAccountability
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
		AND replace(s.GradeLevelEdFactsCode, '_1', '') = rreksc.GRADELEVEL
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'LEA'
		AND rreksc.CategorySetCode = 'CSA'
	
	DROP TABLE #L_CSA


	/**********************************************************************
		Test Case 2:
		CSB at the LEA level - Student Count by Homeless Primary Nighttime Residence
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState, LeaIdentifierSeaAccountability ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		HomelessPrimaryNighttimeResidenceEdFactsCode
		, s.LeaIdentifierSeaAccountability
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSB
	FROM cte s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE HomelessPrimaryNighttimeResidenceEdFactsCode <> 'MISSING'
		AND elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		AND rownum = 1
	GROUP BY HomelessPrimaryNighttimeResidenceEdFactsCode
		, s.LeaIdentifierSeaAccountability

	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT DISTINCT
		@SqlUnitTestId
		, 'CSB LEA Match All'
		, 'CSB LEA Match All - Homeless Primary Mighttime Residence: ' + HomelessPrimaryNighttimeResidenceEdFactsCode 
			+ '; LEA Identifier: ' + s.LeaIdentifierSeaAccountability
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSB s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
		AND s.HomelessPrimaryNighttimeResidenceEdFactsCode = rreksc.HOMELESSPRIMARYNIGHTTIMERESIDENCE
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'LEA'
		AND rreksc.CategorySetCode = 'CSB'

	DROP TABLE #L_CSB


	/**********************************************************************
		Test Case 3:
		CSC at the LEA level - Student Count by Disability Status (Only)
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState, LeaIdentifierSeaAccountability ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		DisabilityStatusEdFactsCode
		, s.LeaIdentifierSeaAccountability
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSC
	FROM cte s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE DisabilityStatusEdFactsCode <> 'MISSING'
		AND elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		AND rownum = 1
	GROUP BY DisabilityStatusEdFactsCode
		, s.LeaIdentifierSeaAccountability
		
	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT DISTINCT
		@SqlUnitTestId
		, 'CSC LEA Match All'
		, 'CSC LEA Match All - Disability Status: ' + s.DisabilityStatusEdFactsCode
			+ '; LEA Identifier: ' + s.LeaIdentifierSeaAccountability
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSC s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
		AND s.DisabilityStatusEdFactsCode = rreksc.IDEAINDICATOR
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'LEA'
		AND rreksc.CategorySetCode = 'CSC'

	DROP TABLE #L_CSC

	
	/**********************************************************************
		Test Case 4:
		CSD at the LEA level - Student Count by English Learner Status (Only)
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState, LeaIdentifierSeaAccountability ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		EnglishLearnerStatusEdFactsCode
		, s.LeaIdentifierSeaAccountability
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSD
	FROM cte s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE EnglishLearnerStatusEdFactsCode = 'LEP'
		AND elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		AND rownum = 1
	GROUP BY EnglishLearnerStatusEdFactsCode
		, s.LeaIdentifierSeaAccountability
		
	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT DISTINCT
		@SqlUnitTestId
		, 'CSD LEA Match All'
		, 'CSD LEA Match All - EL Status: ' + s.EnglishLearnerStatusEdFactsCode
			+ '; LEA Identifier: ' + s.LeaIdentifierSeaAccountability
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSD s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
		AND s.EnglishLearnerStatusEdFactsCode  = rreksc.ENGLISHLEARNERSTATUS
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'LEA'
		AND rreksc.CategorySetCode = 'CSD'
			
	DROP TABLE #L_CSD

	/**********************************************************************
		Test Case 5:
		CSE at the LEA level - Student Count by Migratory Status
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState, LeaIdentifierSeaAccountability ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		MigrantStatusEdFactsCode
		, s.LeaIdentifierSeaAccountability
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSE
	FROM cte s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE MigrantStatusEdFactsCode <> 'MISSING'
		AND elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		AND rownum = 1
	GROUP BY MigrantStatusEdFactsCode
		, s.LeaIdentifierSeaAccountability
		
	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT DISTINCT
		@SqlUnitTestId
		, 'CSE LEA Match All'
		, 'CSE LEA Match All - Migratory Status: ' + s.MigrantStatusEdFactsCode
			+ '; LEA Identifier: ' + s.LeaIdentifierSeaAccountability
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSE s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
		AND s.MigrantStatusEdFactsCode = rreksc.MIGRANTSTATUS
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'LEA'
		AND rreksc.CategorySetCode = 'CSE'
			
	DROP TABLE #L_CSE

	/**********************************************************************
		Test Case 6:
		CSF at the LEA level - Student Count by Homeless Unaccompanied Youth Status
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState, LeaIdentifierSeaAccountability ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		HomelessUnaccompaniedYouthEdFactsCode
		, s.LeaIdentifierSeaAccountability
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSF
	FROM cte s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE HomelessUnaccompaniedYouthEdFactsCode <> 'MISSING'
		AND elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		AND rownum = 1
	GROUP BY HomelessUnaccompaniedYouthEdFactsCode
		, s.LeaIdentifierSeaAccountability
		
	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT DISTINCT
		@SqlUnitTestId
		, 'CSF LEA Match All'
		, 'CSF LEA Match All - Homeless Unaccompanied Youth: ' + s.HomelessUnaccompaniedYouthEdFactsCode
			+ '; LEA Identifier: ' + s.LeaIdentifierSeaAccountability
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSF s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
		AND s.HomelessUnaccompaniedYouthEdFactsCode = rreksc.HOMELESSUNACCOMPANIEDYOUTHSTATUS
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'LEA'
		AND rreksc.CategorySetCode = 'CSF'

	/**********************************************************************
		Test Case 7:
		CSG at the LEA level - Student Count by Homeless Unaccompanied Youth Status 
								by Homeless Primary Nighttime Residence
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState, LeaIdentifierSeaAccountability ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		HomelessUnaccompaniedYouthEdFactsCode
		, HomelessPrimaryNighttimeResidenceEdFactsCode
		, s.LeaIdentifierSeaAccountability
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSG
	FROM cte s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE HomelessUnaccompaniedYouthEdFactsCode <> 'MISSING'
		AND HomelessPrimaryNighttimeResidenceEdFactsCode <> 'MISSING'
		AND elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		AND rownum = 1
	GROUP BY HomelessUnaccompaniedYouthEdFactsCode
		, HomelessPrimaryNighttimeResidenceEdFactsCode
		, s.LeaIdentifierSeaAccountability

	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT DISTINCT
		@SqlUnitTestId
		, 'CSG LEA Match All'
		, 'CSG LEA Match All - Unaccompanied Youth: ' + s.HomelessUnaccompaniedYouthEdFactsCode
			+ '; Primary Nighttime Residence: ' + s.HomelessPrimaryNighttimeResidenceEdFactsCode
			+ '; LEA Identifier: ' + s.LeaIdentifierSeaAccountability
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSG s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
		AND s.HomelessUnaccompaniedYouthEdFactsCode = rreksc.HOMELESSUNACCOMPANIEDYOUTHSTATUS
		AND s.HomelessPrimaryNighttimeResidenceEdFactsCode = rreksc.HOMELESSPRIMARYNIGHTTIMERESIDENCE
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'LEA'
		AND rreksc.CategorySetCode = 'CSG'
			
	DROP TABLE #L_CSG

	/**********************************************************************
		Test Case 8:
		CSH at the LEA level - Student Count by Racial Ethnic
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState, LeaIdentifierSeaAccountability ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		RaceEdFactsCode
		, s.LeaIdentifierSeaAccountability
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSH
	FROM cte s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		AND RaceEdFactsCode is not null -- JW 4/5/2024
		AND rownum = 1
	GROUP BY RaceEdFactsCode
		, s.LeaIdentifierSeaAccountability
		
	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT DISTINCT
		@SqlUnitTestId
		, 'CSH LEA Match All'
		, 'CSH LEA Match All - Race: ' + s.RaceEdFactsCode
			+ '; LEA Identifier: ' + s.LeaIdentifierSeaAccountability
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSH s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
		AND replace(s.RaceEdFactsCode, '_1', '') = rreksc.RACE
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'LEA'
		AND rreksc.CategorySetCode = 'CSH'
			
	DROP TABLE #L_CSH

	/**********************************************************************
		Test Case 9:
		TOT at the LEA level
	***********************************************************************/
	;with cte as (
		select *, ROW_NUMBER() OVER(PARTITION BY StudentIdentifierState, LeaIdentifierSeaAccountability ORDER BY EnrollmentEntryDate) as 'rownum' 
		from #C118Staging
	)
	SELECT 
		s.LeaIdentifierSeaAccountability
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_TOT
	FROM cte s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		AND rownum = 1
	GROUP BY s.LeaIdentifierSeaAccountability
		
	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT DISTINCT
		@SqlUnitTestId
		, 'TOT LEA Match All'
		, 'LEA Identifier: ' + s.LeaIdentifierSeaAccountability
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_TOT s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
		AND rreksc.ReportCode = 'C118' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'LEA'
		AND rreksc.CategorySetCode = 'TOT'
			
	DROP TABLE #L_TOT

	-- IF THE TEST PRODUCES NO RESULTS INSERT A RECORD TO INDICATE THIS
	if not exists(select top 1 * from app.sqlunittest t
		inner join app.SqlUnitTestCaseResult r
			on t.SqlUnitTestId = r.SqlUnitTestId
			and t.SqlUnitTestId = @SqlUnitTestId)
	begin
		INSERT INTO App.SqlUnitTestCaseResult (
			[SqlUnitTestId]
			, [TestCaseName]
			, [TestCaseDetails]
			, [ExpectedResult]
			, [ActualResult]
			, [Passed]
			, [TestDateTime]
		)
		SELECT DISTINCT
			@SqlUnitTestId
			, 'NO TEST RESULTS'
			, 'NO TEST RESULTS'
			, -1
			, -1
			, 0
			, GETDATE()
	end

	--check the results

	-- select *
	-- from App.SqlUnitTestCaseResult sr
	-- 	inner join App.SqlUnitTest s
	-- 		on s.SqlUnitTestId = sr.SqlUnitTestId
	-- where s.TestScope = 'FS118'
	-- and passed = 1
	-- and convert(date, TestDateTime) = convert(date, GETDATE())

END
