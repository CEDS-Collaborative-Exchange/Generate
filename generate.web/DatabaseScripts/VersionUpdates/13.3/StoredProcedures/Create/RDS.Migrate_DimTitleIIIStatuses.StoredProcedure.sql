CREATE PROCEDURE [RDS].[Migrate_DimTitleIIIStatuses] 
	@studentDates AS RDS.K12StudentDateTableType READONLY,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN
	
	DECLARE @k12StudentRoleId AS INT
	DECLARE @schoolOrganizationTypeId AS INT
	SELECT @k12StudentRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Student'
	SELECT @schoolOrganizationTypeId = RefOrganizationTypeId FROM dbo.RefOrganizationType WHERE code = 'K12School'

	CREATE TABLE #titleIIIAccountabilityProgress 
	(
		  PersonId INT
		, OrganizationId INT
		, TitleIIIAccountabilityCode VARCHAR(50)
	)

	CREATE TABLE #formerEnglishLearnerYear
	(
		  PersonId INT
		, NumberOfYear INT
		, OrganizationId INT
	)

	INSERT INTO #titleIIIAccountabilityProgress (
		  PersonId
		, OrganizationId 
		, TitleIIIAccountabilityCode
		)
	SELECT DISTINCT 
		  r1.PersonId
		, op.Parent_OrganizationId
		, titleIIIAcct.Code  
	FROM dbo.OrganizationPersonRole r1
	JOIN dbo.OrganizationRelationship op 
		ON r1.OrganizationId = op.Parent_OrganizationId 
		AND r1.RoleId = @k12StudentRoleId
		AND (@dataCollectionId IS NULL 
			OR op.DataCollectionId = @dataCollectionId)	
	JOIN dbo.OrganizationPersonRole rp 
		ON op.OrganizationId = rp.OrganizationId 
		AND r1.PersonId = rp.PersonId
		AND (@dataCollectionId IS NULL 
			OR rp.DataCollectionId = @dataCollectionId)	
	JOIN dbo.PersonProgramParticipation ppp 
		ON rp.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId
		AND (@dataCollectionId IS NULL 
			OR ppp.DataCollectionId = @dataCollectionId)	
	JOIN dbo.ProgramParticipationTitleIIILep partIIILep 
		ON ppp.PersonProgramParticipationId = partIIILep.PersonProgramParticipationId
		AND (@dataCollectionId IS NULL 
			OR partIIILep.DataCollectionId = @dataCollectionId)	
	JOIN dbo.RefTitleIIIAccountability titleIIIAcct 
		ON titleIIIAcct.RefTitleIIIAccountabilityId = partIIILep.RefTitleIIIAccountabilityId	
	WHERE (@dataCollectionId IS NULL 
		OR r1.DataCollectionId = @dataCollectionId)	

	INSERT INTO #formerEnglishLearnerYear (
		  PersonId
		, NumberOfYear
		, OrganizationId
		)
	SELECT 
		  PersonId AS PersonId
		, count(*) AS NumberOfYear
		, fy.OrganizationId  
	FROM
		(SELECT DISTINCT 
			  r.PersonId
			, 1 AS NumberOfYear
			, op.Parent_OrganizationId AS OrganizationId
		FROM dbo.OrganizationPersonRole r
		JOIN dbo.OrganizationRelationship op 
			ON r.OrganizationId = op.Parent_OrganizationId 
			AND r.RoleId = @k12StudentRoleId
			AND (@dataCollectionId IS NULL 
				OR op.DataCollectionId = @dataCollectionId)	
		JOIN dbo.OrganizationPersonRole rp 
			ON op.OrganizationId = rp.OrganizationId 
			AND r.PersonId = rp.PersonId
			AND (@dataCollectionId IS NULL 
				OR rp.DataCollectionId = @dataCollectionId)	
		JOIN dbo.PersonProgramParticipation ppp 
			ON rp.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId
			AND (@dataCollectionId IS NULL 
				OR ppp.DataCollectionId = @dataCollectionId)	
		JOIN dbo.ProgramParticipationTitleIIILep partIIILep 
			ON ppp.PersonProgramParticipationId = partIIILep.PersonProgramParticipationId 
			AND ppp.RefProgramExitReasonId IS NULL
			AND (@dataCollectionId IS NULL 
				OR partIIILep.DataCollectionId = @dataCollectionId)	
		JOIN dbo.RefTitleIIIAccountability iiiAcct 
			ON partIIILep.RefTitleIIIAccountabilityId = iiiAcct.RefTitleIIIAccountabilityId
		JOIN dbo.OrganizationCalendar c 
			ON c.OrganizationId = r.OrganizationId
			AND (@dataCollectionId IS NULL 
				OR c.DataCollectionId = @dataCollectionId)	
		JOIN dbo.OrganizationCalendarSession ocs 
			ON ocs.OrganizationCalendarId = c.OrganizationCalendarId 
			AND partIIILep.RecordStartDateTime <= ocs.EndDate 
			AND (@dataCollectionId IS NULL 
				OR ocs.DataCollectionId = @dataCollectionId)	
		WHERE (@dataCollectionId IS NULL 
			OR r.DataCollectionId = @dataCollectionId)	
		GROUP BY Designator, r.PersonId, iiiAcct.Code, op.Parent_OrganizationId,ppp.RefProgramExitReasonId) fy	
	GROUP BY fy.PersonId, fy.OrganizationId	
		
	SELECT DISTINCT
		  s.DimK12StudentId
		, org.DimK12SchoolId
		, org.DimLeaId
		, org.DimSeaId	
		, s.PersonId
		, s.DimCountDateId		
		, ISNULL(titleIIIAcct.TitleIIIAccountabilityCode,'MISSING') AS TitleIIIAccountability
		, ISNULL(TitleIIILanguageInstructionProg.Code, 'MISSING') AS TitleIIILanguageInstructionProgramType
		, CASE 
			WHEN ISNULL(titleIIIAcct.TitleIIIAccountabilityCode,'MISSING') ='MISSING' THEN 'MISSING'
			WHEN schreg.AssessmentParticipationCode = 'DidNotParticipate' AND fely.NumberOfYear>=4 THEN 'NOTPROFICIENT'
			WHEN titleIIIAcct.TitleIIIAccountabilityCode = 'PROFICIENT' THEN 'PROFICIENT '
			ELSE  'NOTPROFICIENT '
		 END AS ProficiencyStatus 
		, CASE WHEN ISNULL(fely.NumberOfYear,0) = 0 THEN 'MISSING'
			 WHEN fely.NumberOfYear = 1 THEN '1YEAR' 
			 WHEN fely.NumberOfYear = 2 THEN '2YEAR' 
			 WHEN fely.NumberOfYear = 3 THEN '3YEAR' 
			 WHEN fely.NumberOfYear = 4 THEN '4YEAR' 
			 WHEN fely.NumberOfYear > 4 THEN '5YEAR' 
		  END AS FormerEnglishLearnerYearStatus
	FROM @studentDates s  
	JOIN @studentOrganizations org 
		ON s.DimK12StudentId = org.DimK12StudentId
		AND s.DimCountDateId = org.DimCountDateId
	LEFT JOIN dbo.AssessmentRegistration reg 
		ON s.PersonId = reg.PersonId 
		AND org.LeaOrganizationid = reg.LeaOrganizationId
		AND (@dataCollectionId IS NULL 
			OR reg.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.AssessmentAdministration adm 
		ON reg.AssessmentAdministrationId = adm.AssessmentAdministrationId
		AND (@dataCollectionId IS NULL 
			OR adm.DataCollectionId = @dataCollectionId)	
		AND adm.StartDate BETWEEN s.SessionBeginDate AND s.SessionEndDate		
	LEFT JOIN (
			SELECT DISTINCT 
				  PersonId
				, SchoolOrganizationId
				, ind.Code AS AssessmentParticipationCode
			FROM dbo.AssessmentRegistration assreg
			JOIN dbo.RefAssessmentParticipationIndicator ind 
				ON assreg.RefAssessmentParticipationIndicatorId = ind.RefAssessmentParticipationIndicatorId
			WHERE (@dataCollectionId IS NULL 
				OR assreg.DataCollectionId = @dataCollectionId)	
				AND ind.Code = 'DidNotParticipate') schreg 
		ON s.PersonId = schreg.PersonId 
		AND org.K12SchoolOrganizationId = schreg.SchoolOrganizationId
	LEFT JOIN #titleIIIAccountabilityProgress titleIIIAcct 
		ON s.PersonId = titleIIIAcct.PersonId 
		AND IIF(org.K12SchoolOrganizationId > 0 , org.K12SchoolOrganizationId, org.LeaOrganizationId) = titleIIIAcct.OrganizationId
	LEFT JOIN (
		SELECT 
			  LangInst.OrganizationId
			, LangInst.RefTitleIIILanguageInstructionProgramTypeId
			, progType.Code 
		FROM dbo.K12TitleIIILanguageInstruction LangInst 
		JOIN dbo.RefTitleIIILanguageInstructionProgramType progType 
			ON LangInst.RefTitleIIILanguageInstructionProgramTypeId = progType.RefTitleIIILanguageInstructionProgramTypeId
		WHERE (@dataCollectionId IS NULL 
			OR langInst.DataCollectionId = @dataCollectionId)	
		) TitleIIILanguageInstructionProg 
		ON TitleIIILanguageInstructionProg.OrganizationId = IIF(org.K12SchoolOrganizationId > 0 , org.K12SchoolOrganizationId, org.LeaOrganizationId)
	LEFT JOIN #formerEnglishLearnerYear fely 
		ON fely.PersonId = s.PersonId 
		AND fely.OrganizationId = IIF(org.K12SchoolOrganizationId > 0 , org.K12SchoolOrganizationId, org.LeaOrganizationId)

	DROP TABLE #titleIIIAccountabilityProgress 
	DROP TABLE #formerEnglishLearnerYear
	
END