IF NOT EXISTS (SELECT * FROM sys.synonyms WHERE name = N'EDENDB_dbo_GenerateOptions' AND schema_id = SCHEMA_ID(N'dbo'))
CREATE SYNONYM [dbo].[EDENDB_dbo_GenerateOptions] FOR [SQL01.EDMITS-AEM.COM,3748].[EDENDB].[dbo].[GenerateOptions]



