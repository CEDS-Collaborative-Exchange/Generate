IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'PersonnelDateTableType' AND ss.name = N'RDS')
DROP TYPE [RDS].[PersonnelDateTableType]
