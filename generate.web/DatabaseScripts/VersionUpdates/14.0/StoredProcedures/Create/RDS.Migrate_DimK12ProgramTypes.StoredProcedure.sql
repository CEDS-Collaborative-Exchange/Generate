CREATE PROCEDURE [RDS].[Migrate_DimK12ProgramTypes]
	@studentDates AS RDS.K12StudentDateTableType READONLY,
	@useCutOffDate BIT,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL,
	@loadAllForDataCollection AS BIT
AS
BEGIN

	DECLARE @ProgramOrgId INT
	SELECT @ProgramOrgId = RefOrganizationTypeId FROM RefOrganizationType WHERE Code = 'Program'

	SELECT DISTINCT
		  o.DimK12StudentId
		, o.DimSeaId
		, o.DimIeuId
		, o.DimLeaId
		, o.DimK12SchoolId
		, d.DimCountDateId
		, d.DimSchoolYearId
		, ISNULL(dpt.ProgramTypeCode, 'MISSING') AS ProgramTypeCode
		, entryDate.DateValue AS EntryDate
		, exitDate.DateValue AS ExitDate
		, ISNULL(dpt.DimProgramTypeId, -1) AS DimProgramTypeId
		, ISNULL(entryDate.DimDateId, -1) AS DimEntryDateId
		, ISNULL(exitDate.DimDateId, -1) AS DimExitDateId
	FROM @studentDates d
	JOIN @studentOrganizations o
		ON d.DimK12StudentId = o.DimK12StudentId
	JOIN dbo.OrganizationRelationship ore
		ON o.IeuOrganizationId = ore.Parent_OrganizationId
		OR o.LeaOrganizationId = ore.Parent_OrganizationId
		OR o.K12SchoolOrganizationId = ore.Parent_OrganizationId
	JOIN dbo.OrganizationDetail od
		ON ore.OrganizationId = od.OrganizationId
		AND od.RefOrganizationTypeId = @ProgramOrgId
	JOIN dbo.OrganizationProgramType opt
		ON od.OrganizationId = opt.OrganizationId
	JOIN dbo.RefProgramType pt
		ON opt.RefProgramTypeId = pt.RefProgramTypeId
	JOIN dbo.OrganizationPersonRole opr
		ON d.PersonId = opr.PersonId
		AND od.OrganizationId = opr.OrganizationId
		AND opr.DataCollectionId = @dataCollectionId
		AND (@loadAllForDataCollection = 1
			OR ((@useCutOffDate = 1
					AND d.CountDate = opr.EntryDate)
				OR  (@useCutOffDate = 0
					AND opr.EntryDate <= d.SessionEndDate
					AND (opr.ExitDate >= d.SessionBeginDate
						OR opr.ExitDate IS NULL)
					)
				))	
	JOIN rds.DimProgramTypes dpt
		ON pt.Code = dpt.ProgramTypeCode
	JOIN rds.DimDates entryDate
		ON opr.EntryDate = entryDate.DateValue
	LEFT  JOIN rds.DimDates exitDate
		ON opr.ExitDate = exitDate.DateValue
END