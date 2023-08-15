-- Metadata changes for the ODS schema
----------------------------------
set nocount on
begin try
	begin transaction

			if not exists(select 1 from ods.RefLeaType where Code = 'IndependentCharterDistrict')
			BEGIN

				INSERT INTO [ODS].[RefLeaType]([Description],[Code],[Definition],[SortOrder])
				VALUES('Independent Charter District','IndependentCharterDistrict','An independent charter district is an education unit created under the state charter legislation that is not under the administrative control of another local education agency and that operates one or more charter schools – and only charter schools.',9.00)

			END
			   
		  if not exists(select 1 from ods.RefSchoolType where Code = 'Reportable')
		  begin
			INSERT INTO [ODS].[RefSchoolType]([Description],[Code],[Definition],[SortOrder]) VALUES('Reportable Program','Reportable','The permitted value reportable program is available for SEAs that have data to report to EDFacts at the school level that the SEA has determined does not meet the definition of a public elementary/secondary school.',5.00)
		  end
		  

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
