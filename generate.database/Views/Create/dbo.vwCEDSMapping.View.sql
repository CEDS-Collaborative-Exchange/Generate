CREATE VIEW [dbo].[vwCEDSMapping]
AS 
SELECT 
	c.TABLE_NAME 		[TableName]
	, c.COLUMN_NAME 	[ColumnName]
	, m.value			[GlobalId]
	, e.value			[ElementName]
	, u.value			[URL]
FROM INFORMATION_SCHEMA.COLUMNS c 
INNER JOIN INFORMATION_SCHEMA.TABLES t ON t.TABLE_NAME = c.TABLE_NAME 
OUTER APPLY fn_listextendedproperty ('CEDS_GlobalId', 'schema', 'dbo', N'table', c.TABLE_NAME, N'column', c.COLUMN_NAME) m
OUTER APPLY fn_listextendedproperty ('CEDS_Element', 'schema', 'dbo', N'table', c.TABLE_NAME, N'column', c.COLUMN_NAME) e
OUTER APPLY fn_listextendedproperty ('CEDS_URL', 'schema', 'dbo', N'table', c.TABLE_NAME, N'column', c.COLUMN_NAME) u
CROSS APPLY app.Split(CAST(m.Value AS VARCHAR(MAX)), ',') ms
CROSS APPLY app.Split(CAST(e.Value AS VARCHAR(MAX)), ',') es
CROSS APPLY app.Split(CAST(u.Value AS VARCHAR(MAX)), ',') us
-- WHERE ms.RowNumber = es.RowNumber
-- 	AND ms.RowNumber = us.RowNumber

UNION

SELECT 
	T.TABLE_NAME		[TableName]
	, NULL 				[ColumnName]
	, LTRIM(ms.Item) 	[GlobalId]
	, LTRIM(es.Item) 	[ElementName]
	, LTRIM(us.Item) 	[URL]
FROM INFORMATION_SCHEMA.COLUMNS c 
INNER JOIN INFORMATION_SCHEMA.TABLES t ON t.TABLE_NAME = c.TABLE_NAME 
OUTER APPLY fn_listextendedproperty ('CEDS_GlobalId', 'schema', 'dbo', N'table', c.TABLE_NAME, NULL, DEFAULT) m
OUTER APPLY fn_listextendedproperty ('CEDS_Element', 'schema', 'dbo', N'table', c.TABLE_NAME, NULL, DEFAULT) e
OUTER APPLY fn_listextendedproperty ('CEDS_URL', 'schema', 'dbo', N'table', c.TABLE_NAME, NULL, DEFAULT) u
CROSS APPLY app.Split(CAST(m.Value AS VARCHAR(MAX)), ',') ms
CROSS APPLY app.Split(CAST(e.Value AS VARCHAR(MAX)), ',') es
CROSS APPLY app.Split(CAST(u.Value AS VARCHAR(MAX)), ',') us
-- WHERE ms.RowNumber = es.RowNumber
-- 	AND ms.RowNumber = us.RowNumber
