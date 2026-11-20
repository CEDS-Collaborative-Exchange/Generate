CREATE PROCEDURE [Utilities].[Cleanup_DataMigrationHistories] (
	@cleanupDate as date
)
AS
/*
   Each time a data migration runs in Generate, log entries are written to the table App.DataMigrationHistories. 
   Over time this table can grow large. This utility allows for the deletion of older Data Migration History records 
   that are no longer needed.

    parameters:
        @cleanupDate = The cutoff date. All Data Migration History records dated before this date will be removed.

    If the cleanupDate parameter is missing or null, the stored procedure will not execute and will return an error.
    Records with a date earlier than the cleanup date will be removed. Records on or after the cleanup date will be kept.
*/
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