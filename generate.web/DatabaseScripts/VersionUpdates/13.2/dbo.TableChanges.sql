	SET NOCOUNT ON;

/*
    Drops all user tables in [dbo].
    - First drops foreign keys that involve dbo tables (including cross-schema references).
    - Then drops all dbo tables.

    Safety:
    - Set @Execute = 0 to preview generated statements without executing.
*/

	DECLARE @Execute BIT = 1;
	DECLARE @Sql NVARCHAR(MAX) = N'';

	-- 1) Drop foreign keys that would block dropping dbo tables
	SELECT @Sql = @Sql +
		N'ALTER TABLE ' + QUOTENAME(ps.name) + N'.' + QUOTENAME(pt.name) +
		N' DROP CONSTRAINT ' + QUOTENAME(fk.name) + N';' + CHAR(13) + CHAR(10)
	FROM sys.foreign_keys fk
	JOIN sys.tables pt
		ON fk.parent_object_id = pt.object_id
	JOIN sys.schemas ps
		ON pt.schema_id = ps.schema_id
	JOIN sys.tables rt
		ON fk.referenced_object_id = rt.object_id
	JOIN sys.schemas rs
		ON rt.schema_id = rs.schema_id
	WHERE ps.name = N'dbo'
	   OR rs.name = N'dbo';

	IF @Sql <> N''
	BEGIN
		PRINT N'-- Dropping foreign keys';
		IF @Execute = 1
			EXEC sys.sp_executesql @Sql;
		ELSE
			PRINT @Sql;
	END
	ELSE
	BEGIN
		PRINT N'-- No foreign keys found to drop.';
	END;

	-- 2) Drop all dbo tables
	SET @Sql = N'';

	SELECT @Sql = @Sql +
		N'DROP TABLE ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name) + N';' + CHAR(13) + CHAR(10)
	FROM sys.tables t
	JOIN sys.schemas s
		ON t.schema_id = s.schema_id
	WHERE s.name = N'dbo'
	  AND t.is_ms_shipped = 0;

	IF @Sql <> N''
	BEGIN
		PRINT N'-- Dropping dbo tables';
		IF @Execute = 1
			EXEC sys.sp_executesql @Sql;
		ELSE
			PRINT @Sql;
	END
	ELSE
	BEGIN
		PRINT N'-- No dbo tables found.';
	END;
