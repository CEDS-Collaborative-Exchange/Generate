



--Migrate_DimTitle1Statuses
 CREATE PROCEDURE [RDS].[Migrate_DimTitle1Statuses_School]
	@orgDates as SchoolDateTableType READONLY
AS
BEGIN

	

	declare @TitleISchoolStatusQuery as table (
		
		DimSchoolId int,
		SchoolOrgId int,		
		DimCountDateId int,
		TitleISchoolStatusCode varchar(50)
	)

	insert into @TitleISchoolStatusQuery
	(		
		DimSchoolId,
		SchoolOrgId,
		DimCountDateId,
		TitleISchoolStatusCode
	)
	select d.DimSchoolId,
		sch.OrganizationId,		
		d.DimCountDateId,
		isnull(title1Status.Code, 'MISSING')
	from ods.K12SchoolStatus schStatus
			inner join ods.K12School sch on schStatus.K12SchoolId = sch.K12SchoolId
			inner join @orgDates d on d.SchoolOrganizationId = sch.OrganizationId
			left outer join ods.RefTitleISchoolStatus title1Status on schStatus.RefTitleISchoolStatusId = title1Status.RefTitle1SchoolStatusId

	
	declare @Title1InstructionalServiceQuery as table (
		DimSchoolId int,
		SchoolOrgId int,		
		DimCountDateId int,
		TitleIinstructionalServiceCode varchar(50),
		Title1ProgramTypeCode varchar(50)
	)
	insert into @Title1InstructionalServiceQuery
	(		
		DimSchoolId,
		SchoolOrgId,
		DimCountDateId,
		TitleIinstructionalServiceCode,
		Title1ProgramTypeCode

	)
	SELECT 
		d.DimSchoolId,
		sch.OrganizationId,		
		d.DimCountDateId,	
		isnull(instrlSrvc.Code,'MISSING'),
		isnull(prgType.Code,'MISSING')
	from  @orgDates d
	inner join ods.K12School sch on sch.OrganizationId = d.SchoolOrganizationId
	inner join ods.K12programOrService ps on ps.OrganizationId = sch.OrganizationId	
	left outer join ods.RefTitleIinstructionalServices instrlSrvc on instrlSrvc.RefTitleIInstructionalServicesId = ps.RefTitleIInstructionalServicesId
	left outer join ods.RefTitleIProgramType prgType on prgType.RefTitleIProgramTypeId = ps.RefTitleIProgramTypeId	
	
			
	declare @Title1SupportServiceQuery as table (
		DimSchoolId int,
		SchoolOrgId int,		
		DimCountDateId int,
		Title1SupportServiceCode varchar(50)
	)
	insert into @Title1SupportServiceQuery
	(
		DimSchoolId,
		SchoolOrgId,
		DimCountDateId,
		Title1SupportServiceCode
	)
	SELECT 
		d.DimSchoolId,
		sch.OrganizationId,		
		d.DimCountDateId,	
		isnull(srvc.Code,'MISSING')
	from @orgDates d	
	inner join ods.K12School sch on d.SchoolOrganizationId = sch.OrganizationId
	inner join ods.K12LeaTitleISupportService tss on tss.OrganizationId = sch.OrganizationId
	left outer join ods.RefK12LeaTitleISupportService srvc on srvc.RefK12LEATitleISupportServiceId = tss.RefK12LEATitleISupportServiceId	

	
	-- Return results

	select distinct
		d.DimCountDateId,
		d.DimSchoolId,
		isnull(tssq.TitleISchoolStatusCode, 'MISSING') as TitleISchoolStatusCode,
		isnull(tisq.TitleIinstructionalServiceCode, 'MISSING') as TitleIinstructionalServiceCode,
		isnull(tsprtq.Title1SupportServiceCode, 'MISSING') as Title1SupportServiceCode,
		isnull(tisq.Title1ProgramTypeCode , 'MISSING') as Title1ProgramTypeCode		
	from @orgDates d		
	left outer join @TitleISchoolStatusQuery tssq on tssq.SchoolOrgId = d.SchoolOrganizationId 
	left outer join @Title1InstructionalServiceQuery tisq on tisq.SchoolOrgId = d.SchoolOrganizationId 
	left outer join @Title1SupportServiceQuery tsprtq on tsprtq.SchoolOrgId = d.SchoolOrganizationId 
	
END	

