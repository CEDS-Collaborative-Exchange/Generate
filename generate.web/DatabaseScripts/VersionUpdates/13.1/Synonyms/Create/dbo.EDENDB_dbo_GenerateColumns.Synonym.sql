IF NOT EXISTS (SELECT * FROM sys.synonyms WHERE name = N'EDENDB_dbo_GenerateColumns' AND schema_id = SCHEMA_ID(N'dbo'))
CREATE SYNONYM [dbo].[EDENDB_dbo_GenerateColumns] FOR [SQL01.EDMITS-AEM.COM,3748].[EDENDB].[dbo].[GenerateColumns]


