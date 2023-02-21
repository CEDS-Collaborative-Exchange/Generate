CREATE PROCEDURE [dbo].[Get_GradeLevels]
	   @gradeLevelType as varchar(50)
AS
BEGIN

		select distinct g.RefGradeLevelId, g.Description, g.Code, g.Definition, g.RefGradeLevelTypeId
		from dbo.K12StudentEnrollment enr
		inner join dbo.RefGradeLevel g on enr.RefEntryGradeLevelId = g.RefGradeLevelId
		inner join dbo.RefGradeLevelType t on g.RefGradeLevelTypeId = t.RefGradeLevelTypeId
		Where t.Code = @gradeLevelType
		order by Code

END
