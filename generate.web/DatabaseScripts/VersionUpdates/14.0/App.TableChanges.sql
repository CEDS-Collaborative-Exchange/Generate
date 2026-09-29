-- App schema table changes for release 14.0

--Add metadata for the 'AssessedFirstTime' dimension to the 'FIRSTASSESS' category
if (select 1
	from app.Category_Dimensions cd
		inner join app.Categories c
			on cd.CategoryId = c.CategoryId
		inner join app.Dimensions d
			on cd.DimensionId = d.DimensionId
	where c.CategoryCode = 'FIRSTASSESS'
	and d.DimensionFieldName = 'AssessedFirstTime') <> 1
begin

	declare @categoryId int = (select min(categoryId) from app.Categories where CategoryCode = 'FIRSTASSESS')
	declare @dimensionId int = (select dimensionId from app.Dimensions where DimensionFieldName = 'AssessedFirstTime')

	insert into app.Category_Dimensions select @categoryId, @dimensionId

end

print 'App.TableChanges.sql executed for 14.0.'
