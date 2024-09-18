set nocount on
begin try
	begin transaction
	
	-------------------
	-- Populate DimAges
	-------------------
	-- Create MISSING record 
	IF NOT EXISTS (SELECT 1 FROM RDS.DimAges WHERE DimAgeId = -1) BEGIN 
		SET IDENTITY_INSERT RDS.DimAges ON;
		INSERT INTO RDS.DimAges (DimAgeId, AgeCode, AgeDescription, AgeEdFactsCode, AgeValue) VALUES (-1, 'MISSING', 'MISSING', 'MISSING', -1)
		SET IDENTITY_INSERT RDS.DimAges OFF;  
	END

	-- Create a temp table and fill it with ages 1-130
	CREATE TABLE #Ages (Age INT IDENTITY(1,1))

	DECLARE @loop INT = 1
	WHILE @loop <= 130 BEGIN
		INSERT INTO #Ages DEFAULT VALUES
		SET @loop = @loop + 1
	END

	-- Insert ages that aren't already in DimAges
	INSERT INTO RDS.DimAges
	SELECT CAST(Age AS VARCHAR(3)), 'Age ' + CAST(Age AS VARCHAR(3)), CAST(Age AS VARCHAR(3)), Age 
	FROM #Ages a
	LEFT JOIN RDS.DimAges da
		ON CAST(a.Age AS VARCHAR(3)) = da.AgeCode
	WHERE da.AgeCode IS NULL

	-- Drop the temp table
	DROP TABLE #Ages


	---------------------------------
	-- Populate DimK12ProgramTypes
	---------------------------------
	IF NOT EXISTS (SELECT 1 FROM RDS.DimK12ProgramTypes WHERE ProgramTypeCode = 'MISSING') BEGIN
		SET IDENTITY_INSERT RDS.DimK12ProgramTypes ON

		INSERT INTO RDS.DimK12ProgramTypes (DimK12ProgramTypeId, ProgramTypeCode, ProgramTypeDescription, ProgramTypeDefinition)
			VALUES (-1, 'MISSING', 'MISSING', 'MISSING')

		SET IDENTITY_INSERT RDS.DimK12ProgramTypes OFF
	END

	INSERT INTO RDS.DimK12ProgramTypes
	SELECT 
		  p.Code
		, p.Description
		, p.Definition
	FROM dbo.RefProgramType p
	LEFT JOIN RDS.DimK12ProgramTypes dp
		ON p.Code = dp.ProgramTypeCode
	WHERE dp.ProgramTypeCode IS NULL

	---------------------------------
	-- Populate DimSchoolYears
	---------------------------------
	IF NOT EXISTS (SELECT 1 FROM RDS.DimSchoolYears s WHERE s.SchoolYear = -1) BEGIN
		SET IDENTITY_INSERT RDS.DimSchoolYears ON

		INSERT INTO RDS.DimSchoolYears (DimSchoolYearId, SchoolYear, SessionBeginDate, SessionEndDate)
			VALUES (-1, -1, '1/1/1900', '1/1/1900')

		SET IDENTITY_INSERT RDS.DimSchoolYears OFF
	END

	DECLARE @start INT = 2000, @end INT = 2050

	WHILE @start <= @end
	BEGIN
		INSERT INTO RDS.DimSchoolYears
		SELECT DISTINCT
			  @start
			, CAST('7/1/' + CAST(@start - 1 AS VARCHAR(4)) AS DATE) 
			, CAST('6/30/' + CAST(@start AS VARCHAR(4)) AS DATE) 
		WHERE @start NOT IN (SELECT SchoolYear FROM RDS.DimSchoolYears)

		SET @start = @start + 1
    END


	---------------------------------
	-- Populate DimDataCollections
	---------------------------------
	IF NOT EXISTS (SELECT 1 FROM RDS.DimDataCollections d WHERE d.DataCollectionName = 'MISSING') BEGIN
		SET IDENTITY_INSERT RDS.DimDataCollections ON

		INSERT INTO RDS.DimDataCollections (DimDataCollectionId, SourceSystemDataCollectionIdentifier, SourceSystemName, DataCollectionName, DataCollectionDescription, DataCollectionOpenDate, DataCollectionCloseDate, DataCollectionAcademicSchoolYear, DataCollectionSchoolYear)
			VALUES (-1, -1, 'MISSING', 'MISSING', 'MISSING', '1/1/1900', '1/1/1900', 'MISSING', 'MISSING')

		SET IDENTITY_INSERT RDS.DimDataCollections OFF
	END

	INSERT INTO RDS.DimDataCollections
	SELECT DISTINCT
		  dc.SourceSystemDataCollectionIdentifier
		, dc.SourceSystemName
		, dc.DataCollectionName
		, dc.DataCollectionDescription
		, dc.DataCollectionOpenDate
		, dc.DataCollectionCloseDate
		, dc.DataCollectionAcademicSchoolYear
		, dc.DataCollectionSchoolYear
	FROM dbo.DataCollection dc
	LEFT JOIN RDS.DimDataCollections ddc
		ON dc.DataCollectionName = ddc.DataCollectionName
	WHERE ddc.DataCollectionName IS NULL


	------------------------------------------------
	-- Populate DimK12Courses					  --
	------------------------------------------------
	IF NOT EXISTS (SELECT 1 FROM RDS.DimK12Courses d WHERE d.CourseIdentifier = 'MISSING') BEGIN
		SET IDENTITY_INSERT RDS.DimK12Courses ON

		INSERT INTO RDS.DimK12Courses 
		(DimK12CourseId,CourseIdentifier,CourseCodeSystemCode,CourseCodeSystemDesciption,CourseTitle,CourseDescription,CourseDepartmentName,CourseCreditUnitsCode,CourseCreditUnitsDescription
		,CreditValue,AdvancedPlacementCourseCode,CareerClusterCode,CareerClusterDescription,CourseCertificationDescription,TuitionFunded,CourseFundingProgram )
		VALUES (-1,'MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING',-0.00,'MISSING','MISSING','MISSING','MISSING',0,'MISSING')

		SET IDENTITY_INSERT RDS.DimK12Courses OFF
	END

	INSERT INTO RDS.DimK12Courses 
		(
		CourseIdentifier 
		,CourseCodeSystemCode
		,CourseCodeSystemDesciption
		,CourseTitle
		,CourseDescription
		,CourseDepartmentName
		,CourseCreditUnitsCode
		,CourseCreditUnitsDescription
		,CreditValue
		,AdvancedPlacementCourseCode
		,CareerClusterCode
		,CareerClusterDescription
		,CourseCertificationDescription
		,TuitionFunded
		,CourseFundingProgram      
		)
	SELECT distinct
		  oi.Identifier as CourseIdentifier
		  ,rois.Code as CourseCodeSystemCode
		  ,rois.Description as CourseCodeSystemDesciption
		  ,od.Name as CourseTitle
		  ,c.Description as CourseDescription
		  ,'MISSING' as CourseDepartmentName
		  ,'MISSING' as CourseCreditUnitsCode
		  ,'MISSING' as CourseCreditUnitsDescription
		  , 0.00 as CreditValue
		  ,'MISSING' as AdvancedPlacementCourseCode
		  ,'MISSING' as CareerClusterCode
		  ,'MISSING' as CareerClusterDescription
		  ,'MISSING' as CourseCertificationDescription
		  , 0 as TuitionFunded
		  ,'MISSING' as CourseFundingProgram  
	FROM dbo.Course c
	JOIN dbo.OrganizationIdentifier oi
		on c.OrganizationId = oi.OrganizationId
	JOIN dbo.OrganizationDetail od
		on c.OrganizationId = od.OrganizationId
	JOIN dbo.RefOrganizationIdentificationSystem  rois
		on rois.RefOrganizationIdentificationSystemId=oi.RefOrganizationIdentificationSystemId
	LEFT JOIN rds.DimK12Courses cs
		ON oi.Identifier = cs.CourseIdentifier
			and od.Name = cs.CourseTitle
	WHERE cs.DimK12CourseId IS NULL

	--------------------------------------------------
	---- Populate DimK12CourseStatuses			 ---
	--------------------------------------------------
	--IF NOT EXISTS (SELECT 1 FROM RDS.DimK12CourseStatuses d WHERE d.CourseLevelCharacteristicCode = 'MISSING') BEGIN
	--	SET IDENTITY_INSERT RDS.DimK12CourseStatuses ON

	--	INSERT INTO RDS.DimK12CourseStatuses(DimK12CourseStatusId,CourseLevelCharacteristicCode, CourseLevelCharacteristicDescription, CourseLevelCharacteristicId)
	--	VALUES (-1, 'MISSING', 'MISSING', -1)

	--	SET IDENTITY_INSERT RDS.DimK12CourseStatuses OFF
	--END

	--INSERT INTO RDS.DimK12CourseStatuses
	--	(
	--	  CourseLevelCharacteristicCode        
	--	, CourseLevelCharacteristicDescription
	--	, CourseLevelCharacteristicId        
	--	)
	--SELECT 
	--	  clc.Code
	--	, clc.Description
	--	, clc.RefCourseLevelCharacteristicId
	--FROM dbo.RefCourseLevelCharacteristic clc
	--LEFT JOIN rds.DimK12CourseStatuses cs
	--	ON clc.Code = cs.CourseLevelCharacteristicCode
	--WHERE cs.DimK12CourseStatusId IS NULL

	------------------------------------------------
	-- Populate DimScedCodes					  --
	------------------------------------------------
	IF NOT EXISTS (SELECT 1 FROM RDS.DimScedCodes d WHERE d.ScedCourseCode = 'MISSING') BEGIN
		SET IDENTITY_INSERT RDS.DimScedCodes ON

		INSERT INTO RDS.DimScedCodes 
		(DimScedCodeId,ScedCourseCode,ScedCourseTitle,ScedCourseDescription,ScedCourseLevelCode,ScedCourseLevelDescription,
	ScedCourseSubjectAreaCode,ScedCourseSubjectAreaDescription,ScedGradeSpan,ScedSequenceOfCourse)
		VALUES (-1,'-1','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','-1','MISSING')

		SET IDENTITY_INSERT RDS.DimScedCodes OFF
	END

	INSERT INTO RDS.DimScedCodes 
		(
		ScedCourseCode
		,ScedCourseTitle
		,ScedCourseDescription
		,ScedCourseLevelCode
		,ScedCourseLevelDescription
		,ScedCourseSubjectAreaCode
		,ScedCourseSubjectAreaDescription
		,ScedGradeSpan
		,ScedSequenceOfCourse    
		)
	Select DISTINCT
		c.[SCEDCourseCode], 
		'MISSING' as [ScedCourseTitle], 
		'MISSING' as [ScedCourseDescription], 
		'MISSING' as [ScedCourseLevelCode], 
		'MISSING' as [ScedCourseLevelDescription], 
		'MISSING' as [ScedCourseSubjectAreaCode], 
		'MISSING' as [ScedCourseSubjectAreaDescription], 
		'-1'	  as [ScedGradeSpan], 
		'MISSING' as [ScedSequenceOfCourse]
	From dbo.K12Course c
		JOIN dbo.OrganizationIdentifier oi
			on c.OrganizationId = oi.OrganizationId
		JOIN dbo.OrganizationDetail od
			on c.OrganizationId = od.OrganizationId
		LEFT JOIN rds.DimScedCodes cs
			ON oi.Identifier = cs.ScedCourseCode
				and od.Name = cs.ScedCourseDescription
	WHERE cs.DimScedCodeId IS NULL 

	------------------------------------------------
	-- Populate DimDates						 ---
	------------------------------------------------

	IF NOT EXISTS (SELECT 1 FROM RDS.DimDates d WHERE d.DimDateId = -1) BEGIN
		SET IDENTITY_INSERT RDS.DimDates ON

		INSERT INTO RDS.DimDates ([DimDateId], [DateValue], [Day], [DayOfWeek], [DayOfYear], [Month], [MonthName], SubmissionYear, [Year] )
			VALUES (-1, '1/1/1900', -1, 'MISSING', -1, -1, 'MISSING', 'MISSING', -1)

		SET IDENTITY_INSERT RDS.DimDates OFF
	END

	DECLARE @startDate DATE = '2000-01-01', @endDate DATE = '2050-12-31'

	WHILE @startDate <= @endDate
	BEGIN
		INSERT INTO RDS.DimDates (
			  DateValue
			, [Day]
			, [DayOfWeek]
			, [DayOfYear]
			, [Month]
			, [MonthName]
			, SubmissionYear
			, [Year] )
		SELECT 
			  @startDate
			, DATEPART(dd,@start)
			, DATEPART(dw,@start)
			, DATEPART(dy,@start) 
			, DATEPART(mm,@start)
			, DATENAME(mm,@start)
			, CASE 
				WHEN CAST(DATEPART(mm, @startDate) AS INT) >= 7 THEN YEAR(@startDate) + 1
				ELSE YEAR(@startDate)
			  END
			, YEAR(@startDate)
		WHERE NOT EXISTS (SELECT 1 FROM RDS.DimDates WHERE DateValue = @startDate)
	
		SET @startDate = DATEADD(dd,1,@startDate)
	  END
	  	  	  
	------------------------------------------------
	-- Populate DimK12CourseStatuses			 ---
	------------------------------------------------
	--IF NOT EXISTS (SELECT 1 FROM RDS.DimK12CourseStatuses d WHERE d.CourseLevelCharacteristicCode = 'MISSING') BEGIN
	--	SET IDENTITY_INSERT RDS.DimK12CourseStatuses ON

	--	INSERT INTO RDS.DimK12CourseStatuses VALUES (-1, 'MISSING', 'MISSING', -1)

	--	SET IDENTITY_INSERT RDS.DimK12CourseStatuses ON
	--END

	--INSERT INTO RDS.DimK12CourseStatuses 
	--	(
	--	  CourseLevelCharacteristicCode        
	--	, CourseLevelCharacteristicDescription
	--	, CourseLevelCharacteristicId        
	--	)
	--SELECT 
	--	  clc.Code
	--	, clc.Description
	--	, clc.RefCourseLevelCharacteristicId
	--FROM dbo.RefCourseLevelCharacteristic clc
	--LEFT JOIN rds.DimK12CourseStatuses cs
	--	ON clc.Code = cs.CourseLevelCharacteristicCode
	--WHERE cs.DimK12CourseStatusId IS NULL

	  	  	  
	------------------------------------------------
	-- Populate DimPsAcademicAwardStatuses		 ---
	------------------------------------------------

	CREATE TABLE #PescAwardLevelType (PescAwardLevelTypeCode VARCHAR(50), PescAwardLevelTypeDescription VARCHAR(200))

	INSERT INTO #PescAwardLevelType VALUES ('MISSING', 'MISSING')
	INSERT INTO #PescAwardLevelType 
	SELECT 
		  Code
		, Description
	FROM dbo.RefPescAwardLevelType

	CREATE TABLE #ProfessionalTechnicalCredentialType (ProfessionalTechnicalCredentialTypeCode VARCHAR(50), ProfessionalTechnicalCredentialTypeDescription VARCHAR(200))

	INSERT INTO #ProfessionalTechnicalCredentialType VALUES ('MISSING', 'MISSING')
	INSERT INTO #ProfessionalTechnicalCredentialType
	SELECT
		  Code
		, Description
	FROM dbo.RefProfessionalTechnicalCredentialType

	-- Populate RDS.DimPsAcademicAwardStatuses
	INSERT INTO RDS.DimPsAcademicAwardStatuses
	SELECT
		  palt.PescAwardLevelTypeCode
		, palt.PescAwardLevelTypeDescription
		, ptct.ProfessionalTechnicalCredentialTypeCode
		, ptct.ProfessionalTechnicalCredentialTypeDescription
	FROM #PescAwardLevelType palt
	CROSS JOIN #ProfessionalTechnicalCredentialType ptct
	LEFT JOIN RDS.DimPsAcademicAwardStatuses paas
		ON palt.PescAwardLevelTypeCode = paas.PescAwardLevelTypeCode
		AND ptct.ProfessionalTechnicalCredentialTypeCode = paas.ProfessionalOrTechnicalCredentialConferredCode
	WHERE paas.DimPsAcademicAwardStatusId IS NULL

	DROP TABLE #PescAwardLevelType
	DROP TABLE #ProfessionalTechnicalCredentialType
	  	  	  
	------------------------------------------------
	-- Populate DimPsEnrollmentStatuses			 ---
	------------------------------------------------

	IF NOT EXISTS (SELECT 1 FROM RDS.DimPsEnrollmentStatuses d WHERE d.PostsecondaryExitOrWithdrawalTypeCode = 'MISSING') BEGIN
		SET IDENTITY_INSERT RDS.DimPsEnrollmentStatuses ON

		INSERT INTO RDS.DimPsEnrollmentStatuses (DimPsEnrollmentStatusId, PostsecondaryExitOrWithdrawalTypeCode, PostsecondaryExitOrWithdrawalTypeDescription)
			VALUES (-1, 'MISSING', 'MISSING')

		SET IDENTITY_INSERT RDS.DimPsEnrollmentStatuses OFF
	END

	INSERT INTO RDS.DimPsEnrollmentStatuses
		(
			  PostsecondaryExitOrWithdrawalTypeCode
			, PostsecondaryExitOrWithdrawalTypeDescription
		)
	SELECT 
		  ewt.Code as PostsecondaryExitOrWithdrawalTypeCode
		, ewt.Description as PostsecondaryExitOrWithdrawalTypeDescription
	FROM dbo.RefPSExitOrWithdrawalType ewt
	LEFT JOIN rds.DimPsEnrollmentStatuses pes
		ON ewt.Code = pes.PostsecondaryExitOrWithdrawalTypeCode
	WHERE pes.DimPsEnrollmentStatusId IS NULL

	------------------------------------------------
	-- Populate DimK12EnrollmentStatuses			 ---
	------------------------------------------------
	-- Replaced by RDS.PopulateK12EnrollmentStatuses script

	--IF NOT EXISTS (SELECT 1 FROM RDS.DimK12EnrollmentStatuses d WHERE d.DimK12EnrollmentStatusId = -1) BEGIN
	--	SET IDENTITY_INSERT RDS.DimK12EnrollmentStatuses ON

	--	INSERT INTO RDS.DimK12EnrollmentStatuses (
	--		  [DimK12EnrollmentStatusId]
	--		, [EnrollmentStatusCode]
	--		, [EnrollmentStatusDescription]
	--		, [EntryTypeCode]
	--		, [EntryTypeDescription]
	--		, [ExitOrWithdrawalTypeCode]
	--		, [ExitOrWithdrawalTypeDescription]
	--		, [PostSecondaryEnrollmentStatusCode]
	--		, [PostSecondaryEnrollmentStatusDescription]
	--		, [PostSecondaryEnrollmentStatusEdFactsCode]
	--		)
	--		VALUES (
	--			  -1
	--			, 'MISSING'
	--			, 'MISSING'
	--			, 'MISSING'
	--			, 'MISSING'
	--			, 'MISSING'
	--			, 'MISSING'
	--			, 'MISSING'
	--			, 'MISSING'
	--			, 'MISSING'
	--			)

	--	SET IDENTITY_INSERT RDS.DimK12EnrollmentStatuses OFF
	--END

	--CREATE TABLE #EnrollmentStatus (EnrollmentStatusCode VARCHAR(50), EnrollmentStatusDescription VARCHAR(200))

	--INSERT INTO #EnrollmentStatus VALUES ('MISSING', 'MISSING')
	--INSERT INTO #EnrollmentStatus 
	--SELECT 
	--	  Code
	--	, Description
	--FROM dbo.RefEnrollmentStatus

	--CREATE TABLE #EntryType (EntryTypeCode VARCHAR(50), EntryTypeDescription VARCHAR(200))

	--INSERT INTO #EntryType VALUES ('MISSING', 'MISSING')
	--INSERT INTO #EntryType 
	--SELECT 
	--	  Code
	--	, Description
	--FROM dbo.RefEntryType

	--CREATE TABLE #ExitOrWithdrawalType (ExitOrWithdrawalTypeCode VARCHAR(50), ExitOrWithdrawalTypeDescription VARCHAR(200))

	--INSERT INTO #ExitOrWithdrawalType VALUES ('MISSING', 'MISSING')
	--INSERT INTO #ExitOrWithdrawalType 
	--SELECT 
	--	  Code
	--	, Description
	--FROM dbo.RefExitOrWithdrawalType

	--CREATE TABLE #PostSecondaryEnrollmentStatus (PostSecondaryEnrollmentStatusCode VARCHAR(50), PostSecondaryEnrollmentStatusDescription VARCHAR(200), PostSecondaryEnrollmentStatusEdFactsCode VARCHAR(50))

	--INSERT INTO #PostSecondaryEnrollmentStatus VALUES ('MISSING', 'MISSING', 'MISSING')
	--INSERT INTO #PostSecondaryEnrollmentStatus 
	--SELECT 
	--	  Code
	--	, Description
	--	, Code
	--FROM dbo.RefPsEnrollmentStatus


	--INSERT INTO RDS.DimK12EnrollmentStatuses
	--	(
	--		  [EnrollmentStatusCode]
	--		, [EnrollmentStatusDescription]
	--		, [EntryTypeCode]
	--		, [EntryTypeDescription]
	--		, [ExitOrWithdrawalTypeCode]
	--		, [ExitOrWithdrawalTypeDescription]
	--		, [PostSecondaryEnrollmentStatusCode]
	--		, [PostSecondaryEnrollmentStatusDescription]
	--		, [PostSecondaryEnrollmentStatusEdFactsCode]
	--	)
	--SELECT DISTINCT
	--	  es.EnrollmentStatusCode
	--	, es.EnrollmentStatusDescription
	--	, et.EntryTypeCode
	--	, et.EntryTypeDescription
	--	, ewt.ExitOrWithdrawalTypeCode
	--	, ewt.ExitOrWithdrawalTypeDescription
	--	, pes.PostSecondaryEnrollmentStatusCode
	--	, pes.PostSecondaryEnrollmentStatusDescription
	--	, pes.PostSecondaryEnrollmentStatusEdFactsCode
	--FROM #EnrollmentStatus es
	--CROSS JOIN #EntryType et
	--CROSS JOIN #ExitOrWithdrawalType ewt
	--CROSS JOIN #PostSecondaryEnrollmentStatus pes
	--LEFT JOIN rds.DimK12EnrollmentStatuses kes
	--	ON es.EnrollmentStatusCode = kes.EnrollmentStatusCode
	--	AND et.EntryTypeCode = kes.EntryTypeCode
	--	AND ewt.ExitOrWithdrawalTypeCode = kes.ExitOrWithdrawalTypeCode
	--	AND pes.PostSecondaryEnrollmentStatusCode = kes.PostSecondaryEnrollmentStatusCode
	--WHERE kes.DimK12EnrollmentStatusId IS NULL

	--DROP TABLE #EnrollmentStatus
	--DROP TABLE #EntryType
	--DROP TABLE #ExitOrWithdrawalType
	--DROP TABLE #PostSecondaryEnrollmentStatus

	------------------------------------------------
	-- Update DimIdeaStatuses                    ---
	------------------------------------------------

	UPDATE RDS.DimIdeaStatuses
	SET SpecialEducationExitReasonCode = 'GraduatedAlternateDiploma'
	WHERE SpecialEducationExitReasonCode = 'AlternateDiploma' 

	UPDATE RDS.DimIdeaStatuses
	SET SpecialEducationExitReasonCode = 'NotPartBEligibleExitingPartCWithReferrals'
	WHERE SpecialEducationExitReasonCode = 'NotPartBElgibleExitingPartCWithReferrrals' 

	UPDATE RDS.DimIdeaStatuses
	SET SpecialEducationExitReasonCode = 'NotPartBEligibleExitingPartCWithoutReferrals'
	WHERE SpecialEducationExitReasonCode = 'NotPartBElgibleExitingPartCWithoutReferrrals' 

	
	------------------------------------------------
	-- Populate DimProgramTypes					 ---
	------------------------------------------------

	IF NOT EXISTS (SELECT 1 FROM RDS.DimProgramTypes d WHERE d.ProgramTypeCode = 'MISSING') BEGIN
		SET IDENTITY_INSERT RDS.DimProgramTypes ON

		INSERT INTO RDS.DimProgramTypes (DimProgramTypeId, ProgramTypeCode, ProgramTypeDescription)
			VALUES (-1, 'MISSING', 'MISSING')

		SET IDENTITY_INSERT RDS.DimProgramTypes OFF
	END

	INSERT INTO RDS.DimProgramTypes
		(
			  ProgramTypeCode
			, ProgramTypeDescription		
		)
	SELECT 
		  pt.Code as ProgramTypeCode
		, pt.Description as ProgramTypeDescription
	FROM dbo.RefProgramType pt
	LEFT JOIN rds.DimProgramTypes dpt
		ON pt.Code = dpt.ProgramTypeCode
	WHERE dpt.DimProgramTypeId IS NULL


	------------------------------------------------
	-- Update DimK12StudentStatuses              ---
	------------------------------------------------

	--CREATE TABLE #EntryType (EntryTypeCode VARCHAR(50), EntryTypeDescription VARCHAR(200))

	--INSERT INTO #EntryType VALUES ('MISSING', 'MISSING')
	--INSERT INTO #EntryType 
	--SELECT 
	--	  Code
	--	, Description
	--FROM dbo.RefEntryType

	DELETE
	FROM [RDS].[DimK12StudentStatuses]
	WHERE HighSchoolDiplomaTypeEdFactsCode = 'HSDPROF'

		commit transaction
end try
 
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()         
	RAISERROR(@msg, @sev, 1)
end catch
 
set nocount off