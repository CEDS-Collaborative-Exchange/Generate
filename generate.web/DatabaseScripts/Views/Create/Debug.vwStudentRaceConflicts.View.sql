CREATE VIEW [Debug].[vwStudentRaceConflicts]
AS
    -- Students whose race differs between LEAs/Schools in the same school year.
    -- These students can be counted more than once when rolled up to the SEA.
    SELECT
        rm.StudentIdentifierState
        , rm.LeaIdentifierSeaAccountability
        , rm.SchoolIdentifierSea
        , rm.RaceMap
        , rm.SchoolYear
        , conflicts.DistinctRaceCount
    FROM RDS.vwUnduplicatedRaceMap rm
    JOIN (
        SELECT
            StudentIdentifierState
            , SchoolYear
            , COUNT(DISTINCT RaceMap) AS DistinctRaceCount
        FROM RDS.vwUnduplicatedRaceMap
        GROUP BY
            StudentIdentifierState
            , SchoolYear
        HAVING COUNT(DISTINCT RaceMap) > 1
    ) conflicts
        ON rm.StudentIdentifierState = conflicts.StudentIdentifierState
        AND rm.SchoolYear = conflicts.SchoolYear
