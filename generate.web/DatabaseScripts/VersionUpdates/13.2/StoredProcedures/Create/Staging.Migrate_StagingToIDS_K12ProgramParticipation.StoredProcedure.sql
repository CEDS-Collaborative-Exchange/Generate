CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_K12ProgramParticipation]
    --@SchoolYear SMALLINT = NULL
AS
  /*************************************************************************************************************
    Date Created:  2/12/2018

    Purpose:
        The purpose student's participation in K12 programs 

    Account executed under: LOGIN

    Approximate run time:  ~ 5 seconds

    Data Sources: 

    Data Targets:  Generate Database:   Generate

    Return VALUES:
         0    = Success
  
    Example Usage: 
      EXEC Staging.[Migrate_StagingToIDS_K12ProgramParticipation]] 2019;
    
    Modification Log:
      #      Date          Issue#   Description
      --  ----------  -------  --------------------------------------------------------------------
      01               
    *************************************************************************************************************/
BEGIN
    --SET nocount ON;


    --    IF @SchoolYear IS NULL BEGIN
    --    SELECT @SchoolYear = d.Year + 1
    --    FROM rds.DimDateDataMigrationTypes dd 
    --    JOIN rds.DimDates d 
    --        ON dd.DimDateId = d.DimDateId 
    --    JOIN rds.DimDataMigrationTypes b 
    --        ON b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
    --    WHERE dd.IsSelected = 1 
    --        AND DataMigrationTypeCode = 'ODS'
    --END 


    ---------------------------------------------------
    --- Declare Error Handling Variables           ----
    ---------------------------------------------------
    DECLARE @eStoredProc VARCHAR(100) = 'Migrate_StagingToIDS_K12ProgramParticipation'


    ---------------------------------------------------
        --- Update DataCollectionId in Staging.K12Enrollment  ----Added
    ---------------------------------------------------
    BEGIN TRY


        Update kpe
        Set kpe.DataCollectionId = dc.DataCollectionId
        FROM Staging.K12ProgramParticipation kpe
        JOIN dbo.DataCollection dc
            ON kpe.DataCollectionName = dc.DataCollectionName


    END TRY


    BEGIN CATCH
        EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12ProgramParticipation', 'DataCollectionId', 'S03EC090'
    END CATCH


    ---------------------------------------------------
    --- Get LEA/School Organization ID               ----
    ---------------------------------------------------
            
    DECLARE @LeaIdSystem INT = 0
    SELECT @LeaIdSystem = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001072')
    DECLARE @LeaIdType INT = 0
    SELECT @LeaIdType = [Staging].[GetOrganizationIdentifierTypeId]('001072')


    DECLARE @SchoolIdSystem INT = 0
    SELECT @SchoolIdSystem = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001073')
    DECLARE @SchoolIdType INT = 0
    SELECT @SchoolIdType = [Staging].[GetOrganizationIdentifierTypeId]('001073')


    DECLARE @PersonIdSystem INT = 0
    SELECT @PersonIdSystem = Staging.GetRefPersonIdentificationSystemId('State', '001075')
    DECLARE @PersonInfoVerif INT = 0
    SELECT @PersonInfoVerif = Staging.GetRefPersonalInformationVerificationId('01011')


    DECLARE @K12StudentRoleId INT
    SELECT @K12StudentRoleId = RoleId
    FROM dbo.[Role] r 
    WHERE r.Name = 'K12 Student'


    BEGIN TRY


        UPDATE Staging.K12ProgramParticipation
        SET OrganizationId = oi.OrganizationId
        FROM Staging.K12ProgramParticipation kpe
        JOIN dbo.OrganizationIdentifier oi
            ON kpe.OrganizationIdentifier = oi.Identifier
            AND ISNULL(kpe.DataCollectionId, '') = ISNULL(oi.DataCollectionId, '')
        JOIN Staging.SourceSystemReferenceData ssrd
            ON kpe.OrganizationType = ssrd.InputCode
            AND ssrd.TableName = 'RefOrganizationType'
            AND ssrd.TableFilter = '001156'
            AND ssrd.SchoolYear = kpe.SchoolYear
        JOIN dbo.OrganizationDetail od
            ON oi.OrganizationId = od.OrganizationId
        JOIN dbo.RefOrganizationType ot
            ON od.RefOrganizationTypeId = ot.RefOrganizationTypeId
            AND ssrd.OutputCode = ot.Code
        WHERE oi.RefOrganizationIdentifierTypeId = 
                CASE ot.Code
                    WHEN 'LEA' THEN @LeaIdType
                    WHEN 'K12School' THEN @SchoolIdType
                END


    END TRY


    BEGIN CATCH 
        EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12ProgramParticipation', 'OrganizationId', 'S13EC0100' 
    END CATCH


    ---------------------------------------------------
    --- Get Program Organization ID                ----
    ---------------------------------------------------
            
    BEGIN TRY
        UPDATE Staging.K12ProgramParticipation
        SET ProgramOrganizationId = opt.OrganizationId
        FROM Staging.K12ProgramParticipation kpe
        JOIN [Staging].[SourceSystemReferenceData] ssrd
            ON kpe.ProgramType = ssrd.InputCode
            AND ssrd.TableName = 'RefProgramType'
            AND ssrd.SchoolYear = kpe.SchoolYear
        JOIN dbo.RefProgramType pt 
            ON ssrd.OutputCode = pt.Code
        JOIN dbo.OrganizationProgramType opt
            ON pt.RefProgramTypeId = opt.RefProgramTypeId
        JOIN dbo.OrganizationRelationship ore
            ON opt.OrganizationId = ore.OrganizationId
            AND ISNULL(ore.DataCollectionId, '') = ISNULL(kpe.DataCollectionId, '') --Added
            AND ISNULL(opt.DataCollectionId, '') = ISNULL(ore.DataCollectionId, '') --Added
            AND ore.Parent_OrganizationId = kpe.OrganizationId


    END TRY


    BEGIN CATCH 
        EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12ProgramParticipation', 'ProgramOrganizationId', 'S13EC0110' 
    END CATCH


    
    ---------------------------------------------------
    --- Get Person IDs for students                ----
    ---------------------------------------------------
    
    BEGIN TRY


        UPDATE Staging.K12ProgramParticipation
        SET PersonId = pid.PersonId
        FROM Staging.K12ProgramParticipation kpe
        JOIN dbo.PersonIdentifier pid 
            ON kpe.Student_Identifier_State = pid.Identifier
            AND ISNULL(kpe.DataCollectionId, '') = ISNULL(pid.DataCollectionId, '')
		JOIN dbo.OrganizationPersonRole opr
				ON pid.PersonId = opr.PersonId
				AND opr.OrganizationId = kpe.OrganizationId
        WHERE pid.RefPersonIdentificationSystemId = @PersonIdSystem
            AND pid.RefPersonalInformationVerificationId = @PersonInfoVerif


    END TRY


    BEGIN CATCH 
        EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'K12ProgramParticipation', 'PersonId', 'S13EC0120' 
    END CATCH

    
    -------------------------------------------------------
    --- Check for existing program enrollment record   ----
    -------------------------------------------------------
            
    BEGIN TRY
        UPDATE Staging.K12ProgramParticipation
        SET OrganizationPersonRoleId = opr.OrganizationPersonRoleId
        FROM Staging.K12ProgramParticipation kpe
        JOIN dbo.OrganizationPersonRole opr
            ON kpe.ProgramOrganizationId = opr.OrganizationId
            AND kpe.PersonId = opr.PersonId
            AND ISNULL(kpe.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '') --Added


    END TRY


    BEGIN CATCH 
        EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'K12ProgramParticipation', 'OrganizationPersonRoleId', 'S13EC0130' 
    END CATCH



    -------------------------------------------------------
    --- Create new program enrollment records          ----
    -------------------------------------------------------    
    BEGIN TRY


        -- Create new records
        INSERT INTO dbo.OrganizationPersonRole
            (
              OrganizationId
            , PersonId
            , RoleId
            , EntryDate
            , ExitDate
            , DataCollectionId
            )
        SELECT 
              pe.ProgramOrganizationId
            , pe.PersonId
            , @K12StudentRoleId
            , pe.EntryDate
            , pe.ExitDate
            , pe.DataCollectionId
        FROM Staging.K12ProgramParticipation pe
        WHERE pe.OrganizationPersonRoleId IS NULL
    END TRY


    BEGIN CATCH 
        EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', '', 'S13EC0140'
    END CATCH



    ----------------------------------------------------------------------------
    --- UPDATE staging table wtih the new OrganizationPersonRoleId          ----
    ----------------------------------------------------------------------------


    BEGIN TRY


        UPDATE Staging.K12ProgramParticipation
        SET OrganizationPersonRoleId = opr.OrganizationPersonRoleId
        FROM Staging.K12ProgramParticipation kpe
        JOIN dbo.OrganizationPersonRole opr
            ON kpe.ProgramOrganizationId = opr.OrganizationId
            AND kpe.PersonId = opr.PersonId
            AND ISNULL(kpe.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '') --Added
            AND kpe.EntryDate = opr.EntryDate
            AND opr.RoleId = @K12StudentRoleId
        WHERE kpe.OrganizationPersonRoleId IS NULL
    END TRY


    BEGIN CATCH 
        EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'K12ProgramParticipation', 'OrganizationPersonRoleId', 'S13EC0150'
    END CATCH


END











 
