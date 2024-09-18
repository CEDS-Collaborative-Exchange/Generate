CREATE PROCEDURE [RDS].[Migrate_DimK12Schools_Personnel]
	@personnelDates AS PersonnelDateTableType READONLY,
	@useChildCountDate AS BIT,
	@dataCollectionId AS INT = NULL
AS
BEGIN

	DECLARE @k12TeacherRoleId AS INT
	DECLARE @schoolOrganizationTypeId AS INT
	SELECT @k12TeacherRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Personnel'
	SELECT @schoolOrganizationTypeId = RefOrganizationTypeId FROM dbo.RefOrganizationType WHERE code = 'K12School'

	SELECT 
		  s.DimK12StaffId
		, s.PersonId
		, s.DimCountDateId
		, sch.DimK12SchoolId
	FROM @personnelDates s
	JOIN dbo.OrganizationPersonRole r 
		ON r.PersonId = s.PersonId
		AND (@dataCollectionId IS NULL 
			OR r.DataCollectionId = @dataCollectionId)	
		AND r.RoleId = @k12TeacherRoleId
	JOIN dbo.OrganizationDetail o 
		ON o.OrganizationId = r.OrganizationId
		AND (@dataCollectionId IS NULL 
			OR o.DataCollectionId = @dataCollectionId)	
		AND o.RefOrganizationTypeId = @schoolOrganizationTypeId
		AND s.CountDate BETWEEN ISNULL(o.RecordStartDateTime, s.CountDate) AND ISNULL(o.RecordEndDateTime, GETDATE())
	JOIN rds.DimK12Schools sch 
		ON sch.SchoolOrganizationId = o.OrganizationId 
		AND sch.RecordEndDateTime IS NULL
	WHERE r.EntryDate <=
		CASE
			WHEN @useChildCountDate = 0 THEN s.SessionEndDate
			ELSE s.CountDate
		END 
	AND (
		r.ExitDate >=
			CASE
				WHEN @useChildCountDate = 0 THEN s.SessionBeginDate
				ELSE s.CountDate
			END 
		OR r.ExitDate IS NULL)

END