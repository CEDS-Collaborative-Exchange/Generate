UPDATE rds.DimMigrantStatuses 
SET MigrantStatusEdFactsCode = 'NoEdFactsEquivalent' 
WHERE MigrantStatusCode = 'No'
AND MigrantStatusEdFactsCode <> 'NoEdFactsEquivalent' 