CREATE FUNCTION [RDS].[Get_DimDate]
(
	@date as Date
)
RETURNS INT
AS
BEGIN
	declare @dimDateId as INT
	select @dimDateId = ISNULL(DimDateId, -1) from rds.DimDates where DateValue = @date
	return @dimDateId
END