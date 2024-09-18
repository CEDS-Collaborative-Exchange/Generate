declare @dimensionId as int
select @dimensionId = dimensionid from app.Dimensions where DimensionFieldName = 'StaffCategorySpecialEd'
Update app.FileColumns set DimensionId = @dimensionId where ColumnName = 'StaffCategoryID' and DisplayName like '%(Special Education)%'
