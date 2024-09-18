-- Metadata changes for the RDS schema
----------------------------------
set nocount on
begin try
	begin transaction	

	  declare @dimDateId as int

IF NOT EXISTS( SELECT 1 from rds.DimDates where SubmissionYear = '2020-21')
BEGIN

        INSERT INTO [RDS].[DimDates]
                   ([DateValue]
                   ,[Day]
                   ,[DayOfWeek]
                   ,[DayOfYear]
                   ,[Month]
                   ,[MonthName]
                   ,[SubmissionYear]
                   ,[Year])
             VALUES
                   ('2020-11-01',1,'Sunday', 305, 11, 'November', '2020-21', 2020)


        select @dimDateId = DimDateId from rds.DimDates where SubmissionYear = '2020-21'

        INSERT INTO [RDS].[DimDateDataMigrationTypes]
                   ([DimDateId]
                   ,[DataMigrationTypeId]
                   ,[IsSelected])
             VALUES(@dimDateId, 1, 0)

        INSERT INTO [RDS].[DimDateDataMigrationTypes]
                   ([DimDateId]
                   ,[DataMigrationTypeId]
                   ,[IsSelected])
             VALUES(@dimDateId, 2, 0)

        INSERT INTO [RDS].[DimDateDataMigrationTypes]
                   ([DimDateId]
                   ,[DataMigrationTypeId]
                   ,[IsSelected])
             VALUES(@dimDateId, 3, 0)

        END


	commit transaction
end try
 
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch
 
set nocount off