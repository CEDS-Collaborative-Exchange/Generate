IF NOT EXISTS (SELECT * FROM sys.synonyms WHERE name = N'EDENDB_dbo_Generate_ExportMetadata_OneFile' AND schema_id = SCHEMA_ID(N'dbo'))
CREATE SYNONYM [dbo].[EDENDB_dbo_Generate_ExportMetadata_OneFile] FOR [SQL01.EDMITS-AEM.COM,3748].[EDENDB].[dbo].[Generate_ExportMetadata_OneFile]

