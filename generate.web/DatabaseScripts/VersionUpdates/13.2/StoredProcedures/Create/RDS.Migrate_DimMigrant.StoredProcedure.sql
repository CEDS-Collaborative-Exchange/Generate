CREATE PROCEDURE [RDS].[Migrate_DimMigrant]
	@studentDates AS RDS.K12StudentDateTableType READONLY,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN


	DECLARE @k12StudentRoleId AS INT
	DECLARE @refParticipationTypeId AS INT
	SELECT @k12StudentRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Student'
	SELECT @refParticipationTypeId = RefParticipationTypeId FROM dbo.RefParticipationType WHERE code = 'MEPParticipation'

	SELECT	
		s.DimK12StudentId,
		r.DimK12SchoolId,
		r.DimLeaId,
		r.DimSeaId,
		s.PersonId,	
		s.DimCountDateId,		
		CASE WHEN ppm.ContinuationOfServicesStatus IS NULL THEN 'MISSING'
			 WHEN ppm.ContinuationOfServicesStatus = 1 THEN 'CONTINUED'
			 ELSE 'MISSING'
		END AS 'ContinuationOfServiceStatus',
		CASE WHEN ppm.PrioritizedForServices IS NULL THEN 'MISSING'
			 WHEN ppm.PrioritizedForServices = 1 THEN 'PS'
			 ELSE 'MISSING'
		END AS MigrantPriorityForServices,
		rmst.Code AS 'MepServiceTypeCode',
		CASE WHEN schStatus.ConsolidatedMepFundsStatus = 1 THEN 'YES'
			WHEN schStatus.ConsolidatedMepFundsStatus = 0 THEN 'NO'
			WHEN schStatus.ConsolidatedMepFundsStatus  IS NULL THEN 'MISSING'
		END AS 'MepFundStatus',
		CASE WHEN projType.Code = 'SchoolDay' THEN 'MEPRSYDAY'
			 WHEN projType.Code = 'ExtendedDay' THEN 'MEPRSYWEEK'
			 WHEN projType.Code = 'SummerIntersession' THEN 'MEPSUM'
			 WHEN projType.Code = 'YearRound' THEN 'MEPYRP'
			 WHEN projType.Code IS NULL THEN 'MISSING'
			 ELSE 'MISSING'
		END AS 'MepEnrollmentType'
	FROM @studentDates s
	JOIN @studentOrganizations r
		ON s.DimK12StudentId = r.DimK12StudentId 
		AND s.DimCountDateId = r.DimCountDateId
	JOIN dbo.OrganizationPersonRole opr 
		ON opr.PersonId = s.PersonId
		AND (@dataCollectionId IS NULL 
			OR opr.DataCollectionId = @dataCollectionId)	
		AND opr.RoleId = @k12StudentRoleId 
		AND opr.OrganizationId = IIF(r.K12SchoolOrganizationId > 0 , r.K12SchoolOrganizationId, r.LeaOrganizationId)
		AND opr.EntryDate <= s.SessionEndDate 
		AND (opr.ExitDate >=  s.SessionBeginDate 
			OR opr.ExitDate IS NULL)
	LEFT JOIN dbo.OrganizationPersonRole r2 
		ON r2.PersonId = s.PersonId
		AND (@dataCollectionId IS NULL 
			OR r2.DataCollectionId = @dataCollectionId)	
		AND r2.EntryDate <= s.SessionEndDate 
		AND (r2.ExitDate >=  s.SessionBeginDate 
			OR opr.ExitDate IS NULL)
	LEFT JOIN dbo.OrganizationRelationship ore 
		ON r2.OrganizationId = ore.OrganizationId 
		AND ore.Parent_OrganizationId = opr.OrganizationId
		AND (@dataCollectionId IS NULL 
			OR ore.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.PersonProgramParticipation ppp 
		ON ppp.OrganizationPersonRoleId = r2.OrganizationPersonRoleId 
		AND ppp.RefParticipationTypeId = @refParticipationTypeId
		AND (@dataCollectionId IS NULL 
			OR ppp.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.ProgramParticipationMigrant ppm 
		ON ppm.PersonProgramParticipationId = ppp.PersonProgramParticipationId
		AND (@dataCollectionId IS NULL 
			OR ppm.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.K12School k12sch 
		ON k12sch.OrganizationId = r.K12SchoolOrganizationId
		AND (@dataCollectionId IS NULL 
			OR k12sch.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.K12SchoolStatus schStatus 
		ON k12sch.K12SchoolId = schStatus.K12SchoolId
		AND (@dataCollectionId IS NULL 
			OR schStatus.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.RefMepServiceType rmst 
		ON rmst.RefMepServiceTypeId = ppm.RefMepServiceTypeId	
	LEFT JOIN dbo.K12ProgramOrService prog 
		ON prog.OrganizationId = r.K12SchoolOrganizationId
		AND (@dataCollectionId IS NULL 
			OR prog.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.RefMepProjectType projType 
		ON projType.RefMepProjectTypeId = prog.RefMepProjectTypeId

END