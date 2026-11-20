CREATE PROCEDURE [RDS].[Migrate_DimOrganizationStatuses_Lea]
	@organizationDates AS [RDS].[LeaDateTableType] READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN

	SELECT 
		  o.DimLeaId
		, o.DimSchoolYearId
		, ISNULL(reap.Code,'MISSING') AS REAPAlternativeFundingStatusCode
		, CASE 
			WHEN gunFree.Code = 'YesReportingOffenses'	THEN 'YESWITHREP' 
			WHEN gunFree.Code = 'YesNoReportedOffenses' THEN 'YESWOREP'
			WHEN gunFree.Code = 'No' THEN 'No' 
			WHEN gunFree.Code ='NA' THEN 'NA' 
			ELSE 'MISSING' 
		  END AS 'GunFreeStatusCode'
		, 'MISSING' AS GraduationRateCode
		, CASE 
			WHEN MKgrant.FederalProgramCode = '84.196'	THEN 'YES' 
			ELSE 'NO'  
		  END AS McKinneyVentoSubgrantRecipient
	FROM @organizationDates o
	JOIN rds.DimLeas dl 
		ON dl.DimLeaID = o.DimLeaId 
		AND dl.RecordStartDateTime <= o.SessionEndDate 
		AND ((dl.RecordEndDateTime >= o.SessionBeginDate) 
		OR dl.RecordEndDateTime IS NULL)
	LEFT JOIN dbo.OrganizationFederalAccountability fa 
		ON dl.LeaOrganizationId = fa.OrganizationId
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
					ON reapAlt.RefReapAlternativeFundingStatusId = k12federalFund.RefReapAlternativeFundingStatusId										
				WHERE (@dataCollectionId IS NULL 
					OR s.DataCollectionId = @dataCollectionId)	
			) reap 
		ON reap.OrganizationId = dl.LeaOrganizationId 
		AND ((reap.BeginDate BETWEEN o.SessionBeginDate AND o.SessionEndDate) 
			OR (reap.EndDate BETWEEN o.SessionBeginDate AND o.SessionEndDate))
	LEFT JOIN (
				SELECT 
					  oc.OrganizationId
					, fa.federalprogramcode
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
				LEFT JOIN dbo.OrganizationFinancial f 
					ON f.OrganizationCalendarSessionId = s.OrganizationCalendarSessionId
					AND (@dataCollectionId IS NULL 
						OR f.DataCollectionId = @dataCollectionId)	
				LEFT JOIN dbo.FinancialAccount fa 
					ON fa.FinancialAccountId = f.FinancialAccountId 
					AND fa.FederalProgramCode = '84.196'	
					AND (@dataCollectionId IS NULL 
						OR fa.DataCollectionId = @dataCollectionId)	
				WHERE (@dataCollectionId IS NULL 
					OR oc.DataCollectionId = @dataCollectionId)	
			) MKgrant 
		ON MKgrant.OrganizationId = dl.LeaOrganizationId
		AND ((MKgrant.BeginDate BETWEEN o.SessionBeginDate AND o.SessionEndDate) 
			OR (MKgrant.EndDate BETWEEN o.SessionBeginDate AND o.SessionEndDate))
END