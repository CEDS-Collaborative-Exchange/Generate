CREATE PROCEDURE [Utilities].[Cleanup_DataMigrationHistories] (
	@cleanupDate as date
)
AS
BEGIN

    IF @cleanupDate IS NULL
    BEGIN
        RAISERROR('@cleanupDate is required.', 16, 1);
        RETURN;
    END

    DELETE FROM App.DataMigrationHistories
    WHERE DataMigrationHistoryDate < @cleanupDate;

    SELECT @@ROWCOUNT AS RowsDeleted;

END