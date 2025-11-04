CREATE PROCEDURE [RDS].[Migrate_PsStudentOrganizations] (
	@studentDates AS RDS.PsStudentDateTableType READONLY,
	@dataCollectionId AS INT = NULL,
	@useCutOffDate AS BIT,
	@loadAllForDataCollection AS BIT
)
AS
BEGIN
	
	DECLARE @CutOffDate DATETIME, @SyStartDate DATETIME, @SyEndDate DATETIME
	SELECT @CutOffDate = MAX(s.CountDate), @SyStartDate = MAX(s.SessionBeginDate), @SyEndDate = MAX(s.SessionEndDate)
	FROM @studentDates s

	DECLARE @PsStudentRoleId AS INT, @PsInstitutionIdType AS INT
	SELECT @PsStudentRoleId = RoleId FROM dbo.[Role] WHERE Name = 'Postsecondary Student'	
	SELECT @PsInstitutionIdType = RefOrganizationIdentifierTypeId FROM dbo.RefOrganizationIdentifierType WHERE Code = '000166'
	
	IF @useCutOffDate = NULL
	BEGIN
		SET @useCutOffDate = 1
	END

	CREATE TABLE #psiIdentifiers (
		  OrganizationId INT
		, Identifier VARCHAR(20)
	)
		
	INSERT INTO #psiIdentifiers
	SELECT DISTINCT
		  OrganizationId
		, Identifier
	FROM OrganizationIdentifier oi
	WHERE oi.RefOrganizationIdentifierTypeId = @PsInstitutionIdType
		AND oi.DataCollectionId = @dataCollectionId


	CREATE NONCLUSTERED INDEX IX_psIdentifiers
	ON #psiIdentifiers ([OrganizationId])
	INCLUDE ([Identifier])

	CREATE TABLE #studOrganizations (
		  DimPsStudentId					INT
		, PersonId							INT
		, DimDateId							INT
		, DimPsInstitutionId				INT
		, PsInstitutionOrganizationId		INT
		, DimOrganizationCalendarSessionId	INT
		, DimAcademicTermDesignatorId		INT
		, OrganizationPersonRoleId			INT
	)

	INSERT INTO #studOrganizations
	SELECT DISTINCT 
		  s.DimPsStudentId
		, s.PersonId
		, s.DimCountDateId as DimDateId
		, psi.DimPsInstitutionId
		, oi.OrganizationId AS PsInstitutionOrganizationId
		, NULL as DimOrganizationCalendarSessionId
		, ISNULL(datd.DimAcademicTermDesignatorId,-1) as DimAcademicTermDesignatorId
		, r.OrganizationPersonRoleId as OrganizationPersonRoleId
	FROM @studentDates s
	INNER JOIN dbo.OrganizationPersonRole r 
		ON r.PersonId = s.PersonId
		AND r.RoleId = @PsStudentRoleId
		AND (@dataCollectionId IS NULL 
			OR r.DataCollectionId = @dataCollectionId)
		AND (@loadAllForDataCollection = 1 
				OR (r.EntryDate <= s.SessionEndDate
						AND (r.ExitDate >= s.SessionBeginDate
							OR r.ExitDate IS NULL)))
		AND (r.EntryDate <= ISNULL(s.RecordEndDateTime,getdate())
				AND (r.ExitDate >= s.RecordStartDateTime
					OR r.ExitDate IS NULL))
	INNER JOIN dbo.miOrganizationPersonRole mr 
		ON r.OrganizationPersonRoleId = mr.OrganizationPersonRoleId
	LEFT JOIN dbo.RefAcademicTermDesignator atd 
		ON mr.RefAcademicTermDesignatorId = atd.RefAcademicTermDesignatorId
	LEFT JOIN rds.DimAcademicTermDesignators datd
		ON datd.AcademicTermDesignatorCode = atd.Code
	INNER JOIN #psiIdentifiers oi 
		ON r.OrganizationId = oi.OrganizationId
	INNER JOIN rds.DimPsInstitutions psi
		ON (r.EntryDate <= psi.RecordEndDateTime 
			OR psi.RecordEndDateTime IS NULL)
		AND r.ExitDate >= psi.RecordStartDateTime
		AND psi.InstitutionIpedsUnitId = oi.Identifier 


	SELECT * FROM #studOrganizations
	
	DROP TABLE #psiIdentifiers
	DROP TABLE #studOrganizations


	
END