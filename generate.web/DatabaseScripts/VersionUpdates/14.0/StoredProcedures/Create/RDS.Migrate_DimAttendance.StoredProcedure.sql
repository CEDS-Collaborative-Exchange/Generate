CREATE PROCEDURE [RDS].[Migrate_DimAttendance]
    @studentDates AS RDS.K12StudentDateTableType READONLY,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL
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
	--declare     @factTypeCode as varchar(50) = 'chronic'

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
      
	SELECT 
          s.DimK12StudentId
        , org.DimK12SchoolId
		, org.DimLeaId
		, org.DimSeaId
        , d.DimCountDateId
        , CASE WHEN (att.AttendanceRate * 100) < 10 THEN 'CA'
			ELSE 'NCA'
		  END AS AbsenteeismCode 
    FROM rds.DimK12Students s 
    JOIN @studentDates d 
		ON s.DimK12StudentId = d.DimK12StudentId 
		AND s.RecordEndDateTime IS NULL
	JOIN @studentOrganizations org
		ON d.PersonId = org.PersonId 
		AND d.DimCountDateId = org.DimCountDateId
    JOIN dbo.OrganizationPersonRole r 
		ON r.PersonId = d.PersonId 
		AND r.OrganizationId = IIF(org.K12SchoolOrganizationId > 0 , org.K12SchoolOrganizationId, org.LeaOrganizationId)
		AND r.EntryDate <= d.CountDate 
		AND (r.ExitDate >= d.CountDate 
			OR r.ExitDate IS NULL)
		AND (@dataCollectionId IS NULL 
			OR r.DataCollectionId = @dataCollectionId)
    JOIN dbo.RoleAttendance att 
		ON att.OrganizationPersonRoleId = r.OrganizationPersonRoleId
		AND (@dataCollectionId IS NULL 
			OR att.DataCollectionId = @dataCollectionId)
			
END



