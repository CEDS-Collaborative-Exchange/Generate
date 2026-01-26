IF EXISTS(SELECT 1 FROM sys.synonyms WHERE name = 'EDENDB_dbo_GenerateColumns') BEGIN
	DROP SYNONYM [dbo].[EDENDB_dbo_GenerateColumns]
END