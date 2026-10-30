
CREATE VIEW [RDS].[vFirstStudent_DimIdeaStatusID] AS
  SELECT MIN(DimStudentID) as DimStudentID, DimSchoolID, DimCountDateId, DimFactTypeId, DimIdeaStatusId
    FROM rds.FactStudentCounts fact
   WHERE DimSchoolID <> -1 and DimStudentID <> -1 
   GROUP BY DimSchoolID, DimCountDateId, DimFactTypeId, DimIdeaStatusId

