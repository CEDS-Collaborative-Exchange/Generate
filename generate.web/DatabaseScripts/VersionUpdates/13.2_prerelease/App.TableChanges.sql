---------------------------------------
--Changes for File 160
--------------------------------------- 
    IF NOT EXISTS (select 1 from app.DimensionTables where DimensionTableName = 'DimPsEnrollmentStatuses')
    BEGIN
        insert into app.DimensionTables
        values ('DimPsEnrollmentStatuses', 1)
    END

    update app.Dimensions
    set DimensionTableId = (select DimensionTableId
                            from app.DimensionTables
                            where DimensionTableName = 'DimPsEnrollmentStatuses')
    where DimensionFieldName = 'PostSecondaryEnrollmentStatus'
