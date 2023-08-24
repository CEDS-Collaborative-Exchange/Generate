CREATE VIEW [Debug].[vwK12Staff_FactTable] 
AS
	SELECT		DISTINCT  
				Staff.K12StaffStaffMemberIdentifierState
				, LEAs.LeaIdentifierSea
				, LEAs.LeaIdentifierNces
				, LEAs.LeaOrganizationName
				, Schools.SchoolIdentifierSea
				, Schools.NameOfInstitution

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
	JOIN		RDS.DimSchoolYears					SchoolYears		ON Fact.SchoolYearId		= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes DMT				ON SchoolYears.dimschoolyearid	= DMT.dimschoolyearid		
	LEFT JOIN	RDS.DimPeople						Staff			ON  Fact.K12StaffId			= Staff.DimPersonId					AND Staff.IsActiveK12Staff = 1
	LEFT JOIN	RDS.DimLeas							LEAs			ON  Fact.LeaId				= LEAs.DimLeaId
	LEFT JOIN	RDS.DimK12Schools					Schools			ON  Fact.K12SchoolId		= Schools.DimK12SchoolId

	LEFT JOIN	RDS.DimK12StaffStatuses				StaffStatus		ON  Fact.K12StaffStatusId	= StaffStatus.DimK12StaffStatusId
	LEFT JOIN	RDS.DimK12StaffCategories			StaffCat		ON  Fact.K12StaffCategoryId	= StaffCat.DimK12StaffCategoryId
    --uncomment/modify the where clause conditions as necessary for validation
    WHERE 1 = 1
	--2 ways to select by SchoolYear, use 1 or the other, not both
	--the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
		AND DMT.IsSelected = 1
		AND DMT.DataMigrationTypeId = 2
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2023
	--AND Staff.StaffMemberIdentifierState = '12345678'	
	--AND LEAs.LeaIdentifierState = '123'
	--AND Schools.SchoolIdentifierState = '456'
	--AND StaffStatus.SpecialEducationAgeGroupTaughtEdFactsCode = '6TO21'					--('3TO5', '6TO21', 'MISSING')
	--AND StaffStatus.CertificationStatusEdFactsCode = 'FC'									--('FC', 'NFC', 'MISSING')
	--AND StaffStatus.QualificationStatusEdFactsCode = 'HQ'									--('NHQ','SPEDTCHFULCRT','HQ','Q','NQ','SPEDTCHNFULCRT', 'MISSING')
	--AND StaffStatus.UnexperiencedStatusEdFactsCode = 'TCHEXPRNCD'							--('TCHINEXPRNCD','TCHEXPRNCD', 'MISSING')
	--AND StaffStatus.EmergencyOrProvisionalCredentialStatusEdFactsCode = 'TCHWEMRPRVCRD'	--('TCHWEMRPRVCRD','TCHWOEMRPRVCRD', 'MISSING')
	--AND StaffStatus.OutOfFieldStatusEdFactsCode = 'TCHINFLD'								--('TCHINFLD','TCHOUTFLD', 'MISSING')
	--AND StaffCat.K12StaffClassificationCode = 'ElementaryTeachers'						--('AdministrativeSupportStaff','Administrators','AllOtherSupportStaff'
																								--,'ElementaryTeachers','InstructionalCoordinators','KindergartenTeachers'
																								--,'LibraryMediaSpecialists','LibraryMediaSupportStaff','Paraprofessionals'
																								--,'Pre-KindergartenTeachers','SchoolCounselors','SchoolPsychologist'
																								--,'SecondaryTeachers','SpecialEducationTeachers','StudentSupportServicesStaff'
																								--,'UngradedTeachers', 'MISSING')
	--AND StaffCat.SpecialEducationSupportServicesCategoryEdFactsCode = 'AUDIO'				--('AUDIO','COUNSELOR','INTERPRET','MEDNURSE','OCCTHERAP','ORIENTMOBIL'
																								--,'PEANDREC','PHYSTHERAP','PSYCH','SOCIALWORK','SPEECHPATH', 'MISSING')
	--AND StaffCat.TitleIProgramStaffCategoryCode = 'TitleIAdministrator'					--('TitleISupportStaff','TitleIAdministrator','TitleIOtherParaprofessional'
																								--,'TitleIParaprofessional','TitleITeacher', 'MISSING')

	
