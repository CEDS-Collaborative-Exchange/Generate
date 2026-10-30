-- Drop each stored procedure found in the previous step
DECLARE @procedureName NVARCHAR(128);
DECLARE @dropQuery NVARCHAR(MAX);

DECLARE procedure_cursor CURSOR FOR

SELECT ROUTINE_SCHEMA + '.' + ROUTINE_NAME
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_NAME LIKE '%_TestCase'
    OR ROUTINE_NAME like '%_DMC'

OPEN procedure_cursor;
FETCH NEXT FROM procedure_cursor INTO @procedureName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @dropQuery = 'DROP PROCEDURE ' + @procedureName;
    EXEC sp_executesql @dropQuery;
    FETCH NEXT FROM procedure_cursor INTO @procedureName;
END

CLOSE procedure_cursor;
DEALLOCATE procedure_cursor;