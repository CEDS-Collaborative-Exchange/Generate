
CREATE FUNCTION [App].[Get_CategoriesByCategorySet]
(
	@CategorySetId as Int,
	@wrapCategoryCode as bit = 0,
	@asReportFields as bit = 0
)
RETURNS Varchar(MAX)
AS
BEGIN

	DECLARE @categories Varchar(MAX)

	declare @wrapText as varchar(1)
	set @wrapText = ''
	if @wrapCategoryCode = 1
	begin
		set @wrapText = '|'
	end

	if @asReportFields = 1
	begin
		SELECT @categories = COALESCE(@categories+',' ,'') + @wrapText + upper(d.DimensionFieldName) + @wrapText
		FROM [App].[CategorySet_Categories] csc
		inner join [App].[Categories] c on csc.CategoryId = c.CategoryId
		inner join [App].[Category_Dimensions] csd on c.CategoryId = csd.CategoryId
		inner join [App].[Dimensions] d on csd.DimensionId = d.DimensionId
		WHERE csc.CategorySetId = @CategorySetId
		order by d.DimensionFieldName
	end
	else
	begin
		SELECT @categories = COALESCE(@categories+',' ,'') + @wrapText + c.[CategoryCode] + @wrapText
		FROM [App].[CategorySet_Categories] csc
		inner join [App].[Categories] c on csc.CategoryId = c.CategoryId
		WHERE csc.CategorySetId = @CategorySetId
		order by c.CategoryCode
	end


	return @categories;

END
