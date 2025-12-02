CREATE PROCEDURE [App].[Enable_Disable_Tests]
	@fileSpecNumbers as varchar(8000),
	@isActive bit = true
AS
BEGIN
	
	DECLARE @fsNum as varchar(10)

	DECLARE fs_cursor CURSOR FOR 
	select * from App.split(@fileSpecNumbers, ',')

	OPEN fs_cursor
	FETCH NEXT FROM fs_cursor INTO @fsNum
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		SET @fsNum = 'FS' + @fsNum
		Update app.SqlUnitTest set IsActive = @isActive where TestScope = @fsNum

		FETCH NEXT FROM fs_cursor INTO @fsNum
  	END
	CLOSE fs_cursor
	DEALLOCATE fs_cursor
END