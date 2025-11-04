IF EXISTS(SELECT 1 FROM sys.synonyms WHERE name = 'EDENDB_dbo_Generate_ExportMetadata_OneFile') BEGIN
	DROP SYNONYM [dbo].[EDENDB_dbo_Generate_ExportMetadata_OneFile]
END