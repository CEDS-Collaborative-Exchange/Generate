CREATE VIEW [RDS].[vwDimTitleIIIStatuses] AS
SELECT 
titleIII.DimTitleIIIStatusId
,rsy.SchoolYear
,titleIII.TitleIIIAccountabilityProgressStatusCode
,ssrd.InputCode as TitleIIIAccountabilityProgressStatusMap
,titleIII.ProficiencyStatusCode 
,ssrd2.InputCode as ProficiencyStatusCodeMap
,titleIII.TitleiiiLanguageInstructionCode
,ssrd3.InputCode as TitleiiiLanguageInstructionMap
FROM RDS.DimTitleIIIStatuses  titleIII
CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
LEFT JOIN Staging.SourceSystemReferenceData ssrd
on titleIII.TitleIIIAccountabilityProgressStatusCode = ssrd.OutputCode
AND ssrd.TableName = 'RefTitleIIIAccountability'
AND rsy.SchoolYear = ssrd.SchoolYear
LEFT JOIN Staging.SourceSystemReferenceData ssrd2
on titleIII.ProficiencyStatusCode = ssrd2.OutputCode
and ssrd2.TableName  = 'RefProficiencyStatus'
AND rsy.SchoolYear = ssrd2.SchoolYear
LEFT JOIN Staging.SourceSystemReferenceData ssrd3
on titleIII.TitleiiiLanguageInstructionCode = ssrd3.OutputCode
and ssrd3.TableName  = 'RefTitleIIILanguageInstructionProgramType'
AND rsy.SchoolYear = ssrd3.SchoolYear
WHERE titleIII.FormerEnglishLearnerYearStatusCode = 'MISSING'