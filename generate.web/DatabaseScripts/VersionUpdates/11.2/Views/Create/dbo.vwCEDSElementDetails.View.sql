CREATE VIEW [dbo].[vwCEDSElementDetails]
AS 
SELECT 
	c.TABLE_NAME TableName
	, c.COLUMN_NAME 									[ColumnName]
	, data_type 										[DataType]
	, character_maximum_length 							[MaxLength]
	, c.ORDINAL_POSITION 								[ColumnPostion]
	, CAST(ISNULL(de.value,me.value) AS varchar(MAX)) 	[Description]
	, CAST(el.value AS varchar(MAX)) 					[CedsElement]
	, CAST(ur.value AS varchar(MAX)) 					[Url]
	, CAST(gi.value as VARCHAR(MAX)) 					[GlobalId]
FROM INFORMATION_SCHEMA.COLUMNS c 
INNER JOIN INFORMATION_SCHEMA.TABLES t ON t.TABLE_NAME = c.TABLE_NAME 
OUTER APPLY fn_listextendedproperty ('MS_Description', 'schema', 'dbo', N'table', c.TABLE_NAME, N'column', c.COLUMN_NAME) me
OUTER APPLY fn_listextendedproperty ('CEDS_Def_Desc', 'schema', 'dbo', N'table', c.TABLE_NAME, N'column', c.COLUMN_NAME) de
OUTER APPLY fn_listextendedproperty ('CEDS_Element', 'schema', 'dbo', N'table', c.TABLE_NAME, N'column', c.COLUMN_NAME) el
OUTER APPLY fn_listextendedproperty ('CEDS_URL', 'schema', 'dbo', N'table', c.TABLE_NAME, N'column', c.COLUMN_NAME) ur
OUTER APPLY fn_listextendedproperty ('CEDS_GlobalId', 'schema', 'dbo', N'table', c.TABLE_NAME, N'column', c.COLUMN_NAME) gi
WHERE t.table_type = 'BASE TABLE'
	AND (me.value IS NOT NULL
		OR de.value IS NOT NULL 
		OR gi.value IS NOT NULL)

UNION

SELECT 
	t.TABLE_NAME 										[TableName]
	, NULL 												[ColumnName]
	, NULL 												[DataType]
	, NULL 												[MaxLength]
	, NULL 												[ColumnPostion]
	, CAST(ISNULL(de.value,me.value) AS varchar(MAX)) 	[Description]
	, CAST(el.value AS varchar(MAX)) 					[CedsElement]
	, CAST(ur.value AS varchar(MAX)) 					[Url]
	, CAST(gi.value as VARCHAR(MAX)) 					[GlobalId]
FROM INFORMATION_SCHEMA.TABLES t 
OUTER APPLY fn_listextendedproperty ('MS_Description', 'schema', 'dbo', N'table', t.TABLE_NAME, NULL, DEFAULT) me
OUTER APPLY fn_listextendedproperty ('CEDS_Def_Desc', 'schema', 'dbo', N'table', t.TABLE_NAME, NULL, DEFAULT) de
OUTER APPLY fn_listextendedproperty ('CEDS_Element', 'schema', 'dbo', N'table', t.TABLE_NAME, NULL, DEFAULT) el
OUTER APPLY fn_listextendedproperty ('CEDS_URL', 'schema', 'dbo', N'table', t.TABLE_NAME, NULL, DEFAULT) ur
OUTER APPLY fn_listextendedproperty ('CEDS_GlobalId', 'schema', 'dbo', N'table', t.TABLE_NAME, NULL, DEFAULT) gi
WHERE t.table_type = 'BASE TABLE'
	AND (me.value IS NOT NULL
		OR de.value IS NOT NULL 
		OR gi.value IS NOT NULL)