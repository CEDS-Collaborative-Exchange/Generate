CREATE PROCEDURE [dbo].[Get_AssessmentTypeChildrenWithDisabilities]
AS
BEGIN

    SELECT [RefAssessmentTypeChildrenWithDisabilitiesId]
          ,[Description]
          ,[Code]
          ,[Definition]
          ,[RefJurisdictionId]
          ,[SortOrder]
      FROM [dbo].[RefAssessmentTypeChildrenWithDisabilities]

END