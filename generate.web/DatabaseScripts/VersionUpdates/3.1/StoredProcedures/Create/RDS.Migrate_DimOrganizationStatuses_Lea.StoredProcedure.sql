CREATE PROCEDURE [RDS].[Migrate_DimOrganizationStatuses_Lea]
	@organizationDates as [RDS].[LeaDateTableType] READONLY	
AS
BEGIN

SELECT 
 o.DimLeaId,
 DimCountDateId,
		ISNULL(reap.Code,'MISSING') as REAPAlternativeFundingStatusCode,
		
		case when gunFree.Code = 'YesReportingOffenses'	THEN 'YESWITHREP' 
			 when gunFree.Code = 'YesNoReportedOffenses'	THEN 'YESWOREP'
			 when gunFree.Code = 'No'	THEN 'No' 
			 when gunFree.Code ='NA' then 'NA' 
			 else 'MISSING' END as 'GunFreeStatusCode'
from @organizationDates o
inner join rds.DimLeas dl on dl.DimLeaID = o.DimLeaId
left join ods.OrganizationFederalAccountability fa on dl.LeaOrganizationId = fa.OrganizationId
left join ods.RefGunFreeSchoolsActReportingStatus gunFree on gunFree.RefGunFreeSchoolsActStatusReportingId = fa.RefGunFreeSchoolsActStatusReportingId
left join ods.RefHighSchoolGraduationRateIndicator refHighSchoolGraduation on refHighSchoolGraduation.RefHSGraduationRateIndicatorId = fa.RefHighSchoolGraduationRateIndicator
left join 
		(
			select oc.OrganizationId, reapAlt.Code from ods.OrganizationCalendar oc
			inner join ods.OrganizationCalendarSession s on s.OrganizationCalendarId = oc.OrganizationCalendarId
			inner join ods.RefSessionType rst on rst.RefSessionTypeId = s.RefSessionTypeId and rst.Code='FullSchoolYear'
			inner join ods.K12FederalFundAllocation k12federalFund on k12federalFund.OrganizationCalendarSessionId = s.OrganizationCalendarSessionId 
			left join ods.RefReapAlternativeFundingStatus reapAlt on reapAlt.RefReapAlternativeFundingStatusId=k12federalFund.RefReapAlternativeFundingStatusId										
		) reap on reap.OrganizationId = dl.LeaOrganizationId
END

