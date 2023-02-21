CREATE PROCEDURE [RDS].[Migrate_DimOrganizationStatuses_Lea]
	@organizationDates as [RDS].[LeaDateTableType] READONLY	
AS
BEGIN

	--LEA Identifier
	declare @leaIdentifierTypeId as int
	select @leaIdentifierTypeId = RefOrganizationIdentifierTypeId			
	from ods.RefOrganizationIdentifierType
	where [Code] = '001072'

	--LEA State Identifer
	declare @leaSEAIdentificationSystemId as int
	select @leaSEAIdentificationSystemId = RefOrganizationIdentificationSystemId
	from ods.RefOrganizationIdentificationSystem
	where [Code] = 'SEA'
	and RefOrganizationIdentifierTypeId = @leaIdentifierTypeId

SELECT 
 o.DimLeaId,
 DimCountDateId,
ISNULL(reap.Code,'MISSING') as REAPAlternativeFundingStatusCode,
case when gunFree.Code = 'YesReportingOffenses'	THEN 'YESWITHREP' 
			 when gunFree.Code = 'YesNoReportedOffenses' THEN 'YESWOREP'
			 when gunFree.Code = 'No' THEN 'No' 
			 when gunFree.Code ='NA' THEN 'NA' 
			 else 'MISSING' END as 'GunFreeStatusCode',
 'MISSING' as GraduationRateCode,
case when MKgrant.FederalProgramCode = '84.196'	THEN 'YES' ELSE 'NO'  END as McKinneyVentoSubgrantRecipient
from @organizationDates o
inner join rds.DimLeas dl on dl.DimLeaID = o.DimLeaId
and dl.RecordStartDateTime <= o.SubmissionYearEndDate 
and ((dl.RecordEndDateTime >= o.SubmissionYearStartDate) OR dl.RecordEndDateTime IS NULL)
left join ods.OrganizationIdentifier oi on dl.LeaStateIdentifier = oi.Identifier
		and oi.RefOrganizationIdentificationSystemId = @leaSEAIdentificationSystemId
left join ods.OrganizationFederalAccountability fa on oi.OrganizationId = fa.OrganizationId
left join ods.RefGunFreeSchoolsActReportingStatus gunFree on gunFree.RefGunFreeSchoolsActStatusReportingId = fa.RefGunFreeSchoolsActStatusReportingId
left join ods.RefHighSchoolGraduationRateIndicator refHighSchoolGraduation on refHighSchoolGraduation.RefHSGraduationRateIndicatorId = fa.RefHighSchoolGraduationRateIndicator
left join 
		(
			select oc.OrganizationId, reapAlt.Code, s.BeginDate, s.EndDate from ods.OrganizationCalendar oc
			inner join ods.OrganizationCalendarSession s on s.OrganizationCalendarId = oc.OrganizationCalendarId
			inner join ods.RefSessionType rst on rst.RefSessionTypeId = s.RefSessionTypeId and rst.Code='FullSchoolYear'
			inner join ods.K12FederalFundAllocation k12federalFund on k12federalFund.OrganizationCalendarSessionId = s.OrganizationCalendarSessionId 
			left join ods.RefReapAlternativeFundingStatus reapAlt on reapAlt.RefReapAlternativeFundingStatusId=k12federalFund.RefReapAlternativeFundingStatusId										
		) reap on reap.OrganizationId = oi.OrganizationId 
		and ((reap.BeginDate between o.SubmissionYearStartDate and o.SubmissionYearEndDate) OR (reap.EndDate between o.SubmissionYearStartDate and o.SubmissionYearEndDate))
left join (
			select oc.OrganizationId, fa.federalprogramcode, s.BeginDate, s.EndDate 
			from ods.OrganizationCalendar oc
			inner join ods.OrganizationCalendarSession s on s.OrganizationCalendarId = oc.OrganizationCalendarId															
			inner join ods.RefSessionType rst on rst.RefSessionTypeId = s.RefSessionTypeId and rst.Code='FullSchoolYear'
			left join ods.OrganizationFinancial f on f.OrganizationCalendarSessionId = s.OrganizationCalendarSessionId
			left join ods.FinancialAccount fa on fa.FinancialAccountId = f.FinancialAccountId and fa.FederalProgramCode = '84.196'	
									
		) MKgrant on MKgrant.OrganizationId = oi.OrganizationId
					and ((MKgrant.BeginDate between o.SubmissionYearStartDate and o.SubmissionYearEndDate) OR (MKgrant.EndDate between o.SubmissionYearStartDate and o.SubmissionYearEndDate))
END