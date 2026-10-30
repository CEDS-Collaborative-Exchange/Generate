
CREATE VIEW [RDS].[vFirstStudent_AGESA] AS
  SELECT MIN(DimStudentID) as DimStudentID, DimSchoolID, DimCountDateId, DimFactTypeId
    FROM rds.FactStudentCounts fact INNER JOIN 
	     rds.DimAges age on fact.DimAgeId = age.DimAgeId and age.AgeValue >= 6 and age.AgeValue <= 21
   WHERE DimSchoolID <> -1 and DimStudentID <> -1 
   GROUP BY DimSchoolID, DimCountDateId, DimFactTypeId
