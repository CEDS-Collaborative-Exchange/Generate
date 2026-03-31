--Remove the leading 'c' from saved snapshot tables
	DECLARE @sql NVARCHAR(MAX) = N'';

	SELECT @sql = @sql + '
	UPDATE [' + s.name + '].[' + t.name + ']
	SET [SnapshotReportCode] = STUFF([SnapshotReportCode], 1, 1, '''')
	WHERE LEFT([SnapshotReportCode], 1) = ''c'';'
	FROM sys.tables t
	INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
	INNER JOIN sys.columns c ON t.object_id = c.object_id
	WHERE s.name = 'source'
	  AND c.name = 'SnapshotReportCode';

	-- Uncomment to preview the generated SQL
	-- PRINT @sql;

	EXEC sp_executesql @sql;

-- Add SchoolYear column as INT if it does not exist in each table
	IF EXISTS (select 1 FROM sys.objects WHERE object_id = OBJECT_ID('Source.ProgramParticipationSpecialEducation'))
	BEGIN
		IF NOT EXISTS (
			SELECT 1 FROM sys.columns 
			WHERE object_id = OBJECT_ID('Source.ProgramParticipationSpecialEducation') 
			  AND name = 'SchoolYear'
		)
		BEGIN
			--Drop the columns so they can all be added in the correct order	
			ALTER TABLE Source.ProgramParticipationSpecialEducation DROP COLUMN DataCollectionName;
			ALTER TABLE Source.ProgramParticipationSpecialEducation DROP COLUMN RunDateTime;
			--Add the columns back
			ALTER TABLE Source.ProgramParticipationSpecialEducation ADD SchoolYear INT null;
			ALTER TABLE Source.ProgramParticipationSpecialEducation ADD DataCollectionName nvarchar(100) null;
			ALTER TABLE Source.ProgramParticipationSpecialEducation ADD RunDateTime datetime null;
		END
	END

	IF EXISTS (select 1 FROM sys.objects WHERE object_id = OBJECT_ID('Source.ProgramParticipationNorD'))
	BEGIN
		IF NOT EXISTS (
			SELECT 1 FROM sys.columns 
			WHERE object_id = OBJECT_ID('Source.ProgramParticipationNorD') 
			  AND name = 'SchoolYear'
		)
		BEGIN
			--Drop the columns so they can all be added in the correct order	
			ALTER TABLE Source.ProgramParticipationNorD DROP COLUMN DataCollectionName;
			--Add the columns back
			ALTER TABLE Source.ProgramParticipationNorD ADD SchoolYear INT null;
			ALTER TABLE Source.ProgramParticipationNorD ADD DataCollectionName nvarchar(100) null;
		END
	END

	IF EXISTS (select 1 FROM sys.objects WHERE object_id = OBJECT_ID('Source.ProgramParticipationTitleI'))
	BEGIN
		IF NOT EXISTS (
			SELECT 1 FROM sys.columns 
			WHERE object_id = OBJECT_ID('Source.ProgramParticipationTitleI') 
			  AND name = 'SchoolYear'
		)
		BEGIN
			--Drop the columns so they can all be added in the correct order	
			ALTER TABLE Source.ProgramParticipationTitleI DROP COLUMN DataCollectionName;
			ALTER TABLE Source.ProgramParticipationTitleI DROP COLUMN RunDateTime;
			--Add the columns back
			ALTER TABLE Source.ProgramParticipationTitleI ADD SchoolYear INT null;
			ALTER TABLE Source.ProgramParticipationTitleI ADD DataCollectionName nvarchar(100) null;
			ALTER TABLE Source.ProgramParticipationTitleI ADD RunDateTime datetime null;
		END
	END

	IF EXISTS (select 1 FROM sys.objects WHERE object_id = OBJECT_ID('Source.ProgramParticipationTitleIII'))
	BEGIN
		IF NOT EXISTS (
			SELECT 1 FROM sys.columns 
			WHERE object_id = OBJECT_ID('Source.ProgramParticipationTitleIII') 
			  AND name = 'SchoolYear'
		)
		BEGIN
			--Drop the columns so they can all be added in the correct order	
			ALTER TABLE Source.ProgramParticipationTitleIII DROP COLUMN DataCollectionName;
			--Add the columns back
			ALTER TABLE Source.ProgramParticipationTitleIII ADD SchoolYear INT null;
			ALTER TABLE Source.ProgramParticipationTitleIII ADD DataCollectionName nvarchar(100) null;
		END
	END

	IF EXISTS (select 1 FROM sys.objects WHERE object_id = OBJECT_ID('Source.PersonStatus'))
	BEGIN
		IF NOT EXISTS (
			SELECT 1 FROM sys.columns 
			WHERE object_id = OBJECT_ID('Source.PersonStatus') 
			  AND name = 'SchoolYear'
		)
		BEGIN
			--Drop the columns so they can all be added in the correct order	
			ALTER TABLE Source.PersonStatus DROP COLUMN DataCollectionName;
			ALTER TABLE Source.PersonStatus DROP COLUMN RunDateTime;
			--Add the columns back
			ALTER TABLE Source.PersonStatus ADD SchoolYear INT null;
			ALTER TABLE Source.PersonStatus ADD DataCollectionName nvarchar(100) null;
			ALTER TABLE Source.PersonStatus ADD RunDateTime datetime null;
		END
	END

--Update the SchoolYear column for snapshot tables built prior to that column existing
	IF EXISTS (select 1 FROM sys.objects WHERE object_id = OBJECT_ID('Source.ProgramParticipationSpecialEducation'))
	BEGIN
		UPDATE Source.ProgramParticipationSpecialEducation
		SET SchoolYear = SnapshotSchoolYear
		WHERE SchoolYear is NULL;
	END

	IF EXISTS (select 1 FROM sys.objects WHERE object_id = OBJECT_ID('Source.ProgramParticipationNorD'))
	BEGIN
		UPDATE Source.ProgramParticipationNorD
		SET SchoolYear = SnapshotSchoolYear
		WHERE SchoolYear is NULL;
	END

	IF EXISTS (select 1 FROM sys.objects WHERE object_id = OBJECT_ID('Source.ProgramParticipationTitleI'))
	BEGIN
		UPDATE Source.ProgramParticipationTitleI
		SET SchoolYear = SnapshotSchoolYear
		WHERE SchoolYear is NULL;
	END

	IF EXISTS (select 1 FROM sys.objects WHERE object_id = OBJECT_ID('Source.ProgramParticipationTitleIII'))
	BEGIN
		UPDATE Source.ProgramParticipationTitleIII
		SET SchoolYear = SnapshotSchoolYear
		WHERE SchoolYear is NULL;
	END

	IF EXISTS (select 1 FROM sys.objects WHERE object_id = OBJECT_ID('Source.PersonStatus'))
	BEGIN
		UPDATE Source.PersonStatus
		SET SchoolYear = SnapshotSchoolYear
		WHERE SchoolYear is NULL;
	END
