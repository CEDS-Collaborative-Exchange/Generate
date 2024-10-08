CREATE PROCEDURE [RDS].[Migrate_DimCteStatuses]
	@studentDates AS RDS.K12StudentDateTableType READONLY,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL,
	@loadAllForDataCollection AS BIT = 0
AS
BEGIN

	/*****************************
	For Debugging 
	*****************************/
	--declare @studentDates as rds.StudentDateTableType
	--declare @migrationType varchar(3) = 'rds'

	----select the appropriate date variable, 8=17-18, 9=18-19, 10=19-20, etc...
	--declare @selectedDate int = 9

	----variable for the file spec, uncomment the appropriate one 
	--declare     @factTypeCode as varchar(50) = 'cte'
	--declare     @factTypeCode as varchar(50) = 'grad'
	--declare     @factTypeCode as varchar(50) = 'gradrate'
	--declare     @factTypeCode as varchar(50) = 'membership'
	--declare     @factTypeCode as varchar(50) = 'other'
	--declare     @factTypeCode as varchar(50) = 'specedexit'
	--declare     @factTypeCode as varchar(50) = 'submission' --Discipline, Assessments

	--insert into @studentDates
	--(
	--     DimStudentId,
	--     PersonId,
	--     DimCountDateId,
	--     SubmissionYearDate,
	--     [Year],
	--     SubmissionYearStartDate,
	--     SubmissionYearEndDate
	--)
	--exec rds.Migrate_DimDates_Students @factTypeCode, @migrationType, @selectedDate
	/*****************************
	End of Debugging code 
	*****************************/
	
	DECLARE @k12StudentRoleId AS INT
	SELECT @k12StudentRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Student'

	DECLARE @cteProgramTypeId AS INT
	SELECT @cteProgramTypeId = RefProgramTypeId FROM dbo.RefProgramType WHERE code = '04906'

	DECLARE @lepPerkinsPersonStatusTypeId AS INT
	SELECT @lepPerkinsPersonStatusTypeId = RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE code = 'Perkins LEP'

	CREATE TABLE #cte
	(
		PersonId INT,
		OrganizationId INT,
		Parent_OrganizationId INT,
		EntryDate date,
		ExitDate date,
		CteProgram VARCHAR(50),
		SingleParentOrSinglePregnantWoman VARCHAR(50),
		DisplacedHomemaker VARCHAR(50),
		CteNonTraditionalCompletion VARCHAR(50),
		RepresentationStatus VARCHAR(50),
		InclusionType VARCHAR(50),
		LepPerkinsStatusCode VARCHAR(50)
	)

	create nonclustered index IX_CTE_Person_Organization ON #cte(PersonId, Parent_OrganizationId)

	INSERT INTO #cte (
		  PersonId
		, OrganizationId
		, Parent_OrganizationId
		, EntryDate
		, ExitDate
		, CteProgram
		, SingleParentOrSinglePregnantWoman
		, DisplacedHomemaker
		, CteNonTraditionalCompletion
		, RepresentationStatus
		, InclusionType
		, LepPerkinsStatusCode
		)
	SELECT  
		  s.PersonId
		, opr.OrganizationId
		, op.Parent_OrganizationId
		, opr.EntryDate
		, opr.ExitDate
		, CASE	
			WHEN p.CteConcentrator = 1 THEN 'CTECONC'
			WHEN p.CteParticipant = 1 THEN 'CTEPART'						
			WHEN p.CteParticipant = 0 THEN 'NONCTEPART'
			ELSE 'MISSING' END
		, CASE	
			WHEN p.SingleParentOrSinglePregnantWoman IS NULL THEN 'MISSING'
			WHEN p.SingleParentOrSinglePregnantWoman = 1 THEN 'SPPT'						
			ELSE 'MISSING' 
		  END
		, CASE	
			WHEN p.DisplacedHomemakerIndicator IS NULL THEN 'MISSING'
			WHEN p.DisplacedHomemakerIndicator = 1 THEN 'DH'						
			ELSE 'MISSING'  
		  END
		, CASE	
			WHEN p.CteNonTraditionalCompletion IS NULL THEN 'MISSING'
			WHEN p.CteNonTraditionalCompletion = 1 THEN 'NTE'						
			ELSE 'MISSING'  
		  END
		, CASE 
			WHEN refnonTrdGender.code ='Underrepresented' THEN 'MEM'
			WHEN refnonTrdGender.code ='NotUnderrepresented' THEN 'NM'
			ELSE 'MISSING' END
		, CASE 
			WHEN p.CteCompleter =1 THEN 'GRAD'
			WHEN p.CteCompleter =0 THEN 'NOTG'
			ELSE 'MISSING' END
		, CASE 
			WHEN statusLep.StatusValue = 1 THEN 'LEP' 
			ELSE 'MISSING' 
		  END AS LepPerkinsStatusCode
	FROM @studentDates s
    INNER JOIN @studentOrganizations r
            ON s.PersonId = r.PersonId
               AND s.DimCountDateId = r.DimCountDateId
    INNER JOIN dbo.OrganizationRelationship op
            ON IIF(r.K12SchoolOrganizationId > 0, r.K12SchoolOrganizationId, r.LeaOrganizationId) = op.Parent_OrganizationId
	INNER JOIN dbo.OrganizationPersonRole opr
			ON opr.OrganizationId = op.OrganizationId
	JOIN dbo.PersonProgramParticipation ppp 
		ON opr.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId
		AND (@dataCollectionId IS NULL 
			OR ppp.DataCollectionId = @dataCollectionId)
	LEFT JOIN dbo.ProgramParticipationCte p 
		ON p.PersonProgramParticipationId = ppp.PersonProgramParticipationId
		AND (@dataCollectionId IS NULL 
			OR p.DataCollectionId = @dataCollectionId)
	JOIN dbo.OrganizationProgramType t 
		ON t.OrganizationId = opr.OrganizationId 
		AND t.RefProgramTypeId = @cteProgramTypeId
		AND (@dataCollectionId IS NULL 
			OR t.DataCollectionId = @dataCollectionId)
	LEFT JOIN dbo.RefNonTraditionalGenderStatus refnonTrdGender 
		ON p.RefNonTraditionalGenderStatusId = refnonTrdGender.RefNonTraditionalGenderStatusId
	LEFT JOIN dbo.PersonStatus statusLep 
		ON opr.PersonId = statusLep.PersonId 
		AND statusLep.RefPersonStatusTypeId = @lepPerkinsPersonStatusTypeId
		AND (@dataCollectionId IS NULL 
			OR statusLep.DataCollectionId = @dataCollectionId)
	WHERE (@dataCollectionId IS NULL 
		OR opr.DataCollectionId = @dataCollectionId)

	SELECT DISTINCT
		  s.DimK12StudentId
		, org.DimK12SchoolId
		, org.DimLeaId
		, org.DimSeaId
		, s.PersonId
		, s.DimCountDateId
		, ISNULL(cte.CteProgram, 'MISSING') AS CteProgram
		, ISNULL(cte.DisplacedHomemaker,'MISSING') AS CteAeDisplacedHomemakerIndicator
		, ISNULL(cte.SingleParentOrSinglePregnantWoman,'MISSING') AS SingleParentOrSinglePregnantWoman
		, ISNULL(cte.CteNonTraditionalCompletion,'MISSING') AS CteNontraditionalGenderStatus
		, ISNULL(cte.RepresentationStatus,'MISSING') AS RepresentationStatus
		, ISNULL(cte.InclusionType,'MISSING') AS CteGraduationRateInclusion
		, ISNULL(cte.LepPerkinsStatusCode,'MISSING') AS LepPerkinsStatusCode
	FROM @studentDates s
	JOIN dbo.OrganizationPersonRole r 
		ON r.PersonId = s.PersonId
		AND r.RoleId = @k12StudentRoleId
		AND ((@loadAllForDataCollection = 1 OR @dataCollectionId IS NULL)
			OR (r.EntryDate <= s.SessionEndDate 
				AND (r.ExitDate >=  s.SessionBeginDate 
					OR r.ExitDate IS NULL)))
		AND (@dataCollectionId IS NULL 
			OR r.DataCollectionId = @dataCollectionId)
	JOIN @studentOrganizations org
		ON s.DimK12StudentId = org.DimK12StudentId 
		AND r.OrganizationId = IIF(org.K12SchoolOrganizationId > 0 , org.K12SchoolOrganizationId, org.LeaOrganizationId)
	LEFT JOIN #cte cte 
		ON s.PersonId = cte.PersonId 
		AND IIF(org.K12SchoolOrganizationId > 0, org.K12SchoolOrganizationId, org.LeaOrganizationId) = cte.Parent_OrganizationId
			
	DROP TABLE #cte
			
END