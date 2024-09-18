---It would be good to just go ahead and include Staff in this process as well to maintain unique staff ID's
---Inform the process for when/if ID's change - how will that be addressed, perhaps not now, but in the future.
-------will the use of PersonMaster come into play?
-------Note: id's can change so long as the end result - report outcome would be the same?

CREATE PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP17_StateDefinedCustomIndicator_EncapsulatedCode]
	@SchoolYear SMALLINT = NULL
	AS
    /*************************************************************************************************************
    Date Created:  2/12/2018

    Purpose:
        The purpose of this ETL is to maintain the unique list of Student & Staff Identifiers assigned by the state
		in the ODS.

    Assumptions:
        

    Account executed under: LOGIN

    Approximate run time:  ~ 5 seconds

    Data Sources:  Ed-Fi ODS: edfi.Student
							  edfi.Staff

    Data Targets:  Generate Database:   Generate.ODS.RefIndicatorStatusCustomType

    Return Values:
    	 0	= Success
       All Errors are Thrown via Try/Catch Block	
  
    Example Usage: 
      EXEC App.[Migrate_Data_ETL_IMPLEMENTATION_STEP17_StateDefinedCustomIndicator_EncapsulatedCode] 2018;
    
    Modification Log:
      #	  Date		    Developer	  Issue#	 Description
      --  ----------  ----------  -------  --------------------------------------------------------------------
      01		  	 
    *************************************************************************************************************/
    BEGIN

        SET NOCOUNT ON;
		
		IF @SchoolYear IS NULL BEGIN
			SELECT @SchoolYear = d.Year + 1
			FROM rds.DimDateDataMigrationTypes dd 
			JOIN rds.DimDates d 
				ON dd.DimDateId = d.DimDateId 
			JOIN rds.DimDataMigrationTypes b 
				ON b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
			WHERE dd.IsSelected = 1 
				AND DataMigrationTypeCode = 'ODS'
		END 

        ---------------------------------------------------
        --- Declare Error Handling Variables           ----
        ---------------------------------------------------
		DECLARE @eStoredProc			varchar(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP17_StateDefinedCustomIndicator_EncapsulatedCode'

        ---------------------------------------------------
        --- Declare Temporary Variables                ----
        ---------------------------------------------------
        DECLARE
			 @RecordStartDate DATETIME

		SET @RecordStartDate = App.GetFiscalYearStartDate(@SchoolYear)


		 --set the year to pull by using GETYEAR - a certain number so that it looks back in time but not so far back
		 --that pulling the data gets too large.  This will keep it dynamic.  So declare a variable and use the date.

		
		------------------------------------------------------------
        --- Insert Person Records                                ---
        ------------------------------------------------------------
        /*
		  Grab the existing PersonId for people that already exist.
		*/ 

		BEGIN TRY
			UPDATE Staging.StateDefinedCustomIndicator
			SET RefIndicatorStatusCustomTypeId = refCi.RefIndicatorStatusCustomTypeId
			FROM Staging.StateDefinedCustomIndicator ci
			JOIN ods.RefIndicatorStatusCustomType refCi
				ON refCi.Code = ci.Code
			
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Person', 'PersonId', 'S17EC100' 
		END CATCH

		

        ------------------------------------------------------------
        --- Insert RefIndicatorStatusCustomType Records -- 
        ------------------------------------------------------------
		BEGIN TRY    
			INSERT ODS.RefIndicatorStatusCustomType (
				Description
				,Code
				,Definition
			)
			  SELECT DISTINCT
				Description = ci.Description
			   ,Code = ci.Code
			   ,Definition = ci.Definition
			  FROM Staging.StateDefinedCustomIndicator ci
			  LEFT JOIN ODS.RefIndicatorStatusCustomType refCi 
				ON refCi.Code = ci.Code
			  WHERE  ci.RefIndicatorStatusCustomTypeId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonIdentifier', NULL, 'S17EC130' 
		END CATCH

		BEGIN TRY
			UPDATE Staging.StateDefinedCustomIndicator
			SET RefIndicatorStatusCustomTypeId = refCi.RefIndicatorStatusCustomTypeId
			FROM Staging.StateDefinedCustomIndicator ci
			JOIN ods.RefIndicatorStatusCustomType refCi
				ON refCi.Code = ci.Code
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Person', 'PersonId', 'S17EC100' 
		END CATCH

    END;