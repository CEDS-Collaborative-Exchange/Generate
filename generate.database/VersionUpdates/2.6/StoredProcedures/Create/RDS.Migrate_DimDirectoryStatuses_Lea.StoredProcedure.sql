CREATE PROCEDURE [RDS].[Migrate_DimDirectoryStatuses_Lea]
	@organizationDates as [RDS].[LeaDateTableType] READONLY	
AS
BEGIN

SELECT 
 o.DimLeaId,
 DimCountDateId,
 case when l.CharterSchoolIndicator is null then 'MISSING'
			 when l.CharterSchoolIndicator = 1 then 'YES'
			 When l.CharterSchoolIndicator = 0 then 'NO'
		END as 'CharterLeaStatusCode',

		case when s.CharterSchoolIndicator is null then 'MISSING'
			 when s.CharterSchoolIndicator = 1 then 'YES'
			 When s.CharterSchoolIndicator = 0 then 'NO'
		END as 'CharterSchoolStatusCode',
		isnull(r.Code, 'MISSING') as 	'ReconstitutedStatusCode',
		isnull(refOP.Code, 'MISSING') as OperationalStatusCode,

		isnull(updatedRefOP.Code, 'MISSING') as 'UpdatedOperationalStatusCode',

		case when MKgrant.FederalProgramCode = '84.196'	THEN 'YES' 
			ELSE 'NO'  END as 'McKinneyVentoSubgrantRecipient'


from @organizationDates o
inner join rds.DimLeas dl on dl.DimLeaID = o.DimLeaId
inner join ods.K12Lea l on dl.LeaOrganizationId = l.OrganizationId
left join ods.k12school s on s.OrganizationId = dl.LeaOrganizationId
left join ods.OrganizationFederalAccountability fa on dl.LeaOrganizationId = fa.OrganizationId
left join ods.RefReconstitutedStatus r on r.RefReconstitutedStatusId = fa.RefReconstitutedStatusId
left join ods.OrganizationOperationalStatus op on op.OrganizationId = dl.LeaOrganizationId
left join ods.RefOperationalStatus refOP on op.RefOperationalStatusId = refOP.RefOperationalStatusId
left  join ods.OrganizationOperationalStatus updatedOp on updatedOp.OrganizationId = dl.LeaOrganizationId
			and updatedOp.OperationalStatusEffectiveDate > o.SubmissionYearStartDate and updatedOp.OperationalStatusEffectiveDate < o.SubmissionYearEndDate
left join  ods.RefOperationalStatus updatedRefOP on updatedOp.RefOperationalStatusId = updatedRefOP.RefOperationalStatusId

left join 
		(
			select oc.OrganizationId, fa.federalprogramcode, s.BeginDate, s.EndDate from ods.OrganizationCalendar oc
			inner join ods.OrganizationCalendarSession s on s.OrganizationCalendarId = oc.OrganizationCalendarId															
			inner join ods.RefSessionType rst on rst.RefSessionTypeId = s.RefSessionTypeId and rst.Code='FullSchoolYear'
			left join ods.OrganizationFinancial f on f.OrganizationCalendarSessionId = s.OrganizationCalendarSessionId
			left join ods.FinancialAccount fa on fa.FinancialAccountId = f.FinancialAccountId and fa.FederalProgramCode = '84.196'	
									
		) MKgrant on MKgrant.OrganizationId = l.OrganizationId
					--and MKgrant.BeginDate = o.SubmissionYearStartDate and MKgrant.EndDate = o.SubmissionYearEndDate

END

