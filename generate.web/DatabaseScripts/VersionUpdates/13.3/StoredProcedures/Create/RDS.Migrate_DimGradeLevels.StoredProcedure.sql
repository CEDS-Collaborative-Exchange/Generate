CREATE PROCEDURE [RDS].[Migrate_DimGradeLevels]
	@studentDates AS RDS.K12StudentDateTableType READONLY,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL,
	@loadAllForDataCollection AS BIT = 0
AS
BEGIN


    DECLARE @k12StudentRoleId AS INT 
	SELECT @k12StudentRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Student'

    SELECT DISTINCT
		s.DimK12StudentId,
		o.DimK12SchoolId,
		o.DimLeaId,
		o.DimSeaId,
        d.PersonId,
        d.DimCountDateId,
        ISNULL(ent.Code, 'MISSING') AS EntryGradeLevelCode,
        ISNULL(ext.Code, 'MISSING') AS ExitGradeLevelCode,
        ISNULL(glent.DimGradeLevelId, -1) AS DimEntryGradeLevelId,
        ISNULL(glext.DimGradeLevelId, -1) AS DimExitGradeLevelId
    FROM rds.DimK12Students s 
	JOIN @studentDates d 
		ON s.DimK12StudentId = d.DimK12StudentId 
	JOIN @studentOrganizations o 
		ON d.DimK12StudentId = o.DimK12StudentId 
		AND d.PersonId = o.PersonId
	JOIN [dbo].[K12StudentEnrollment] enr 
		ON enr.OrganizationPersonRoleId = ISNULL(o.K12SchoolOrganizationPersonRoleId, o.LeaOrganizationPersonRoleId)
		AND (@dataCollectionId IS NULL  
			OR enr.DataCollectionId = @dataCollectionId)	
		AND ((@loadAllForDataCollection = 1 OR @dataCollectionId IS NULL)
			OR (enr.RecordStartDateTime <= ISNULL(ISNULL(o.K12SchoolExitDate, o.LeaExitDate), GETDATE())
				AND (enr.RecordEndDateTime >=  ISNULL(o.K12SchoolEntryDate, o.LeaEntryDate)
					OR enr.RecordEndDateTime IS NULL)))
    LEFT JOIN dbo.RefGradeLevel ent 
		ON enr.RefEntryGradeLevelId = ent.RefGradeLevelId
	LEFT JOIN dbo.RefGradeLevelType gltent 
		ON ent.RefGradeLevelTypeId = gltent.RefGradeLevelTypeId
		AND gltent.Code = '000100'
    LEFT JOIN dbo.RefGradeLevel ext 
		ON enr.RefExitGradeLevelId = ext.RefGradeLevelId
	LEFT JOIN dbo.RefGradeLevelType gltext 
		ON ext.RefGradeLevelTypeId = gltext.RefGradeLevelTypeId
		AND gltext.Code = '001210'
	LEFT JOIN rds.DimGradeLevels glent
		ON ent.Code = glent.GradeLevelCode
	LEFT JOIN rds.DimGradeLevels glext
		ON ext.Code = glext.GradeLevelCode
    WHERE s.DimK12StudentId <> -1
	ORDER BY s.DimK12StudentId

END
