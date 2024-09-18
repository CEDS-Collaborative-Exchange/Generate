---------------------------------
-- Restore Generate Database
---------------------------------

-- This script should be run from the master database using a login with sufficient privileges
-- Prior to running, be sure to modify the database name, version, and files path as needed
-- This script will only restore if needed, if you want to force a restore set @forceRestore = 1

-- NOTE - this file has been preconfigured with settings for the AEM test server

-- ** For production environments, please use the RestoreDatabase.sql script instead

declare @databaseName as nvarchar(100)
set @databaseName = 'generate-test'
declare @databaseVersion as nvarchar(50)
set @databaseVersion = '3.0'
declare @databaseFilesPath as nvarchar(500)
set @databaseFilesPath = 'D:\Data\generate_' + @databaseVersion + '.bak'
declare @forceRestore as bit
set @forceRestore = 1

declare @dataPath as nvarchar(500)
declare @logPath as nvarchar(500)
set @dataPath = convert(nvarchar(500), SERVERPROPERTY('InstanceDefaultDataPath'))
set @logPath = convert(nvarchar(500), SERVERPROPERTY('InstanceDefaultLogPath'))

set @dataPath = 'D:\data\' + @databaseName
set @logPath = 'D:\data\' + @databaseName

declare @sql as nvarchar(max)
declare @paramDefinition as nvarchar(max)

set @sql = '
declare @shouldRestore as bit
set @shouldRestore = 0

print ''Checking database to see if restore is required''

-- Check if database exists
IF DB_ID (@databaseName) IS NOT NULL
BEGIN
	print ''- Database exists''

	-- Check if AppSettings table exists

	IF (EXISTS (SELECT * FROM [' + @databaseName + '].INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG = ''' + @databaseName + ''' AND TABLE_SCHEMA = ''App'' AND TABLE_NAME = ''GenerateConfigurations''))
	BEGIN
		print ''- GenerateConfigurations exists''

		declare @currentVersion as float
		select @currentVersion = convert(float, replace(GenerateConfigurationValue, ''_prerelease'', ''''))
		from [' + @databaseName + '].App.GenerateConfigurations where GenerateConfigurationCategory = ''Database'' and GenerateConfigurationKey = ''DatabaseVersion''

		if (@currentVersion < convert(float, @databaseVersion))
		BEGIN
			print ''- Current version is too old ('' + convert(varchar(20), @currentVersion) + '')''
			set @shouldRestore = 1
		END
		ELSE
		BEGIN
			print ''- Version is equal to or newer than required''
		END
	END
	ELSE
	BEGIN
		print ''- GenerateConfigurations does not exist''
			set @shouldRestore = 1
	END

END
ELSE
BEGIN
	print ''- Database does not exist''
	set @shouldRestore = 1
END

if @shouldRestore = 1 or @forceRestore = 1
BEGIN

	if @forceRestore = 1
	BEGIN
		print ''- Restore is being forced''
	END
	ELSE
	BEGIN
		print ''- Restore is required''
	END

	-- If already exists, set into single_user mode
	IF DB_ID (@databaseName) IS NOT NULL
	BEGIN
		ALTER DATABASE [' + @databaseName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	END

	-- Restore
	RESTORE DATABASE [' + @databaseName + '] FROM DISK = @databaseFilesPath WITH 
		NOUNLOAD, 
		REPLACE,
		MOVE ''generate-test'' TO ''' + @dataPath + '\\' + @databaseName + '.mdf'',   
		MOVE ''generate-test_log'' TO ''' + @logPath + '\\' + @databaseName + '_log.mdf''

	-- Set into multi_user mode
	ALTER DATABASE [' + @databaseName + '] SET MULTI_USER;

	-- Set version number
	update [' + @databaseName + '].App.GenerateConfigurations set GenerateConfigurationValue = @databaseVersion where GenerateConfigurationCategory = ''Database'' and GenerateConfigurationKey = ''DatabaseVersion''

END
ELSE
BEGIN
	print ''- Restore is NOT required''
END';


SET @paramDefinition = N'@databaseName nvarchar(100), @databaseVersion nvarchar(50), @databaseFilesPath nvarchar(500), @forceRestore bit';  
EXECUTE sp_executesql @sql, @paramDefinition, @databaseName = @databaseName, @databaseVersion = @databaseVersion, @databaseFilesPath = @databaseFilesPath, @forceRestore = @forceRestore;

