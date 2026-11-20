-- =============================================
-- Author:		Andy Tsovma
-- Create date: 10/18/2018
-- Description:	Migrate cohort statuses
-- =============================================
CREATE PROCEDURE [RDS].[Migrate_DimCohortStatuses]
	@studentDates AS K12StudentDateTableType READONLY,
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
	--declare     @factTypeCode as varchar(50) = 'gradrate'

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

	DECLARE @COH AS table ( DimK12StudentId integer, PersonId integer, CohortYear VARCHAR(10), CohortDescription VARCHAR(30), DiplomaOrCredentialAwardDate datetime)

	DECLARE @studentRoleId AS INT
	SELECT @studentRoleId = RoleId
	FROM dbo.[Role] WHERE Name = 'K12 Student'

	DECLARE @studentIdentifierTypeId AS INT
	SELECT @studentIdentifierTypeId = RefPersonIdentifierTypeId
	FROM dbo.RefPersonIdentifierType
	WHERE [Code] = '001075'

	DECLARE @schoolIdentificationSystemId AS INT
	SELECT @schoolIdentificationSystemId = RefPersonIdentificationSystemId
	FROM dbo.RefPersonIdentificationSystem
	WHERE [Code] = 'School' AND RefPersonIdentifierTypeId = @studentIdentifierTypeId

	DECLARE @stateIdentificationSystemId AS INT
	SELECT @stateIdentificationSystemId = RefPersonIdentificationSystemId
	FROM dbo.RefPersonIdentificationSystem
	WHERE [Code] = 'State' AND RefPersonIdentifierTypeId = @studentIdentifierTypeId

	DECLARE @stateIssuedId AS INT
	SELECT @stateIssuedId = RefPersonalInformationVerificationId
	FROM dbo.RefPersonalInformationVerification
	WHERE [Code] = '01011'


	INSERT INTO @COH (DimK12StudentId, PersonId, CohortYear, CohortDescription, DiplomaOrCredentialAwardDate)
	SELECT DISTINCT ch.DimK12StudentId, p.PersonId, ch.CohortYear, ch.CohortDescription, a.DiplomaOrCredentialAwardDate
	--, ch.Cohort, p.FirstName, p.MiddleName, p.LastName,
	FROM dbo.PersonDetail p
	JOIN dbo.OrganizationPersonRole r 
		ON p.PersonId = r.PersonId 
		AND r.RoleId = @studentRoleId
		AND (@dataCollectionId IS NULL 
			OR r.DataCollectionId = @dataCollectionId)
	JOIN dbo.K12StudentAcademicRecord a ON a.OrganizationPersonRoleId=r.OrganizationPersonRoleId
		AND (@dataCollectionId IS NULL OR a.DataCollectionId = @dataCollectionId)
	LEFT JOIN (
		SELECT DISTINCT 
			  s.DimK12StudentId
			, r2.PersonId
			, r2.OrganizationId
			, MAX(c.CohortYear) AS CohortYear
			, MAX(c.CohortYear) +  '-' + MAX(c.CohortGraduationYear) AS Cohort
			, c.CohortDescription
		FROM dbo.OrganizationPersonRole r2
		JOIN dbo.K12StudentEnrollment enr ON r2.OrganizationPersonRoleId = enr.OrganizationPersonRoleId
			AND (@dataCollectionId IS NULL OR enr.DataCollectionId = @dataCollectionId)
		JOIN dbo.RefGradeLevel grades ON enr.RefEntryGradeLevelId = grades.RefGradeLevelId
		JOIN dbo.K12StudentCohort c ON r2.OrganizationPersonRoleId = c.OrganizationPersonRoleId
			AND (@dataCollectionId IS NULL OR c.DataCollectionId = @dataCollectionId)
		JOIN @studentDates s ON s.PersonId = r2.PersonId
		WHERE grades.code = '09' 
			AND r2.EntryDate <= s.SessionEndDate AND (r2.ExitDate >= s.SessionBeginDate OR r2.ExitDate IS NULL)
			AND (@dataCollectionId IS NULL OR r2.DataCollectionId = @dataCollectionId)
		GROUP BY s.DimK12StudentId, r2.PersonId, r2.OrganizationId, c.CohortDescription) AS ch
			ON ch.PersonId = r.PersonId
			AND ch.OrganizationId = r.OrganizationId
	JOIN dbo.PersonIdentifier pi ON p.PersonId = pi.PersonId
		AND (@dataCollectionId IS NULL OR pi.DataCollectionId = @dataCollectionId)
	WHERE pi.RefPersonIdentificationSystemId = @stateIdentificationSystemId
		AND pi.RefPersonalInformationVerificationId = @stateIssuedId
		AND ch.Cohort IS NOT NULL
		AND (@dataCollectionId IS NULL OR p.DataCollectionId = @dataCollectionId)

	-- DELETE duplicate entries
	;WITH CTE AS(
	SELECT DimK12StudentId, PersonId, CohortYear, CohortDescription, DiplomaOrCredentialAwardDate, 
       RN = ROW_NUMBER()OVER(PARTITION BY PersonId ORDER BY PersonId)
	FROM @COH
	)
	DELETE FROM CTE WHERE RN > 1

	-- generate output
	SELECT c.* , 
	CASE WHEN c.CohortDescription IS NULL THEN 'MISSING'
		ELSE 
			CASE WHEN c.CohortDescription = 'Regular Diploma' AND YEAR(c.DiplomaOrCredentialAwardDate) = c.CohortYear THEN 'COHYES'
				 WHEN c.CohortDescription = 'Regular Diploma' AND YEAR(c.DiplomaOrCredentialAwardDate) <> c.CohortYear THEN 'COHNO'
				 WHEN c.CohortDescription = 'Alternate Diploma' AND YEAR(c.DiplomaOrCredentialAwardDate) = c.CohortYear  THEN 'COHALTDPL'
				 WHEN c.CohortDescription = 'Alternate Diploma' AND YEAR(c.DiplomaOrCredentialAwardDate) <> c.CohortYear  THEN 'COHNO'
				 WHEN c.CohortDescription = 'Alternate Diploma - Removed' AND YEAR(c.DiplomaOrCredentialAwardDate) = c.CohortYear THEN 'COHALTDPL'
				 WHEN c.CohortDescription = 'Alternate Diploma - Removed' AND YEAR(c.DiplomaOrCredentialAwardDate) <> c.CohortYear THEN 'COHREM'
				 ELSE 'MISSING'
			END
		END AS CohortStatus
	
  
  
	FROM  @COH c

END