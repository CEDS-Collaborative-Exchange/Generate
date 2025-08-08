CREATE PROCEDURE [RDS].[Migrate_K12StaffCounts]
	@factTypeCode AS VARCHAR(50),
	@runAsTest AS BIT,
	@dataCollectionName AS VARCHAR(50) = NULL
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @dataCollectionId AS INT

	SELECT @dataCollectionId = DataCollectionId 
	FROM dbo.DataCollection
	WHERE DataCollectionName = @dataCollectionName

	-- Lookup VALUES
	DECLARE @factTable AS VARCHAR(50)
	SET @factTable = 'FactK12StaffCounts'
	DECLARE @migrationType AS VARCHAR(50)
	DECLARE @dataMigrationTypeId AS INT
	
	SELECT @dataMigrationTypeId = DataMigrationTypeId
	FROM app.DataMigrationTypes WHERE DataMigrationTypeCode = 'rds'
	SET @migrationType='rds'
	

	DECLARE @factTypeId AS INT
	SELECT @factTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = @factTypeCode

	DECLARE @staffDateQuery AS rds.K12StaffDateTableType
	DECLARE @schoolQuery AS rds.K12StaffOrganizationTableType
	
	DECLARE @personnelStatusQuery AS table (
		DimK12StaffId INT,
		DimK12SchoolId INT,
        DimLeaId INT,
        DimSeaId INT,
		PersonId INT,
		DimCountDateId INT,
		AgeGroupCode VARCHAR(50),
		CertificationStatusCode VARCHAR(50),
		PersonnelTypeCode VARCHAR(50),
		QualificationStatusCode VARCHAR(50),
		StaffCategoryCode VARCHAR(50),
		PersonnelFTE DECIMAL(18,3),
		UnexperiencedStatusCode VARCHAR(50),
		EmergencyOrProvisionalCredentialStatusCode VARCHAR(50),
		OutOfFieldStatusCode VARCHAR(50)
	)

	DECLARE @personnelCategoryQuery AS table (
		DimK12StaffId INT,
		DimK12SchoolId INT,
        DimLeaId INT,
        DimSeaId INT,
		PersonId INT,
		DimCountDateId INT,
		StaffCategorySpecialCode VARCHAR(50),
		StaffCategoryCCD  VARCHAR(50),
		StaffCategoryTitle1Code   VARCHAR(50),
		PersonnelFTE DECIMAL(18,3)
	)

	DECLARE @titleIIIStatusQuery AS table (
		DimK12StaffId INT,
		DimK12SchoolId INT,
        DimLeaId INT,
        DimSeaId INT,
		PersonId INT,
		DimCountDateId INT,
		TitleIIIAccountabilityCode VARCHAR(50),
		TitleIIILanguageInstructionCode VARCHAR(50),		
		ProficiencyStatusCode VARCHAR(50),
		FormerEnglishLearnerYearStatus VARCHAR(50)
	)

	create table #queryOutput (
		QueryOutputId INT IDENTITY(1,1) NOT NULL,
		DimK12StaffId INT,
		DimLeaId INT,
		DimSeaId INT,

		PersonnelPersonId INT,
		DimSchoolYearId INT,
		DimK12SchoolId INT,
		
		AgeGroupCode VARCHAR(50),
		CertificationStatusCode VARCHAR(50),
		PersonnelTypeCode VARCHAR(50),
		QualificationStatusCode VARCHAR(50),
		--StaffCategoryCode VARCHAR(50),

		StaffCategorySpecialCode VARCHAR(50),
		StaffCategoryCCD  VARCHAR(50),
		StaffCategoryTitle1Code   VARCHAR(50),

		PersonnelCount INT,
		PersonnelFTE DECIMAL(18,3),

		TitleIIIAccountabilityCode VARCHAR(50),
		TitleIIILanguageInstructionCode VARCHAR(50),		
		ProficiencyStatusCode VARCHAR(50),
		FormerEnglishLearnerYearStatus VARCHAR(50),

		UnexperiencedStatusCode VARCHAR(50),
		EmergencyOrProvisionalCredentialStatusCode VARCHAR(50),
		OutOfFieldStatusCode VARCHAR(50)
	)


	BEGIN TRY
	
	DECLARE @selectedDate AS INT, @submissionYear AS VARCHAR(50)
	DECLARE selectedYears_cursor CURSOR FOR 
	SELECT d.DimSchoolYearId, d.SchoolYear
		FROM rds.DimSchoolYears d
		JOIN rds.DimSchoolYearDataMigrationTypes dd 
			ON dd.DimSchoolYearId = d.DimSchoolYearId
		JOIN rds.DimDataMigrationTypes b 
			ON b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
		WHERE d.DimSchoolYearId <> -1 
		AND dd.IsSelected = 1 
		AND DataMigrationTypeCode = @migrationType


	OPEN selectedYears_cursor
	FETCH NEXT FROM selectedYears_cursor INTO @selectedDate, @submissionYear
	WHILE @@FETCH_STATUS = 0
	BEGIN

	-- Log history
	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ') for ' +  @submissionYear)
	END

	DELETE FROM #queryOutput
	DELETE FROM @staffDateQuery
	DELETE FROM @personnelStatusQuery
	DELETE FROM @personnelCategoryQuery
	DELETE FROM @schoolQuery
	DELETE FROM @titleIIIStatusQuery

	-- Get Dimension Data
	----------------------------
	-- Migrate_DimSchoolYears

	INSERT INTO @staffDateQuery (
		  DimK12StaffId
		, PersonId
		, DimSchoolYearId
		, DimCountDateId
		, CountDate
		, SchoolYear
		, SessionBeginDate
		, SessionEndDate
		, RecordStartDateTime
		, RecordEndDateTime
	)
	exec rds.Migrate_DimSchoolYears_K12Staff @migrationType, @selectedDate
	
	IF @runAsTest = 1
	BEGIN
		print 'staffDateQuery'
		SELECT * FROM @staffDateQuery
	END

	-- Migrate_DimK12Schools

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Schools for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	INSERT INTO @schoolQuery (
		DimK12StaffId
		, PersonId
		, DimCountDateId
		, DimSeaId 
		, DimIeuId 
		, DimLeaID
		, DimK12SchoolId
		, IeuOrganizationId
		, LeaOrganizationId
		, K12SchoolOrganizationId
		, LeaOrganizationPersonRoleId 
		, K12SchoolOrganizationPersonRoleId 
		, LeaEntryDate
		, LeaExitDate 
		, K12SchoolEntryDate	
		, K12SchoolExitDate 
	)
	EXEC rds.Migrate_K12StaffOrganizations @StaffDateQuery, @dataCollectionId, 0

	IF @runAsTest = 1
	BEGIN
		print 'schoolQuery'
		SELECT * FROM @schoolQuery
	END

	-- Migrate_DimK12StaffStatuses

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Personnel Status Dimension for (' + @factTypeCode + ') - ' +  @submissionYear)
	END
	
	INSERT INTO @personnelStatusQuery (
		DimK12StaffId,
		DimK12SchoolId,
        DimLeaId,
        DimSeaId,
		PersonId,
		DimCountDateId,
		AgeGroupCode,
		CertificationStatusCode,
		PersonnelTypeCode,
		QualificationStatusCode,
		StaffCategoryCode,
		PersonnelFTE,
		UnexperiencedStatusCode,
		EmergencyOrProvisionalCredentialStatusCode,
		OutOfFieldStatusCode
	)
	exec rds.Migrate_DimK12StaffStatuses @staffDateQuery, @schoolQuery, @dataCollectionId

	IF @runAsTest = 1
	BEGIN
		print 'personnelStatusQuery'
		SELECT * FROM @personnelStatusQuery
	END

	-- Migrate_DimK12StaffCategories

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Personnel Categories Dimension for (' + @factTypeCode + ') - ' +  @submissionYear)
	END
	
	INSERT INTO @personnelCategoryQuery (
		DimK12StaffId,
		DimK12SchoolId,
		DimLeaId,
		DimSeaId,
		PersonId,
		DimCountDateId,
		StaffCategorySpecialCode,
		StaffCategoryCCD ,
		StaffCategoryTitle1Code,
		PersonnelFTE		
	)
	exec rds.migrate_DimK12StaffCategories @staffDateQuery, @schoolQuery, @dataCollectionId

	IF @runAsTest = 1
	BEGIN
		print 'personnelCategoryQuery'
		SELECT * FROM @personnelCategoryQuery
	END


	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Title III Dimension for (' + @factTypeCode + ') - ' +  @submissionYear)
	END
	
	INSERT INTO @titleIIIStatusQuery (
		DimK12StaffId,
		DimK12SchoolId,
		DimLeaId,
		DimSeaId,
		PersonId,
		DimCountDateId,
		TitleIIIAccountabilityCode ,
		TitleIIILanguageInstructionCode ,		
		ProficiencyStatusCode ,
		FormerEnglishLearnerYearStatus
	)
	exec rds.Migrate_DimTitleIIIStatuses_Personnel @staffDateQuery, @schoolQuery, @dataCollectionId

	IF @runAsTest = 1
	BEGIN
		print 'titleIIIStatusQuery'
		SELECT * FROM @titleIIIStatusQuery
	END


	-- Combine Dimension Data
	----------------------------
	-- Log history
	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Combining Dimension Data for (' + @factTypeCode + ') -  ' + @submissionYear)
	END

	
	INSERT INTO #queryOutput (
		DimK12StaffId,
		PersonnelPersonId,
		DimSchoolYearId,
		DimK12SchoolId,
		DimLeaId,
		DimSeaId,

		AgeGroupCode,
		CertificationStatusCode,
		PersonnelTypeCode,
		QualificationStatusCode,
		--StaffCategoryCode,

		StaffCategorySpecialCode ,
		StaffCategoryCCD ,
		StaffCategoryTitle1Code  ,

		PersonnelCount ,
		PersonnelFTE,

		TitleIIIAccountabilityCode ,
		TitleIIILanguageInstructionCode ,		
		ProficiencyStatusCode ,
		FormerEnglishLearnerYearStatus,

		UnexperiencedStatusCode,
		EmergencyOrProvisionalCredentialStatusCode,
		OutOfFieldStatusCode
	)
	SELECT 
		s.DimK12StaffId,
		s.PersonId,
		s.DimSchoolYearId,

		ISNULL(sch.DimK12SchoolId, -1),
		ISNULL(sch.DimLeaId, -1),
		ISNULL(sch.DimSeaId, -1),
		
		ISNULL(per.AgeGroupCode, 'MISSING'),
		ISNULL(per.CertificationStatusCode, 'MISSING'),
		ISNULL(per.PersonnelTypeCode, 'MISSING'),
		ISNULL(per.QualificationStatusCode, 'MISSING'),
		--ISNULL(per.StaffCategoryCode, 'MISSING'),
		ISNULL(cat.StaffCategorySpecialCode,'MISSING'),
		ISNULL(cat.StaffCategoryCCD, 'MISSING'),
		ISNULL(cat.StaffCategoryTitle1Code, 'MISSING'),

		1,
		cat.PersonnelFTE,

		ISNULL(title3.TitleIIIAccountabilityCode , 'MISSING'),
		ISNULL(TitleIIILanguageInstructionCode ,'MISSING'),	
		ISNULL(ProficiencyStatusCode , 'MISSING'),
		ISNULL(FormerEnglishLearnerYearStatus, 'MISSING'),

		ISNULL(per.UnexperiencedStatusCode, 'MISSING'),
		ISNULL(per.EmergencyOrProvisionalCredentialStatusCode, 'MISSING'),
		ISNULL(per.OutOfFieldStatusCode, 'MISSING')
	FROM @staffDateQuery s
	LEFT JOIN @schoolQuery sch 
		ON s.DimK12StaffId = sch.DimK12StaffId 
		AND s.DimCountDateId = sch.DimCountDateId
	LEFT JOIN @personnelStatusQuery per 
		ON s.DimK12StaffId = per.DimK12StaffId 
		AND s.DimCountDateId = per.DimCountDateId 
		AND sch.DimK12SchoolId = per.DimK12SchoolId
	LEFT JOIN @personnelCategoryQuery cat 
		ON s.DimK12StaffId = cat.DimK12StaffId 
		AND s.DimCountDateId = cat.DimCountDateId 
		AND sch.DimK12SchoolId = cat.DimK12SchoolId
	LEFT JOIN @titleIIIStatusQuery title3 
		ON title3.DimK12StaffId = s.DimK12StaffId 
		AND s.DimCountDateId = title3.DimCountDateId 
		AND sch.DimK12SchoolId = title3.DimK12SchoolId

	IF @runAsTest = 1
	BEGIN
		print 'queryOutput'
		SELECT * FROM #queryOutput
	END

	
	-- INSERT New Facts
	----------------------------
	-- Log history
	

	IF @runAsTest = 0
	BEGIN
		
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserting Facts for (' + @factTypeCode + ') -  ' + @submissionYear)

		INSERT INTO rds.FactK12StaffCounts (
			FactTypeId,
			K12StaffId,
			K12SchoolId,
			LeaId,
			SeaId,
			SchoolYearId,
			K12StaffStatusId,
			K12StaffCategoryId,
			StaffCount,
			StaffFTE,
			TitleIIIStatusId
		)
		SELECT
			@factTypeId AS DimFactTypeId,
			q.DimK12StaffId,
			q.DimK12SchoolId,
			q.DimLeaId,
			q.DimSeaId,
			q.DimSchoolYearId,
			ISNULL(per.DimK12StaffStatusId, -1) AS DimK12StaffStatusId,
			ISNULL(cat.DimK12StaffCategoryId, -1) AS DimK12StaffCategoryId,
			---1,
			ISNULL(sum(
				CASE
					WHEN per.DimK12StaffStatusId <> -1 THEN q.PersonnelCount
					ELSE 0
				END
			),0) AS PersonnelCount,
			ISNULL(sum(
				CASE
					WHEN cat.DimK12StaffCategoryId <> -1 THEN q.PersonnelFTE
					ELSE 0
				END
			),0) AS PersonnelFTE
			,ISNULL(title3.DimTitleiiiStatusId, -1) AS DimTitleiiiStatusId
		FROM #queryOutput q
		LEFT JOIN rds.DimK12StaffStatuses per
			ON q.AgeGroupCode = per.SpecialEducationAgeGroupTaughtCode
			AND q.CertificationStatusCode = per.CertificationStatusCode
			AND q.PersonnelTypeCode = per.K12StaffClassificationCode
			AND q.QualificationStatusCode = per.QualificationStatusCode
			AND q.UnexperiencedStatusCode = per.UnexperiencedStatusCode
			AND q.EmergencyOrProvisionalCredentialStatusCode = per.EmergencyOrProvisionalCredentialStatusCode
			AND q.OutOfFieldStatusCode = per.OutOfFieldStatusCode
			--AND q.StaffCategoryCode = per.StaffCategoryCode
		LEFT JOIN rds.DimK12StaffCategories cat 
			ON q.StaffCategorySpecialCode = cat.SpecialEducationSupportServicesCategoryCode
			AND q.StaffCategoryCCD = cat.K12StaffClassificationCode
			AND q.StaffCategoryTitle1Code = cat.TitleIProgramStaffCategoryCode
		LEFT JOIN rds.DimTitleiiiStatuses title3
			ON title3.TitleiiiLanguageInstructionCode = q.TitleIIILanguageInstructionCode		
			AND title3.TitleiiiAccountabilityProgressStatusCode = q.TitleIIIAccountabilityCode
			AND title3.FormerEnglishLearnerYearStatusCode = q.FormerEnglishLearnerYearStatus
			AND title3.ProficiencyStatusCode = q.ProficiencyStatusCode
		GROUP BY
		q.DimK12StaffId,
		q.DimK12SchoolId,
		q.DimLeaId,
		q.DimSeaId,
		q.DimSchoolYearId,
		ISNULL(per.DimK12StaffStatusId, -1),
		ISNULL(cat.DimK12StaffCategoryId, -1),
		ISNULL(title3.DimTitleiiiStatusId, -1) 
	END
	ELSE
	BEGIN
		-- Run As Test (return data instead of inserting it)
		SELECT
			@factTypeId AS DimFactTypeId,
			q.DimK12StaffId,
			q.DimK12SchoolId,
			q.DimLeaId,
			q.DimSeaId,
			q.DimSchoolYearId,
			ISNULL(per.DimK12StaffStatusId, -1) AS DimK12StaffStatusId,
			ISNULL(cat.DimK12StaffCategoryId, -1) AS DimK12StaffCategoryId,
			---1,
			ISNULL(sum(
				CASE
					WHEN per.DimK12StaffStatusId <> -1 THEN q.PersonnelCount
					ELSE 0
				END
			),0) AS PersonnelCount,
			ISNULL(sum(
				CASE
					WHEN cat.DimK12StaffCategoryId <> -1 THEN q.PersonnelFTE
					ELSE 0
				END
			),0) AS PersonnelFTE
			,ISNULL(title3.DimTitleiiiStatusId, -1) AS DimTitleiiiStatusId
		FROM #queryOutput q
		LEFT JOIN rds.DimK12StaffStatuses per
			ON q.AgeGroupCode = per.SpecialEducationAgeGroupTaughtCode
			AND q.CertificationStatusCode = per.CertificationStatusCode
			AND q.PersonnelTypeCode = per.K12StaffClassificationCode
			AND q.QualificationStatusCode = per.QualificationStatusCode
			AND q.UnexperiencedStatusCode = per.UnexperiencedStatusCode
			AND q.EmergencyOrProvisionalCredentialStatusCode = per.EmergencyOrProvisionalCredentialStatusCode
			AND q.OutOfFieldStatusCode = per.OutOfFieldStatusCode
			--AND q.StaffCategoryCode = per.StaffCategoryCode
		LEFT JOIN rds.DimK12StaffCategories cat 
			ON q.StaffCategorySpecialCode = cat.SpecialEducationSupportServicesCategoryCode
			AND q.StaffCategoryCCD = cat.K12StaffClassificationCode
			AND q.StaffCategoryTitle1Code = cat.TitleIProgramStaffCategoryCode
		LEFT JOIN rds.DimTitleiiiStatuses title3
		ON 
		 title3.TitleiiiLanguageInstructionCode = q.TitleIIILanguageInstructionCode		
		AND title3.TitleiiiAccountabilityProgressStatusCode = q.TitleIIIAccountabilityCode
		AND title3.FormerEnglishLearnerYearStatusCode = q.FormerEnglishLearnerYearStatus
		AND title3.ProficiencyStatusCode = q.ProficiencyStatusCode
		GROUP BY
		q.DimK12StaffId,
		q.DimK12SchoolId,
		q.DimLeaId,
		q.DimSeaId,
		q.DimSchoolYearId,
		ISNULL(per.DimK12StaffStatusId, -1),
		ISNULL(cat.DimK12StaffCategoryId, -1),
		ISNULL(title3.DimTitleiiiStatusId, -1) 
	END

	FETCH NEXT FROM selectedYears_cursor INTO @selectedDate, @submissionYear
	END

	END TRY
	BEGIN CATCH
		--ROLLBACK

		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Error Occurred' + CAST(ERROR_MESSAGE() AS VARCHAR(900)))
		
	END CATCH
	
	IF CURSOR_STATUS('global','selectedYears_cursor') >= 0 
	BEGIN
		close selectedYears_cursor
		deallocate selectedYears_cursor 
	END

	IF EXISTS (SELECT  1 FROM tempdb.dbo.sysobjects o WHERE o.[xtype] IN ('U') AND o.id = object_id(N'tempdb..#queryOutput'))
		DROP table #queryOutput

	SET NOCOUNT OFF;

END
