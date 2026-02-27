 declare @factTableId as int, @dimensionTableId as int,  @categoryId as INT, @dimensionId as INT
 
 Update app.FileColumns set ReportColumn = 'MailingAddressCity' where ColumnName = 'MailingCity'
 Update app.FileColumns set ReportColumn = 'MailingAddressPostalCode' where ColumnName = 'MailingZipcode'
 Update app.FileColumns set ReportColumn = 'MailingAddressState' where ColumnName = 'MailingPostalStateCode'

---------------------------------------
--Changes for File 160
--------------------------------------- 
   

    IF NOT EXISTS (select 1 from app.DimensionTables where DimensionTableName = 'DimPsEnrollmentStatuses')
    BEGIN
        insert into app.DimensionTables
        values ('DimPsEnrollmentStatuses', 1)
    END

    select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimPsEnrollmentStatuses'

    update app.Dimensions
    set DimensionTableId = @dimensionTableId
    where DimensionFieldName = 'PostSecondaryEnrollmentStatus'

    select @factTableId = FactTableId from app.FactTables where FactTableName = 'FactK12StudentCounts'
	

	IF NOT EXISTS (select 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
	BEGIN
		insert into app.FactTable_DimensionTables(FactTableId, DimensionTableId)
		values (@factTableId, @dimensionTableId)
	END

---------------------------------------
--Changes for File 116
--------------------------------------- 
    update app.filecolumns
    set dimensionid = 55
        , ReportColumn = 'TITLEIIILANGUAGEINSTRUCTIONPROGRAMTYPE'
    where ReportColumn = 'TITLEIIILANGUAGEINSTRUCTION'

   

    select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'EdFactsCertificationStatus'
    select @categoryId = CategoryId from app.Categories where CategoryCode = 'CERTSTATUSTLIII'

    IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
    BEGIN
        INSERT INTO [App].[Category_Dimensions]
                   ([CategoryId]
                   ,[DimensionId])
             VALUES (@categoryId, @dimensionId)
    END

    exec App.UpdateViewDefinitions