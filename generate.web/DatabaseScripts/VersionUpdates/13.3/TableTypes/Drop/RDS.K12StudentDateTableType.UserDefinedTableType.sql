IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'StudentDateTableType' AND ss.name = N'RDS')
DROP TYPE [RDS].[StudentDateTableType]

IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'K12StudentDateTableType' AND ss.name = N'RDS')
DROP TYPE [RDS].[K12StudentDateTableType]
