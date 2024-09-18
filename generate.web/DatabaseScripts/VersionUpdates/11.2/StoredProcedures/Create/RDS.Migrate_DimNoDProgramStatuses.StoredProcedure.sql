CREATE PROCEDURE [RDS].[Migrate_DimNoDProgramStatuses]
	@studentDates AS RDS.K12StudentDateTableType READONLY,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN


	DECLARE @k12StudentRoleId AS INT
	DECLARE @schoolOrganizationTypeId AS INT
	DECLARE @refParticipationTypeId AS INT
	SELECT @k12StudentRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Student'
	SELECT @schoolOrganizationTypeId = RefOrganizationTypeId FROM dbo.RefOrganizationType WHERE code = 'K12School'
	SELECT @refParticipationTypeId = RefParticipationTypeId FROM dbo.RefParticipationType WHERE code = 'CorrectionalEducationReentryServicesParticipation'

	SELECT	
		  s.DimK12StudentId
		, org.DimK12SchoolId
		, org.DimLeaId
		, org.DimSeaId
		, s.PersonId
		, s.DimCountDateId
		, CASE 
			WHEN negprogtype.Code <> 'MISSING' 
				AND ppp.RecordEndDateTime IS NOT NULL 
				AND DATEDIFF(d, ppp.RecordStartDateTime, ISNULL(ppp.RecordEndDateTime, GetDate())) >= 90 THEN 'NDLONGTERM'
			WHEN negprogtype.Code <> 'MISSING' 
				AND ppp.RecordEndDateTime IS NULL 
				AND DATEDIFF(d, ppp.RecordStartDateTime, ISNULL(s.SessionEndDate, GetDate())) >= 90 THEN 'NDLONGTERM'
			ELSE 'MISSING'
		  END AS LongTermStatusCode
		, CASE WHEN negprogtype.Code = 'NeglectedPrograms' THEN 'NEGLECT'
			WHEN negprogtype.Code = 'JuvenileDetention' THEN 'JUVDET'
			WHEN negprogtype.Code = 'JuvenileCorrection' THEN 'JUVCORR'
			WHEN negprogtype.Code = 'AtRiskPrograms' THEN 'ATRISK'
			WHEN negprogtype.Code = 'AdultCorrection' THEN 'ADLTCORR'
			WHEN negprogtype.Code = 'OtherPrograms' THEN 'OTHER'
			ELSE 'MISSING' 
		  END AS NeglectedProgramTypeCode
		--, ISNULL(inProgram.Code,'MISSING')
		--, ISNULL(exitedProgram.Code,'MISSING')
	FROM @studentDates s
	JOIN @studentOrganizations org
		ON s.DimK12StudentId = org.DimK12StudentId 
		AND s.DimCountDateId = org.DimCountDateId
	JOIN dbo.OrganizationPersonRole r 
		ON r.PersonId = s.PersonId
		AND (@dataCollectionId IS NULL 
			OR r.DataCollectionId = @dataCollectionId)	
		AND r.RoleId = @k12StudentRoleId 
		AND r.OrganizationId = IIF(org.K12SchoolOrganizationId > 0 , org.K12SchoolOrganizationId, org.LeaOrganizationId)
		AND r.EntryDate <= s.SessionEndDate 
		AND (r.ExitDate >=  s.SessionBeginDate 
			OR r.ExitDate IS NULL)
	JOIN dbo.OrganizationPersonRole r2 
		ON r2.PersonId = s.PersonId
		AND (@dataCollectionId IS NULL 
			OR r2.DataCollectionId = @dataCollectionId)	
		AND r2.EntryDate <= s.SessionEndDate 
		AND (r2.ExitDate >=  s.SessionBeginDate 
			OR r2.ExitDate IS NULL)
	JOIN dbo.OrganizationRelationship ore 
		ON r2.OrganizationId = ore.OrganizationId 
		AND ore.Parent_OrganizationId = r.OrganizationId
		AND (@dataCollectionId IS NULL 
			OR ore.DataCollectionId = @dataCollectionId)	
	JOIN dbo.PersonProgramParticipation ppp 
		ON ppp.OrganizationPersonRoleId = r2.OrganizationPersonRoleId 
		AND ppp.RefParticipationTypeId = @refParticipationTypeId
		AND (@dataCollectionId IS NULL 
			OR ppp.DataCollectionId = @dataCollectionId)	
	JOIN dbo.ProgramParticipationNeglected ppn 
		ON ppn.PersonProgramParticipationId = ppp.PersonProgramParticipationId
		AND (@dataCollectionId IS NULL 
			OR ppn.DataCollectionId = @dataCollectionId)	
	JOIN dbo.RefNeglectedProgramType negprogtype 
		ON negprogtype.[RefNeglectedProgramTypeId] = ppn.[RefNeglectedProgramTypeId]
	--LEFT JOIN dbo.RefAcademicCareerAndTechnicalOutcomesInProgram inProgram 
	--	ON inProgram.RefAcademicCareerAndTechnicalOutcomesInProgramId = ppn.RefAcademicCareerAndTechnicalOutcomesInProgramId
	--LEFT JOIN dbo.RefAcademicCareerAndTechnicalOutcomesExitedProgram exitedProgram 
	--	ON exitedProgram.RefAcademicCareerAndTechnicalOutcomesExitedProgramId = ppn.RefAcademicCareerAndTechnicalOutcomesExitedProgramId

END