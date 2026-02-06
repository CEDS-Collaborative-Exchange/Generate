CREATE VIEW [RDS].[vwDimRuralStatuses]
AS
SELECT
  [DimRuralStatusId],
  rsy.SchoolYear,
  [ERSRuralUrbanContinuumCodeCode],
  ssrd.OutputCode AS [ERSRuralUrbanContinuumCodeMap],
  [RuralResidencyStatusCode],
  ssrd2.OutputCode AS [RuralResidencyStatusMap]
FROM [RDS].[DimRuralStatuses] drs
CROSS JOIN (select sy.SchoolYear
        from rds.DimSchoolYearDataMigrationTypes dm
          inner join rds.dimschoolyears sy
            on dm.dimschoolyearid = sy.dimschoolyearid
        where IsSelected = 1
        and dm.DataMigrationTypeId = 3
    ) AS rsy
LEFT JOIN [Staging].[SourceSystemReferenceData] ssrd
  ON rsy.SchoolYear = ssrd.SchoolYear
  AND drs.[ERSRuralUrbanContinuumCodeCode] = ssrd.InputCode
  AND ssrd.TableName = 'RefERSRuralUrbanContinuumCode'
LEFT JOIN [Staging].[SourceSystemReferenceData] ssrd2
  ON rsy.SchoolYear = ssrd2.SchoolYear
  AND drs.[RuralResidencyStatusCode] = ssrd2.InputCode
  AND ssrd2.TableName = 'RefRuralResidencyStatus'
	