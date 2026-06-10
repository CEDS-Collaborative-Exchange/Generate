CREATE PROCEDURE [RDS].[Migrate_DimTitleIStatuses]
	@studentDates AS RDS.K12StudentDateTableType READONLY,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN

	DECLARE @k12StudentRoleId AS INT
	DECLARE @schoolOrganizationTypeId AS INT
	SELECT @k12StudentRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Student'
	SELECT @schoolOrganizationTypeId = RefOrganizationTypeId FROM dbo.RefOrganizationType WHERE code = 'K12School'

	SELECT DISTINCT
		  s.DimK12StudentId
		, org.DimK12SchoolId
		, org.DimLeaId
		, org.DimSeaId
		, s.PersonId
		, s.DimCountDateId
		, ISNULL(title1Status.Code, 'MISSING') AS TitleISchoolStatusCode
		, ISNULL(instrlSrvc.Code,'MISSING') AS TitleIinstructionalServiceCode
		, ISNULL(srvc.Code,'MISSING') AS Title1SupportServiceCode
		, ISNULL(prgType.Code,'MISSING') AS Title1ProgramTypeCode		
	FROM @studentDates s
	JOIN @studentOrganizations org
		ON s.DimK12StudentId = org.DimK12StudentId
		AND s.DimCountDateId = org.DimCountDateId
	JOIN dbo.OrganizationPersonRole r ON r.PersonId = s.PersonId
		AND (@dataCollectionId IS NULL 
			OR r.DataCollectionId = @dataCollectionId)	
		AND r.RoleId = @k12StudentRoleId 
		AND r.OrganizationId = IIF(org.K12SchoolOrganizationId > 0 , org.K12SchoolOrganizationId, org.LeaOrganizationId)
		AND s.CountDate BETWEEN r.EntryDate AND ISNULL(r.ExitDate, getdate())
	JOIN dbo.OrganizationRelationship ore 
		ON r.OrganizationId = ore.OrganizationId
		AND (@dataCollectionId IS NULL 
			OR ore.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.K12School sch 
		ON org.K12SchoolOrganizationId = sch.OrganizationId
		AND (@dataCollectionId IS NULL 
			OR sch.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.K12SchoolStatus t1schStatus 
		ON t1schStatus.K12SchoolId = sch.K12SchoolId
		AND (@dataCollectionId IS NULL 
			OR t1schStatus.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.RefTitleISchoolStatus title1Status 
		ON t1schStatus.RefTitleISchoolStatusId = title1Status.RefTitleISchoolStatusId
	LEFT JOIN dbo.K12programOrService ps 
		ON ps.OrganizationId = ore.Parent_OrganizationId
		AND (@dataCollectionId IS NULL 
			OR ps.DataCollectionId = @dataCollectionId)	
		AND ps.RecordStartDateTime <= s.SessionEndDate 
		AND (ps.RecordEndDateTime >=  s.SessionBeginDate 
			OR ps.RecordEndDateTime IS NULL)	
	LEFT JOIN dbo.RefTitleIinstructionalServices instrlSrvc 
		ON instrlSrvc.RefTitleIInstructionalServicesId = ps.RefTitleIInstructionalServicesId
	LEFT JOIN dbo.K12programOrService ps2 
		ON ps2.OrganizationId = ore.Parent_OrganizationId	
		AND (@dataCollectionId IS NULL 
			OR ps2.DataCollectionId = @dataCollectionId)	
		AND ps2.RecordStartDateTime <= s.SessionEndDate AND (ps2.RecordEndDateTime >=  s.SessionBeginDate OR ps2.RecordEndDateTime IS NULL)	
	LEFT JOIN dbo.RefTitleIProgramType prgType 
		ON prgType.RefTitleIProgramTypeId = ps2.RefTitleIProgramTypeId	
	LEFT JOIN dbo.K12LeaTitleISupportService tss 
		ON tss.OrganizationId = ore.Parent_OrganizationId	
		AND (@dataCollectionId IS NULL 
			OR tss.DataCollectionId = @dataCollectionId)	
		AND tss.RecordStartDateTime <= s.SessionEndDate 
		AND (tss.RecordEndDateTime >=  s.SessionBeginDate 
			OR tss.RecordEndDateTime IS NULL)	
	LEFT JOIN dbo.RefK12LeaTitleISupportService srvc 
		ON srvc.RefK12LEATitleISupportServiceId = tss.RefK12LEATitleISupportServiceId	

END	