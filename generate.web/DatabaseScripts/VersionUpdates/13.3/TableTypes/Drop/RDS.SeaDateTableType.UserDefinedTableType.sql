IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'SeaDateTableType' AND ss.name = N'RDS')
DROP TYPE [RDS].[SeaDateTableType]
