-- =============================================
-- Author:		Andy Tsovma
-- Create date: 12/14/2018
-- Description:	migrate DimComprehensiveAndTargetedSupport
-- =============================================
CREATE PROCEDURE rds.Migrate_DimComprehensiveAndTargetedSupport_School
	@orgDates as SchoolDateTableType READONLY
AS
BEGIN
	select org.DimCountDateId, s.DimSchoolId--, k12status.K12SchoolStatusId, sch.OrganizationId
	,isnull(cts.Code, 'MISSING') as ComprehensiveAndTargetedSupportCode,
		isnull(cs.Code, 'MISSING') as ComprehensiveSupportCode,
		isnull(ts.Code, 'MISSING') as TargetedSupportCode
	from ods.K12SchoolStatus k12status
	inner join ods.K12School sch on k12status.K12SchoolId = sch.K12SchoolId
	inner join rds.DimSchools s on s.SchoolOrganizationId = sch.OrganizationId
	inner join @orgDates org on org.DimSchoolId = s.DimSchoolId 
	and
	org.SubmissionYearStartDate <= isnull(k12status.RecordEndDateTime, getdate())
	and k12status.RecordStartDateTime <= org.SubmissionYearEndDate
	left join ods.RefComprehensiveAndTargetedSupport cts on cts.RefComprehensiveAndTargetedSupportId=k12status.RefComprehensiveAndTargetedSupportId
	left join ods.RefComprehensiveSupport cs on cs.RefComprehensiveSupportId=k12status.RefComprehensiveSupportId
	left join ods.RefTargetedSupport ts on ts.RefTargetedSupportId=k12status.RefTargetedSupportId
	group by s.DimSchoolId,  org.DimCountDateId, k12status.RecordStartDateTime, cts.Code, cs.Code, ts.Code --, k12status.K12SchoolStatusId, sch.OrganizationId
	having (k12status.RecordStartDateTime = max(k12status.RecordStartDateTime))
END