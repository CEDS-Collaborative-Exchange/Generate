
set nocount on
begin try
begin transaction

IF EXISTS(SELECT 1 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo' and TABLE_TYPE = 'BASE TABLE' and TABLE_NAME NOT LIKE '__EFMigrationsHistory')
BEGIN
	
	/*CIID-4447 add PV USETH to Target Identification Subgroups*/
	PRINT N'Populate RefSubgroup table'

	IF EXISTS(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[RefSubgroup]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
		IF NOT EXISTS (
			SELECT 1
			FROM [dbo].[RefSubgroup]
			WHERE Code = 'UnderservedRaceEthnicity'
			)
		INSERT [dbo].[RefSubgroup] (
			[Description]
			,[Code]
			,[Definition]
			,[RefSubgroupTypeId]
			,[SortOrder]
			)
		VALUES (
			'Underserved Race/Ethnicity'
			,'UnderservedRaceEthnicity'
			,'Underserved Race/Ethnicity'
			,1
			,15
			)
	END

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
