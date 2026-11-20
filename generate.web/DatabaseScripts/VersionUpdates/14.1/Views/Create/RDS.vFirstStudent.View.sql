
CREATE VIEW [RDS].[vFirstStudent] AS
  SELECT MIN(DimStudentID) as DimStudentID, DimSchoolID, DimCountDateId, DimFactTypeId
    FROM rds.FactStudentCounts fact 
   WHERE DimSchoolID <> -1 and DimStudentID <> -1 
   GROUP BY DimSchoolID, DimCountDateId, DimFactTypeId
