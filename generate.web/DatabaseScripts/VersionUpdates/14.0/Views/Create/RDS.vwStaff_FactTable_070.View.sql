CREATE VIEW [RDS].[vwStaff_FactTable_070] 
AS
	SELECT	f.[K12StaffStaffMemberIdentifierState]
      		, f.[LeaIdentifierSea]
      		, f.[LeaIdentifierNces]
      		, f.[LeaOrganizationName]
      		, f.[SchoolIdentifierSea]
      		, f.[NameOfInstitution]
      		, f.[SpecialEducationAgeGroupTaughtEdFactsCode]
	  		, CASE
            	WHEN f.[EdFactsCertificationStatusEdFactsCode] = 'FC' THEN 'SPEDTCHFULCRT'
            	ELSE 'SPEDTCHNFULCRT'
          	  END AS SpecialEducationCertificationStatusEdFactsCode
      		, f.[HighlyQualifiedTeacherIndicatorEdFactsCode]
      		, f.[EdFactsTeacherInexperiencedStatusEdFactsCode]
      		, f.[TeachingCredentialTypeEdFactsCode]
      		, f.[EdFactsTeacherOutOfFieldStatusEdFactsCode]
      		, f.[SpecialEducationTeacherQualificationStatusEdFactsCode]
      		, f.[ParaprofessionalQualificationStatusEdFactsCode]
      		, f.[K12StaffClassificationEdFactsCode]
      		, f.[SpecialEducationSupportServicesCategoryEdFactsCode]
      		, f.[TitleIProgramStaffCategoryEdFactsCode]
      		, f.[StaffCount]
      		, f.[StaffFullTimeEquivalency]
	FROM [debug].[vwK12Staff_FactTable] f
  	WHERE [StaffFullTimeEquivalency] > 0
