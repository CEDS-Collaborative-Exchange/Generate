set nocount on
begin try
	begin transaction

		IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.Tables WHERE TABLE_NAME = 'SqlUnitTestCaseResult') BEGIN 
			DROP TABLE App.SqlUnitTestCaseResult 
			DROP TABLE App.SqlUnitTest 
		END

		CREATE TABLE App.SqlUnitTest (
			  SqlUnitTestId			INT	IDENTITY (1, 1) PRIMARY KEY
			, UnitTestName			VARCHAR(100)
			, StoredProcedureName	VARCHAR(100)
			, TestScope				VARCHAR(1000)
			, IsActive				BIT
		)

		CREATE TABLE App.SqlUnitTestCaseResult (
			  SqlUnitTestResultId			INT	IDENTITY (1, 1) PRIMARY KEY
			, SqlUnitTestId					INT
			, TestCaseName					VARCHAR(100)
			, TestCaseDetails				VARCHAR(MAX)
			, ExpectedResult				VARCHAR(100)
			, ActualResult					VARCHAR(100)
			, Passed						BIT
			, TestDateTime					DATETIME
			, CONSTRAINT FK_SqlUnitTest FOREIGN KEY (SqlUnitTestId) REFERENCES App.SqlUnitTest(SqlUnitTestId)
		)

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