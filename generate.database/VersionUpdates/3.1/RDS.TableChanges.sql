-- Release-Specific table changes for the RDS schema
-- e.g. new fact/dimension tables/fields
----------------------------------
set nocount on
begin try
	begin transaction
		
		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'DimLeaId' AND Object_ID = Object_ID(N'[RDS].[FactStudentAssessments]'))
		BEGIN
			ALTER TABLE [RDS].[FactStudentAssessments] ADD DimLeaId int not null default(-1)
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
