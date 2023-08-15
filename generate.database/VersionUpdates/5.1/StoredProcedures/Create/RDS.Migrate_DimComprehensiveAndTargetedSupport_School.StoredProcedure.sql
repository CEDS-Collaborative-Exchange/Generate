CREATE PROCEDURE [RDS].[Migrate_DimComprehensiveAndTargetedSupport_School]
    @orgDates AS RDS.SchoolDateTableType READONLY,
    @dataCollectionId AS INT = NULL
AS
BEGIN
    SELECT org.DimSchoolYearId, s.DimK12SchoolId--, k12status.K12SchoolStatusId, sch.OrganizationId
    ,ISNULL(cts.Code, 'MISSING') AS ComprehensiveAndTargetedSupportCode,
        ISNULL(cs.Code, 'MISSING') AS ComprehensiveSupportCode,
        ISNULL(ts.Code, 'MISSING') AS TargetedSupportCode
    FROM dbo.K12SchoolStatus k12status
    JOIN dbo.K12School sch ON k12status.K12SchoolId = sch.K12SchoolId AND sch.RecordEndDateTime IS NULL
        AND (@dataCollectionId IS NULL OR k12status.DataCollectionId = @dataCollectionId)
    JOIN rds.DimK12Schools s ON s.SchoolOrganizationId = sch.OrganizationId AND s.RecordEndDateTime IS NULL
    JOIN @orgDates org ON org.DimSchoolId = s.DimK12SchoolId
    AND
    org.SubmissionYearStartDate <= ISNULL(k12status.RecordEndDateTime, getdate())
    AND k12status.RecordStartDateTime <= org.SubmissionYearEndDate
    LEFT JOIN dbo.RefComprehensiveAndTargetedSupport cts ON cts.RefComprehensiveAndTargetedSupportId=k12status.RefComprehensiveAndTargetedSupportId
    LEFT JOIN dbo.RefComprehensiveSupport cs ON cs.RefComprehensiveSupportId=k12status.RefComprehensiveSupportId
    LEFT JOIN dbo.RefTargetedSupport ts ON ts.RefTargetedSupportId=k12status.RefTargetedSupportId
    WHERE (@dataCollectionId IS NULL OR k12Status.DataCollectionId = @dataCollectionId)
    GROUP BY s.DimK12SchoolId,  org.DimSchoolYearId, k12status.RecordStartDateTime, cts.Code, cs.Code, ts.Code --, k12status.K12SchoolStatusId, sch.OrganizationId
    having (k12status.RecordStartDateTime = MAX(k12status.RecordStartDateTime))
END