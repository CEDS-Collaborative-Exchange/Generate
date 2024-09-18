CREATE PROCEDURE [RDS].[Migrate_DimDemographics]
    @studentDates AS StudentDateTableType READONLY,
    @useCutOffDate BIT
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
    --declare     @factTypeCode as varchar(50) = 'childcount'
    --declare     @factTypeCode as varchar(50) = 'chronic'
    --declare     @factTypeCode as varchar(50) = 'cte'
    --declare     @factTypeCode as varchar(50) = 'datapopulation'
    --declare     @factTypeCode as varchar(50) = 'dropout'
    --declare     @factTypeCode as varchar(50) = 'grad'
    --declare     @factTypeCode as varchar(50) = 'gradrate'
    --declare     @factTypeCode as varchar(50) = 'homeless'
    --declare     @factTypeCode as varchar(50) = 'hsgradenroll'
    --declare     @factTypeCode as varchar(50) = 'immigrant'
    --declare     @factTypeCode as varchar(50) = 'membership'
    --declare     @factTypeCode as varchar(50) = 'mep'
    --declare     @factTypeCode as varchar(50) = 'nord'
    --declare     @factTypeCode as varchar(50) = 'other'
    --declare     @factTypeCode as varchar(50) = 'specedexit'
    --declare     @factTypeCode as varchar(50) = 'submission' --Discipline, Assessments
    --declare     @factTypeCode as varchar(50) = 'titleI'
    --declare     @factTypeCode as varchar(50) = 'titleIIIELOct'

    ----variable for UseCutOffDate, uncomment the appropriate one
    ----If you're working on     'childcount','membership','titleIIIELOct','submission' -for Assessments
    --declare @useCutOffDate as bit = 1
    ----otherwise
    --declare @useCutOffDate as bit = 0

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

    DECLARE @ecoDisPersonStatusTypeId AS INT;
    SELECT @ecoDisPersonStatusTypeId = RefPersonStatusTypeId
    FROM ods.RefPersonStatusType
    WHERE code = 'EconomicDisadvantage';

    DECLARE @homelessPersonStatusTypeId AS INT;
    SELECT @homelessPersonStatusTypeId = RefPersonStatusTypeId
    FROM ods.RefPersonStatusType
    WHERE code = 'Homeless';

    DECLARE @homelessUnaccompaniedYouthPersonStatusTypeId AS INT;
    SELECT @homelessUnaccompaniedYouthPersonStatusTypeId = RefPersonStatusTypeId
    FROM ods.RefPersonStatusType
    WHERE code = 'HomelessUnaccompaniedYouth';

    DECLARE @lepPersonStatusTypeId AS INT;
    SELECT @lepPersonStatusTypeId = RefPersonStatusTypeId
    FROM ods.RefPersonStatusType
    WHERE code = 'LEP';

    DECLARE @migrantPersonStatusTypeId AS INT;
    SELECT @migrantPersonStatusTypeId = RefPersonStatusTypeId
    FROM ods.RefPersonStatusType
    WHERE code = 'Migrant';

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
               PersonId,
               RecordStartDateTime
        FROM ods.PersonDetail
        WHERE RecordStartDateTime IS NOT NULL
        UNION
        SELECT DISTINCT
               PersonId,
               StatusStartDate
        FROM ods.PersonStatus
        WHERE StatusStartDate IS NOT NULL
              AND RefPersonStatusTypeId IN ( @ecoDisPersonStatusTypeId, @homelessPersonStatusTypeId,
                                             @homelessUnaccompaniedYouthPersonStatusTypeId, @lepPersonStatusTypeId,
                                             @migrantPersonStatusTypeId
                                           )
              AND StatusValue = 1
        UNION
        SELECT DISTINCT
               PersonId,
               DATEADD(DAY, 1, StatusEndDate)
        FROM ods.PersonStatus
        WHERE StatusEndDate IS NOT NULL
              AND RefPersonStatusTypeId IN ( @ecoDisPersonStatusTypeId, @homelessPersonStatusTypeId,
                                             @homelessUnaccompaniedYouthPersonStatusTypeId, @lepPersonStatusTypeId,
                                             @migrantPersonStatusTypeId
                                           )
              AND StatusValue = 1
    ) dates;

    SELECT DISTINCT
           s.DimStudentId,
           p.PersonId,
           s.DimCountDateId,
           CASE
               WHEN @useCutOffDate = 1 THEN
                   CASE
                       WHEN statusEcoDis.StatusValue IS NULL THEN
                           'MISSING'
                       WHEN s.SubmissionYearDate
                            BETWEEN statusEcoDis.StatusStartDate AND ISNULL(statusEcoDis.StatusEndDate, GETDATE()) THEN
                           CASE
                               WHEN statusEcoDis.StatusValue = 1 THEN
                                   'EconomicDisadvantage'
                               ELSE
                                   'MISSING'
                           END
                       ELSE
                           'MISSING'
                   END
               ELSE
                   CASE
                       WHEN statusEcoDis.StatusValue IS NULL THEN
                           'MISSING'
                       WHEN statusEcoDis.StatusStartDate <= s.SubmissionYearEndDate
                            AND ISNULL(statusEcoDis.StatusEndDate, GETDATE()) >= s.SubmissionYearStartDate THEN
                           CASE
                               WHEN statusEcoDis.StatusValue = 1 THEN
                                   'EconomicDisadvantage'
                               ELSE
                                   'MISSING'
                           END
                       ELSE
                           'MISSING'
                   END
           END AS EcoDisStatusCode,
           CASE
               WHEN @useCutOffDate = 1 THEN
                   CASE
                       WHEN statusHomeless.StatusValue IS NULL THEN
                           'MISSING'
                       WHEN s.SubmissionYearDate
                            BETWEEN statusHomeless.StatusStartDate AND ISNULL(statusHomeless.StatusEndDate, GETDATE()) THEN
                           CASE
                               WHEN statusHomeless.StatusValue = 1 THEN
                                   'Homeless'
                               ELSE
                                   'MISSING'
                           END
                       ELSE
                           'MISSING'
                   END
               ELSE
                   CASE
                       WHEN statusHomeless.StatusValue IS NULL THEN
                           'MISSING'
                       WHEN statusHomeless.StatusStartDate <= s.SubmissionYearEndDate
                            AND ISNULL(statusHomeless.StatusEndDate, GETDATE()) >= s.SubmissionYearStartDate THEN
                           CASE
                               WHEN statusHomeless.StatusValue = 1 THEN
                                   'Homeless'
                               ELSE
                                   'MISSING'
                           END
                       ELSE
                           'MISSING'
                   END
           END AS HomelessStatusCode,
           CASE
               WHEN @useCutOffDate = 1 THEN
                   CASE
                       WHEN statusHomelessUY.StatusValue IS NULL THEN
                           'MISSING'
                       WHEN s.SubmissionYearDate
                            BETWEEN statusHomelessUY.StatusStartDate AND ISNULL(statusHomelessUY.StatusEndDate, GETDATE()) THEN
                           CASE
                               WHEN statusHomelessUY.StatusValue = 1 THEN
                                   'UY'
                               ELSE
                                   'MISSING'
                           END
                       ELSE
                           'MISSING'
                   END
               ELSE
                   CASE
                       WHEN statusHomelessUY.StatusValue IS NULL THEN
                           'MISSING'
                       WHEN statusHomelessUY.StatusStartDate <= s.SubmissionYearEndDate
                            AND ISNULL(statusHomelessUY.StatusEndDate, GETDATE()) >= s.SubmissionYearStartDate THEN
                           CASE
                               WHEN statusHomelessUY.StatusValue = 1 THEN
                                   'UY'
                               ELSE
                                   'MISSING'
                           END
                       ELSE
                           'MISSING'
                   END
           END AS HomelessUYStatusCode,
           CASE
               WHEN @useCutOffDate = 1 THEN
                   CASE
                       WHEN statusLep.StatusValue IS NULL THEN
                           'MISSING'
                       WHEN s.SubmissionYearDate
                            BETWEEN statusLep.StatusStartDate AND ISNULL(statusLep.StatusEndDate, GETDATE()) THEN
                           CASE
                               WHEN statusLep.StatusValue = 1 THEN
                                   'LEP'
                               ELSE
                                   'NLEP'
                           END
                       ELSE
                           'MISSING'
                   END
               ELSE
                   CASE
                       WHEN statusLep.StatusValue IS NULL THEN
                           'MISSING'
                       WHEN statusLep.StatusStartDate <= s.SubmissionYearEndDate
                            AND ISNULL(statusLep.StatusEndDate, GETDATE()) >= s.SubmissionYearStartDate THEN
                           CASE
                               WHEN statusLep.StatusValue = 1 THEN
                                   'LEP'
                               ELSE
                                   'NLEP'
                           END
                       ELSE
                           'MISSING'
                   END
           END AS LepStatusCode,
           CASE
               WHEN @useCutOffDate = 1 THEN
                   CASE
                       WHEN statusMigrant.StatusValue IS NULL THEN
                           'MISSING'
                       WHEN s.SubmissionYearDate
                            BETWEEN statusMigrant.StatusStartDate AND ISNULL(statusMigrant.StatusEndDate, GETDATE()) THEN
                           CASE
                               WHEN statusMigrant.StatusValue = 1 THEN
                                   'Migrant'
                               ELSE
                                   'MISSING'
                           END
                       ELSE
                           'MISSING'
                   END
               ELSE
                   CASE
                       WHEN statusMigrant.StatusValue IS NULL THEN
                           'MISSING'
                       WHEN statusMigrant.StatusStartDate <= d.SubmissionYearEndDate
                            AND ISNULL(statusMigrant.StatusEndDate, GETDATE()) >= d.SubmissionYearStartDate THEN
                           CASE
                               WHEN statusMigrant.StatusValue = 1 THEN
                                   'Migrant'
                               ELSE
                                   'MISSING'
                           END
                       ELSE
                           'MISSING'
                   END
           END AS MigrantStatusCode,
           ISNULL(sex.Code, 'MISSING') AS SexCode,
           CASE
               WHEN ISNULL(militaryStatus.RefMilitaryConnectedStudentIndicatorId, 0) = 0 THEN
                   'MISSING'
               ELSE
                   'MILCNCTD'
           END AS 'MilitaryConnectedStatus',
           CASE
               WHEN dt.Code = 'Shelters' THEN
                   'STH'
               WHEN dt.Code = 'DoubledUp' THEN
                   'D'
               WHEN dt.Code = 'Unsheltered' THEN
                   'U'
               WHEN dt.Code = 'HotelMotel' THEN
                   'HM'
               ELSE
                   ISNULL(dt.Code, 'MISSING')
           END AS HomelessNighttimeResidence,
           startDate.RecordStartDateTime,
           endDate.RecordStartDateTime - 1 AS RecordEndDateTime
    FROM #DATECTE startDate
        LEFT JOIN #DATECTE endDate
            ON startDate.PersonId = endDate.PersonId
               AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
        INNER JOIN @studentDates s
            ON s.PersonId = startDate.PersonId
               AND startDate.RecordStartDateTime
               BETWEEN s.SubmissionYearStartDate AND ISNULL(s.SubmissionYearEndDate, GETDATE())
        INNER JOIN ods.PersonDetail p
            ON p.PersonId = s.PersonId
               AND startDate.RecordStartDateTime
               BETWEEN p.RecordStartDateTime AND ISNULL(p.RecordEndDateTime, GETDATE())
        LEFT OUTER JOIN ods.RefSex sex
            ON p.RefSexId = sex.RefSexId
        LEFT OUTER JOIN ods.PersonStatus statusEcoDis
            ON p.PersonId = statusEcoDis.PersonId
               AND startDate.RecordStartDateTime
               BETWEEN statusEcoDis.StatusStartDate AND ISNULL(statusEcoDis.StatusEndDate, GETDATE())
               AND statusEcoDis.RefPersonStatusTypeId = @ecoDisPersonStatusTypeId
        LEFT OUTER JOIN ods.PersonStatus statusHomeless
            ON p.PersonId = statusHomeless.PersonId
               AND startDate.RecordStartDateTime
               BETWEEN statusHomeless.StatusStartDate AND ISNULL(statusHomeless.StatusEndDate, GETDATE())
               AND statusHomeless.RefPersonStatusTypeId = @homelessPersonStatusTypeId
        LEFT OUTER JOIN ods.PersonStatus statusHomelessUY
            ON p.PersonId = statusHomelessUY.PersonId
               AND startDate.RecordStartDateTime
               BETWEEN statusHomelessUY.StatusStartDate AND ISNULL(statusHomelessUY.StatusEndDate, GETDATE())
               AND statusHomelessUY.RefPersonStatusTypeId = @homelessUnaccompaniedYouthPersonStatusTypeId
        LEFT OUTER JOIN ods.PersonStatus statusLep
            ON p.PersonId = statusLep.PersonId
               AND startDate.RecordStartDateTime
               BETWEEN statusLep.StatusStartDate AND ISNULL(statusLep.StatusEndDate, GETDATE())
               AND statusLep.RefPersonStatusTypeId = @lepPersonStatusTypeId
        LEFT OUTER JOIN ods.PersonStatus statusMigrant
            ON p.PersonId = statusMigrant.PersonId
               AND startDate.RecordStartDateTime
               BETWEEN statusMigrant.StatusStartDate AND ISNULL(statusMigrant.StatusEndDate, GETDATE())
               AND statusMigrant.RefPersonStatusTypeId = @migrantPersonStatusTypeId
        LEFT JOIN ods.PersonMilitary militaryStatus
            ON militaryStatus.PersonId = p.PersonId
        LEFT OUTER JOIN ods.PersonHomelessness ph
            ON ph.PersonId = p.PersonId
               AND startDate.RecordStartDateTime
               BETWEEN ph.RecordStartDateTime AND ISNULL(ph.RecordEndDateTime, GETDATE())
               AND ISNULL(ph.RecordStartDateTime, s.SubmissionYearDate) <= CASE
                                                                               WHEN @useCutOffDate = 0 THEN
                                                                                   s.SubmissionYearEndDate
                                                                               ELSE
                                                                                   s.SubmissionYearDate
                                                                           END
               AND ISNULL(ph.RecordEndDateTime, GETDATE()) >= CASE
                                                                  WHEN @useCutOffDate = 0 THEN
                                                                      s.SubmissionYearStartDate
                                                                  ELSE
                                                                      s.SubmissionYearDate
                                                              END
        LEFT JOIN ods.RefHomelessNighttimeResidence dt
            ON dt.RefHomelessNighttimeResidenceId = ph.RefHomelessNighttimeResidenceId;

    DROP TABLE #DATECTE;
END;