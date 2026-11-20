CREATE PROCEDURE [RDS].[Migrate_DimK12Demographics]
	@studentDates AS RDS.K12StudentDateTableType READONLY,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@useCutOffDate BIT = 0,
	@dataCollectionId AS INT = NULL,
	@loadAllForDataCollection AS BIT = 0
AS
BEGIN
	
	DECLARE @ecoDisPersonStatusTypeId AS INT
	SELECT @ecoDisPersonStatusTypeId = RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE code = 'EconomicDisadvantage'

	DECLARE @homelessPersonStatusTypeId AS INT
	SELECT @homelessPersonStatusTypeId = RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE code = 'Homeless'

	DECLARE @homelessUnaccompaniedYouthPersonStatusTypeId AS INT
	SELECT @homelessUnaccompaniedYouthPersonStatusTypeId = RefPersonStatusTypeId FROM dbo.RefPersonStatusType 
	WHERE code = 'HomelessUnaccompaniedYouth'
	
	DECLARE @lepPersonStatusTypeId AS INT
	SELECT @lepPersonStatusTypeId = RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE code = 'LEP'
	
	DECLARE @leppPersonStatusTypeId AS INT
	SELECT @leppPersonStatusTypeId = RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE code = 'Perkins LEP'

	DECLARE @migrantPersonStatusTypeId AS INT
	SELECT @migrantPersonStatusTypeId = RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE code = 'Migrant'
	
    -- Statuses
    CREATE TABLE #DATECTE
    (
        PersonId INT,
        RecordStartDateTime DATETIME,
        SequenceNumber INT
    );

    CREATE NONCLUSTERED INDEX IX_DATECTE
    ON #DATECTE (
                    PersonId,
                    RecordStartDateTime
                );

    INSERT INTO #DATECTE
    SELECT PersonId,
           RecordStartDateTime,
           ROW_NUMBER() OVER (PARTITION BY PersonId ORDER BY RecordStartDateTime) AS SequenceNumber
    FROM
    (
        SELECT DISTINCT
               p.PersonId,
               p.RecordStartDateTime
        FROM dbo.PersonDetail p
        JOIN @studentDates d
            ON p.PersonId = d.PersonId
        WHERE (@loadAllForDataCollection = 1 
			OR (p.RecordStartDateTime <=
					CASE
						WHEN @useCutOffDate = 0 THEN d.SessionEndDate
						ELSE d.CountDate
					END 
				AND (
					p.RecordEndDateTime >=
						CASE
							WHEN @useCutOffDate = 0 THEN d.SessionBeginDate
							ELSE d.CountDate
						END 
					OR p.RecordEndDateTime IS NULL)))
		AND (@dataCollectionId IS NULL 
			OR p.DataCollectionId = @dataCollectionId)
        UNION
        SELECT DISTINCT
               ps.PersonId,
               ps.StatusStartDate
        FROM dbo.PersonStatus ps
        JOIN @studentDates d
            ON ps.PersonId = d.PersonId
        WHERE (@loadAllForDataCollection = 1 
			OR (ps.StatusStartDate <=
					CASE
						WHEN @useCutOffDate = 0 THEN d.SessionEndDate
						ELSE d.CountDate
					END 
				AND (
					ps.StatusEndDate >=
						CASE
							WHEN @useCutOffDate = 0 THEN d.SessionBeginDate
							ELSE d.CountDate
						END 
					OR ps.StatusEndDate IS NULL)))
		    AND (@dataCollectionId IS NULL 
			    OR ps.DataCollectionId = @dataCollectionId)
            AND RefPersonStatusTypeId IN ( @ecoDisPersonStatusTypeId, @homelessPersonStatusTypeId,
                                            @homelessUnaccompaniedYouthPersonStatusTypeId, @lepPersonStatusTypeId, @leppPersonStatusTypeId,
                                            @migrantPersonStatusTypeId
                                        )
        UNION
        SELECT DISTINCT
               ps.PersonId,
               DATEADD(DAY, 1, ps.StatusEndDate)
        FROM dbo.PersonStatus ps
        JOIN @studentDates d 
            ON ps.PersonId = d.PersonId
        WHERE (@loadAllForDataCollection = 1 
			OR (ps.StatusStartDate <=
					CASE
						WHEN @useCutOffDate = 0 THEN d.SessionEndDate
						ELSE d.CountDate
					END 
				AND (
					ps.StatusEndDate >=
						CASE
							WHEN @useCutOffDate = 0 THEN d.SessionBeginDate
							ELSE d.CountDate
						END 
					OR ps.StatusEndDate IS NULL)))
			AND (@dataCollectionId IS NULL 
				OR ps.DataCollectionId = @dataCollectionId)
			AND ps.StatusEndDate IS NOT NULL
            AND RefPersonStatusTypeId IN ( @ecoDisPersonStatusTypeId, @homelessPersonStatusTypeId,
                                             @homelessUnaccompaniedYouthPersonStatusTypeId, @lepPersonStatusTypeId,
                                             @migrantPersonStatusTypeId
                                           )
    ) dates;

	SELECT DISTINCT
		  s.DimK12StudentId
		, org.DimIeuId
		, org.DimLeaId
		, org.DimK12SchoolId
		, s.DimCountDateId
		, CASE 
			WHEN statusEcoDis.StatusValue = 1 THEN 'Yes'
			WHEN statusEcoDis.StatusValue = 0 THEN 'No'
			ELSE 'MISSING'
		  END AS EcoDisStatusCode
		, CASE 
			WHEN statusHomeless.StatusValue = 1 THEN 'Yes'
			WHEN statusHomeless.StatusValue = 0 THEN 'No'
			ELSE 'MISSING'
		  END AS HomelessStatusCode
		, CASE 
			WHEN statusHomelessUY.StatusValue = 1 THEN 'Yes'
			WHEN statusHomelessUY.StatusValue = 0 THEN 'No'
			ELSE 'MISSING'
		  END AS HomelessUYStatusCode
		, CASE 
			WHEN statusLep.StatusValue = 1 THEN 'LEP'
			WHEN statusLep.StatusValue = 0 THEN 'NLEP'
			ELSE 'NLEP'
		  END AS LepStatusCode
		, CASE 
			WHEN statusMigrant.StatusValue = 1 THEN 'Yes'
			WHEN statusMigrant.StatusValue = 0 THEN 'No'
			ELSE 'MISSING'
		  END AS MigrantStatusCode
		, CASE 
			WHEN mcsi.Code IN ('NationalGuardOrReserve', 'ActiveDuty') THEN 'MILCNCTD'
			WHEN mcsi.Code = 'NotMilitaryConnected' THEN 'NOTMILCNCTD'
			ELSE 'MISSING'
		  END AS MilitaryConnectedStatus
		, ISNULL(dt.Code,'MISSING') as HomelessNighttimeResidence
		, startDate.RecordStartDateTime AS PersonStartDate
		, endDate.RecordStartDateTime - 1 AS PersonEndDate
		, kd.DimK12DemographicId
        FROM #DATECTE startDate
        LEFT JOIN #DATECTE endDate
            ON startDate.PersonId = endDate.PersonId
               AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
        INNER JOIN @studentDates s
            ON s.PersonId = startDate.PersonId
               AND startDate.RecordStartDateTime BETWEEN s.SessionBeginDate AND ISNULL(s.SessionEndDate, GETDATE())
		JOIN @studentOrganizations org 
			ON s.DimK12StudentId = org.DimK12StudentId 
			AND s.PersonId = org.PersonId
        INNER JOIN dbo.PersonDetail p
            ON p.PersonId = s.PersonId
               AND startDate.RecordStartDateTime BETWEEN p.RecordStartDateTime AND ISNULL(p.RecordEndDateTime, GETDATE())
        LEFT OUTER JOIN dbo.RefSex sex
            ON p.RefSexId = sex.RefSexId
        LEFT OUTER JOIN dbo.PersonStatus statusEcoDis
            ON p.PersonId = statusEcoDis.PersonId
               AND startDate.RecordStartDateTime BETWEEN statusEcoDis.StatusStartDate AND ISNULL(statusEcoDis.StatusEndDate, GETDATE())
               AND statusEcoDis.RefPersonStatusTypeId = @ecoDisPersonStatusTypeId
        LEFT OUTER JOIN dbo.PersonStatus statusHomeless
            ON p.PersonId = statusHomeless.PersonId
               AND startDate.RecordStartDateTime BETWEEN statusHomeless.StatusStartDate AND ISNULL(statusHomeless.StatusEndDate, GETDATE())
               AND statusHomeless.RefPersonStatusTypeId = @homelessPersonStatusTypeId
        LEFT OUTER JOIN dbo.PersonStatus statusHomelessUY
            ON p.PersonId = statusHomelessUY.PersonId
               AND startDate.RecordStartDateTime BETWEEN statusHomelessUY.StatusStartDate AND ISNULL(statusHomelessUY.StatusEndDate, GETDATE())
               AND statusHomelessUY.RefPersonStatusTypeId = @homelessUnaccompaniedYouthPersonStatusTypeId
        LEFT OUTER JOIN dbo.PersonStatus statusLep
            ON p.PersonId = statusLep.PersonId
               AND startDate.RecordStartDateTime BETWEEN statusLep.StatusStartDate AND ISNULL(statusLep.StatusEndDate, GETDATE())
               AND statusLep.RefPersonStatusTypeId = @lepPersonStatusTypeId
        LEFT OUTER JOIN dbo.PersonStatus statusLepp
            ON p.PersonId = statusLepp.PersonId
               AND startDate.RecordStartDateTime BETWEEN statusLepp.StatusStartDate AND ISNULL(statusLepp.StatusEndDate, GETDATE())
               AND statusLep.RefPersonStatusTypeId = @leppPersonStatusTypeId
        LEFT OUTER JOIN dbo.PersonStatus statusMigrant
            ON p.PersonId = statusMigrant.PersonId
               AND startDate.RecordStartDateTime
               BETWEEN statusMigrant.StatusStartDate AND ISNULL(statusMigrant.StatusEndDate, GETDATE())
               AND statusMigrant.RefPersonStatusTypeId = @migrantPersonStatusTypeId
        LEFT JOIN dbo.PersonMilitary militaryStatus
            ON militaryStatus.PersonId = p.PersonId
		LEFT JOIN dbo.RefMilitaryConnectedStudentIndicator mcsi
			ON militaryStatus.RefMilitaryConnectedStudentIndicatorId = mcsi.RefMilitaryConnectedStudentIndicatorId
		LEFT OUTER JOIN dbo.PersonHomelessness ph
            ON ph.PersonId = p.PersonId
               AND startDate.RecordStartDateTime
               BETWEEN ph.RecordStartDateTime AND ISNULL(ph.RecordEndDateTime, GETDATE())
               AND ISNULL(ph.RecordStartDateTime, s.CountDate) <= CASE
                                                                               WHEN @useCutOffDate = 0 THEN
                                                                                   s.SessionEndDate
                                                                               ELSE
                                                                                   s.CountDate
                                                                           END
               AND ISNULL(ph.RecordEndDateTime, GETDATE()) >= CASE
                                                                  WHEN @useCutOffDate = 0 THEN
                                                                      s.SessionBeginDate
                                                                  ELSE
                                                                      s.CountDate
                                                              END
        LEFT JOIN dbo.RefHomelessNighttimeResidence dt
            ON dt.RefHomelessNighttimeResidenceId = ph.RefHomelessNighttimeResidenceId
		LEFT JOIN rds.DimK12Demographics kd 
			ON kd.EconomicDisadvantageStatusCode =	CASE 
													WHEN statusEcoDis.StatusValue = 1 THEN 'Yes'
													WHEN statusEcoDis.StatusValue = 0 THEN 'No'
													ELSE 'MISSING'
												END 
				AND kd.HomelessnessStatusCode = CASE 
													WHEN statusHomeless.StatusValue = 1 THEN 'Yes'
													WHEN statusHomeless.StatusValue = 0 THEN 'No'
													ELSE 'MISSING'
												END
				AND kd.HomelessUnaccompaniedYouthStatusCode = CASE 
																WHEN statusHomelessUY.StatusValue = 1 THEN 'Yes'
																WHEN statusHomelessUY.StatusValue = 0 THEN 'No'
																ELSE 'MISSING'
															  END
				AND kd.EnglishLearnerStatusCode = CASE 
													WHEN statusLep.StatusValue = 1 THEN 'LEP'
													WHEN statusLepp.StatusValue = 1 THEN 'LEPP'
													WHEN statusLep.StatusValue = 0 THEN 'NLEP'
													ELSE 'MISSING'
					 							  END 
				AND kd.MigrantStatusCode =  CASE 
												WHEN statusMigrant.StatusValue = 1 THEN 'Yes'
												WHEN statusMigrant.StatusValue = 0 THEN 'No'
												ELSE 'MISSING'
											END
				AND kd.MilitaryConnectedStudentIndicatorCode = ISNULL(mcsi.Code, 'MISSING')
				AND kd.HomelessPrimaryNighttimeResidenceCode = ISNULL(dt.Code, 'MISSING')

END