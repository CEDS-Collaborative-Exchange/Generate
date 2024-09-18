CREATE VIEW [Debug].[vwK12Staff_FactTable] AS

	SELECT		DISTINCT  
				[K12StaffId]			
				, [LeaId]
				, [K12SchoolId]
				, [K12StaffStatusId]	
				, [K12StaffCategoryId]	
				, [TitleIIIStatusId]	
				, [StaffCount]
				, [StaffFTE]

	FROM		RDS.FactK12StaffCounts			Fact
	JOIN		RDS.DimSchoolYears				SchoolYears		ON Fact.SchoolYearId		= SchoolYears.DimSchoolYearId	
	LEFT JOIN	RDS.DimK12Staff					Staff			ON  Fact.K12StaffId			= Staff.DimK12StaffId
	LEFT JOIN	RDS.DimLeas						LEAs			ON  Fact.LeaId				= LEAs.DimLeaId
	LEFT JOIN	RDS.DimK12Schools				Schools			ON  Fact.K12SchoolId		= Schools.DimK12SchoolId

	LEFT JOIN	RDS.DimK12StaffStatuses			StaffStatus		ON  Fact.K12StaffStatusId	= StaffStatus.DimK12StaffStatusId
	LEFT JOIN	RDS.DimK12StaffCategories		StaffCat		ON  Fact.K12StaffCategoryId	= StaffCat.DimK12StaffCategoryId
	LEFT JOIN	RDS.DimTitleIIIStatuses			TitleIII		ON  Fact.TitleIIIStatusId	= TitleIII.DimTitleIIIStatusId      
    --uncomment/modify the where clause conditions as necessary for validation
    WHERE 1 = 1
	AND SchoolYears.SchoolYear = 2022
	--AND Staff.StaffMemberIdentifierState = '12345678'	
	--AND LEAs.LeaIdentifierState = '123'
	--AND Schools.SchoolIdentifierState = '456'
	--AND StaffStatus.SpecialEducationAgeGroupTaughtEdFactsCode = '6TO21'					--('3TO5', '6TO21', 'MISSING')
	--AND StaffStatus.CertificationStatusEdFactsCode = 'FC'									--('FC', 'NFC', 'MISSING')
	--AND StaffStatus.K12StaffClassificationEdFactsCode = 'STAFF'							--('TEACHER','PARAPROFESSIONAL','STAFF', 'MISSING')
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
	--AND TitleIII.FormerEnglishLearnerYearStatusEdFactsCode = '1YEAR'						--('1YEAR','2YEAR','3YEAR','4YEAR','5YEAR', 'MISSING')
	--AND TitleIII.ProficiencyStatusEdFactsCode = 'PROFICIENT'								--('PROFICIENT','NOTPROFICIENT', 'MISSING')
	--AND TitleIII.TitleiiiAccountabilityProgressStatusEdFactsCode = 'PROGRESS'				--('NOPROGRESS','PROFICIENT','PROGRESS', 'MISSING')','
	--AND TitleIII.TitleiiiLanguageInstructionCode = 'DualLanguage'							--('ContentBasedESL','DualLanguage','NewcomerPrograms','Other','PullOutESL'
																								--,'TransitionalBilingual','TwoWayImmersion', 'MISSING')

	
