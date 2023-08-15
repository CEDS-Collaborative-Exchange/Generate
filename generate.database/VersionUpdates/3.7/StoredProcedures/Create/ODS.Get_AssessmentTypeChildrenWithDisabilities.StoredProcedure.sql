CREATE PROCEDURE [ODS].[Get_AssessmentTypeChildrenWithDisabilities]
AS
BEGIN

    SELECT [RefAssessmentTypeChildrenWithDisabilitiesId]
          ,[Description]
          ,[Code]
          ,[Definition]
          ,[RefJurisdictionId]
          ,[SortOrder]
      FROM [ODS].[RefAssessmentTypeChildrenWithDisabilities]

END