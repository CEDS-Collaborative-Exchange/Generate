set nocount on
begin try
begin transaction

--Create the new schema to house the Source to Staging scripts
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Source')
BEGIN
	EXEC('CREATE SCHEMA [Source]')
END

---------------------------------------------------------------------------------------------------
--Create the new stored procedures for the Source to Staging scripts if they don't already exist
---------------------------------------------------------------------------------------------------

--Directory
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_Directory'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_Directory] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Child Count
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_ChildCount'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_ChildCount] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Exiting
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_Exiting'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_Exiting] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Discipline
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_Discipline'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_Discipline] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Assessments
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_Assessments'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_Assessments] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Staff
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_Staff'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_Staff] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Chronic Absenteeism
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_ChronicAbsenteeism'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_ChronicAbsenteeism] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Dropout
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_Dropout'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_Dropout] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Graduates Completers
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_GraduatesCompleters'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_GraduatesCompleters] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Graduation Rate
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_GraduationRate'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_GraduationRate] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Homeless
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_Homeless'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_Homeless] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--HS Grad PS Enroll
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_HSGradPSEnroll'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_HSGradPSEnroll] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Immigrant
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_Immigrant'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_Immigrant] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Membership
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_Membership'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_Membership] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Migrant Education Program
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_MigrantEdProgram'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_MigrantEdProgram] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Neglected or Delinquent
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_NeglectedOrDelinquent'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_NeglectedOrDelinquent] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Title I
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_TitleI'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_TitleI] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Title III EL Oct
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_TitleIIIELOct'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_TitleIIIELOct] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END


--Title III EL SY
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_TitleIIIELSY'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_TitleIIIELSY] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END



	commit transaction
end try
 
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()         
	RAISERROR(@msg, @sev, 1)
end catch
 
set nocount off