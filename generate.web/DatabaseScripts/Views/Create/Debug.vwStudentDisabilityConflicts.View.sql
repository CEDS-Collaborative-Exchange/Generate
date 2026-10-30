CREATE VIEW [Debug].[vwStudentDisabilityConflicts]
AS
    -- Students whose primary IDEA disability type differs between LEAs/Schools in the same school year,
    -- including students with a disability at one LEA/School and no disability at another.
    -- These students can be counted more than once when rolled up to the SEA.
    WITH StudentDisabilities AS (
        SELECT DISTINCT
            ske.StudentIdentifierState
            , ske.LeaIdentifierSeaAccountability
            , ske.SchoolIdentifierSea
            , sidt.IdeaDisabilityTypeCode
            , ske.SchoolYear
        FROM Staging.K12Enrollment ske
        LEFT JOIN Staging.IdeaDisabilityType sidt
            ON ske.StudentIdentifierState = sidt.StudentIdentifierState
            AND ske.SchoolYear = sidt.SchoolYear
            AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(sidt.LeaIdentifierSeaAccountability, '')
            AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(sidt.SchoolIdentifierSea, '')
            AND sidt.IsPrimaryDisability = 1
    )
    SELECT
        sd.StudentIdentifierState
        , sd.LeaIdentifierSeaAccountability
        , sd.SchoolIdentifierSea
        , sd.IdeaDisabilityTypeCode
        , sd.SchoolYear
        , conflicts.DistinctDisabilityTypeCount
    FROM StudentDisabilities sd
    JOIN (
        SELECT
            StudentIdentifierState
            , SchoolYear
            , COUNT(DISTINCT ISNULL(IdeaDisabilityTypeCode, 'NONE')) AS DistinctDisabilityTypeCount
        FROM StudentDisabilities
        GROUP BY
            StudentIdentifierState
            , SchoolYear
        HAVING COUNT(DISTINCT ISNULL(IdeaDisabilityTypeCode, 'NONE')) > 1
            AND COUNT(DISTINCT ISNULL(LeaIdentifierSeaAccountability, '') + '|' + ISNULL(SchoolIdentifierSea, '')) > 1
    ) conflicts
        ON sd.StudentIdentifierState = conflicts.StudentIdentifierState
        AND sd.SchoolYear = conflicts.SchoolYear
