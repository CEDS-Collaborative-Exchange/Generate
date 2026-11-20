IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[App].[vwStagingRelationships]'))
DROP VIEW [App].[vwStagingRelationships]
