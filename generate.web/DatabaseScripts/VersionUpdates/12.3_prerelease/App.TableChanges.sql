--Set the dimension for Disability Status for 037
update app.FileColumns
set DimensionId = 145
where ColumnName = 'DisabilityStatusID'
and DisplayName = 'Disability Status (Only)'
