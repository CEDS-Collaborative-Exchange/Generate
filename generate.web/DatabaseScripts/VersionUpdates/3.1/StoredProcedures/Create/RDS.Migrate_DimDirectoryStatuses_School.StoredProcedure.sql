CREATE PROCEDURE [RDS].[Migrate_DimDirectoryStatuses_School]
	 @organizationDates as [RDS].[SchoolDateTableType]  READONLY
AS
BEGIN

SELECT 
 ds.DimSchoolId,
 DimCountDateId,
 'MISSING' as CharterLeaStatusCode,
 case when s.CharterSchoolIndicator is null then 'MISSING'
	  when s.CharterSchoolIndicator = 1 then 'YES'
      When s.CharterSchoolIndicator = 0 then 'NO'
		END as 'CharterSchoolStatusCode',
		isnull(r.Code, 'MISSING') as 	'ReconstitutedStatusCode',
		isnull(refOP.Code, 'MISSING') as OperationalStatusCode,

		isnull(updatedRefOP.Code, 'MISSING') as 'UpdatedOperationalStatusCode'

from @organizationDates d
inner join rds.DimSchools ds on ds.DimSchoolId = d.DimSchoolId
left join ods.k12school s on s.OrganizationId = ds.SchoolOrganizationId
left join ods.OrganizationFederalAccountability fa on ds.SchoolOrganizationId = fa.OrganizationId
left join ods.RefReconstitutedStatus r on r.RefReconstitutedStatusId = fa.RefReconstitutedStatusId
left join ods.OrganizationOperationalStatus op on op.OrganizationId = ds.SchoolOrganizationId
left join ods.RefOperationalStatus refOP on op.RefOperationalStatusId = refOP.RefOperationalStatusId
left join ods.RefOperationalStatusType refost on refOP.RefOperationalStatusTypeId = refost.RefOperationalStatusTypeId
left  join ods.OrganizationOperationalStatus updatedOp on updatedOp.OrganizationId = ds.SchoolOrganizationId
			and updatedOp.OperationalStatusEffectiveDate > d.SubmissionYearStartDate and updatedOp.OperationalStatusEffectiveDate < d.SubmissionYearEndDate
left join  ods.RefOperationalStatus updatedRefOP on updatedOp.RefOperationalStatusId = updatedRefOP.RefOperationalStatusId
left join ods.RefOperationalStatusType updatedrefost on updatedRefOP.RefOperationalStatusTypeId = updatedrefost.RefOperationalStatusTypeId
Where (refost.Code is NULL or refost.Code = '000533') AND (updatedrefost.Code is NULL or updatedrefost.Code = '000533')

END

