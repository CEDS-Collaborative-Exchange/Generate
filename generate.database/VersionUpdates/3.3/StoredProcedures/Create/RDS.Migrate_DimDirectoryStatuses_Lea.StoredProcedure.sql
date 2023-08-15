CREATE PROCEDURE [RDS].[Migrate_DimDirectoryStatuses_Lea]
	@organizationDates as [RDS].[LeaDateTableType] READONLY	
AS
BEGIN

declare @charterLeaCount as int

select @charterLeaCount = count(OrganizationId) from ods.K12Lea where CharterSchoolIndicator = 1

SELECT 
 o.DimLeaId,
 DimCountDateId,
 case when l.CharterSchoolIndicator = 1 AND leaType.Code = 'RegularNotInSupervisoryUnion' then isnull(cl.Code, 'MISSING')
	  else IIF(@charterLeaCount > 0,'NOTCHR','NA')
 end as CharterLeaStatusCode,
'MISSING' as CharterSchoolStatusCode,
isnull(r.Code, 'MISSING') as 	ReconstitutedStatusCode,
isnull(refOP.Code, 'MISSING') as OperationalStatusCode,
isnull(updatedRefOP.Code, 'MISSING') as UpdatedOperationalStatusCode,
case when MKgrant.FederalProgramCode = '84.196'	THEN 'YES' ELSE 'NO'  END as McKinneyVentoSubgrantRecipient
from @organizationDates o
inner join rds.DimLeas dl on dl.DimLeaID = o.DimLeaId
inner join ods.K12Lea l on dl.LeaOrganizationId = l.OrganizationId
left join ods.RefCharterLeaStatus cl on l.RefCharterLeaStatusId = cl.RefCharterLeaStatusId
left join ods.RefLeaType leaType on l.RefLeaTypeId = leaType.RefLeaTypeId
left join ods.OrganizationFederalAccountability fa on dl.LeaOrganizationId = fa.OrganizationId
left join ods.RefReconstitutedStatus r on r.RefReconstitutedStatusId = fa.RefReconstitutedStatusId
left join ods.OrganizationOperationalStatus op on op.OrganizationId = dl.LeaOrganizationId
left join ods.RefOperationalStatus refOP on op.RefOperationalStatusId = refOP.RefOperationalStatusId
left join ods.RefOperationalStatusType refost on refOP.RefOperationalStatusTypeId = refost.RefOperationalStatusTypeId
left  join ods.OrganizationOperationalStatus updatedOp on updatedOp.OrganizationId = dl.LeaOrganizationId
			and updatedOp.OperationalStatusEffectiveDate > o.SubmissionYearStartDate and updatedOp.OperationalStatusEffectiveDate < o.SubmissionYearEndDate
left join  ods.RefOperationalStatus updatedRefOP on updatedOp.RefOperationalStatusId = updatedRefOP.RefOperationalStatusId
left join ods.RefOperationalStatusType updatedrefost on updatedRefOP.RefOperationalStatusTypeId = updatedrefost.RefOperationalStatusTypeId
left join 
		(
			select oc.OrganizationId, fa.federalprogramcode, s.BeginDate, s.EndDate from ods.OrganizationCalendar oc
			inner join ods.OrganizationCalendarSession s on s.OrganizationCalendarId = oc.OrganizationCalendarId															
			inner join ods.RefSessionType rst on rst.RefSessionTypeId = s.RefSessionTypeId and rst.Code='FullSchoolYear'
			left join ods.OrganizationFinancial f on f.OrganizationCalendarSessionId = s.OrganizationCalendarSessionId
			left join ods.FinancialAccount fa on fa.FinancialAccountId = f.FinancialAccountId and fa.FederalProgramCode = '84.196'	
									
		) MKgrant on MKgrant.OrganizationId = l.OrganizationId
					and ((MKgrant.BeginDate between o.SubmissionYearStartDate and o.SubmissionYearEndDate) OR (MKgrant.EndDate between o.SubmissionYearStartDate and o.SubmissionYearEndDate))
Where (refost.Code is NULL or refost.Code = '000174') AND (updatedrefost.Code is NULL or updatedrefost.Code = '000174')
END
