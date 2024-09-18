--Migrate_DimTitle1Statuses
 CREATE PROCEDURE [RDS].[Migrate_DimTitle1Statuses_School]
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
		oi.OrganizationId,		
		d.DimCountDateId,
		isnull(title1Status.Code, 'MISSING')
	from ods.K12SchoolStatus schStatus
			inner join ods.K12School sch on schStatus.K12SchoolId = sch.K12SchoolId			
			inner join ods.OrganizationIdentifier oi on sch.OrganizationId = oi.OrganizationId 
					and oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId 
			inner join rds.DimSchools s on oi.Identifier = s.SchoolStateIdentifier
			inner join @orgDates d on s.DimSchoolId = d.DimSchoolId
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
		oi.OrganizationId,		
		d.DimCountDateId,	
		isnull(instrlSrvc.Code,'MISSING'),
		isnull(prgType.Code,'MISSING')
	from  @orgDates d
	inner join rds.DimSchools s on d.DimSchoolId = s.DimSchoolId
	inner join ods.OrganizationIdentifier oi on s.SchoolStateIdentifier = oi.Identifier
				and oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId 
	inner join ods.K12School sch on sch.OrganizationId = oi.OrganizationId
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
		oi.OrganizationId,		
		d.DimCountDateId,	
		isnull(srvc.Code,'MISSING')
	from @orgDates d	
	inner join rds.DimSchools s on d.DimSchoolId = s.DimSchoolId
	inner join ods.OrganizationIdentifier oi on s.SchoolStateIdentifier = oi.Identifier
			and oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
	inner join ods.K12School sch on oi.OrganizationId = sch.OrganizationId	
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
	inner join rds.DimSchools s on d.DimSchoolId = s.DimSchoolId
	inner join ods.OrganizationIdentifier oi on s.SchoolStateIdentifier = oi.Identifier		
			and oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
	left outer join @TitleISchoolStatusQuery tssq on tssq.SchoolOrgId = oi.OrganizationId
	left outer join @Title1InstructionalServiceQuery tisq on tisq.SchoolOrgId = oi.OrganizationId
	left outer join @Title1SupportServiceQuery tsprtq on tsprtq.SchoolOrgId = oi.OrganizationId 
	
END
GO


