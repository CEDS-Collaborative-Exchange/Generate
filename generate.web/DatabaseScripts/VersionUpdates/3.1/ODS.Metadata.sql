-- Metadata changes for the ODS schema
----------------------------------
set nocount on
begin try
	begin transaction

		if not exists (select 1 from ods.RefCharterLeaStatus)
		begin
			INSERT INTO [ODS].[RefCharterLeaStatus]([Description],[Code],[Definition],[SortOrder]) VALUES('Not applicable','NA','Not applicable',1)
			INSERT INTO [ODS].[RefCharterLeaStatus]([Description],[Code],[Definition],[SortOrder]) VALUES('Not a charter district','NOTCHR','Not a charter district',2)
			INSERT INTO [ODS].[RefCharterLeaStatus]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('Not LEA for federal programs','CHRTNOTLEA','Charter district which is not an LEA for federal programs',3)
			INSERT INTO [ODS].[RefCharterLeaStatus]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('LEA for IDEA','CHRTIDEA','Charter district which is an LEA for programs authorized under IDEA but not under ESEA and Perkins',4)
			INSERT INTO [ODS].[RefCharterLeaStatus]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('LEA for ESEA and Perkins','CHRTESEA','Charter district which is an LEA for programs authorized under ESEA and Perkins but not under IDEA',5)
			INSERT INTO [ODS].[RefCharterLeaStatus]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('LEA for federal programs','CHRTIDEAESEA','Charter district which is an LEA for programs authorized under IDEA, ESEA and Perkins',6)
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