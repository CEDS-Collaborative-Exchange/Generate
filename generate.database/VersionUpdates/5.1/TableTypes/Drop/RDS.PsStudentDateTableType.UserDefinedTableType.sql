IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'PsStudentDateTableType' AND ss.name = N'RDS')
DROP TYPE [RDS].[PsStudentDateTableType]