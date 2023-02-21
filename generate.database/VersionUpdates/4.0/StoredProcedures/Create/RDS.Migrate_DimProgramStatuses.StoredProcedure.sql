CREATE PROCEDURE [RDS].[Migrate_DimProgramStatuses]
	@studentDates AS RDS.K12StudentDateTableType READONLY,
	@useCutOffDate BIT,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL,
	@loadAllForDataCollection AS BIT = 0
AS
BEGIN

	DECLARE @immigrantTitleIIIPersonStatusTypeId AS INT
	SELECT @immigrantTitleIIIPersonStatusTypeId = RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE code = 'TitleIIIImmigrant'

	DECLARE @TitleIIIImmigrantParticipation AS INT
	SELECT @TitleIIIImmigrantParticipation = RefParticipationTypeId FROM dbo.RefParticipationType WHERE code = 'TitleIIIImmigrantParticipation'

	DECLARE @homelessServicedIndicator AS INT
	SELECT @homelessServicedIndicator = RefParticipationTypeId FROM dbo.RefParticipationType WHERE code = 'HomelessServiced'


	DECLARE @section504ProgramTypeId AS INT
	SELECT @section504ProgramTypeId = RefProgramTypeId FROM dbo.RefProgramType WHERE code = '04967'

	DECLARE @fosterCareProgramTypeId AS INT
	SELECT @fosterCareProgramTypeId = RefProgramTypeId FROM dbo.RefProgramType WHERE code = '75000'

	DECLARE @k12StudentRoleId AS INT
	DECLARE @schoolOrganizationTypeId AS INT
	SELECT @k12StudentRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Student'
	SELECT @schoolOrganizationTypeId = RefOrganizationTypeId FROM dbo.RefOrganizationType WHERE code = 'K12School'
			   			
	CREATE TABLE #section504
	(
		PersonId INT,
		ParentOrganizationId INT,
		EntryDate datetime,
		ExitDate datetime,
		Section504Code VARCHAR(50)
	)

	CREATE TABLE #fosterCare
	(
		PersonId INT,
		ParentOrganizationId INT,
		EntryDate datetime,
		ExitDate datetime,
		FosterCareCode VARCHAR(50)
	)

	CREATE TABLE #titleIII
	(
		PersonId INT,
		ParentOrganizationId INT,
		EntryDate datetime,
		ExitDate datetime,
		TitleIIIImmigrantParticipation VARCHAR(50)
	)

	CREATE TABLE #homeless
	(
		PersonId INT,
		ParentOrganizationId INT,
		EntryDate datetime,
		ExitDate datetime,
		HomelessServicedIndicator VARCHAR(50)
	)

	INSERT INTO #section504  (
		  PersonId
		, ParentOrganizationId
		, EntryDate
		, ExitDate
		, Section504Code
		)
	SELECT  
		  r504.PersonId
		, op.Parent_OrganizationId
		, r504.EntryDate
		, r504.ExitDate
		, ISNULL(pt.Code,'MISSING') AS Section504Code
	FROM @studentDates s
	JOIN @studentOrganizations r	
		ON s.DimK12StudentId = r.DimK12StudentId
		AND s.DimCountDateId = r.DimCountDateId
	JOIN dbo.OrganizationRelationship op 
		ON op.Parent_OrganizationId = IIF(r.K12SchoolOrganizationId > 0 , r.K12SchoolOrganizationId, r.LeaOrganizationId)
		AND (@dataCollectionId IS NULL 
			OR op.DataCollectionId = @dataCollectionId)	
	JOIN dbo.OrganizationPersonRole r504 
		ON r504.PersonId = s.PersonId 
		AND r504.RoleId = @k12StudentRoleId 
		AND (@dataCollectionId IS NULL 
			OR r504.DataCollectionId = @dataCollectionId)	
		AND r504.OrganizationId = op.OrganizationId
		AND ((@loadAllForDataCollection = 1 OR @dataCollectionId IS NULL)
			OR ((@useCutOffDate = 0 
					AND r504.EntryDate BETWEEN s.SessionBeginDate AND s.SessionEndDate)
				OR (@useCutOffDate = 1 
					AND s.CountDate BETWEEN r504.EntryDate AND ISNULL(r504.ExitDate, getdate()))))
	JOIN dbo.PersonProgramParticipation ppp 
		ON ppp.OrganizationPersonRoleId = r504.OrganizationPersonRoleId
		AND (@dataCollectionId IS NULL 
			OR ppp.DataCollectionId = @dataCollectionId)	
	JOIN dbo.OrganizationProgramType t2 
		ON t2.OrganizationId = r504.OrganizationId 
		AND t2.RefProgramTypeId = @section504ProgramTypeId
		AND (@dataCollectionId IS NULL 
			OR t2.DataCollectionId = @dataCollectionId)	
	JOIN dbo.RefParticipationType pt 
		ON pt.RefParticipationTypeId = ppp.RefParticipationTypeId

	INSERT INTO #fosterCare (
		  PersonId
		, ParentOrganizationId
		, EntryDate
		, ExitDate
		, FosterCareCode
		)
	SELECT 
		  rfoster.PersonId
		, op.Parent_OrganizationId
		, rfoster.EntryDate
		, rfoster.ExitDate
		, CASE ISNULL(pt.Definition,'MISSING') 
			WHEN 'MISSING' THEN 'MISSING'	
			ELSE 'FOSTERCARE' 
		  END AS FosterCareCode
	FROM @studentDates s
	JOIN @studentOrganizations r	
		ON s.DimK12StudentId = r.DimK12StudentId 
		AND s.DimCountDateId = r.DimCountDateId
	JOIN dbo.OrganizationRelationship op 
		ON op.Parent_OrganizationId = IIF(r.K12SchoolOrganizationId > 0 , r.K12SchoolOrganizationId, r.LeaOrganizationId)
		AND (@dataCollectionId IS NULL 
			OR op.DataCollectionId = @dataCollectionId)	
	JOIN dbo.OrganizationPersonRole rfoster 
		ON rfoster.PersonId = s.PersonId 
		AND rfoster.RoleId = @k12StudentRoleId 
		AND (@dataCollectionId IS NULL 
			OR rfoster.DataCollectionId = @dataCollectionId)	
		AND rfoster.OrganizationId = op.OrganizationId
		AND ((@loadAllForDataCollection = 1 OR @dataCollectionId IS NULL)
			OR ((@useCutOffDate = 0 
					AND rfoster.EntryDate BETWEEN s.SessionBeginDate AND s.SessionEndDate)
				OR (@useCutOffDate = 1 
					AND s.CountDate BETWEEN rfoster.EntryDate AND ISNULL(rfoster.ExitDate, getdate()))))
	JOIN dbo.PersonProgramParticipation ppp3 
		ON ppp3.OrganizationPersonRoleId = rfoster.OrganizationPersonRoleId
		AND (@dataCollectionId IS NULL 
			OR ppp3.DataCollectionId = @dataCollectionId)	
	JOIN dbo.OrganizationProgramType t3 
		ON t3.OrganizationId = rfoster.OrganizationId	
		AND t3.RefProgramTypeId = @fosterCareProgramTypeId
		AND (@dataCollectionId IS NULL 
			OR t3.DataCollectionId = @dataCollectionId)	
	JOIN dbo.RefProgramType pt 
		ON t3.RefProgramTypeId = pt.RefProgramTypeId
	

	INSERT INTO #titleIII (
		  PersonId
		, ParentOrganizationId
		, EntryDate
		, ExitDate
		, TitleIIIImmigrantParticipation
		)
	SELECT 
		  s.PersonId
		, op.Parent_OrganizationId
		, rtitleiii.EntryDate
		, rtitleiii.ExitDate
		, CASE ISNULL(ptype.Code,'MISSING') 
			WHEN 'MISSING' THEN 'MISSING' 
			ELSE 'PART' 
		   END AS TitleIIIImmigrantParticipation
	FROM @studentDates s
	JOIN @studentOrganizations r	
		ON s.DimK12StudentId = r.DimK12StudentId 
		AND s.DimCountDateId = r.DimCountDateId
	JOIN [dbo].[OrganizationRelationship] op 
		ON op.Parent_OrganizationId = IIF(r.K12SchoolOrganizationId > 0 , r.K12SchoolOrganizationId, r.LeaOrganizationId)
		AND (@dataCollectionId IS NULL 
			OR op.DataCollectionId = @dataCollectionId)	
	JOIN dbo.OrganizationPersonRole rtitleiii 
		ON op.OrganizationId = rtitleiii.OrganizationId
		AND (@dataCollectionId IS NULL 
			OR rtitleiii.DataCollectionId = @dataCollectionId)	
		AND rtitleiii.OrganizationId = op.OrganizationId												  
		AND (@loadAllForDataCollection = 1
			OR ((@useCutOffDate = 0 
					AND rtitleiii.EntryDate BETWEEN s.SessionBeginDate AND s.SessionEndDate)
				OR (@useCutOffDate = 1 
					AND s.CountDate BETWEEN rtitleiii.EntryDate AND ISNULL(rtitleiii.ExitDate, GETDATE()))))
	JOIN dbo.PersonProgramParticipation ppp 
		ON ppp.OrganizationPersonRoleId = rtitleiii.OrganizationPersonRoleId
		AND (@dataCollectionId IS NULL 
			OR ppp.DataCollectionId = @dataCollectionId)	
	JOIN dbo.RefParticipationType ptype 
		ON ppp.RefParticipationTypeId = ptype.RefParticipationTypeId
		AND ppp.RefParticipationTypeId = @TitleIIIImmigrantParticipation

	INSERT INTO #homeless (
		  PersonId
		, ParentOrganizationId
		, EntryDate
		, ExitDate
		, HomelessServicedIndicator
		)
	SELECT 
		  s.PersonId
		, opp.Parent_OrganizationId AS ParentOrganizationId
		, rhomeless.EntryDate
		, rhomeless.ExitDate
		, CASE 
			WHEN ISNULL(ptype.Code, 'NO') = 'NO' THEN 'NO' 
			ELSE 'YES' 
		  END AS HomelessServicedIndicator
	FROM @studentDates s
	JOIN @studentOrganizations r	
		ON s.DimK12StudentId = r.DimK12StudentId 
		AND s.DimCountDateId = r.DimCountDateId
	JOIN [dbo].[OrganizationRelationship] opp 
		ON opp.Parent_OrganizationId = IIF(r.K12SchoolOrganizationId > 0 , r.K12SchoolOrganizationId, r.LeaOrganizationId)
		AND (@dataCollectionId IS NULL 
			OR opp.DataCollectionId = @dataCollectionId)	
	JOIN dbo.OrganizationDetail od 
		ON od.OrganizationId = opp.OrganizationId
		AND (@dataCollectionId IS NULL 
			OR od.DataCollectionId = @dataCollectionId)	
	JOIN dbo.OrganizationPersonRole rhomeless 
		ON rhomeless.PersonId = s.PersonId 
		AND rhomeless.RoleId = @k12StudentRoleId 
		AND (@dataCollectionId IS NULL 
			OR rhomeless.DataCollectionId = @dataCollectionId)	
		AND rhomeless.OrganizationId = opp.OrganizationId
		AND ((@loadAllForDataCollection = 1 OR @dataCollectionId IS NULL)
			OR s.CountDate BETWEEN rhomeless.EntryDate AND ISNULL(rhomeless.ExitDate, getdate()))
	JOIN dbo.PersonProgramParticipation ppp 
		ON ppp.OrganizationPersonRoleId = rhomeless.OrganizationPersonRoleId
		AND (@dataCollectionId IS NULL 
			OR ppp.DataCollectionId = @dataCollectionId)	
	JOIN dbo.RefParticipationType ptype 
		ON ptype.RefParticipationTypeId = ppp.RefParticipationTypeId
		AND ptype.RefParticipationTypeId = @homelessServicedIndicator
	

	SELECT DISTINCT
		  s.DimK12StudentId
		, r.DimK12SchoolId
		, r.DimLeaId
		, r.DimSeaId
		, s.PersonId
		, s.DimCountDateId
		, CASE
			WHEN statusImmigrantTitleIII.StatusValue IS NULL THEN 'MISSING'
			WHEN statusImmigrantTitleIII.StatusValue = 1 
				AND statusImmigrantTitleIII.StatusStartDate <= s.SessionEndDate 
				AND ISNULL(statusImmigrantTitleIII.StatusEndDate, GETDATE()) >= s.SessionBeginDate
					THEN 'IMMIGNTTTLIII'
			ELSE 'MISSING'
		  END AS ImmigrantTitleIIICode
		, ISNULL(Section504Code, 'MISSING') AS Section504Code
		, ISNULL(foodServiceEligibility.Code, 'MISSING') AS FoodServiceEligibilityCode
		, ISNULL(FosterCareCode, 'MISSING') AS FosterCareCode
		, ISNULL(TitleIIIImmigrantParticipation, 'MISSING') AS TitleIIIImmigrantParticipation
		, ISNULL(homeless.HomelessServicedIndicator, 'NO') AS HomelessServicedIndicatorCode
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
		AND (@loadAllForDataCollection = 1
			OR ((@useCutOffDate = 0 
					AND opr.EntryDate <= s.SessionEndDate 
					AND (ISNULL(opr.ExitDate, getdate()) >=  s.SessionBeginDate 
						OR opr.ExitDate IS NULL))
				OR (@useCutOffDate = 1 
					AND s.CountDate BETWEEN opr.EntryDate AND ISNULL(opr.ExitDate, getdate()))))
	LEFT JOIN dbo.PersonStatus statusImmigrantTitleIII 
		ON s.PersonId = statusImmigrantTitleIII.PersonId
		AND (@dataCollectionId IS NULL 
			OR statusImmigrantTitleIII.DataCollectionId = @dataCollectionId)	
		AND statusImmigrantTitleIII.RefPersonStatusTypeId = @immigrantTitleIIIPersonStatusTypeId
	LEFT JOIN dbo.K12StudentEnrollment enrollment 
		ON enrollment.OrganizationPersonRoleId = opr.OrganizationPersonRoleId
		AND (@dataCollectionId IS NULL 
			OR enrollment.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.RefFoodServiceEligibility foodServiceEligibility 
		ON foodServiceEligibility.RefFoodServiceEligibilityId = enrollment.RefFoodServiceEligibilityId
	LEFT JOIN #section504 section504 
		ON s.PersonId = section504.PersonId 
		AND IIF(r.K12SchoolOrganizationId > 0, r.K12SchoolOrganizationId, r.LeaOrganizationId) = section504.ParentOrganizationId
	LEFT JOIN #fosterCare foster 
		ON s.PersonId = foster.PersonId 
		AND IIF(r.K12SchoolOrganizationId > 0, r.K12SchoolOrganizationId, r.LeaOrganizationId) = foster.ParentOrganizationId
	LEFT JOIN #titleIII ImmPart	
		ON s.PersonId = ImmPart.PersonId 
		AND IIF(r.K12SchoolOrganizationId > 0, r.K12SchoolOrganizationId, r.LeaOrganizationId) = ImmPart.ParentOrganizationId
	LEFT JOIN #homeless homeless	
		ON s.PersonId = homeless.PersonId 
		AND IIF(r.K12SchoolOrganizationId > 0, r.K12SchoolOrganizationId, r.LeaOrganizationId) = homeless.ParentOrganizationId
	
	DROP TABLE #section504
	DROP TABLE #fosterCare
	DROP TABLE #titleIII
	DROP TABLE #homeless

END