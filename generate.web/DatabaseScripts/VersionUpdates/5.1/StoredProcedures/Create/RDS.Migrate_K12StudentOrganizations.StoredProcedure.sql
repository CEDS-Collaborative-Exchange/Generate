﻿CREATE PROCEDURE [RDS].[Migrate_K12StudentOrganizations]
	@studentDates AS RDS.K12StudentDateTableType READONLY, 
	@dataCollectionId AS INT = NULL,
	@useCutOffDate AS BIT = 0,
	@loadAllForDataCollection AS BIT = 0
AS
BEGIN

	DECLARE @k12StudentRoleId AS INT
	DECLARE @schoolOrganizationTypeId AS INT, @leaOrganizationElementTypeId AS INT, @leaOrganizationTypeId AS INT, @ieuOrganizationTypeId AS INT, @ieuOrgIdSystem AS INT, @leaOrgIdSystem AS INT, @schOrgIdSystem AS INT, @seaOrganizationTypeId AS INT, @seaOrgIdSystem AS INT
	SELECT @k12StudentRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Student'
	
	SELECT @leaOrganizationElementTypeId = RefOrganizationElementTypeId FROM dbo.RefOrganizationElementType WHERE Code = '001156'
	SELECT @schoolOrganizationTypeId = RefOrganizationTypeId FROM dbo.RefOrganizationType WHERE code = 'K12School'
	SELECT @leaOrganizationTypeId = RefOrganizationTypeId FROM dbo.RefOrganizationType WHERE code = 'LEA' AND RefOrganizationElementTypeId = @leaOrganizationElementTypeId
	SELECT @ieuOrganizationTypeId = RefOrganizationTypeId FROM dbo.RefOrganizationType WHERE code = 'IEU' AND RefOrganizationElementTypeId = @leaOrganizationElementTypeId
	SELECT @seaOrganizationTypeId = RefOrganizationTypeId FROM dbo.RefOrganizationType WHERE code = 'SEA' AND RefOrganizationElementTypeId = @leaOrganizationElementTypeId

	SELECT @leaOrgIdSystem = RefOrganizationIdentificationSystemId 
		FROM dbo.RefOrganizationIdentificationSystem ois 
		JOIN dbo.RefOrganizationIdentifierType ot 
		ON ois.RefOrganizationIdentifierTypeId = ot.RefOrganizationIdentifierTypeId 
		WHERE ois.Code = 'SEA' AND ot.Code = '001072'

	SELECT @ieuOrgIdSystem = RefOrganizationIdentificationSystemId 
		FROM dbo.RefOrganizationIdentificationSystem ois 
		JOIN dbo.RefOrganizationIdentifierType ot 
		ON ois.RefOrganizationIdentifierTypeId = ot.RefOrganizationIdentifierTypeId 
		WHERE ois.Code = 'IEU' AND ot.Code = '001156'

	SELECT @seaOrgIdSystem = RefOrganizationIdentificationSystemId 
		FROM dbo.RefOrganizationIdentificationSystem ois 
		JOIN dbo.RefOrganizationIdentifierType ot 
		ON ois.RefOrganizationIdentifierTypeId = ot.RefOrganizationIdentifierTypeId 
		WHERE ois.Code = 'Federal' AND ot.Code = '001491'

	SELECT @schOrgIdSystem = RefOrganizationIdentificationSystemId 
		FROM dbo.RefOrganizationIdentificationSystem ois 
		JOIN dbo.RefOrganizationIdentifierType ot
		ON ois.RefOrganizationIdentifierTypeId = ot.RefOrganizationIdentifierTypeId 
		WHERE ois.Code = 'SEA' AND ot.Code = '001073'

	IF @useCutOffDate = NULL
	BEGIN
		SET @useCutOffDate = 1
	END

	Create table #studentDates (
		DimK12StudentId INT,
		PersonId INT,
		DimSchoolYearId INT,
		DimCountDateId INT,
		CountDate DATETIME,
		SchoolYear INT,
		SessionBeginDate DATETIME,
		SessionEndDate   DATETIME,
		RecordStartDateTime DATETIME,
		RecordEndDateTime DATETIME NULL
	)
	
	INSERT INTO #studentDates SELECT * FROM @studentDates
	CREATE NONCLUSTERED INDEX [IX_studentDates_PersonId] ON #studentDates ([PersonId])
	
	CREATE TABLE #organizationPersonRole 
	(
		  DimK12StudentId INT
		, PersonId INT
		, DimCountDateId INT
		, OrganizationPersonRoleId INT
		, OrganizationId INT
		, EntryDate DATETIME
		, ExitDate DATETIME
		, RefOrganizationTypeId INT
		, Identifier VARCHAR(20)
	)
	CREATE CLUSTERED INDEX IX_TEMP_person ON #organizationPersonRole ([PersonId])
	CREATE NONCLUSTERED INDEX IX_TEMP_organizationPersonRole ON #organizationPersonRole (OrganizationPersonRoleId)
	CREATE NONCLUSTERED INDEX IX_Opr ON #organizationPersonRole (PersonId, RefOrganizationTypeId)
	CREATE NONCLUSTERED INDEX IX_Opr_IdentifierSystem ON #organizationPersonRole (Identifier, RefOrganizationTypeId)
	CREATE NONCLUSTERED INDEX IX_Opr_EntryDate_ExitDate_Identifier ON #organizationPersonRole (EntryDate, ExitDate, Identifier)

	INSERT INTO #organizationPersonRole
	SELECT DISTINCT 
		  s.DimK12StudentId
		, s.PersonId
		, s.DimCountDateId
		, r.OrganizationPersonRoleId
		, r.OrganizationId
		, r.EntryDate
		, r.ExitDate
		, od.RefOrganizationTypeId
		, i.Identifier
	FROM #studentDates s
	JOIN dbo.OrganizationPersonRole r 
		ON r.PersonId = s.PersonId
		AND r.RoleId = 1
		AND (@dataCollectionId IS NULL 
			OR r.DataCollectionId = @dataCollectionId)
		AND (@useCutOffDate = 1
				AND s.CountDate BETWEEN r.EntryDate AND ISNULL(r.ExitDate, GETDATE())
			OR (@useCutOffDate = 0
				AND r.EntryDate <= ISNULL(s.RecordEndDateTime, GETDATE())
				AND (r.ExitDate >= s.RecordStartDateTime
					OR r.ExitDate IS NULL)))
	JOIN dbo.OrganizationDetail od
		ON r.OrganizationId = od.OrganizationId
		AND (@dataCollectionId IS NULL 
			OR od.DataCollectionId = @dataCollectionId)
		AND od.RefOrganizationTypeId IN (@leaOrganizationTypeId, @schoolOrganizationTypeId)
	JOIN dbo.OrganizationIdentifier i
		ON r.OrganizationId = i.OrganizationId
		AND i.RefOrganizationIdentificationSystemId IN (@leaOrgIdSystem, @schOrgIdSystem)

	CREATE TABLE #ieuIdentifiers (
		  OrganizationId	INT PRIMARY KEY
		, Identifier		VARCHAR(100)
	)
	CREATE NONCLUSTERED INDEX IX_ieuIds ON #ieuIdentifiers (Identifier)
		
	INSERT INTO #ieuIdentifiers
	SELECT DISTINCT
		  OrganizationId
		, Identifier
	FROM OrganizationIdentifier
	WHERE RefOrganizationIdentificationSystemId = @ieuOrgIdSystem
		AND (@dataCollectionId IS NULL 
			OR DataCollectionId = @dataCollectionId)

	-- Traditional school enrollments
	CREATE TABLE #studentOrgs (
		  DimK12StudentId INT
		, PersonId INT
		, DimCountDate INT
		, DimSeaId INT
		, DimIeuId INT NULL
		, DimLeaId INT NULL
		, DimK12SchoolId INT NULL
		, IeuOrganizationId INT NULL
		, leaOrganizationId INT NULL
		, K12SchoolOrganizationId INT NULL
		, LeaOrganizationPersonRoleId INT NULL
		, K12SchoolOrganizationPersonRoleId INT NULL
		, LeaEntryDate DATETIME NULL
		, LeaExitDate DATETIME NULL
		, K12SchoolEntryDate DATETIME NULL	
		, K12SchoolExitDate DATETIME NULL
	)
	CREATE NONCLUSTERED INDEX IX_studentOrgs ON #studentOrgs (PersonId)
	CREATE NONCLUSTERED INDEX [IX_stdudentOrgs_DimLeaId] ON #studentOrgs(DimLeaId) INCLUDE (K12SchoolOrganizationPersonRoleId)
	CREATE NONCLUSTERED INDEX [IX_stdudentOrgs_K12SchoolOrganizationId] ON #studentOrgs(K12SchoolOrganizationId) INCLUDE (LeaOrganizationId) 
	CREATE NONCLUSTERED INDEX [IX_stdudentOrgs_LeaOrganizationId] ON #studentOrgs(LeaOrganizationId) INCLUDE (K12SchoolOrganizationId)
	CREATE NONCLUSTERED INDEX [IX_stdudentOrgs_K12SchoolEntryDate_K12SchoolExitDate] ON #studentOrgs(K12SchoolEntryDate, K12SchoolExitDate) INCLUDE (K12SchoolOrganizationId) 
	CREATE NONCLUSTERED INDEX [IX_stdudentOrgs_LeaEntryDate_LeaExitDate] ON #studentOrgs(LeaEntryDate, LeaExitDate) INCLUDE (LeaOrganizationId) 
	
	INSERT INTO #studentOrgs
	SELECT 
		  s.DimK12StudentId				  AS DimK12StudentId 
		, s.PersonId					  AS PersonId 
		, s.DimCountDateId				  AS DimCountDate 
		, sea.DimSeaId					  AS DimSeaId 
		, NULL 							  AS DimIeuId 
		, NULL 							  AS DimLeaId 
		, sch.DimK12SchoolId 			  AS DimK12SchoolId 
		, NULL 							  AS IeuOrganizationId 
		, NULL 							  AS leaOrganizationId 
		, r.OrganizationId 				  AS K12SchoolOrganizationId 
		, NULL							  AS LeaOrganizationPersonRoleId 
		, r.OrganizationPersonRoleId      AS K12SchoolOrganizationPersonRoleId
		, NULL							  AS LeaEntryDate
		, NULL							  AS LeaExitDate 
		, r.EntryDate					  AS K12SchoolEntryDate
		, r.ExitDate					  AS K12SchoolExitDate 
	FROM #studentDates s
	JOIN #organizationPersonRole r 
		ON r.PersonId = s.PersonId
		AND r.RefOrganizationTypeId = @schoolOrganizationTypeId
	JOIN rds.DimK12Schools sch
		ON ((@useCutOffDate = 1
				AND s.CountDate BETWEEN sch.RecordStartDateTime AND ISNULL(sch.RecordEndDateTime, GETDATE()))
			OR (@useCutOffDate = 0
				AND s.SessionBeginDate <= ISNULL(sch.RecordEndDateTime, GETDATE())
				AND ISNULL(s.SessionEndDate, GETDATE()) >= sch.RecordStartDateTime))
		AND sch.SchoolIdentifierState = r.Identifier 
	JOIN rds.DimSeas sea
		ON s.SessionBeginDate <= ISNULL(sea.RecordEndDateTime, GETDATE())
		AND s.SessionEndDate >= sea.RecordStartDateTime

	INSERT INTO #studentOrgs
	SELECT DISTINCT
		  s.DimK12StudentId							AS DimK12StudentId 
		, s.PersonId								AS PersonId 
		, s.DimCountDateId							AS DimCountDate 
		, sea.DimSeaId								AS DimSeaId 
		, NULL										AS DimIeuId 
		, lea.DimLeaId								AS DimLeaId 
		, -1										AS DimK12SchoolId 
		, NULL										AS IeuOrganizationId 
		, r.OrganizationId							AS leaOrganizationId 
		, NULL										AS K12SchoolOrganizationId 
		, r.OrganizationPersonRoleId				AS LeaOrganizationPersonRoleId 
		, NULL										AS K12SchoolOrganizationPersonRoleId
		, r.EntryDate								AS LeaEntryDate
		, r.ExitDate								AS LeaExitDate 
		, NULL										AS K12SchoolEntryDate
		, NULL										AS K12SchoolExitDate 
	FROM #studentDates s
	JOIN #organizationPersonRole r 
		ON r.PersonId = s.PersonId
		AND r.RefOrganizationTypeId = @leaOrganizationTypeId
	JOIN rds.DimLeas lea	
		ON ((@useCutOffDate = 1
				AND s.CountDate BETWEEN lea.RecordStartDateTime AND ISNULL(lea.RecordEndDateTime, GETDATE()))
			OR
			(@useCutOffDate = 0 
				AND s.SessionBeginDate <= ISNULL(lea.RecordEndDateTime, GETDATE())
				AND ISNULL(s.SessionEndDate, GETDATE()) >= lea.RecordStartDateTime))
		AND lea.LeaIdentifierState = r.Identifier 
	JOIN rds.DimSeas sea
		ON s.SessionBeginDate <= ISNULL(sea.RecordEndDateTime, GETDATE())
		AND s.SessionEndDate >= sea.RecordStartDateTime
	LEFT JOIN #studentOrgs exclude
		ON r.PersonId = exclude.PersonId
	WHERE exclude.PersonId IS NULL

	UPDATE #studentOrgs
	SET   DimLeaId = lea.DimLeaID
		, leaOrganizationId = opr.OrganizationId 
		, LeaOrganizationPersonRoleId = opr.OrganizationPersonRoleId
		, LeaEntryDate = opr.EntryDate
		, LeaExitDate = opr.ExitDate
	FROM #studentDates s
	JOIN #studentOrgs so
		ON s.PersonId = so.PersonId
	JOIN OrganizationPersonRoleRelationship oprr
		ON so.K12SchoolOrganizationPersonRoleId = oprr.OrganizationPersonRoleId
	JOIN OrganizationPersonRole opr
		ON oprr.OrganizationPersonRoleId_Parent = opr.OrganizationPersonRoleId
	JOIN OrganizationIdentifier oi
		ON opr.OrganizationId = oi.OrganizationId
	JOIN rds.DimLeas lea	
		ON ((@useCutOffDate = 1
				AND s.CountDate BETWEEN lea.RecordStartDateTime AND ISNULL( lea.RecordEndDateTime, GETDATE()))
			OR (@useCutOffDate = 0
				AND s.SessionBeginDate <= ISNULL(lea.RecordEndDateTime, GETDATE())
				AND s.SessionEndDate >= lea.RecordStartDateTime))
		AND oi.Identifier = Lea.LeaIdentifierState
	WHERE so.DimLeaId IS NULL

	UPDATE #studentOrgs
	SET   DimIeuId = ieu.DimIeuId
		, ieuOrganizationId = ieuoi.OrganizationId 
	FROM #studentDates s
	JOIN #studentOrgs so
		ON s.PersonId = so.PersonId
	JOIN OrganizationRelationship ore
		ON so.K12SchoolOrganizationId = ore.OrganizationId
		OR so.leaOrganizationId = ore.OrganizationId
	JOIN #ieuIdentifiers ieuoi 
		ON ore.Parent_OrganizationId = ieuoi.OrganizationId
	JOIN rds.Dimieus ieu	
		ON ((@useCutOffDate = 1
				AND s.CountDate BETWEEN ieu.RecordStartDateTime AND ISNULL( ieu.RecordEndDateTime, GETDATE()))
			OR (@useCutOffDate = 0
				AND s.SessionBeginDate <= ISNULL(ieu.RecordEndDateTime, GETDATE())
				AND s.SessionEndDate >= ieu.RecordStartDateTime))
		AND ieu.IeuIdentifierState = ieuoi.Identifier 

	SELECT 
		  DimK12StudentId
		, PersonId
		, DimCountDate
		, DimSeaId 
		, DimIeuId 
		, DimLeaId 
		, DimK12SchoolId 
		, IeuOrganizationId 
		, leaOrganizationId 
		, K12SchoolOrganizationId 
		, LeaOrganizationPersonRoleId 
		, K12SchoolOrganizationPersonRoleId 
		, LeaEntryDate
		, LeaExitDate 
		, K12SchoolEntryDate	
		, K12SchoolExitDate 
	FROM #studentOrgs

	DROP TABLE #studentOrgs
	DROP TABLE #studentDates
	DROP TABLE #organizationPersonRole
	DROP TABLE #ieuIdentifiers
END