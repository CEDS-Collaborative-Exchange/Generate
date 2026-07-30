/**********************************************************************
  14.1 - RDS (CEDS Data Warehouse) fact-table repair.

  DATA-PRESERVING UPGRADE: this script is strictly ADDITIVE and idempotent.
  It only ADDs a missing column (with a default that back-fills existing rows)
  and ADDs missing DEFAULT constraints. It performs NO drop, truncate, or
  table rebuild, so states upgrading in place keep all existing fact data
  (no reload of prior years required).

  Restore DEFAULT((-1)) on NOT NULL dimension/date key columns
         of the RDS fact tables (all RDS.Fact* tables).

  The 14.0 fact-table rebuild recreated these tables but dropped the
  DEFAULT((-1)) constraints on every key column except K12Student_CurrentId.
  As a result, any Staging->Fact procedure that does not explicitly list a
  (newly added) NOT NULL key column fails its INSERT with a
  "Cannot insert the value NULL" error. That error is swallowed by the
  procedures' generic TRY/CATCH, so the migration silently produces ZERO
  fact rows (observed across ChildCount, TitleI, Membership, etc. for 2027).

  -1 is the standard star-schema "not applicable / unknown" dimension
  member used throughout Generate (see the surviving default on
  K12Student_CurrentId). Restoring the defaults makes fact population
  robust to key columns a given fact type does not populate.

  Idempotent: only adds a default where the column currently has none.
***********************************************************************/
SET NOCOUNT ON;

-- The 14.0 fact-table rebuild also dropped RDS.FactK12StudentCounts.CteOutcomeIndicatorId,
-- which the NeglectedOrDelinquent fact proc still inserts (for FS218-221/119/127 CTE/academic
-- outcome reporting) and debug.vwNeglectedOrDelinquent_FactTable joins. Its absence made that
-- proc's INSERT fail (0 NorD facts) and the debug view fail to bind. Re-add it (NA-member default -1).
IF COL_LENGTH('RDS.FactK12StudentCounts', 'CteOutcomeIndicatorId') IS NULL
    ALTER TABLE RDS.FactK12StudentCounts
        ADD CteOutcomeIndicatorId INT NOT NULL
            CONSTRAINT DF_FactK12StudentCounts_CteOutcomeIndicatorId DEFAULT((-1));

DECLARE @facts TABLE (tbl sysname);
-- All RDS fact tables (the 14.0 rebuild dropped the NA-member -1 defaults across the board).
INSERT INTO @facts (tbl)
SELECT 'RDS.' + name FROM sys.tables
WHERE SCHEMA_NAME(schema_id) = 'RDS' AND name LIKE 'Fact%';

DECLARE @sql nvarchar(max) = N'';

SELECT @sql = @sql
    + 'ALTER TABLE ' + f.tbl
    + ' ADD CONSTRAINT [DF_' + OBJECT_NAME(c.object_id) + '_' + c.name + ']'
    + ' DEFAULT((-1)) FOR ' + QUOTENAME(c.name) + ';' + CHAR(10)
FROM @facts f
JOIN sys.columns c
    ON c.object_id = OBJECT_ID(f.tbl)
LEFT JOIN sys.default_constraints dc
    ON dc.parent_object_id = c.object_id
    AND dc.parent_column_id = c.column_id
WHERE OBJECT_ID(f.tbl) IS NOT NULL
    AND c.is_nullable = 0
    AND c.is_identity = 0
    AND dc.object_id IS NULL      -- no existing default
    AND c.name LIKE '%Id';        -- dimension / date foreign keys only (never the StudentCount measure)

IF @sql <> N''
BEGIN
    PRINT @sql;
    EXEC sp_executesql @sql;
END
ELSE
    PRINT '14.1 RDS.TableChanges: all fact-table key columns already have defaults; nothing to do.';

SET NOCOUNT OFF;
