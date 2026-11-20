CREATE VIEW [Debug].[vwStudentSexConflicts]
AS
    -- Students whose sex differs between LEAs/Schools in the same school year.
    -- These students can be counted more than once when rolled up to the SEA.
    SELECT DISTINCT
        ske.StudentIdentifierState
        , ske.LeaIdentifierSeaAccountability
        , ske.SchoolIdentifierSea
        , ske.Sex
        , ske.SchoolYear
        , conflicts.DistinctSexCount
    FROM Staging.K12Enrollment ske
    JOIN (
        SELECT
            StudentIdentifierState
            , SchoolYear
            , COUNT(DISTINCT Sex) AS DistinctSexCount
        FROM Staging.K12Enrollment
        GROUP BY
            StudentIdentifierState
            , SchoolYear
        HAVING COUNT(DISTINCT Sex) > 1
            AND COUNT(DISTINCT ISNULL(LeaIdentifierSeaAccountability, '') + '|' + ISNULL(SchoolIdentifierSea, '')) > 1
    ) conflicts
        ON ske.StudentIdentifierState = conflicts.StudentIdentifierState
        AND ske.SchoolYear = conflicts.SchoolYear
