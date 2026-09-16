CREATE PROCEDURE [RDS].[Migrate_DimOrganizationStatuses_School]
	 @organizationDates AS [RDS].[SchoolDateTableType]  READONLY,
	 @dataCollectionId AS INT = NULL
AS
BEGIN

	SELECT 
		  ds.DimK12SchoolId
		, DimSchoolYearId
		, 'MISSING' AS REAPAlternativeFundingStatusCode
		, CASE 
			WHEN gunFree.Code = 'YesReportingOffenses'	THEN 'YESWITHREP' 
			WHEN gunFree.Code = 'YesNoReportedOffenses'	THEN 'YESWOREP'
			WHEN gunFree.Code = 'No'	THEN 'No' 
			WHEN gunFree.Code ='NA' THEN 'NA' 
			ELSE 'MISSING' 
		  END AS 'GunFreeStatusCode'
		, CASE 
			WHEN refHighSchoolGraduation.Code IS NULL THEN 'MISSING'
			WHEN refHighSchoolGraduation.Code ='MetGoal'  THEN 'STTDEF'
			WHEN refHighSchoolGraduation.Code ='TooFewStudents'  THEN 'TOOFEW'
			WHEN refHighSchoolGraduation.Code ='NoStudents'  THEN 'NOSTUDENTS'
		  END AS 'GraduationRateCode'
		,'MISSING' as McKinneyVentoSubgrantRecipient
	FROM @organizationDates d
	JOIN rds.DimK12Schools ds 
		ON ds.DimK12SchoolId = d.DimSchoolId 
		AND ds.RecordEndDateTime IS NULL
	LEFT JOIN dbo.OrganizationFederalAccountability fa 
		ON ds.SchoolOrganizationId = fa.OrganizationId
		AND (@dataCollectionId IS NULL 
			OR fa.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.RefGunFreeSchoolsActReportingStatus gunFree 
		ON gunFree.RefGunFreeSchoolsActReportingStatusId = fa.RefGunFreeSchoolsActReportingStatusId
	LEFT JOIN dbo.RefHighSchoolGraduationRateIndicator refHighSchoolGraduation 
		ON refHighSchoolGraduation.RefHighSchoolGraduationRateIndicatorId = fa.RefHighSchoolGraduationRateIndicatorId
	LEFT JOIN 
			(
				SELECT 
					  oc.OrganizationId
					, reapAlt.Code
					, s.BeginDate
					, s.EndDate 
				FROM dbo.OrganizationCalendar oc
				JOIN dbo.OrganizationCalendarSession s 
					ON s.OrganizationCalendarId = oc.OrganizationCalendarId
					AND (@dataCollectionId IS NULL 
						OR s.DataCollectionId = @dataCollectionId)	
				JOIN dbo.RefSessionType rst 
					ON rst.RefSessionTypeId = s.RefSessionTypeId 
					AND rst.Code='FullSchoolYear'
				JOIN dbo.K12FederalFundAllocation k12federalFund 
					ON k12federalFund.OrganizationCalendarSessionId = s.OrganizationCalendarSessionId 
					AND (@dataCollectionId IS NULL 
						OR k12federalFund.DataCollectionId = @dataCollectionId)	
				LEFT JOIN dbo.RefReapAlternativeFundingStatus reapAlt 
					ON reapAlt.RefReapAlternativeFundingStatusId=k12federalFund.RefReapAlternativeFundingStatusId										
				WHERE (@dataCollectionId IS NULL 
					OR oc.DataCollectionId = @dataCollectionId)	
			) reap 
		ON reap.OrganizationId =  ds.SchoolOrganizationId
		AND reap.BeginDate between d.SubmissionYearStartDate and d.SubmissionYearEndDate

END