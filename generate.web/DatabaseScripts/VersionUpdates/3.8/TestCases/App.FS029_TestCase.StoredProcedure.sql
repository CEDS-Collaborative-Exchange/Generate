CREATE PROCEDURE [App].[FS029_TestCase]
	@SchoolYear SMALLINT
AS
BEGIN

BEGIN TRY
	BEGIN TRANSACTION

		/* This Test Case will be built out for the full Directory specification. As of June 2021, this work is planned for Q3 2021. 
		   The Generate Technical Team has decided that there is no need to build out test cases specifically for "Directory Lite" 
		   since this data is the foundation for nearly all file specification already being tested. 
		*/



	COMMIT TRANSACTION

	END TRY
	BEGIN CATCH

	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION
	END

	DECLARE @msg AS NVARCHAR(MAX)
	SET @msg = ERROR_MESSAGE()

	DECLARE @sev AS INT
	SET @sev = ERROR_SEVERITY()

	RAISERROR(@msg, @sev, 1)

	END CATCH; 


END