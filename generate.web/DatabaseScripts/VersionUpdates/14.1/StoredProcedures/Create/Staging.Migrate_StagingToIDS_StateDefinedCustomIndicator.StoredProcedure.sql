CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_StateDefinedCustomIndicator]
	@SchoolYear SMALLINT = NULL
	AS
    /*************************************************************************************************************
    Date Created:  2/12/2018

    Purpose:
        Load the state's custom indicators

    Assumptions:
        

    Account executed under: LOGIN

    Approximate run time:  ~ 5 seconds

    Data Sources:  

    Data Targets:  Generate Database:   Generate.dbo.RefIndicatorStatusCustomType

    Return Values:
    	 0	= Success
       All Errors are Thrown via Try/Catch Block	
  
    Example Usage: 
      EXEC Staging.[Migrate_StagingToIDS_StateDefinedCustomIndicator] 2018;
    
    Modification Log:
      #	  Date		    Developer	  Issue#	 Description
      --  ----------  ----------  -------  --------------------------------------------------------------------
      01		  	 
    *************************************************************************************************************/
    BEGIN

        SET NOCOUNT ON;
		
		IF @SchoolYear IS NULL BEGIN
			SELECT @SchoolYear = d.SchoolYear
			FROM rds.DimSchoolYearDataMigrationTypes dd 
			JOIN rds.DimSchoolYears d 
				ON dd.DimSchoolYearId = d.DimSchoolYearId 
			JOIN rds.DimDataMigrationTypes b 
				ON b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
			WHERE dd.IsSelected = 1 
				AND DataMigrationTypeCode = 'ODS'
		END 

        ---------------------------------------------------
        --- Declare Error Handling Variables           ----
        ---------------------------------------------------
		DECLARE @eStoredProc			varchar(100) = 'Migrate_StagingToIDS_StateDefinedCustomIndicator'

        ---------------------------------------------------
        --- Declare Temporary Variables                ----
        ---------------------------------------------------
        DECLARE
			 @RecordStartDate DATETIME

		SET @RecordStartDate = Staging.GetFiscalYearStartDate(@SchoolYear)


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
			JOIN dbo.RefIndicatorStatusCustomType refCi
				ON refCi.Code = ci.Code
			
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Person', 'PersonId', 'S17EC100' 
		END CATCH

		

        ------------------------------------------------------------
        --- Insert RefIndicatorStatusCustomType Records -- 
        ------------------------------------------------------------
		BEGIN TRY    
			INSERT dbo.RefIndicatorStatusCustomType (
				Description
				,Code
				,Definition
			)
			  SELECT DISTINCT
				Description = ci.Description
			   ,Code = ci.Code
			   ,Definition = ci.Definition
			  FROM Staging.StateDefinedCustomIndicator ci
			  LEFT JOIN dbo.RefIndicatorStatusCustomType refCi 
				ON refCi.Code = ci.Code
			  WHERE  ci.RefIndicatorStatusCustomTypeId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonIdentifier', NULL, 'S17EC130' 
		END CATCH

		BEGIN TRY
			UPDATE Staging.StateDefinedCustomIndicator
			SET RefIndicatorStatusCustomTypeId = refCi.RefIndicatorStatusCustomTypeId
			FROM Staging.StateDefinedCustomIndicator ci
			JOIN dbo.RefIndicatorStatusCustomType refCi
				ON refCi.Code = ci.Code
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Person', 'PersonId', 'S17EC100' 
		END CATCH

    END;