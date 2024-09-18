CREATE PROCEDURE [RDS].[Migrate_DimTitleIIIStatuses_Personnel] 
	@staffDates AS K12StaffDateTableType READONLY,
	@staffOrganizations AS K12StaffOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL,
	@loadAllForDataCollection AS BIT = 0
AS
BEGIN

	DECLARE @k12PersonnelRoleId AS INT
	DECLARE @schoolOrganizationTypeId AS INT
	SELECT @k12PersonnelRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Personnel'
	SELECT @schoolOrganizationTypeId = RefOrganizationTypeId FROM dbo.RefOrganizationType WHERE code = 'K12School'
 		
	SELECT 
		s.DimK12StaffId
		, org.DimK12SchoolId
		, org.DimLeaId
		, org.DimSeaId
		, s.PersonId
		, s.DimCountDateId		
		, ISNULL(titleIIIAcct.Code,'MISSING') AS TitleIIIAccountability
		, ISNULL(TitleIIILanguageInstructionProg.Code, 'MISSING') AS TitleIIILanguageInstructionProgramType
		, CASE 
			WHEN ISNULL(titleIIIAcct.Code,'MISSING') ='MISSING' THEN 'MISSING'
			WHEN titleIIIAcct.Code = 'PROFICIENT' THEN 'PROFICIENT '
			ELSE  'NOTPROFICIENT '
		END AS ProficiencyStatus 
		, CASE 
			WHEN ISNULL(fely.NumberOfYear,0) = 0 THEN 'MISSING'
			WHEN fely.NumberOfYear = 1 THEN '1YEAR ' 
			WHEN fely.NumberOfYear = 2 THEN '2YEAR ' 
			WHEN fely.NumberOfYear = 3 THEN '3YEAR ' 
			WHEN fely.NumberOfYear = 4 THEN '4YEAR ' 
		END AS FormerEnglishLearnerYearStatus
	FROM @staffDates s
    JOIN @staffOrganizations org
        ON s.PersonId = org.PersonId
    JOIN dbo.OrganizationPersonRole r
        ON r.PersonId = s.PersonId
        AND r.OrganizationId = IIF(org.K12SchoolOrganizationId > 0, org.K12SchoolOrganizationId, org.LeaOrganizationId)
        AND r.RoleId = @k12PersonnelRoleId
        AND	(	( @loadAllForDataCollection = 1 OR @dataCollectionId IS NULL ) 
				OR
				( r.EntryDate <= s.SessionEndDate
					AND ( r.ExitDate >= s.SessionBeginDate OR r.ExitDate IS NULL )
				)
			)
	JOIN dbo.OrganizationDetail o 
		ON o.OrganizationId = r.OrganizationId
		AND (@dataCollectionId IS NULL 
			OR o.DataCollectionId = @dataCollectionId)	
		AND o.RefOrganizationTypeId = @schoolOrganizationTypeId
	LEFT JOIN dbo.PersonProgramParticipation ppp 
		ON ppp.OrganizationPersonRoleId = r.OrganizationPersonRoleId
		AND (@dataCollectionId IS NULL 
			OR ppp.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.ProgramParticipationTitleIIILep partIIILep 
		ON ppp.PersonProgramParticipationId = partIIILep.PersonProgramParticipationId
		AND (@dataCollectionId IS NULL 
			OR partIIILep.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.RefTitleIIIAccountability titleIIIAcct 
		ON titleIIIAcct.RefTitleIIIAccountabilityId = partIIILep.RefTitleIIIAccountabilityId	
	LEFT JOIN (
		SELECT 
				LangInst.OrganizationId
			,LangInst.RefTitleIIILanguageInstructionProgramTypeId
			,progType.Code  
		FROM dbo.K12TitleIIILanguageInstruction LangInst 
		JOIN dbo.RefTitleIIILanguageInstructionProgramType progType 
			ON LangInst.RefTitleIIILanguageInstructionProgramTypeId = progType.RefTitleIIILanguageInstructionProgramTypeId
		WHERE (@dataCollectionId IS NULL OR langInst.DataCollectionId = @dataCollectionId)	
	)TitleIIILanguageInstructionProg 
		ON TitleIIILanguageInstructionProg.OrganizationId = o.OrganizationId

			-- Former English Learner Year	
	LEFT JOIN (
		SELECT 
			  PersonId
			, count(1) - 1 AS NumberOfYear
			, iiiAcct.Code
		FROM dbo.OrganizationCalendarSession ocs
		JOIN dbo.ProgramParticipationTitleIIILep iii
			ON iii.RecordStartDateTime <= ocs.EndDate
			AND (@dataCollectionId IS NULL 
				OR iii.DataCollectionId = @dataCollectionId)	
			AND iii.RefTitleIIIAccountabilityId = 3
		JOIN dbo.PersonProgramParticipation ppp
			ON iii.PersonProgramParticipationId = ppp.PersonProgramParticipationId
			AND (@dataCollectionId IS NULL 
				OR ppp.DataCollectionId = @dataCollectionId)	
		JOIN dbo.OrganizationPersonRole opr
			ON ppp.OrganizationPersonRoleId = opr.OrganizationPersonRoleId
			AND (@dataCollectionId IS NULL 
				OR opr.DataCollectionId = @dataCollectionId)	
		JOIN dbo.RefTitleIIIAccountability iiiAcct 
			ON iii.RefTitleIIIAccountabilityId = iiiAcct.RefTitleIIIAccountabilityId
		WHERE (@dataCollectionId IS NULL 
			OR ocs.DataCollectionId = @dataCollectionId)	
		GROUP BY opr.PersonId, iiiAcct.Code
		having count(1) >= 2		
	) fely ON fely.PersonId = s.PersonId
	
END
