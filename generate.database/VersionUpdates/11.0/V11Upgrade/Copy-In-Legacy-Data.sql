SET NOCOUNT ON;
-- People - Students
INSERT INTO RDS.DimPeople (
	  FirstName
	, MiddleName
	, LastOrSurname
	, BirthDate 
    , IsActiveK12Student
	, K12StudentStudentIdentifierState 
   	, RecordStartDateTime 
	, RecordEndDateTime 
)
SELECT 
	  FirstName
	, MiddleName
	, LastOrSurname
	, BirthDate 
    , 1
	, K12StudentStudentIdentifierState 
   	, RecordStartDateTime 
	, RecordEndDateTime 
FROM Upgrade.DimK12Students

-- People - Staff
INSERT INTO RDS.DimPeople (
	  FirstName
	, MiddleName
	, LastOrSurname
	, BirthDate 
    , IsActiveK12Staff
	, K12StaffStaffMemberIdentifierState 
   	, RecordStartDateTime 
	, RecordEndDateTime 
)
SELECT 
    FirstName
	, MiddleName
	, LastOrSurname
	, BirthDate 
    , 1
	, K12StaffStaffMemberIdentifierState 
   	, RecordStartDateTime 
	, RecordEndDateTime 
FROM Upgrade.DimK12Staff

/*******************************************************************************************************/
-- Staff Count
INSERT INTO RDS.FactK12StaffCounts (
		[SchoolYearId]
      ,[FactTypeId]
      ,[SeaId]
      ,[LeaId]
      ,[K12SchoolId]
      ,[K12StaffId]
      ,[K12StaffStatusId]
      ,[K12StaffCategoryId]
      ,[TitleIIIStatusId]
      ,[StaffCount]
      ,[StaffFullTimeEquivalency]
)
SELECT 
		ISNULL(rdsy.DimSchoolYearId, -1) --[SchoolYearId]
	  , ISNULL(edft.DimFactTypeId, -1) --[FactTypeId]
      , ISNULL(rdsea.DimSeaId, -1)  --[SeaId]
      , ISNULL(DimLeaId, -1) -- [LeaId]
      , ISNULL(dks.DimK12SchoolId, -1) --[K12SchoolId]
      , ISNULL(rdp.DimPersonId, -1) --[K12StaffId]
      , ISNULL(rdss.DimK12StaffStatusId, -1) AS [K12StaffStatusId] 
      , ISNULL(rdsc.DimK12StaffCategoryId, -1) -- [K12StaffCategoryId]
      , ISNULL(rdtiiis.DimTitleIIIStatusId, -1) --[TitleIIIStatusId]
      , ISNULL(f.StaffCount, -1)--[StaffCount]
      , ISNULL(f.StaffFTE, 0) -- [StaffFullTimeEquivalency]
FROM Upgrade.FactK12StaffCounts f
	LEFT JOIN RDS.DimSchoolYears rdsy 
		ON f.SchoolYear = rdsy.SchoolYear

	LEFT JOIN RDS.DimFactTypes edft
		ON edft.FactTypeCode = 'submission'	

	LEFT JOIN RDS.DimSeas rdsea 
		ON f.SeaIdentifierState = rdsea.SeaOrganizationIdentifierSea
		AND f.SEA_RecordStartDateTime = rdsea.RecordStartDateTime
		AND ISNULL(f.SEA_RecordEndDateTime, '1/1/1900') = ISNULL(rdsea.RecordEndDateTime, '1/1/1900') 

	LEFT JOIN RDS.DimPeople rdp
		ON f.StaffMemberIdentifierState = rdp.K12StaffStaffMemberIdentifierState 
		AND rdp.IsActiveK12Staff = 1

	LEFT JOIN RDS.DimLeas rdl 
		ON f.LeaIdentifierState = rdl.LeaIdentifierSea
		AND f.LEA_RecordStartDateTime = rdl.RecordStartDateTime
		AND ISNULL(f.LEA_RecordEndDateTime, '1/1/1900') = ISNULL(rdl.RecordEndDateTime, '1/1/1900') 

	LEFT JOIN RDS.DimK12Schools dks
		ON dks.SchoolIdentifierSea = SchoolIdentifierState 
		AND f.SCH_RecordStartDateTime = dks.RecordStartDateTime
		AND ISNULL(f.SCH_RecordEndDateTime, '1/1/1900') = ISNULL(dks.RecordEndDateTime, '1/1/1900') 

	LEFT JOIN RDS.DimK12StaffStatuses rdss
		on f.SpecialEducationAgeGroupTaughtCode= rdss.SpecialEducationAgeGroupTaughtCode 
		AND f.CertificationStatusCode = rdss.EdFactsCertificationStatusCode
		AND f.UnexperiencedStatusCode = rdss.EdFactsTeacherInexperiencedStatusCode
		AND f.OutOfFieldStatusCode = rdss.EdFactsTeacherOutOfFieldStatusCode		
		
		AND CASE f.EmergencyOrProvisionalCredentialStatusCode 
			when 'TCHWEMRPRVCRD' then 'Emergency'
			when 'TCHWOEMRPRVCRD' then 'Master'
			ELSE 'MISSING'
		END = rdss.TeachingCredentialTypeCode

		AND  CASE f.QualificationStatusCode
			WHEN 'NotQualified' THEN 'NotQualified'
			WHEN 'Qualified' THEN 'Qualified'
			ELSE 'MISSING'
		END = rdss.ParaprofessionalQualificationStatusCode

		AND  CASE f.QualificationStatusCode
			WHEN 'SPEDTCHFULCRT' THEN 'SPEDTCHFULCRT'
			WHEN 'SPEDTCHNFULCRT' THEN 'SPEDTCHNFULCRT'
			ELSE 'MISSING'
		END = rdss.SpecialEducationTeacherQualificationStatusCode

		AND  CASE f.QualificationStatusCode
			WHEN 'HQ' THEN 'HighlyQualitifed'
			WHEN 'NHQ' THEN 'NotHighlyQualified'
			ELSE 'MISSING'
		END = rdss.HighlyQualifiedTeacherIndicatorCode

	LEFT JOIN RDS.DimK12StaffCategories rdsc
		ON  f.Category_K12StaffClassificationCode = rdsc.K12StaffClassificationCode -- or f.Status_K12StaffClassificationCode
		AND f.SpecialEducationSupportServicesCategoryCode = rdsc.SpecialEducationSupportServicesCategoryCode
		AND f.TitleIProgramStaffCategoryCode = rdsc.TitleIProgramStaffCategoryCode

	LEFT JOIN RDS.DimTitleIIIStatuses rdtiiis
		ON  rdtiiis.ProgramParticipationTitleIIILiepCode = 'Missing'
		AND rdtiiis.TitleIIIImmigrantParticipationStatusCode = 'Missing'
		AND f.ProficiencyStatusCode = rdtiiis.ProficiencyStatusCode
		AND f.TitleiiiAccountabilityProgressStatusCode = rdtiiis.TitleIIIAccountabilityProgressStatusCode
		AND f.TitleiiiLanguageInstructionCode = rdtiiis.TitleIIILanguageInstructionProgramTypeCode

/*******************************************************************************************************/
-- Organization Count -- working
INSERT INTO RDS.FactOrganizationCounts (
		[SchoolYearId]
		,[FactTypeId]
		,[SeaId]
		,[LeaId]
		,[K12StaffId]
		,[K12SchoolId]
		,[AuthorizingBodyCharterSchoolAuthorizerId]
		,[CharterSchoolManagementOrganizationId]
		,[SecondaryAuthorizingBodyCharterSchoolAuthorizerId]
		,[CharterSchoolStatusId]
		,[CharterSchoolUpdatedManagementOrganizationId]
		,[ComprehensiveAndTargetedSupportId]
		,[ReasonApplicabilityId]
		,[K12OrganizationStatusId]
		,[K12SchoolStatusId]
		,[K12SchoolStateStatusId]
		,[SubgroupId]
		,[TitleIStatusId]
		,[FederalProgramCode]
		,[FederalProgramsFundingAllocationType]
		,[FederalProgramsFundingAllocation]
		,[SchoolImprovementFunds]
		,[TitleIParentalInvolveRes]
		,[TitleIPartAAllocations]
		,[OrganizationCount]	
)
SELECT 
		ISNULL(rdsy.DimSchoolYearId, -1) --[SchoolYearId]
		, ISNULL(edft.DimFactTypeId, -1) --[FactTypeId]
		, ISNULL(rdsea.DimSeaId, -1)  --[SeaId]
		, ISNULL(DimLeaId, -1) -- [LeaId]
		, ISNULL(rdp.DimPersonId, -1)	--[K12StaffId]
		, ISNULL(dks.DimK12SchoolId, -1) --[K12SchoolId]
		, ISNULL(rdcsa.DimCharterSchoolAuthorizerId, -1) --[AuthorizingBodyCharterSchoolAuthorizerId]
		, ISNULL(rdcsmo.DimCharterSchoolManagementOrganizationId, -1) --[CharterSchoolManagementOrganizationId]
		, ISNULL(rdcsas.DimCharterSchoolAuthorizerId, -1) --[SecondaryAuthorizingBodyCharterSchoolAuthorizerId]
		, ISNULL(rdcss.DimCharterSchoolStatusId, -1) --[CharterSchoolStatusId]
		, ISNULL(rdcsumo.DimCharterSchoolManagementOrganizationId, -1) --[CharterSchoolUpdatedManagementOrganizationId]
		, ISNULL(rdcts.DimComprehensiveAndTargetedSupportId, -1) --[ComprehensiveAndTargetedSupportId]
		, ISNULL(rdra.DimReasonApplicabilityId, -1) --[ReasonApplicabilityId]
		, ISNULL(rdos.DimK12OrganizationStatusId, -1) --[K12OrganizationStatusId]
		, ISNULL(rdkss.DimK12SchoolStatusId, -1) --[K12SchoolStatusId]
		, ISNULL(rdksss.DimK12SchoolStateStatusId, -1) --[K12SchoolStateStatusId]
		, ISNULL(rdsub.DimSubgroupId, -1) --[SubgroupId]
		, ISNULL(rdtis.DimTitleIStatusId, -1)
		, ISNULL(f.FederalProgramCode, -1) --[FederalProgramCode]
		, ISNULL(f.FederalFundAllocationType, -1) --[FederalProgramsFundingAllocationType]
		, ISNULL(f.FederalFundAllocated, -1) --[FederalProgramsFundingAllocation]
		, ISNULL(f.SchoolImprovementFunds, -1) --[SchoolImprovementFunds]
		, ISNULL(f.TitleIParentalInvolveRes, -1) --[TitleIParentalInvolveRes]
		, ISNULL(f.TitleIPartAAllocations, -1) --[TitleIPartAAllocations]
		, ISNULL(f.OrganizationCount, -1) --[OrganizationCount]	
FROM Upgrade.FactOrganizationCounts f
	LEFT JOIN RDS.DimSchoolYears rdsy 
		ON f.SchoolYear = rdsy.SchoolYear

	LEFT JOIN RDS.DimFactTypes edft
		ON edft.FactTypeCode = 'directory'		

	LEFT JOIN RDS.DimSeas rdsea 
		ON f.SeaIdentifierState = rdsea.SeaOrganizationIdentifierSea
		AND f.RecordStartDateTime = rdsea.RecordStartDateTime
		AND ISNULL(f.RecordEndDateTime, '1/1/1900') = ISNULL(rdsea.RecordEndDateTime, '1/1/1900') 

	LEFT JOIN RDS.DimPeople rdp
		ON f.StaffMemberIdentifierState = rdp.K12StaffStaffMemberIdentifierState 
		AND rdp.IsActiveK12Staff = 1

	LEFT JOIN RDS.DimLeas rdl 
		ON f.LeaIdentifierState = rdl.LeaIdentifierSea
		AND f.LEA_RecordStartDateTime = rdl.RecordStartDateTime
		AND ISNULL(f.LEA_RecordEndDateTime, '1/1/1900') = ISNULL(rdl.RecordEndDateTime, '1/1/1900') 

	LEFT JOIN RDS.DimK12Schools dks
		ON dks.SchoolIdentifierSea = SchoolIdentifierState 
		AND f.SCH_RecordStartDateTime = dks.RecordStartDateTime
		AND ISNULL(f.SCH_RecordEndDateTime, '1/1/1900') = ISNULL(dks.RecordEndDateTime, '1/1/1900') 

	LEFT JOIN RDS.DimCharterSchoolAuthorizers rdcsa															
		ON f.CSAP_StateIdentifier = rdcsa.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea
		AND f.CSAP_RecordStartDateTime = rdcsa.RecordStartDateTime
		AND ISNULL(f.CSAP_RecordEndDateTime, '1/1/1900') = ISNULL(rdcsa.RecordEndDateTime, '1/1/1900') 
	
	LEFT JOIN RDS.DimCharterSchoolManagementOrganizations rdcsmo
		ON f.CSMO_StateIdentifier = rdcsmo.CharterSchoolManagementOrganizationOrganizationIdentifierSea
		AND f.CSMO_RecordStartDateTime = rdcsmo.RecordStartDateTime
		AND ISNULL(f.CSMO_RecordEndDateTime, '1/1/1900') = ISNULL(rdcsmo.RecordEndDateTime, '1/1/1900') 
		
	LEFT JOIN RDS.DimCharterSchoolAuthorizers rdcsas															
		ON f.CSAS_StateIdentifier = rdcsas.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea
		AND f.CSAS_RecordStartDateTime = rdcsas.RecordStartDateTime
		AND ISNULL(f.CSAS_RecordEndDateTime, '1/1/1900') = ISNULL(rdcsas.RecordEndDateTime, '1/1/1900') 

	LEFT JOIN RDS.DimCharterSchoolManagementOrganizations rdcsumo												
		ON f.CSASU_StateIdentifier = rdcsumo.CharterSchoolManagementOrganizationOrganizationIdentifierSea
		AND f.CSASU_RecordStartDateTime = rdcsumo.RecordStartDateTime
		AND ISNULL(f.CSASU_RecordEndDateTime, '1/1/1900') = ISNULL(rdcsumo.RecordEndDateTime, '1/1/1900') 
	
	LEFT JOIN RDS.DimCharterSchoolStatuses rdcss
		ON f.AppropriationMethodCode = rdcss.AppropriationMethodCode
		--select * from RDS.DimComprehensiveAndTargetedSupports 
	LEFT JOIN RDS.DimComprehensiveAndTargetedSupports rdcts -- follow up with Nathan
		ON f.AdditionalTargetedSupportandImprovementCode = rdcts.AdditionalTargetedSupportAndImprovementStatusCode --		case statment --??
		AND f.ComprehensiveAndTargetedSupportCode = 'Missing' -- no field to map this to is this a case and map to a different field?
		AND f.ComprehensiveSupportCode = 'Missing'
		AND f.ComprehensiveSupportImprovementCode = rdcts.ComprehensiveSupportAndImprovementStatusCode 
		AND f.TargetedSupportCode = 'Missing'
		AND f.TargetedSupportImprovementCode = rdcts.TargetedSupportAndImprovementStatusCode 
	LEFT JOIN RDS.DimReasonApplicabilities rdra
		ON f.ComprehensiveSupportReasonApplicabilityCode = rdra.ReasonApplicabilityCode
	
	LEFT JOIN RDS.DimK12OrganizationStatuses rdos
		ON f.GunFreeSchoolsActReportingStatusCode = rdos.GunFreeSchoolsActReportingStatusCode
		AND f.HighSchoolGraduationRateIndicatorStatusCode = rdos.HighSchoolGraduationRateIndicatorStatusCode
		AND f.McKinneyVentoSubgrantRecipientCode = rdos.McKinneyVentoSubgrantRecipientCode
		AND f.ReapAlternativeFundingStatusCode = rdos.ReapAlternativeFundingStatusCode
		
	LEFT JOIN RDS.DimK12SchoolStatuses rdkss 
		ON f.MagnetOrSpecialProgramEmphasisSchoolCode = rdkss.MagnetOrSpecialProgramEmphasisSchoolCode
		AND f.NslpStatusCode = rdkss.NslpStatusCode
		AND f.PersistentlyDangerousStatusCode = rdkss.PersistentlyDangerousStatusCode
		AND f.ProgressAchievingEnglishLanguageCode = rdkss.ProgressAchievingEnglishLanguageProficiencyIndicatorTypeCode
		AND f.SchoolImprovementStatusCode = rdkss.SchoolImprovementStatusCode	
		AND f.SharedTimeIndicatorCode = rdkss.SharedTimeIndicatorCode
		AND f.StatePovertyDesignationCode = rdkss.StatePovertyDesignationCode
		AND f.VirtualSchoolStatusCode = rdkss.VirtualSchoolStatusCode

	LEFT JOIN RDS.DimK12SchoolStateStatuses rdksss 
		ON f.SchoolStateStatusCode = rdksss.SchoolStateStatusCode

	LEFT JOIN RDS.DimSubgroups rdsub 
		ON f.SubgroupCode = rdsub.SubgroupCode
	
	LEFT JOIN RDS.DimTitleIStatuses rdtis
		ON  f.TitleIInstructionalServicesCode = rdtis.TitleIInstructionalServicesCode
		AND f.TitleIProgramTypeCode = rdtis.TitleIProgramTypeCode
		AND f.TitleISchoolStatusCode = rdtis.TitleISchoolStatusCode
		AND f.TitleISupportServicesCode = rdtis.TitleISupportServicesCode

/*******************************************************************************************************/
-- Student Count
INSERT INTO RDS.FactK12StudentCounts (
    SchoolYearId
	, FactTypeId
	, SeaId
	, IeuId
	, LeaId
	, K12SchoolId
	, K12StudentId
	, AgeId
	, AttendanceId
	, CohortStatusId
	, CteStatusId
	, EnglishLearnerStatusId
	, GradeLevelId
	, HomelessnessStatusId
	, EconomicallyDisadvantagedStatusId
	, FosterCareStatusId
	, IdeaStatusId
	, ImmigrantStatusId
	, K12DemographicId
	, K12EnrollmentStatusId
	, K12AcademicAwardStatusId
	, LanguageId
	, MigrantStatusId
	, NOrDStatusId
	, PrimaryDisabilityTypeId
	, RaceId
	, SpecialEducationServicesExitDateId
	, MigrantStudentQualifyingArrivalDateId
	, LastQualifyingMoveDateId
	, TitleIStatusId
	, TitleIIIStatusId
	--, MilitaryStatu
	, StudentCount        
    )
SELECT 
	  ISNULL(DimSchoolYearId, -1)
	, ISNULL(FactTypeId, -1)
	, ISNULL(DimSeaId, -1)
	, ISNULL(DimIeuId, -1)
	, ISNULL(DimLeaId, -1)
	, ISNULL(DimK12SchoolId, -1)
	, ISNULL(DimPersonId, -1)
	, ISNULL(DimAgeId, -1)
	, ISNULL(DimAttendanceId, -1)
	, ISNULL(DimCohortStatusId, -1)
	, ISNULL(DimCteStatusId, -1)
	, ISNULL(DimEnglishLearnerStatusId, -1)
	, ISNULL(DimGradeLevelId, -1)
	, ISNULL(DimHomelessnessStatusId, -1)
	, ISNULL(DimEconomicallyDisadvantagedStatusId, -1)
	, ISNULL(DimFosterCareStatusId, -1)
	, ISNULL(DimIdeaStatusId, -1)
	, ISNULL(DimImmigrantStatusId, -1)
	, ISNULL(DimK12DemographicId, -1)
	, ISNULL(DimK12EnrollmentStatusId, -1)
	, ISNULL(rdkaas.DimK12AcademicAwardStatusId, -1)
	, ISNULL(DimLanguageId, -1)
	, ISNULL(DimMigrantStatusId, -1)
	, ISNULL(DimNOrDStatusId, -1)
	, ISNULL(DimIdeaDisabilityTypeId, -1) AS DisabilityType
	, ISNULL(DimRaceId, -1)
	, ISNULL(rdsesed.DimDateId, -1) -- DimSpecialEducationServicesExitDateId
	, -1
	, -1
	, ISNULL(DimTitleIStatusId, -1)
	, ISNULL(DimTitleIIIStatusId, -1)
	--, ISNULL(rdms2.DimMilitaryStatusId, -1)
	, ISNULL(StudentCount, -1)

FROM Upgrade.FactK12StudentCounts f
LEFT JOIN RDS.DimSchoolYears rdsy 
    ON f.SchoolYear = rdsy.SchoolYear
LEFT JOIN RDS.DimSeas rds 
    ON f.SeaIdentifierState = rds.SeaOrganizationIdentifierSea
    AND f.SEA_RecordStartDateTime = rds.RecordStartDateTime
    AND ISNULL(f.SEA_RecordEndDateTime, '1/1/1900') = ISNULL(rds.RecordEndDateTime, '1/1/1900') 
LEFT JOIN RDS.DimIeus rdi 
    ON f.IeuIdentifierState = rdi.IeuOrganizationIdentifierSea
    AND f.IEU_RecordStartDateTime = rdi.RecordStartDateTime
    AND ISNULL(f.IEU_RecordEndDateTime, '1/1/1900') = ISNULL(rdi.RecordEndDateTime, '1/1/1900') 
LEFT JOIN RDS.DimLeas rdl 
    ON f.LeaIdentifierState = rdl.LeaIdentifierSea
    AND f.LEA_RecordStartDateTime = rdl.RecordStartDateTime
    AND ISNULL(f.LEA_RecordEndDateTime, '1/1/1900') = ISNULL(rdl.RecordEndDateTime, '1/1/1900') 
LEFT JOIN RDS.DimK12Schools rdksch
    ON f.SchoolIdentifierState = rdksch.SchoolIdentifierSea
    AND f.SCH_RecordStartDateTime = rdksch.RecordStartDateTime
    AND ISNULL(f.SCH_RecordEndDateTime, '1/1/1900') = ISNULL(rdksch.RecordEndDateTime, '1/1/1900') 
LEFT JOIN RDS.DimPeople rdp
	ON f.StateStudentIdentifier = rdp.K12StudentStudentIdentifierState
	AND f.STU_RecordStartDateTime = rdp.RecordStartDateTime
    AND ISNULL(f.STU_RecordEndDateTime, '1/1/1900') = ISNULL(rdp.RecordEndDateTime, '1/1/1900') 
LEFT JOIN RDS.DimAges rda    
    ON f.AgeCode = rda.AgeCode
LEFT JOIN RDS.DimAttendances rdab
    ON f.AbsenteeismCode = rdab.AbsenteeismCode
LEFT JOIN RDS.DimCohortStatuses rdcs 
    ON f.CohortStatusCode = rdcs.CohortStatusCode
LEFT JOIN RDS.DimCteStatuses rdctes 
    ON  CASE f.CteAeDisplacedHomemakerIndicatorCode
            WHEN 'DH' THEN 'Yes'
            ELSE 'MISSING'
        END = rdctes.CteAeDisplacedHomemakerIndicatorCode
    AND CASE f.RepresentationStatusCode
            WHEN 'MEM' THEN 'Underrepresented'
            WHEN 'NM' THEN 'NotUnderrepresented'
            ELSE 'MISSING'
        END = rdctes.CteNontraditionalGenderStatusCode
    AND CASE f.CteNontraditionalGenderStatusCode
            WHEN 'NTE' THEN 'Yes'
            ELSE 'MISSING'
        END = rdctes.CteNontraditionalCompletionCode
    AND CASE f.SingleParentOrSinglePregnantWomanCode
            WHEN 'SPPT' THEN 'Yes'
            ELSE 'MISSING'
        END = rdctes.SingleParentOrSinglePregnantWomanStatusCode
    AND CASE f.CteGraduationRateInclusionCode
            WHEN 'GRAD' THEN 'IncludedAsGraduated'
            WHEN 'NOTG' THEN 'NotIncludedAsGraduated'
            ELSE 'MISSING'
        END = rdctes.CteGraduationRateInclusionCode
    AND CASE f.CteProgramCode 
            WHEN 'CTEPART' THEN 'Yes'
            WHEN 'NONCTEPART' THEN 'No'
            ELSE 'MISSING'
        END = rdctes.CteParticipantCode
    AND CASE f.CteProgramCode 
            WHEN 'CTECONC' THEN 'Yes'
            WHEN 'NONCTEPART' THEN 'No'
            ELSE 'MISSING'
        END = rdctes.CteConcentratorCode
LEFT JOIN RDS.DimEnglishLearnerStatuses rdels 
    ON  CASE f.EnglishLearnerStatusCode  
            WHEN 'LEP' THEN 'Yes'
            WHEN 'NLEP' THEN 'No'
            ELSE 'MISSING'
        END = rdels.EnglishLearnerStatusCode
	AND CASE f.LepPerkinsStatusCode
			WHEN 'LEPP' THEN 'Yes'
			WHEN 'MISSING' THEN 'MISSING'
			ELSE 'MISSING'
		 END = rdels.PerkinsEnglishLearnerStatusCode

LEFT JOIN RDS.DimGradeLevels rdgl
    ON  f.GradeLevelCode = rdgl.GradeLevelCode --Codes are the same
LEFT JOIN RDS.DimHomelessnessStatuses rdhs
    ON  f.HomelessnessStatusCode = rdhs.HomelessnessStatusCode --Codes are the same
    AND f.HomelessPrimaryNighttimeResidenceCode = rdhs.HomelessPrimaryNighttimeResidenceCode --Codes are the same
    AND f.HomelessServicedIndicatorCode = rdhs.HomelessServicedIndicatorCode --Codes are the same
    AND f.HomelessUnaccompaniedYouthStatusCode = rdhs.HomelessUnaccompaniedYouthStatusCode --Codes are the same
LEFT JOIN RDS.DimEconomicallyDisadvantagedStatuses rdeds
    ON  f.EconomicDisadvantageStatusCode = rdeds.EconomicDisadvantageStatusCode --Codes are the same
    AND f.EligibilityStatusForSchoolFoodServiceProgramCode = rdeds.EligibilityStatusForSchoolFoodServiceProgramsCode --Codes are the same
    AND f.NSLPDirectCertificationIndicatorCode = rdeds.NationalSchoolLunchProgramDirectCertificationIndicatorCode --Codes are the same
LEFT JOIN RDS.DimFosterCareStatuses rdfcs
    ON CASE f.FosterCareProgramCode
            WHEN 'FOSTERCARE' THEN 'Yes'
            WHEN 'NONFOSTERCARE' THEN 'No'
            ELSE 'MISSING'
        END = rdfcs.ProgramParticipationFosterCareCode
LEFT JOIN RDS.DimIdeaStatuses rdis
    ON  f.SpecialEducationExitReasonCode = rdis.SpecialEducationExitReasonCode --Codes are the same
    AND CASE f.IdeaIndicatorCode
            WHEN 'IDEA' THEN 'Yes'
            ELSE 'MISSING'
        END = rdis.IdeaIndicatorCode
    AND CASE WHEN (f.AgeCode >= 6 AND f.AgeCode <= 21)
                OR (f.AgeCode = 5 and f.GradeLevelCode NOT IN ('MISSING','PK'))
                    THEN f.IdeaEducationalEnvironmentCode 
            ELSE 'MISSING'
        END = rdis.IdeaEducationalEnvironmentForSchoolAgeCode
    AND CASE WHEN (f.AgeCode < 5 AND f.AgeCode >= 3)
                OR (f.AgeCode = 5 and f.GradeLevelCode IN ('MISSING','PK'))
                    THEN f.IdeaEducationalEnvironmentCode 
            ELSE 'MISSING'
        END = rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode
LEFT JOIN RDS.DimImmigrantStatuses rdimms
    -- I think
    ON  f.TitleiiiProgramParticipationCode = rdimms.TitleIIIImmigrantStatusCode
    AND f.TitleIIIImmigrantParticipationStatusCode = rdimms.TitleIIIImmigrantParticipationStatusCode
LEFT JOIN RDS.DimK12Demographics rdkdemo
    ON f.SexCode = rdkdemo.SexCode
LEFT JOIN RDS.DimK12EnrollmentStatuses rdkes
    ON  f.EnrollmentStatusCode = rdkes.EnrollmentStatusCode
    AND f.EntryTypeCode = rdkes.EntryTypeCode
    AND f.ExitOrWithdrawalTypeCode = rdkes.ExitOrWithdrawalTypeCode
    AND f.PostSecondaryEnrollmentStatusCode = rdkes.PostSecondaryEnrollmentStatusCode
    AND f.AcademicOrVocationalOutcomeCode = rdkes.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode
    AND f.AcademicOrVocationalExitOutcomeCode = rdkes.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode
LEFT JOIN RDS.DimK12AcademicAwardStatuses rdkaas    
	ON CASE f.HighSchoolDiplomaTypeCode -- coded these because there are three rows for missing
		 WHEN 'REGDIP' THEN '00806' 
		 WHEN 'REGDIP' THEN '00812'
		 WHEN 'REGDIP' THEN '00816'
		 ELSE 'MISSING'
    END = rdkaas.HighSchoolDiplomaTypeCode	
LEFT JOIN RDS.DimLanguages rdlang
    ON f.Iso6392LanguageCode = rdlang.Iso6392LanguageCodeCode
LEFT JOIN RDS.DimMigrantStatuses rdms
	ON  f.MigrantStatusCode = rdms.MigrantStatusCode --Codes are the same
	AND 'MISSING' = rdms.MigrantEducationProgramEnrollmentTypeCode
	AND CASE f.ContinuationOfServicesReasonCode
            WHEN 'CONTINUED' THEN '01' -- The best we can do. NOTE: This data may not be used, so may not need to be upgraded. 
            ELSE 'MISSING'
        END = rdms.ContinuationOfServicesReasonCode
	AND f.ConsolidatedMepFundsStatusCode = rdms.ConsolidatedMepFundsStatusCode --Codes are the same
	AND f.MepServicesTypeCode = rdms.MigrantEducationProgramServicesTypeCode
	AND CASE f.MigrantPrioritizedForServicesCode
            WHEN 'PS' THEN 'Yes'
            ELSE 'MISSING'
        END = rdms.MigrantPrioritizedForServicesCode
	AND rdms.MEPContinuationOfServicesStatusCode = 'MISSING'
LEFT JOIN RDS.DimNOrDStatuses rdnords
	ON  CASE f.NeglectedOrDelinquentProgramTypeCode
            WHEN 'ADLTCORR' THEN 'AdultCorrection'
            WHEN 'ATRISK' THEN 'AtRiskPrograms'
            WHEN 'JUVCORR' THEN 'JuvenileCorrection'
            WHEN 'JUVDET' THEN 'JuvenileDetention'
            WHEN 'NEGLECT' THEN 'NeglectedPrograms'
            WHEN 'OTHER' THEN 'OtherPrograms'
            ELSE 'MISSING'
        END = rdnords.NeglectedOrDelinquentProgramTypeCode
		--NeglectedOrDelinquentLongTermStatusCode		these are NULL										--**********
LEFT JOIN RDS.DimIdeaDisabilityTypes rdidt -- case with RefDisabilityTypeId 
					ON CASE f.PrimaryDisabilityTypeCode 
						WHEN 'AUT'	THEN 'Autism'
    					WHEN 'DB'	THEN 'Deafblindness'
						WHEN 'DD'	THEN 'Developmentaldelay'
						WHEN 'EMN'	THEN 'Emotionaldisturbance'
						WHEN 'HI'	THEN 'Hearingimpairment'
						WHEN 'ID'	THEN 'IntellectualDisability'
						WHEN 'MD'	THEN 'Multipledisabilities'
						WHEN 'OI'	THEN 'Orthopedicimpairment'
						WHEN 'OHI'	THEN 'Otherhealthimpairment'
						WHEN 'SLD'	THEN 'Specificlearningdisability'
						WHEN 'SLI'	THEN 'Speechlanguageimpairment'
						WHEN 'TBI'	THEN 'Traumaticbraininjury'
						WHEN 'VI'	THEN 'Visualimpairment'
						ELSE 'MISSING'	
					END = rdidt.IdeaDisabilityTypeCode		
	
LEFT JOIN RDS.DimRaces rdr
	ON f.RaceCode = rdr.RaceCode
LEFT JOIN RDS.DimDates rdsesed
	ON f.SpecialEducationServicesExitDate = rdsesed.DateValue 
LEFT JOIN RDS.DimTitleIStatuses rdtis
	ON  f.TitleIInstructionalServicesCode = rdtis.TitleIInstructionalServicesCode
	AND f.TitleIProgramTypeCode = rdtis.TitleIProgramTypeCode
	AND f.TitleISchoolStatusCode = rdtis.TitleISchoolStatusCode
	AND f.TitleISupportServicesCode = rdtis.TitleISupportServicesCode
LEFT JOIN RDS.DimTitleIIIStatuses rdtiiis
	ON  f.TitleiiiProgramParticipationCode = rdtiiis.ProgramParticipationTitleIIILiepCode
	AND f.TitleIIIImmigrantParticipationStatusCode = rdtiiis.TitleIIIImmigrantParticipationStatusCode
	AND f.ProficiencyStatusCode = rdtiiis.ProficiencyStatusCode
	AND f.TitleiiiAccountabilityProgressStatusCode = rdtiiis.TitleIIIAccountabilityProgressStatusCode
	AND f.TitleiiiLanguageInstructionCode = rdtiiis.TitleIIILanguageInstructionProgramTypeCode
--LEFT JOIN RDS.DimMilitaryStatuses rdms2 
--	ON f.MilitaryConnectedStudentIndicatorCode = rdms2.MilitaryConnectedStudentIndicatorCode
/*******************************************************************************************************/

-- Disciplines

-- temp table for inserting race into BridgeK12StudentDisciplineRaces table
		  DECLARE
          @student_person_xwalk TABLE (
              NewFactK12StudentDisciplineId INT
            , RaceId VARCHAR(100)
          );

-- Create CTE with the data to be inserted into RDS.FactK12StudentDisciplines 	
        WITH distinctFactRecords AS (
            SELECT DISTINCT -- select and joins goes in here
			ISNULL(rdsy.DimSchoolYearId, -1)							AS [SchoolYearId]
			, ISNULL(edft.DimFactTypeId, -1)							AS [FactTypeId] 
			, -1 														AS [DataCollectionId]
			, ISNULL(rdsea.DimSeaId, -1) 								AS [SeaId]
			, ISNULL(rdi.DimIeuId, -1) 									AS [IeuId]
			, ISNULL(DimLeaId, -1)										AS [LeaId]
			, ISNULL(dks.DimK12SchoolId, -1)							AS [K12SchoolId]
			, ISNULL(rdp.DimPersonId, -1) 								AS [K12StudentId]
			, ISNULL(DimAgeId, -1) 										AS [AgeId]
			, ISNULL(rdctes.DimCteStatusId, -1) 						AS [CteStatusId]
			, -1 														AS [DisabilityStatusId]
			, ISNULL(rddds.DimDateId, -1)								AS [DisciplinaryActionStartDateId]
			, -1 														AS [DisciplinaryActionEndDateId]
			, ISNULL(rdds.DimDisciplineStatusId, -1)					AS [DisciplineStatusId]
			, ISNULL(rdeds.DimEconomicallyDisadvantagedStatusId, -1)	AS [EconomicallyDisadvantagedStatusId]
			, ISNULL(rdels.DimEnglishLearnerStatusId, -1)				AS [EnglishLearnerStatusId]
			, ISNULL(rdf.DimFirearmId, -1)								AS [FirearmId]
			, ISNULL(dfd.DimFirearmDisciplineStatusId, -1)				AS [FirearmDisciplineStatusId]
			, ISNULL(rdfcs.DimFosterCareStatusId, -1)					AS [FosterCareStatusId]
			, ISNULL(rdgl.DimGradeLevelId, -1)							AS [GradeLevelId]
			, ISNULL(rdhs.DimHomelessnessStatusId, -1)					AS [HomelessnessStatusId]
			, ISNULL(rdis.DimIdeaStatusId, -1)							AS [IdeaStatusId] 
			, ISNULL(rdimms.DimImmigrantStatusId, -1) 					AS [ImmigrantStatusId]
			, -1 														AS [IncidentIdentifier]
			, ISNULL(rdins.DimIncidentStatusId, -1)						AS [IncidentStatusId]
			, -1 														AS [IncidentDateId]
			,  ISNULL(rdkdemo.DimK12DemographicId, -1)					AS [K12DemographicId]
			, -1 														AS [MigrantStatusId]
			, -1 														AS [MilitaryStatusId]
			, -1 														AS [NOrDStatusId]
			, ISNULL(rdr.DimRaceId, -1)									AS [RaceId]
			, ISNULL(rdidtp.DimIdeaDisabilityTypeId, -1) 				AS [PrimaryDisabilityTypeId]
			, -1														AS [SecondaryDisabilityTypeId]
			, -1														AS [TitleIStatusId]
			, ISNULL(rdtiiis.DimTitleIIIStatusId, -1) 					AS [TitleIIIStatusId]
			, ISNULL(f.DurationOfDisciplinaryAction, 0)					AS [DurationOfDisciplinaryAction]
			, ISNULL(f.DisciplineCount, -1)								AS [DisciplineCount]
			FROM Upgrade.FactK12StudentDisciplines f 

				LEFT JOIN RDS.DimSchoolYears rdsy 
					ON f.SchoolYear = rdsy.SchoolYear

				LEFT JOIN RDS.DimFactTypes edft
					ON edft.FactTypeCode = 'submission'

				LEFT JOIN RDS.DimSeas rdsea 
					ON f.SeaIdentifierState = rdsea.SeaOrganizationIdentifierSea
					AND f.SEA_RecordStartDateTime = rdsea.RecordStartDateTime
					AND ISNULL(f.SEA_RecordEndDateTime, '1/1/1900') = ISNULL(rdsea.RecordEndDateTime, '1/1/1900') 

				LEFT JOIN RDS.DimPeople rdp
					ON f.StateStudentIdentifier = rdp.K12StudentStudentIdentifierState 
					AND rdp.IsActiveK12Student = 1

				LEFT JOIN RDS.DimIeus rdi 
					ON f.IeuIdentifierState = rdi.IeuOrganizationIdentifierSea
					AND f.IEU_RecordStartDateTime = rdi.RecordStartDateTime
					AND ISNULL(f.IEU_RecordEndDateTime, '1/1/1900') = ISNULL(rdi.RecordEndDateTime, '1/1/1900') 

				LEFT JOIN RDS.DimLeas rdl 
					ON f.LeaIdentifierState = rdl.LeaIdentifierSea
					AND f.LEA_RecordStartDateTime = rdl.RecordStartDateTime
					AND ISNULL(f.LEA_RecordEndDateTime, '1/1/1900') = ISNULL(rdl.RecordEndDateTime, '1/1/1900') 

				LEFT JOIN RDS.DimK12Schools dks
					ON dks.SchoolIdentifierSea = SchoolIdentifierState 

				LEFT JOIN RDS.DimAges rda    
					ON f.AgeCode = rda.AgeCode

				LEFT JOIN RDS.DimCteStatuses rdctes 
					ON  CASE f.CteAeDisplacedHomemakerIndicatorCode
							WHEN 'DH' THEN 'Yes'
							ELSE 'MISSING'
						END = rdctes.CteAeDisplacedHomemakerIndicatorCode
					AND CASE f.RepresentationStatusCode
							WHEN 'MEM' THEN 'Underrepresented'
							WHEN 'NM' THEN 'NotUnderrepresented'
							ELSE 'MISSING'
						END = rdctes.CteNontraditionalGenderStatusCode
					AND CASE f.CteNontraditionalGenderStatusCode
							WHEN 'NTE' THEN 'Yes'
							ELSE 'MISSING'
						END = rdctes.CteNontraditionalCompletionCode
					AND CASE f.SingleParentOrSinglePregnantWomanCode
							WHEN 'SPPT' THEN 'Yes'
							ELSE 'MISSING'
						END = rdctes.SingleParentOrSinglePregnantWomanStatusCode
					AND CASE f.CteGraduationRateInclusionCode
							WHEN 'GRAD' THEN 'IncludedAsGraduated'
							WHEN 'NOTG' THEN 'NotIncludedAsGraduated'
							ELSE 'MISSING'
						END = rdctes.CteGraduationRateInclusionCode
					AND CASE f.CteProgramCode 
							WHEN 'CTEPART' THEN 'Yes'
							WHEN 'NONCTEPART' THEN 'No'
							ELSE 'MISSING'
						END = rdctes.CteParticipantCode
					AND CASE f.CteProgramCode 
							WHEN 'CTECONC' THEN 'Yes'
							WHEN 'NONCTEPART' THEN 'No'
							ELSE 'MISSING'
						END = rdctes.CteConcentratorCode

				LEFT JOIN RDS.DimDisciplineStatuses rdds
					ON f.DisciplinaryActionTakenCode = rdds.DisciplinaryActionTakenCode 
					AND f.DisciplineMethodOfChildrenWithDisabilitiesCode  = rdds.DisciplineMethodOfChildrenWithDisabilitiesCode
					AND CASE f.EducationalServicesAfterRemovalCode
							WHEN 'SERVPROV' THEN 'Yes'
							WHEN 'SERVNOTPROV' THEN 'No'
							Else 'MISSING' 
							END = rdds.EducationalServicesAfterRemovalCode
					AND CASE f.IdeaInterimRemovalReasonCode 
								WHEN 'D' THEN 'Drugs'
								WHEN 'W' THEN 'Weapons'
								WHEN 'SBI' THEN 'SeriousBodilyInjury' 
								Else 'MISSING' 
							END = rdds.IdeaInterimRemovalReasonCode
					AND f.IdeaInterimRemovalCode = rdds.IdeaInterimRemovalCode

				LEFT JOIN RDS.DimEconomicallyDisadvantagedStatuses rdeds
					ON  f.EconomicallyDisadvantagedStatusCode = rdeds.EconomicDisadvantageStatusCode --Codes are the same
					AND f.EligibilityStatusForSchoolFoodServiceProgramCode = rdeds.EligibilityStatusForSchoolFoodServiceProgramsCode --Codes are the same
					AND rdeds.NationalSchoolLunchProgramDirectCertificationIndicatorCode = 'Missing'--Codes are the same

				LEFT JOIN RDS.DimEnglishLearnerStatuses rdels 
					ON  CASE f.EnglishLearnerStatusCode  
							WHEN 'LEP' THEN 'Yes'
							WHEN 'NLEP' THEN 'No'
							ELSE 'MISSING'
						END = rdels.EnglishLearnerStatusCode
					AND CASE f.LepPerkinsStatusCode
							WHEN 'LEPP' THEN 'Yes'
							WHEN 'MISSING' THEN 'MISSING'
							ELSE 'MISSING'
							END = rdels.PerkinsEnglishLearnerStatusCode
				LEFT JOIN RDS.DimFirearms rdf
					ON f.FirearmTypeCode = rdf.FirearmTypeCode

				LEFT JOIN RDS.DimFirearmDisciplineStatuses dfd
					ON f.DisciplineMethodForFirearmsIncidentsCode = dfd.DisciplineMethodForFirearmsIncidentsCode
					AND f.IdeaDisciplineMethodForFirearmsIncidentsCode = dfd.IdeaDisciplineMethodForFirearmsIncidentsCode

				LEFT JOIN RDS.DimFosterCareStatuses rdfcs
					ON f.FosterCareProgramCode = rdfcs.ProgramParticipationFosterCareCode

				LEFT JOIN RDS.DimGradeLevels rdgl 
					ON f.GradeLevelCode = rdgl.GradeLevelCode 

				LEFT JOIN RDS.DimHomelessnessStatuses rdhs
					ON  rdhs.HomelessnessStatusCode = 'Missing'--Codes are the same
					AND rdhs.HomelessPrimaryNighttimeResidenceCode = 'Missing'--Codes are the same
					AND f.HomelessServicedIndicatorCode = rdhs.HomelessServicedIndicatorCode --Codes are the same
					AND rdhs.HomelessUnaccompaniedYouthStatusCode = 'Missing'--Codes are the same

				LEFT JOIN RDS.DimIdeaStatuses rdis
					ON   rdis.SpecialEducationExitReasonCode = 'Missing' --Codes are the same
					AND CASE f.IdeaIndicatorCode
							WHEN 'IDEA' THEN 'Yes'
							ELSE 'MISSING'
						END = rdis.IdeaIndicatorCode
						AND rdis.IdeaEducationalEnvironmentForSchoolAgeCode = 'Missing'
					AND  rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = 'Missing'
				LEFT JOIN RDS.DimIdeaDisabilityTypes rdidtp -- case with RefDisabilityTypeId 
					ON CASE f.PrimaryDisabilityTypeCode 
						WHEN 'AUT'	THEN 'Autism'
    					WHEN 'DB'	THEN 'Deafblindness'
						WHEN 'DD'	THEN 'Developmentaldelay'
						WHEN 'EMN'	THEN 'Emotionaldisturbance'
						WHEN 'HI'	THEN 'Hearingimpairment'
						WHEN 'ID'	THEN 'IntellectualDisability'
						WHEN 'MD'	THEN 'Multipledisabilities'
						WHEN 'OI'	THEN 'Orthopedicimpairment'
						WHEN 'OHI'	THEN 'Otherhealthimpairment'
						WHEN 'SLD'	THEN 'Specificlearningdisability'
						WHEN 'SLI'	THEN 'Speechlanguageimpairment'
						WHEN 'TBI'	THEN 'Traumaticbraininjury'
						WHEN 'VI'	THEN 'Visualimpairment'
						ELSE 'MISSING'	
					END = rdidtp.IdeaDisabilityTypeCode		

				LEFT JOIN RDS.DimDates rddds 
					ON f.DisciplinaryActionStartDate = rddds.DateValue

				LEFT JOIN RDS.DimImmigrantStatuses rdimms
					-- I think
					ON  f.TitleiiiProgramParticipationCode = rdimms.TitleIIIImmigrantStatusCode --- used two times
					AND f.TitleIIIImmigrantParticipationStatusCode = rdimms.TitleIIIImmigrantParticipationStatusCode
				LEFT JOIN RDS.DimIncidentStatuses rdins
					ON f.IdeaInterimRemovalReasonCode =  rdins.IdeaInterimRemovalReasonCode

				LEFT JOIN RDS.DimK12Demographics rdkdemo 
					ON f.SexCode = rdkdemo.SexCode

				LEFT JOIN RDS.DimRaces rdr 
					ON f.RaceCode = rdr.RaceCode
					
				LEFT JOIN RDS.DimTitleIIIStatuses rdtiiis
					ON  f.TitleIIIImmigrantParticipationStatusCode = rdtiiis.TitleIIIImmigrantParticipationStatusCode
					AND rdtiiis.ProgramParticipationTitleIIILiepCode = 'Missing' 
					AND rdtiiis.ProficiencyStatusCode = 'Missing'
					AND rdtiiis.TitleIIIAccountabilityProgressStatusCode = 'Missing'
					AND rdtiiis.TitleIIILanguageInstructionProgramTypeCode = 'Missing'
        )

-- Insert and get the new table id from RDS.FactK12StudentDisciplines and the Race ID from CTE distinctFactRecords and insert it into @student_person_xwalk 
        MERGE INTO RDS.FactK12StudentDisciplines TARGET
		   USING distinctFactRecords AS distinctIDs
           ON TARGET.SchoolYearId = 0 --Set this to something that will not match
        WHEN NOT MATCHED THEN 
            INSERT ( [SchoolYearId]
					  ,[FactTypeId] 
					  ,[DataCollectionId]
					  ,[SeaId]
					  ,[IeuId]
					  ,[LeaId]
					  ,[K12SchoolId]
					  ,[K12StudentId]
					  ,[AgeId]
					  ,[CteStatusId]
					  ,[DisabilityStatusId]
					  ,[DisciplinaryActionStartDateId]
					  ,[DisciplinaryActionEndDateId]
					  ,[DisciplineStatusId]
					  ,[EconomicallyDisadvantagedStatusId]
					  ,[EnglishLearnerStatusId]
					  ,[FirearmId]
					  ,[FirearmDisciplineStatusId]
					  ,[FosterCareStatusId]
					  ,[GradeLevelId]
					  ,[HomelessnessStatusId]
					  ,[IdeaStatusId] 
					  ,[ImmigrantStatusId]
					  ,[IncidentIdentifier]
					  ,[IncidentStatusId]
					  ,[IncidentDateId]
					  ,[K12DemographicId]
					  ,[MigrantStatusId]
					  ,[MilitaryStatusId]
					  ,[NOrDStatusId]
					  ,[RaceId]
					  ,[PrimaryDisabilityTypeId]
					  ,[SecondaryDisabilityTypeId]
					  ,[TitleIStatusId]
					  ,[TitleIIIStatusId]
					  ,[DurationOfDisciplinaryAction]
					  ,[DisciplineCount])  
            VALUES ( [SchoolYearId]
					  ,[FactTypeId] 
					  ,[DataCollectionId]
					  ,[SeaId]
					  ,[IeuId]
					  ,[LeaId]
					  ,[K12SchoolId]
					  ,[K12StudentId]
					  ,[AgeId]
					  ,[CteStatusId]
					  ,[DisabilityStatusId]
					  ,[DisciplinaryActionStartDateId]
					  ,[DisciplinaryActionEndDateId]
					  ,[DisciplineStatusId]
					  ,[EconomicallyDisadvantagedStatusId]
					  ,[EnglishLearnerStatusId]
					  ,[FirearmId]
					  ,[FirearmDisciplineStatusId]
					  ,[FosterCareStatusId]
					  ,[GradeLevelId]
					  ,[HomelessnessStatusId]
					  ,[IdeaStatusId] 
					  ,[ImmigrantStatusId]
					  ,[IncidentIdentifier]
					  ,[IncidentStatusId]
					  ,[IncidentDateId]
					  ,[K12DemographicId]
					  ,[MigrantStatusId]
					  ,[MilitaryStatusId]
					  ,[NOrDStatusId]
					  ,[RaceId]
					  ,[PrimaryDisabilityTypeId]
					  ,[SecondaryDisabilityTypeId]
					  ,[TitleIStatusId]
					  ,[TitleIIIStatusId]
					  ,[DurationOfDisciplinaryAction]
					  ,[DisciplineCount])   
        OUTPUT	INSERTED.FactK12StudentDisciplineId
                ,INSERTED.RaceID
        INTO @student_person_xwalk (NewFactK12StudentDisciplineId, RaceId);

 -- Insert the new RDS.FactK12StudentDisciplines and raceID into RDS.BridgeK12StudentDiscplineRaces
         INSERT INTO RDS.BridgeK12StudentDisciplineRaces
        SELECT
            NewFactK12StudentDisciplineId,
            DimRaceId
        FROM @student_person_xwalk xw
        JOIN RDS.DimRaces r
            On xw.RaceId = r.DimRaceId

/*******************************************************************************************************/


-- temp table for inserting race into BridgeK12StudentDisciplineRaces table
		  DECLARE
          @student_Assessment_xwalk TABLE (
              NewFactK12StudentAssessmentId INT
            , RaceId VARCHAR(100)
          );

-- Create CTE with the data to be inserted into RDS.FactK12StudentDisciplines 	
        WITH distinctFactRecords AS (
            SELECT DISTINCT -- select and joins goes in here
					ISNULL(DimSchoolYearId, -1) AS [SchoolYearId]
					, -1	AS [CountDateId]							--[CountDateId]
					, ISNULL(edft.DimFactTypeId, -1) AS [FactTypeId]
					, ISNULL(DimSeaId, -1) AS [SeaId]
					, ISNULL(DimIeuId, -1) AS [IeuId]
					, ISNULL(DimLeaId, -1) AS [LeaId]
					, ISNULL(DimK12SchoolId, -1) AS [K12SchoolId]
					, ISNULL(DimPersonId, -1) AS [K12StudentId]
					, ISNULL(rdr.DimRaceId, -1)		AS [RaceId]
					, ISNULL(rda.DimAssessmentId, -1)  AS [AssessmentId]
					, -1	AS [AssessmentSubtestId]
					, -1	AS [AssessmentAdministrationId]
					, -1	AS [AssessmentRegistrationId]
					, -1	AS [AssessmentParticipationSessionId]
					, -1	AS [AssessmentResultId]
					, ISNULL(rdap.DimAssessmentPerformanceLevelId, -1) AS [AssessmentPerformanceLevelId]
					, -1	AS [CompetencyDefinitionId]
					, ISNULL(rdctes.DimCteStatusId, -1) AS [CteStatusId]
					, ISNULL(rdgl.DimGradeLevelId, -1) AS [GradeLevelWhenAssessedId]
					, ISNULL(rdis.DimIdeaStatusId, -1) AS [IdeaStatusId]
					, ISNULL(rdkdemo.DimK12DemographicId, -1)  AS [K12DemographicId]
					, ISNULL(DimNOrDStatusId, -1) AS [NOrDStatusId]
					, ISNULL(rdtiiis.DimTitleIIIStatusId, -1) AS [TitleIIIStatusId]
					, ISNULL(f.AssessmentCount, -1) AS [AssessmentCount]
					, -1	AS [AssessmentResultScoreValueRawScore]
					, -1	AS [AssessmentResultScoreValueScaleScore]
					, -1	AS [AssessmentResultScoreValuePercentile]
					, -1	AS [AssessmentResultScoreValueTScore]
					, -1	AS [AssessmentResultScoreValueZScore]
					, -1	AS [AssessmentResultScoreValueACTScore]
					, -1	AS [AssessmentResultScoreValueSATScore]
					, -1	AS [FactK12StudentAssessmentAccommodationId]
					
			FROM Upgrade.FactK12StudentAssessments f
			LEFT JOIN RDS.DimSchoolYears rdsy 
				ON f.SchoolYear = rdsy.SchoolYear

			LEFT JOIN RDS.DimFactTypes edft
				ON edft.FactTypeCode = 'Assessment'

			LEFT JOIN RDS.DimSeas rdsea 
				ON f.SeaIdentifierState = rdsea.SeaOrganizationIdentifierSea
				AND f.SEA_RecordStartDateTime = rdsea.RecordStartDateTime
				AND ISNULL(f.SEA_RecordEndDateTime, '1/1/1900') = ISNULL(rdsea.RecordEndDateTime, '1/1/1900') 

			LEFT JOIN RDS.DimIeus rdi 
				ON f.IeuIdentifierState = rdi.IeuOrganizationIdentifierSea
				AND f.IEU_RecordStartDateTime = rdi.RecordStartDateTime
				AND ISNULL(f.IEU_RecordEndDateTime, '1/1/1900') = ISNULL(rdi.RecordEndDateTime, '1/1/1900') 

			LEFT JOIN RDS.DimLeas rdl 
				ON f.LeaIdentifierState = rdl.LeaIdentifierSea
				AND f.LEA_RecordStartDateTime = rdl.RecordStartDateTime
				AND ISNULL(f.LEA_RecordEndDateTime, '1/1/1900') = ISNULL(rdl.RecordEndDateTime, '1/1/1900') 

			LEFT JOIN RDS.DimK12Schools dks
				ON dks.SchoolIdentifierSea = SchoolIdentifierState 

			LEFT JOIN RDS.DimPeople rdp
				ON f.StateStudentIdentifier = rdp.K12StudentStudentIdentifierState 
				AND rdp.IsActiveK12Student = 1

			LEFT JOIN RDS.DimRaces rdr 
				ON f.RaceCode = rdr.RaceCode

			LEFT JOIN RDS.DimAssessments rda
				ON f.AssessmentTypeCode = rda.AssessmentTypeCode
				AND f.AssessmentSubjectCode = rda.AssessmentTypeCode
				AND f.ParticipationStatusCode = rda.AssessmentAcademicSubjectCode
				AND f.AssessmentTypeAdministeredToEnglishLearnersCode = rda.AssessmentTypeAdministeredToEnglishLearnersCode

			LEFT JOIN RDS.DimAssessmentPerformanceLevels rdap
				ON f.PerformanceLevelCode = rdap.AssessmentPerformanceLevelIdentifier

			LEFT JOIN RDS.DimCteStatuses rdctes 
				ON  CASE f.CteAeDisplacedHomemakerIndicatorCode
						WHEN 'DH' THEN 'Yes'
						ELSE 'MISSING'
					END = rdctes.CteAeDisplacedHomemakerIndicatorCode
				AND CASE f.RepresentationStatusCode
						WHEN 'MEM' THEN 'Underrepresented'
						WHEN 'NM' THEN 'NotUnderrepresented'
						ELSE 'MISSING'
					END = rdctes.CteNontraditionalGenderStatusCode
				AND CASE f.CteNontraditionalGenderStatusCode
						WHEN 'NTE' THEN 'Yes'
						ELSE 'MISSING'
					END = rdctes.CteNontraditionalCompletionCode
				AND CASE f.SingleParentOrSinglePregnantWomanCode
						WHEN 'SPPT' THEN 'Yes'
						ELSE 'MISSING'
					END = rdctes.SingleParentOrSinglePregnantWomanStatusCode
				AND CASE f.CteGraduationRateInclusionCode
						WHEN 'GRAD' THEN 'IncludedAsGraduated'
						WHEN 'NOTG' THEN 'NotIncludedAsGraduated'
						ELSE 'MISSING'
					END = rdctes.CteGraduationRateInclusionCode
				AND CASE f.CteProgramCode 
						WHEN 'CTEPART' THEN 'Yes'
						WHEN 'NONCTEPART' THEN 'No'
						ELSE 'MISSING'
					END = rdctes.CteParticipantCode
				AND CASE f.CteProgramCode 
						WHEN 'CTECONC' THEN 'Yes'
						WHEN 'NONCTEPART' THEN 'No'
						ELSE 'MISSING'
					END = rdctes.CteConcentratorCode

			LEFT JOIN RDS.DimGradeLevels rdgl 
				ON f.GradeLevelCode = rdgl.GradeLevelCode

			LEFT JOIN RDS.DimIdeaStatuses rdis
				ON   rdis.SpecialEducationExitReasonCode = 'Missing' --Codes are the same
				AND CASE f.IdeaIndicatorCode
						WHEN 'IDEA' THEN 'Yes'
						ELSE 'MISSING'
					END = rdis.IdeaIndicatorCode
					AND rdis.IdeaEducationalEnvironmentForSchoolAgeCode = 'Missing'
				AND  rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = 'Missing'

			LEFT JOIN RDS.DimK12Demographics rdkdemo 
				ON f.SexCode = rdkdemo.SexCode

			LEFT JOIN RDS.DimNOrDStatuses rdnords
				ON  CASE f.NeglectedOrDelinquentProgramTypeCode
						WHEN 'ADLTCORR' THEN 'AdultCorrection'
						WHEN 'ATRISK' THEN 'AtRiskPrograms'
						WHEN 'JUVCORR' THEN 'JuvenileCorrection'
						WHEN 'JUVDET' THEN 'JuvenileDetention'
						WHEN 'NEGLECT' THEN 'NeglectedPrograms'
						WHEN 'OTHER' THEN 'OtherPrograms'
						ELSE 'MISSING'
					END = rdnords.NeglectedOrDelinquentProgramTypeCode

			LEFT JOIN RDS.DimTitleIIIStatuses rdtiiis
				ON  f.TitleiiiProgramParticipationCode = rdtiiis.ProgramParticipationTitleIIILiepCode
				AND f.TitleIIIImmigrantParticipationStatusCode = rdtiiis.TitleIIIImmigrantParticipationStatusCode
				AND f.ProficiencyStatusCode = rdtiiis.ProficiencyStatusCode
				AND f.TitleiiiAccountabilityProgressStatusCode = rdtiiis.TitleIIIAccountabilityProgressStatusCode
				AND f.TitleiiiLanguageInstructionCode = rdtiiis.TitleIIILanguageInstructionProgramTypeCode
        )

-- Insert and get the new table id from RDS.FactK12StudentDisciplines and the Race ID from CTE distinctFactRecords and insert it into @student_Assessment_xwalk 
        MERGE INTO RDS.FactK12StudentAssessments TARGET
		   USING distinctFactRecords AS distinctIDs
           ON TARGET.SchoolYearId = 0 --Set this to something that will not match
        WHEN NOT MATCHED THEN 
            INSERT ( [SchoolYearId]
				  ,[CountDateId]
				  ,[FactTypeId]
				  ,[SeaId]
				  ,[IeuId]
				  ,[LeaId]
				  ,[K12SchoolId]
				  ,[K12StudentId]
				  ,[AssessmentId]
				  ,[AssessmentSubtestId]
				  ,[AssessmentAdministrationId]
				  ,[AssessmentRegistrationId]
				  ,[AssessmentParticipationSessionId]
				  ,[AssessmentResultId]
				  ,[AssessmentPerformanceLevelId]
				  ,[CompetencyDefinitionId]
				  ,[CteStatusId]
				  ,[GradeLevelWhenAssessedId]
				  ,[IdeaStatusId]
				  ,[K12DemographicId]
				  ,[NOrDStatusId]
				  ,[TitleIIIStatusId]
				  ,[AssessmentCount]
				  ,[AssessmentResultScoreValueRawScore]
				  ,[AssessmentResultScoreValueScaleScore]
				  ,[AssessmentResultScoreValuePercentile]
				  ,[AssessmentResultScoreValueTScore]
				  ,[AssessmentResultScoreValueZScore]
				  ,[AssessmentResultScoreValueACTScore]
				  ,[AssessmentResultScoreValueSATScore]
				  ,[FactK12StudentAssessmentAccommodationId])  
						VALUES ( [SchoolYearId]
				  ,[CountDateId]
				  ,[FactTypeId]
				  ,[SeaId]
				  ,[IeuId]
				  ,[LeaId]
				  ,[K12SchoolId]
				  ,[K12StudentId]
				  ,[AssessmentId]
				  ,[AssessmentSubtestId]
				  ,[AssessmentAdministrationId]
				  ,[AssessmentRegistrationId]
				  ,[AssessmentParticipationSessionId]
				  ,[AssessmentResultId]
				  ,[AssessmentPerformanceLevelId]
				  ,[CompetencyDefinitionId]
				  ,[CteStatusId]
				  ,[GradeLevelWhenAssessedId]
				  ,[IdeaStatusId]
				  ,[K12DemographicId]
				  ,[NOrDStatusId]
				  ,[TitleIIIStatusId]
				  ,[AssessmentCount]
				  ,[AssessmentResultScoreValueRawScore]
				  ,[AssessmentResultScoreValueScaleScore]
				  ,[AssessmentResultScoreValuePercentile]
				  ,[AssessmentResultScoreValueTScore]
				  ,[AssessmentResultScoreValueZScore]
				  ,[AssessmentResultScoreValueACTScore]
				  ,[AssessmentResultScoreValueSATScore]
				  ,[FactK12StudentAssessmentAccommodationId])   
        OUTPUT	INSERTED.FactK12StudentAssessmentId
                ,distinctIDs.RaceID
        INTO @student_Assessment_xwalk (NewFactK12StudentAssessmentId, RaceId);

 -- Insert the new RDS.FactK12StudentDisciplines and raceID into RDS.BridgeK12StudentDiscplineRaces
         INSERT INTO RDS.BridgeK12StudentDisciplineRaces
        SELECT
            NewFactK12StudentAssessmentId,
            DimRaceId
        FROM @student_Assessment_xwalk xw
        JOIN RDS.DimRaces r
            On xw.RaceId = r.DimRaceId