CREATE PROCEDURE [RDS].[Migrate_DimDisciplines]
	@studentDates AS RDS.K12StudentDateTableType READONLY,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN

	DECLARE @lepPersonStatusTypeId AS INT
	SELECT @lepPersonStatusTypeId = RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE code = 'LEP'

	SELECT 
		s.DimK12StudentId
		, d.DimCountDateId
		, d.PersonId
		, ISNULL(org.DimK12SchoolId, -1) AS DimK12SchoolId
		, NULL AS DimLeaId
		, org.DimSeaId
		, dis.IncidentId
        , ISNULL(actionTaken.Code, 'MISSING') AS DisciplineActionCode
		, ISNULL(drdmoc.Code, 'MISSING') AS DisciplineMethodCode
		, CASE	
			WHEN dis.EducationalServicesAfterRemoval = 1 THEN 'SERVPROV'
			WHEN dis.EducationalServicesAfterRemoval = 0 THEN 'SERVNOTPROV'
			ELSE 'MISSING'
		  END AS EducationalServicesCode
		, CASE
			WHEN removalReason.Code = 'Drugs' THEN 'D'
			WHEN removalReason.Code = 'Weapons' THEN 'W'
			WHEN removalReason.Code = 'SeriousBodilyInjury' THEN 'SBI'
			ELSE 'MISSING'
		  END AS RemovalReasonCode
		, ISNULL(removalType.Code, 'MISSING') AS RemovalTypeCode
		, CASE
			WHEN statusLep.StatusValue IS NULL THEN 'MISSING'
			WHEN (statusLep.StatusStartDate IS NULL AND statusLep.StatusEndDate IS NULL)
					OR (NOT statusLep.StatusStartDate IS NULL 
						AND NOT statusLep.StatusEndDate IS NULL 
						AND statusLep.StatusStartDate <= d.SessionBeginDate 
						AND statusLep.StatusEndDate >= d.SessionEndDate
						AND dis.DisciplinaryActionStartDate BETWEEN statusLep.StatusStartDate AND statusLep.StatusEndDate)
					OR (NOT statusLep.StatusStartDate IS NULL 
						AND statusLep.StatusEndDate IS NULL 
						AND statusLep.StatusStartDate <= d.SessionBeginDate 
						AND statusLep.StatusStartDate <= dis.DisciplinaryActionStartDate)
				THEN
					CASE 
						WHEN statusLep.StatusValue = 1 THEN 'LEP'
						ELSE 'NLEP'
					END
			ELSE 'MISSING' END
		  AS LepStatusCode
		, ISNULL(dis.DurationOfDisciplinaryAction, 0.0) AS DisciplineDuration
		, dis.DisciplinaryActionStartDate
		, dd.DimDisciplineId
	INTO #Disciplines
	FROM rds.DimK12Students s 
	JOIN @studentDates d 
		ON s.DimK12StudentId = d.DimK12StudentId 
		AND s.RecordEndDateTime IS NULL
	JOIN @studentOrganizations org 
		ON s.DimK12StudentId = org.DimK12StudentId 
		AND d.DimCountDateId = org.DimCountDateId
	JOIN dbo.OrganizationDetail od 
		ON org.K12SchoolOrganizationId = od.OrganizationId
		AND (@dataCollectionId IS NULL 
			OR od.DataCollectionId = @dataCollectionId)	
	JOIN dbo.RefOrganizationType ot 
		ON od.RefOrganizationTypeId = ot.RefOrganizationTypeId
		AND ot.Code = 'K12School'
	JOIN dbo.OrganizationPersonRole r 
		ON d.PersonId = r.PersonId 
		AND r.OrganizationId = org.K12SchoolOrganizationId	
		AND r.EntryDate <= d.SessionEndDate 
		AND (r.ExitDate >= d.SessionBeginDate 
			OR r.ExitDate IS NULL)	
		AND (@dataCollectionId IS NULL 
			OR r.DataCollectionId = @dataCollectionId)	
	JOIN dbo.K12studentDiscipline dis 
		ON r.OrganizationPersonRoleId = dis.OrganizationPersonRoleId 
		AND (@dataCollectionId IS NULL 
			OR dis.DataCollectionId = @dataCollectionId)	
		AND (dis.DisciplinaryActionStartDate BETWEEN d.SessionBeginDate AND d.SessionEndDate
			OR dis.DisciplinaryActionEndDate IS NULL 
			OR dis.DisciplinaryActionEndDate BETWEEN d.SessionBeginDate AND d.SessionEndDate)
	LEFT JOIN dbo.PersonStatus statusLep 
		ON d.PersonId = statusLep.PersonId 
		AND statusLep.RefPersonStatusTypeId = @lepPersonStatusTypeId
		AND (@dataCollectionId IS NULL 
			OR statusLep.DataCollectionId = @dataCollectionId)	
		AND dis.DisciplinaryActionStartDate >= Convert(Date,statusLep.StatusStartDate) 
		AND dis.DisciplinaryActionStartDate <= Convert(Date,ISNULL(statusLep.StatusEndDate,dis.DisciplinaryActionStartDate))
	LEFT JOIN dbo.RefDisciplineMethodOfCwd drdmoc
		ON dis.RefDisciplineMethodOfCwdId = drdmoc.RefDisciplineMethodOfCwdId
	LEFT JOIN dbo.RefDisciplinaryActionTaken actionTaken
		ON dis.RefDisciplinaryActionTakenId = actionTaken.RefDisciplinaryActionTakenId
	LEFT JOIN dbo.RefIDEAInterimRemoval removalType 
		ON dis.RefIdeaInterimRemovalId = removalType.RefIDEAInterimRemovalId
	LEFT JOIN dbo.RefIDEAInterimRemovalReason removalReason 
		ON dis.RefIdeaInterimRemovalReasonId = removalReason.RefIDEAInterimRemovalReasonId

 	LEFT JOIN rds.DimDisciplines dd
		ON dd.DisciplineMethodOfChildrenWithDisabilitiesCode = ISNULL(drdmoc.Code, 'MISSING')
		AND dd.DisciplinaryActionTakenCode = ISNULL(actionTaken.Code, 'MISSING')
		AND dd.IdeaInterimRemovalCode = ISNULL(removalType.Code, 'MISSING')
		AND dd.IdeaInterimRemovalReasonCode  
			= CASE
				WHEN removalReason.Code = 'Drugs' THEN 'D'
				WHEN removalReason.Code = 'Weapons' THEN 'W' 
				WHEN removalReason.Code = 'SeriousBodilyInjury' THEN 'SBI' 
				ELSE 'MISSING'
			END
		AND dd.EducationalServicesAfterRemovalCode 
			= CASE
				WHEN dis.EducationalServicesAfterRemoval = 1 THEN 'SERVPROV'
				WHEN dis.EducationalServicesAfterRemoval = 0 THEN 'SERVNOTPROV' 
				ELSE 'MISSING'
			END
		AND dd.DisciplineELStatusCode 
			= CASE
				WHEN statusLep.StatusValue = 1 THEN 'LEP'
				WHEN statusLep.StatusValue = 0 THEN 'NLEP'
				ELSE 'MISSING'
			END

	WHERE s.DimK12StudentId <> -1

	UPDATE #Disciplines
	SET DimLeaId = org.DimLeaId
	FROM #Disciplines d
	JOIN @studentOrganizations org
		ON d.DimK12StudentId = org.DimK12StudentId 
		AND d.DimCountDateId = org.DimCountDateId
		AND d.DimK12SchoolId = org.DimK12SchoolId
	JOIN dbo.OrganizationDetail od 
		ON org.LeaOrganizationId = od.OrganizationId
	JOIN dbo.RefOrganizationType ot 
		ON od.RefOrganizationTypeId = ot.RefOrganizationTypeId
		AND ot.Code = 'LEA'
	JOIN dbo.OrganizationPersonRole r 
		ON d.PersonId = r.PersonId 
		AND r.OrganizationId = org.LeaOrganizationId	
		AND d.DisciplinaryActionStartDate BETWEEN r.EntryDate AND ISNULL(r.ExitDate, GETDATE())
	JOIN dbo.K12studentDiscipline dis 
		ON r.OrganizationPersonRoleId = dis.OrganizationPersonRoleId 
		AND dis.DisciplinaryActionStartDate = d.DisciplinaryActionStartDate

	SELECT * FROM #Disciplines
	
	DROP TABLE #Disciplines
END