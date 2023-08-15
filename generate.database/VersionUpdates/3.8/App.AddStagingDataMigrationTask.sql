IF NOT EXISTS (SELECT 1 FROM App.DataMigrationTypes t WHERE t.DataMigrationTypeCode = 'Staging') BEGIN
	INSERT INTO App.DataMigrationTypes VALUES ('staging', 'Staging Data Store')
END