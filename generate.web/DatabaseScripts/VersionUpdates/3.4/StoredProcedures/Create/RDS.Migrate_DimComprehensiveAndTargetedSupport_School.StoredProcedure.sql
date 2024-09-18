CREATE PROCEDURE [RDS].[Migrate_DimComprehensiveAndTargetedSupport_School]
	@orgDates as SchoolDateTableType READONLY
AS
BEGIN
	-- School Identifer
	declare @schoolIdentifierTypeId as int
	select @schoolIdentifierTypeId = RefOrganizationIdentifierTypeId
	from ods.RefOrganizationIdentifierType
	where [Code] = '001073'
	
	--School State Identifer
	declare @schoolSEAIdentificationSystemId as int
	select @schoolSEAIdentificationSystemId = RefOrganizationIdentificationSystemId
	from ods.RefOrganizationIdentificationSystem
	where [Code] = 'SEA'
	and RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId

	select org.DimCountDateId, s.DimSchoolId
	,isnull(cts.Code, 'MISSING') as ComprehensiveAndTargetedSupportCode,
		isnull(cs.Code, 'MISSING') as ComprehensiveSupportCode,
		isnull(ts.Code, 'MISSING') as TargetedSupportCode
	from @orgDates org
	inner join rds.DimSchools s on org.DimSchoolId = s.DimSchoolId 
	inner join ods.OrganizationIdentifier oi on s.SchoolStateIdentifier = oi.Identifier 
				and oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
				and oi.RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId
	inner join ods.K12School sch on  sch.OrganizationId = oi.OrganizationId
	inner join ods.K12SchoolStatus k12status on k12status.K12SchoolId = sch.K12SchoolId
				and	org.SubmissionYearStartDate <= isnull(k12status.RecordEndDateTime, getdate())
				and k12status.RecordStartDateTime <= org.SubmissionYearEndDate
	left join ods.RefComprehensiveAndTargetedSupport cts on cts.RefComprehensiveAndTargetedSupportId=k12status.RefComprehensiveAndTargetedSupportId
	left join ods.RefComprehensiveSupport cs on cs.RefComprehensiveSupportId=k12status.RefComprehensiveSupportId
	left join ods.RefTargetedSupport ts on ts.RefTargetedSupportId=k12status.RefTargetedSupportId
	group by s.DimSchoolId,  org.DimCountDateId, k12status.RecordStartDateTime, cts.Code, cs.Code, ts.Code
	having (k12status.RecordStartDateTime = max(k12status.RecordStartDateTime))
END