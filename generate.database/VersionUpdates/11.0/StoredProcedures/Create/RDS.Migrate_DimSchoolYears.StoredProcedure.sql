CREATE PROCEDURE [RDS].[Migrate_DimSchoolYears]
	@DateValue DATETIME
AS
BEGIN

	SELECT
		  DimSchoolYearId
	FROM RDS.DimSchoolYears sy
	WHERE @DateValue BETWEEN sy.SessionBeginDate AND sy.SessionEndDate

END