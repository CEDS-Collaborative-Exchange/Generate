CREATE PROCEDURE [App].[Get_GradeLevels]
	   @gradeLevelType as varchar(50)
AS
BEGIN

		select distinct 
			  DimGradeLevelId AS RefGradeLevelId
			, GradeLevelDescription AS Description
			, GradeLevelCode AS Code
			, NULL AS Definition
			, '000100' AS RefGradeLevelTypeId
		from RDS.DimGradeLevels
		order by GradeLevelCode

END
