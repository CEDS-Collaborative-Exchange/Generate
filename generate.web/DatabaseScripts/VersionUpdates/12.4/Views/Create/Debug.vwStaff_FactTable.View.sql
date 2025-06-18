CREATE VIEW [Debug].[vwStaff_FactTable] 
AS
	SELECT	
			Fact.FactK12StaffCountId
			, Staff.K12StaffStaffMemberIdentifierState
			, SchoolYear
			, Fact.K12StaffId
			, SEA.StateANSICode
			, SEA.StateAbbreviationCode
			, SEA.StateAbbreviationDescription
			, SEA.SeaOrganizationIdentifierSea
			, SEA.SeaOrganizationName
			, LEAs.LeaIdentifierSea
			, LEAs.LeaOrganizationName
			, Schools.SchoolIdentifierSea
			, Schools.DimK12SchoolId
			, Schools.NameOfInstitution
			, Schools.SchoolOperationalStatus
			, Schools.SchoolTypeCode

			, StaffStatus.SpecialEducationAgeGroupTaughtEdFactsCode
			, StaffStatus.EdFactsCertificationStatusEdFactsCode
			, StaffStatus.HighlyQualifiedTeacherIndicatorEdFactsCode
			, StaffStatus.EdFactsTeacherInexperiencedStatusEdFactsCode
			, StaffStatus.TeachingCredentialTypeEdFactsCode
			, StaffStatus.EdFactsTeacherOutOfFieldStatusEdFactsCode
			, StaffStatus.SpecialEducationTeacherQualificationStatusEdFactsCode
			, StaffStatus.ParaprofessionalQualificationStatusEdFactsCode

			, StaffCat.K12StaffClassificationEdFactsCode
			, StaffCat.SpecialEducationSupportServicesCategoryEdFactsCode
			, StaffCat.TitleIProgramStaffCategoryEdFactsCode

			, Fact.StaffCount
			, Fact.StaffFullTimeEquivalency

	FROM		RDS.FactK12StaffCounts				Fact
	JOIN		RDS.DimSchoolYears					SchoolYears		ON Fact.SchoolYearId			= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes DMT				ON SchoolYears.dimschoolyearid	= DMT.dimschoolyearid		
	LEFT JOIN	RDS.DimPeople						Staff			ON Fact.K12StaffId				= Staff.DimPersonId					AND Staff.IsActiveK12Staff = 1
	LEFT JOIN	RDS.DimSeas                        	SEA         	ON Fact.SeaId   				= SEA.DimSeaId
	LEFT JOIN	RDS.DimLeas							LEAs			ON Fact.LeaId					= LEAs.DimLeaId
	LEFT JOIN	RDS.DimK12Schools					Schools			ON Fact.K12SchoolId				= Schools.DimK12SchoolId
	LEFT JOIN	RDS.DimK12StaffStatuses				StaffStatus		ON Fact.K12StaffStatusId		= StaffStatus.DimK12StaffStatusId
	LEFT JOIN	RDS.DimK12StaffCategories			StaffCat		ON Fact.K12StaffCategoryId		= StaffCat.DimK12StaffCategoryId
    --uncomment/modify the where clause conditions as necessary for validation
    WHERE 1 = 1
	--2 ways to select by SchoolYear, use 1 or the other, not both
	--the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
		AND DMT.IsSelected = 1
		AND DMT.DataMigrationTypeId = 3
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2023
	AND Fact.FactTypeId = 26
	
