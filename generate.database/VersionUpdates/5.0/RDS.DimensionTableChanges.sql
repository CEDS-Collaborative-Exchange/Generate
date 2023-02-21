    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimFirearms' AND COLUMN_NAME = 'FirearmTypeCode')
    BEGIN
        UPDATE RDS.DimFirearms SET FirearmTypeCode = 'RIFLESSHOTGUNS' WHERE FirearmTypeCode = 'RIFLESHOTGUN'
    END

    SELECT rdksc.DimK12StaffCategoryId, dupes.DimK12StaffCategoryId AS ShouldBeId
	INTO #Swaps
	FROM RDS.DimK12StaffCategories rdksc
	JOIN (SELECT MIN(c.DimK12StaffCategoryId) AS DimK12StaffCategoryId, c.K12StaffClassificationCode, c.SpecialEducationSupportServicesCategoryCode, c.TitleIProgramStaffCategoryCode
		  FROM rds.DimK12StaffCategories c 
		  GROUP BY c.K12StaffClassificationCode, c.SpecialEducationSupportServicesCategoryCode, c.TitleIProgramStaffCategoryCode 
		  HAVING COUNT(*) > 1) dupes
		ON rdksc.K12StaffClassificationCode = dupes.K12StaffClassificationCode
		AND rdksc.SpecialEducationSupportServicesCategoryCode = dupes.SpecialEducationSupportServicesCategoryCode
		AND rdksc.TitleIProgramStaffCategoryCode = dupes.TitleIProgramStaffCategoryCode
		AND rdksc.DimK12StaffCategoryId <> dupes.DimK12StaffCategoryId
	ORDER BY rdksc.K12StaffClassificationCode, rdksc.SpecialEducationSupportServicesCategoryCode, rdksc.TitleIProgramStaffCategoryCode

	UPDATE RDS.FactK12StaffCounts 
	SET K12StaffCategoryId = swaps.ShouldBeId
	FROM RDS.FactK12StaffCounts rfksc
	JOIN #Swaps swaps
		ON rfksc.K12StaffCategoryId = swaps.DimK12StaffCategoryId

	DELETE rdksc
	FROM RDS.DimK12StaffCategories rdksc
	WHERE DimK12StaffCategoryId IN (SELECT DimK12StaffCategoryId FROM #swaps)

	DROP TABLE #Swaps