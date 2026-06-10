CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_ProgramParticipationNorD]
	@SchoolYear SMALLINT = NULL
AS

	/*************************************************************************************************************
	Date Created:  5/28/2019

	Purpose:
		The purpose of this ETL is to load NoD indicators about students for EDFacts reports that apply to the full year.

	Assumptions:
        
	Account executed under: LOGIN

	Approximate run time:  ~ 5 seconds

	Data Sources: 

	Data Targets:  Generate Database:   Generate

	Return Values:
    		0	= Success
  
	Example Usage: 
		EXEC Staging.[Migrate_StagingToIDS_ProgramParticipationNorD] 2018;
    
	Modification Log:
		#	  Date		  Issue#   Description
		--  ----------  -------  --------------------------------------------------------------------
		01		  	 
	*************************************************************************************************************/

BEGIN
	--begin transaction

	set nocount on;

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
	--- Declare Error Handling Variables
	---------------------------------------------------
	DECLARE @eStoredProc			varchar(100) = 'Migrate_StagingToIDS_ProgramParticipationNorD'

	---------------------------------------------------
	--- Declare Multiple Use Variables
	---------------------------------------------------
	DECLARE @RefParticipationTypeId INT
	SELECT @RefParticipationTypeId = RefParticipationTypeId FROM [dbo].[RefParticipationType] 
		WHERE [Code] = 'CorrectionalEducationReentryServicesParticipation'

	DECLARE @RefEmployedAfterExitId INT
	SELECT @RefEmployedAfterExitId = (SELECT RefEmployedAfterExitId FROM dbo.RefEmployedAfterExit 
		WHERE dbo.RefEmployedAfterExit.Code = 'Yes')

	DECLARE @RefWfProgramParticipationId INT
	SELECT @RefWfProgramParticipationId = (SELECT RefWfProgramParticipationId FROM dbo.RefWfProgramParticipation
		WHERE dbo.RefWfProgramParticipation.Code = '06')		-- Code = 'Adult Education and Literacy'

	DECLARE @RefAcademicSubject_MathId INT
	SELECT @RefAcademicSubject_MathId = (SELECT RefAcademicSubjectId FROM dbo.RefAcademicSubject 
		WHERE Code = '01166')		-- Code = 'Mathematics'

	DECLARE @RefAcademicSubject_ELAId INT
	SELECT @RefAcademicSubject_ELAId = (SELECT RefAcademicSubjectId FROM dbo.RefAcademicSubject 
		WHERE Code = '13372')		-- Code = 'English'


	--------------------------------------------------------------
	--- Optimize indexes on Staging.ProgramParticipationNorD 
	--------------------------------------------------------------
	ALTER INDEX ALL ON Staging.ProgramParticipationNorD
	REBUILD WITH (FILLFACTOR = 100, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);

	-------------------------------------------------------
	---Associate the PersonId with the staging table 
	-------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.ProgramParticipationNorD
		SET PersonID = pid.PersonId
		FROM Staging.ProgramParticipationNorD mcc
		JOIN dbo.PersonIdentifier pid 
			ON mcc.Student_Identifier_State = pid.Identifier
		WHERE pid.RefPersonIdentificationSystemId = Staging.GetRefPersonIdentificationSystemId('State', '001075')
			AND pid.RefPersonalInformationVerificationId = Staging.GetRefPersonalInformationVerificationId('01011')
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'PersonID', 'S11EC100'
	END CATCH

	--------------------------------------------------------------------
	---Associate the LEA OrganizationId with the staging table 
	--------------------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.ProgramParticipationNorD
		SET OrganizationID_LEA = orgid.OrganizationId
		FROM Staging.ProgramParticipationNorD mcc
		JOIN dbo.OrganizationIdentifier orgid 
			ON mcc.LEA_Identifier_State = orgid.Identifier
		WHERE orgid.RefOrganizationIdentifierTypeId = Staging.[GetOrganizationIdentifierTypeId]('001072')
			AND orgid.RefOrganizationIdentificationSystemId = Staging.[GetOrganizationIdentifierSystemId]('SEA', '001072')
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'OrganizationID_LEA', 'S11EC110'
	END CATCH

	--------------------------------------------------------------------
	---Associate the School OrganizationId with the staging table 
	--------------------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.ProgramParticipationNorD
		SET OrganizationID_School = orgid.OrganizationId
		FROM Staging.ProgramParticipationNorD mcc
		JOIN dbo.OrganizationIdentifier orgid 
			ON mcc.School_Identifier_State = orgid.Identifier
		WHERE orgid.RefOrganizationIdentifierTypeId = Staging.[GetOrganizationIdentifierTypeId]('001073')
			AND orgid.RefOrganizationIdentificationSystemId = Staging.[GetOrganizationIdentifierSystemId]('SEA', '001073')
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'OrganizationID_School', 'S11EC120'
	END CATCH

	-----------------------------------------------------------------------------
	---Associate the NoD Program LEA OrganizationId with the staging table ----
	-----------------------------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.ProgramParticipationNorD
		SET OrganizationID_Program_LEA  = orgd.OrganizationId
		FROM Staging.ProgramParticipationNorD tp
		JOIN dbo.OrganizationRelationship orgr 
			ON tp.OrganizationID_LEA = orgr.Parent_OrganizationId
		JOIN dbo.OrganizationDetail orgd 
			ON orgr.OrganizationId = orgd.OrganizationId
		JOIN dbo.OrganizationProgramType orgpt 
			ON orgd.OrganizationId = orgpt.OrganizationId
		WHERE orgd.RefOrganizationTypeId = Staging.GetOrganizationTypeId('Program', '001156') 
			AND orgpt.RefProgramTypeId = Staging.GetProgramTypeId('09999') -- TODO. Use 'Other', '09999' for now
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'OrganizationID_Program_LEA', 'S11EC130'
	END CATCH

	-----------------------------------------------------------------------------
	---Associate the NoD Program School OrganizationId with the staging table ----
	-----------------------------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.ProgramParticipationNorD
		SET OrganizationID_Program_School  = orgd.OrganizationId
		FROM Staging.ProgramParticipationNorD tp
		JOIN dbo.OrganizationRelationship orgr 
			ON tp.OrganizationID_School = orgr.Parent_OrganizationId
		JOIN dbo.OrganizationDetail orgd 
			ON orgr.OrganizationId = orgd.OrganizationId
		JOIN dbo.OrganizationProgramType orgpt 
			ON orgd.OrganizationId = orgpt.OrganizationId
		WHERE orgd.RefOrganizationTypeId = Staging.GetOrganizationTypeId('Program', '001156') 
			AND orgpt.RefProgramTypeId = Staging.GetProgramTypeId('09999') -- TODO. Use 'Other', '09999' for now
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'OrganizationID_Program_School', 'S11EC140'
	END CATCH



	--Note: Need to change 09999 to the ID that represents NoD Programs when that is created ---

	--------------------------------------------------
	----Create LEA NorD Indicator for the Student 
	--------------------------------------------------

	--Check for NorD Records that already exist--
	BEGIN TRY
		UPDATE Staging.ProgramParticipationNorD
		SET OrganizationPersonRoleId_Program_LEA = opr.OrganizationPersonRoleId
		FROM Staging.ProgramParticipationNorD tp
		JOIN dbo.OrganizationPersonRole opr 
			ON tp.PersonID = opr.PersonId
		WHERE tp.OrganizationID_Program_LEA  = opr.OrganizationId
			AND opr.RoleId = Staging.GetRoleId('K12 Student')
			AND opr.EntryDate = Staging.[GetFiscalYearStartDate](@SchoolYear)
			AND opr.ExitDate = Staging.[GetFiscalYearEndDate](@SchoolYear)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'OrganizationPersonRoleId_Program_LEA', 'S11EC150'
	END CATCH

	--Create an OrganizationPersonRole (Enrollment) into the NoD Program for the last day of the year --
	BEGIN TRY
		INSERT INTO [dbo].[OrganizationPersonRole]
			([OrganizationId]
			,[PersonId]
			,[RoleId]
			,[EntryDate]
			,[ExitDate])
		SELECT DISTINCT
			tp.OrganizationID_Program_LEA					[OrganizationId]
			,tp.PersonID									[PersonId]
			,Staging.GetRoleId('K12 Student')				[RoleId]
			,Staging.[GetFiscalYearStartDate](@SchoolYear)	[EntryDate]
			,Staging.[GetFiscalYearEndDate](@SchoolYear)	[ExitDate] 
		FROM Staging.ProgramParticipationNorD tp
		WHERE tp.OrganizationPersonRoleId_Program_LEA IS NULL
			AND tp.OrganizationID_Program_LEA IS NOT NULL
			AND tp.PersonID IS NOT NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S11EC160'
	END CATCH

	--Update the staging table with the NoD Program OrganizationPersonRoleId
	BEGIN TRY
		UPDATE Staging.ProgramParticipationNorD
		SET OrganizationPersonRoleId_Program_LEA = opr.OrganizationPersonRoleId
		FROM Staging.ProgramParticipationNorD tp
		JOIN dbo.OrganizationPersonRole opr 
			ON tp.PersonID = opr.PersonId
			AND tp.OrganizationID_Program_LEA = opr.OrganizationId
		WHERE opr.RoleId = Staging.GetRoleId('K12 Student')
			AND opr.EntryDate = Staging.[GetFiscalYearStartDate](@SchoolYear)
			AND opr.ExitDate = Staging.[GetFiscalYearEndDate](@SchoolYear)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'OrganizationPersonRoleID_NoDProgram_LEA', 'S11EC170'
	END CATCH

	--------------------------------------------------
	----Create School NorD Indicator for the Student 
	--------------------------------------------------

	--Check for NorD Records that already exist--
	BEGIN TRY
		UPDATE Staging.ProgramParticipationNorD
		SET OrganizationPersonRoleId_Program_School = opr.OrganizationPersonRoleId
		FROM Staging.ProgramParticipationNorD tp
		JOIN dbo.OrganizationPersonRole opr 
			ON tp.PersonID = opr.PersonId
		WHERE tp.OrganizationID_Program_School  = opr.OrganizationId
			AND opr.RoleId = Staging.GetRoleId('K12 Student')
			AND opr.EntryDate = Staging.[GetFiscalYearStartDate](@SchoolYear)
			AND opr.ExitDate = Staging.[GetFiscalYearEndDate](@SchoolYear)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'OrganizationPersonRoleId_Program_School', 'S11EC180'
	END CATCH

	--Create an OrganizationPersonRole (Enrollment) into the NoD Program for the last day of the year --
	BEGIN TRY
		INSERT INTO [dbo].[OrganizationPersonRole]
			([OrganizationId]
			,[PersonId]
			,[RoleId]
			,[EntryDate]
			,[ExitDate])
		SELECT DISTINCT
			tp.OrganizationID_Program_School				[OrganizationId]
			,tp.PersonID									[PersonId]
			,Staging.GetRoleId('K12 Student')				[RoleId]
			,Staging.[GetFiscalYearStartDate](@SchoolYear)	[EntryDate]
			,Staging.[GetFiscalYearEndDate](@SchoolYear)	[ExitDate] 
		FROM Staging.ProgramParticipationNorD tp
		WHERE tp.OrganizationPersonRoleId_Program_School IS NULL
			AND tp.OrganizationID_Program_School IS NOT NULL
			AND tp.PersonID IS NOT NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S11EC190'
	END CATCH

	--Update the staging table with the NoD Program OrganizationPersonRoleId
	BEGIN TRY
		UPDATE Staging.ProgramParticipationNorD
		SET OrganizationPersonRoleId_Program_School = opr.OrganizationPersonRoleId
		FROM Staging.ProgramParticipationNorD tp
		JOIN dbo.OrganizationPersonRole opr 
			ON tp.PersonID = opr.PersonId
			AND tp.OrganizationID_Program_School = opr.OrganizationId
		WHERE opr.RoleId = Staging.GetRoleId('K12 Student')
			AND opr.EntryDate = Staging.[GetFiscalYearStartDate](@SchoolYear)
			AND opr.ExitDate = Staging.[GetFiscalYearEndDate](@SchoolYear)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'OrganizationPersonRoleID_NoDProgram_School', 'S11EC200'
	END CATCH

	--------------------------------------------------------------
	----Create LEA PersonProgramParticipation for the Student 
	--------------------------------------------------------------

	BEGIN TRY
		--Check to see if a PersonProgramParticipation already exists for the NorD Program--
		UPDATE Staging.ProgramParticipationNorD
		SET PersonProgramParticipationId_LEA = ppp.PersonProgramParticipationId
		FROM Staging.ProgramParticipationNorD tp
		JOIN dbo.PersonProgramParticipation ppp 
			ON tp.OrganizationPersonRoleId_Program_LEA = ppp.OrganizationPersonRoleId
		JOIN dbo.ProgramParticipationNeglected pp 
			ON ppp.PersonProgramParticipationId = pp.PersonProgramParticipationId
		WHERE ppp.RecordStartDateTime = Staging.[GetFiscalYearStartDate](@SchoolYear)
			AND ppp.RecordEndDateTime = Staging.[GetFiscalYearEndDate](@SchoolYear)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'PersonProgramParticipationId_LEA', 'S11EC210'
	END CATCH

	--Create a PersonProgramParticipation for each OrganizationPersonRole
	DECLARE @NewLEAPersonProgramParticipationNorD TABLE (
			PersonProgramParticipationId INT
		, SourceId INT
	);

	BEGIN TRY

		MERGE [dbo].[PersonProgramParticipation] AS TARGET
		USING Staging.ProgramParticipationNorD AS SOURCE
			ON SOURCE.PersonProgramParticipationId_LEA = TARGET.PersonProgramParticipationId
		WHEN NOT MATCHED AND SOURCE.OrganizationPersonRoleId_Program_LEA IS NOT NULL THEN 
			INSERT (
			[OrganizationPersonRoleId]
			,[RefParticipationTypeId]
			,[RefProgramExitReasonId]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
		)
		VALUES
		(
			OrganizationPersonRoleId_Program_LEA
			,@RefParticipationTypeId 
			,NULL 
			,ProgramParticipationBeginDate
			,ProgramParticipationEndDate
		)
		OUTPUT
			INSERTED.PersonProgramParticipationId 
			, SOURCE.ID
		INTO @NewLEAPersonProgramParticipationNorD;
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S11EC220'
	END CATCH

	BEGIN TRY
		--Update the staging table with the new PersonProgramParticipationId
		UPDATE Staging.ProgramParticipationNorD 
		SET PersonProgramParticipationId_LEA = nppp.PersonProgramParticipationId
		FROM Staging.ProgramParticipationNorD ppi
		JOIN @NewLEAPersonProgramParticipationNorD nppp
			ON ppi.ID = nppp.SourceId
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'PersonProgramParticipationId', 'S11EC230'
	END CATCH

	--------------------------------------------------------------
	----Create School PersonProgramParticipation for the Student 
	--------------------------------------------------------------

	BEGIN TRY
		--Check to see if a PersonProgramParticipation already exists for the NorD Program--
		UPDATE Staging.ProgramParticipationNorD
		SET PersonProgramParticipationId_School = ppp.PersonProgramParticipationId
		FROM Staging.ProgramParticipationNorD tp
		JOIN dbo.PersonProgramParticipation ppp 
			ON tp.OrganizationPersonRoleId_Program_School = ppp.OrganizationPersonRoleId
		JOIN dbo.ProgramParticipationNeglected pp 
			ON ppp.PersonProgramParticipationId = pp.PersonProgramParticipationId
		WHERE ppp.RecordStartDateTime = Staging.[GetFiscalYearStartDate](@SchoolYear)
			AND ppp.RecordEndDateTime = Staging.[GetFiscalYearEndDate](@SchoolYear)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'PersonProgramParticipationId_School', 'S11EC240'
	END CATCH

	--Create a PersonProgramParticipation for each OrganizationPersonRole
	DECLARE @NewSchoolPersonProgramParticipationNorD TABLE (
			PersonProgramParticipationId INT
		, SourceId INT
	);

	BEGIN TRY

		MERGE [dbo].[PersonProgramParticipation] AS TARGET
		USING Staging.ProgramParticipationNorD AS SOURCE
			ON SOURCE.PersonProgramParticipationId_School = TARGET.PersonProgramParticipationId
		WHEN NOT MATCHED AND SOURCE.OrganizationPersonRoleId_Program_School IS NOT NULL THEN 
			INSERT (
			[OrganizationPersonRoleId]
			,[RefParticipationTypeId]
			,[RefProgramExitReasonId]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
		)
		VALUES
		(
			OrganizationPersonRoleId_Program_School
			,@RefParticipationTypeId 
			,NULL 
			,ProgramParticipationBeginDate
			,ProgramParticipationEndDate
		)
		OUTPUT
			INSERTED.PersonProgramParticipationId 
			, SOURCE.ID
		INTO @NewSchoolPersonProgramParticipationNorD;
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S11EC250'
	END CATCH

	BEGIN TRY
		--Update the staging table with the new PersonProgramParticipationId
		UPDATE Staging.ProgramParticipationNorD 
		SET PersonProgramParticipationId_School = nppp.PersonProgramParticipationId
		FROM Staging.ProgramParticipationNorD ppi
		JOIN @NewSchoolPersonProgramParticipationNorD nppp
			ON ppi.ID = nppp.SourceId
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'PersonProgramParticipationId_School', 'S11EC260'
	END CATCH

	--------------------------------------------------------------
	----Create LEA ProgramParticipation NorD for the Student 
	--------------------------------------------------------------

	-- detect new program participation NoD - OrganizationPersonRoleId
	DECLARE @NewLEAOrganizationPersonRoleNoD TABLE (
			OrganizationPersonRoleId INT
		--, SourceId INT
	);

	-- create new dbo.ProgramParticipationNorD records
	BEGIN TRY

		INSERT INTO [dbo].[ProgramParticipationNeglected] (
			[PersonProgramParticipationId]
			,[RefNeglectedProgramTypeId]
			--,[AchievementIndicator]
			--,[OutcomeIndicator]
			--,[ObtainedEmployment]
			--,[RefAcademicCareerAndTechnicalOutcomesInProgramId]
			--,[RefAcademicCareerAndTechnicalOutcomesExitedProgramId]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
		)
		SELECT 
			ppn.PersonProgramParticipationId_LEA
			,neg.[RefNeglectedProgramTypeId]
			--,outcome.RefAcademicCareerAndTechnicalOutcomesInProgramId
			--,CASE
			--	WHEN ProgramParticipationEndDate IS NOT NULL THEN outcomeexit.RefAcademicCareerAndTechnicalOutcomesInProgramId
			--	ELSE NULL
			--END
			,ProgramParticipationBeginDate
			,ProgramParticipationEndDate
		FROM Staging.ProgramParticipationNorD ppn
	--	JOIN @NewLEAPersonProgramParticipationNorD nppp
	--		ON ppn.ID = nppp.SourceId
		LEFT JOIN Staging.[SourceSystemReferenceData] src 
			ON src.InputCode = ppn.ProgramParticipationNorD 
			AND TableName = 'RefNeglectedProgramType' -- TODO Add entries
		LEFT JOIN [dbo].[RefNeglectedProgramType] neg 
			ON neg.Code = src.OutputCode
		LEFT JOIN [dbo].[ProgramParticipationNeglected] dppn
			ON dppn.PersonProgramParticipationID = ppn.PersonProgramParticipationID_LEA
			--AND ppn2.RefNeglectedProgramTypeId = neg.RefNeglectedProgramTypeId
			AND dppn.RecordStartDateTime = ProgramParticipationBeginDate
		--LEFT JOIN [dbo].RefAcademicCareerAndTechnicalOutcomesInProgram outcome
		--	ON outcome.Code = ppn.Outcome
		--LEFT JOIN [dbo].RefAcademicCareerAndTechnicalOutcomesInProgram outcomeexit
		--	ON outcomeexit.Code = ppn.Outcome
		WHERE dppn.[ProgramParticipationNeglectedId] IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationNeglected', NULL, 'S11EC270'
	END CATCH

	BEGIN TRY
		INSERT INTO @NewLEAOrganizationPersonRoleNoD 
		SELECT ppp.OrganizationPersonRoleId 
		FROM dbo.OrganizationPersonRole org
		JOIN dbo.PersonProgramParticipation ppp
			ON ppp.OrganizationPersonRoleId = org.OrganizationPersonRoleId
		JOIN @NewLEAPersonProgramParticipationNorD nppp
			ON nppp.PersonProgramParticipationId = ppp.PersonProgramParticipationId

	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '@NewLEAOrganizationPersonRoleNoD', NULL, 'S11EC280'
	END CATCH

	--------------------------------------------------------------
	----Create School ProgramParticipation NorD for the Student 
	--------------------------------------------------------------

	-- detect new program participation NoD - OrganizationPersonRoleId
	DECLARE @NewSchoolOrganizationPersonRoleNoD TABLE (
			OrganizationPersonRoleId INT
		--, SourceId INT
	);

	-- create new dbo.ProgramParticipationNorD records
	BEGIN TRY

		INSERT INTO [dbo].[ProgramParticipationNeglected] (
			[PersonProgramParticipationId]
			,[RefNeglectedProgramTypeId]
			--,[AchievementIndicator]
			--,[OutcomeIndicator]
			--,[ObtainedEmployment]
			--,[RefAcademicCareerAndTechnicalOutcomesInProgramId]
			--,[RefAcademicCareerAndTechnicalOutcomesExitedProgramId]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
		)
		SELECT 
			ppn.PersonProgramParticipationId_School
			,neg.[RefNeglectedProgramTypeId]
			--,outcome.RefAcademicCareerAndTechnicalOutcomesInProgramId
			--,CASE
			--	WHEN ProgramParticipationEndDate IS NOT NULL THEN outcomeexit.RefAcademicCareerAndTechnicalOutcomesInProgramId
			--	ELSE NULL
			--END
			,ProgramParticipationBeginDate
			,ProgramParticipationEndDate
		FROM Staging.ProgramParticipationNorD ppn
	--	JOIN @NewSchoolPersonProgramParticipationNorD nppp
	--		ON ppn.ID = nppp.SourceId
		LEFT JOIN Staging.[SourceSystemReferenceData] src 
			ON src.InputCode = ppn.ProgramParticipationNorD 
			AND TableName = 'RefNeglectedProgramType' -- TODO Add entries
		LEFT JOIN [dbo].[RefNeglectedProgramType] neg 
			ON neg.Code = src.OutputCode
		LEFT JOIN [dbo].[ProgramParticipationNeglected] dppn
			ON dppn.PersonProgramParticipationID = ppn.PersonProgramParticipationID_School
			--AND ppn2.RefNeglectedProgramTypeId = neg.RefNeglectedProgramTypeId
			AND dppn.RecordStartDateTime = ProgramParticipationBeginDate
		--LEFT JOIN [dbo].RefAcademicCareerAndTechnicalOutcomesInProgram outcome
		--	ON outcome.Code = ppn.Outcome
		--LEFT JOIN [dbo].RefAcademicCareerAndTechnicalOutcomesInProgram outcomeexit
		--	ON outcomeexit.Code = ppn.Outcome
		WHERE dppn.[ProgramParticipationNeglectedId] IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationNeglected', NULL, 'S11EC290'
	END CATCH

	BEGIN TRY
		INSERT INTO @NewSchoolOrganizationPersonRoleNoD 
		SELECT ppp.OrganizationPersonRoleId 
		FROM dbo.OrganizationPersonRole org
		JOIN dbo.PersonProgramParticipation ppp
			ON ppp.OrganizationPersonRoleId = org.OrganizationPersonRoleId
		JOIN @NewLEAPersonProgramParticipationNorD nppp
			ON nppp.PersonProgramParticipationId = ppp.PersonProgramParticipationId

	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '@NewSchoolOrganizationPersonRoleNoD', NULL, 'S11EC300'
	END CATCH

	--------------------------------------------------------------
	----Update LEA NorD fields for the Student 
	--------------------------------------------------------------

	BEGIN TRY
		-- Update the existing school student K12StudentAcademicRecord
		-- The reason is that the generate migrate procedures use the OrganizationPersonRoleId and not using the OrganizationPersonRoleId with program organization Id.
		Update ar
		SET DiplomaOrCredentialAwardDate = stp.DiplomaCredentialAwardDate
			,RefHighSchoolDiplomaTypeId = 
			CASE
				WHEN stp.Outcome = 'EARNDIPL' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00806')
				WHEN stp.Outcome = 'EARNEGED' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00816')
			END 
			, RefPsEnrollmentActionId = act.RefPsEnrollmentActionId
		FROM Staging.ProgramParticipationNorD stp
		JOIN dbo.OrganizationPersonRole op 
			ON stp.PersonID = op.PersonId 
			AND stp.OrganizationID_LEA = op.OrganizationId
		JOIN dbo.K12StudentAcademicRecord ar 
			ON ar.OrganizationPersonRoleId = op.OrganizationPersonRoleId
	--	JOIN @NewOrganizationPersonRoleNoD nop ON nop.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleID_Program
		LEFT JOIN dbo.K12StudentAcademicRecord k12 
			ON k12.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_Program_LEA
		LEFT JOIN [dbo].[RefHighSchoolDiplomaType] t 
			ON t.Code = stp.Outcome
		LEFT JOIN dbo.RefPsEnrollmentAction act 
			ON act.Code = stp.Outcome
		WHERE stp.Outcome IN ('EARNDIPL', 'EARNEGED') 

		-- FS083 Diploma/Credential (Expanded)
		INSERT INTO dbo.K12StudentAcademicRecord (
			OrganizationPersonRoleId
			,DiplomaOrCredentialAwardDate
			,RefHighSchoolDiplomaTypeId
			,RefPsEnrollmentActionId
		) 
		SELECT 
			stp.OrganizationPersonRoleID_Program_LEA
			,stp.DiplomaCredentialAwardDate
			,CASE
				WHEN stp.Outcome = 'EARNDIPL' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00806')
				WHEN stp.Outcome = 'EARNEGED' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00816')
			END
			, act.RefPsEnrollmentActionId
		FROM Staging.ProgramParticipationNorD stp
		JOIN @NewLEAOrganizationPersonRoleNoD nop 
			ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_Program_LEA
		LEFT JOIN dbo.K12StudentAcademicRecord  k12		
			ON k12.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_Program_LEA
		LEFT JOIN dbo.RefHighSchoolDiplomaType t 
			ON t.Code = stp.Outcome
		LEFT JOIN dbo.RefPsEnrollmentAction act 
			ON act.Code = stp.Outcome
		WHERE stp.Outcome IN ('EARNDIPL', 'EARNEGED') AND k12.RefHighSchoolDiplomaTypeId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentAcademicRecord', NULL, 'S11EC310'
	END CATCH

	--BEGIN TRY
	--	-- populate ADVTRAIN for new records
	--	--INSERT INTO dbo.PsStudentEnrollment (
			--OrganizationPersonRoleId
			--, EntryDateIntoPostSecondary)
	--	--SELECT stp.OrganizationPersonRoleID_CTEProgram
			--, stp.AdvancedTrainingEnrollmentDate
	--	--FROM Staging.ProgramParticipationNorD stp
	--	--JOIN @NewOrganizationPersonRoleNoD nop 
	--	--	ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleId_Program_LEA
	--	--WHERE stp.AdvancedTrainingEnrollmentDate IS NOT NULL
	--END TRY

	--BEGIN CATCH 
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PsStudentEnrollment', NULL, 'S11EC210'
	--END CATCH

	-- populate EMPLOYMENT for new records
	BEGIN TRY
		INSERT INTO dbo.WorkforceEmploymentQuarterlyData (
			OrganizationPersonRoleId
			, RefEmployedAfterExitId
		)
		SELECT stp.OrganizationPersonRoleId_Program_LEA
			, @RefEmployedAfterExitId
		FROM Staging.ProgramParticipationNorD stp
		JOIN @NewLEAOrganizationPersonRoleNoD nop 
			ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleId_Program_LEA
		LEFT JOIN dbo.WorkforceEmploymentQuarterlyData wf 
			ON wf.OrganizationPersonRoleId = stp.OrganizationPersonRoleId_Program_LEA 
			AND wf.RefEmployedAfterExitId = @RefEmployedAfterExitId
		WHERE stp.Outcome = 'OBTAINEMP' AND wf.OrganizationPersonRoleId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.WorkforceEmploymentQuarterlyData', NULL, 'S11EC320'
	END CATCH


	-- populate POSTSEC for new records
	BEGIN TRY
		INSERT INTO dbo.WorkforceProgramParticipation (
			PersonProgramParticipationId
			, RefWfProgramParticipationId
		)
		SELECT stp.PersonProgramParticipationId_LEA
			, @RefWfProgramParticipationId
		FROM Staging.ProgramParticipationNorD stp
		JOIN @NewLEAOrganizationPersonRoleNoD nop 
			ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleId_Program_LEA
		LEFT JOIN dbo.WorkforceProgramParticipation wfpp 
			ON wfpp.PersonProgramParticipationId = stp.PersonProgramParticipationId_LEA
			AND wfpp.RefWfProgramParticipationId = @RefWfProgramParticipationId
		WHERE stp.Outcome = 'POSTSEC'
			AND wfpp.PersonProgramParticipationId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.WorkforceProgramParticipation', NULL, 'S11EC330'
	END CATCH

	-- Populate Progresslevel-Math
	BEGIN TRY
		INSERT INTO dbo.ProgramParticipationNeglectedProgressLevel (
			PersonProgramParticipationId
			, RefAcademicSubjectId
			, RefProgressLevelId
		)
		SELECT stp.PersonProgramParticipationId_LEA
			, @RefAcademicSubject_MathId
			, refpl.RefProgressLevelId
		FROM Staging.ProgramParticipationNorD stp
		JOIN @NewLEAOrganizationPersonRoleNoD nop 
			ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleId_Program_LEA
		JOIN Staging.SourceSystemReferenceData rd 
			ON rd.InputCode = stp.ProgressLevel_Math 
			AND rd.TableName = 'RefProgressLevel'
		JOIN dbo.RefProgressLevel refpl 
			ON refpl.Code = rd.OutputCode
		LEFT JOIN dbo.ProgramParticipationNeglectedProgressLevel pl 
			ON pl.PersonProgramParticipationId = stp.PersonProgramParticipationId_LEA 
			AND pl.RefAcademicSubjectId = @RefAcademicSubject_MathId
		WHERE pl.ProgramParticipationNeglectedProgressLevelId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationNeglectedProgressLevel', NULL, 'S11EC340'
	END CATCH

	-- Populate Progresslevel-ELA
	BEGIN TRY
		INSERT INTO dbo.ProgramParticipationNeglectedProgressLevel (
			PersonProgramParticipationId
			, RefAcademicSubjectId
			, RefProgressLevelId
		)
		SELECT stp.PersonProgramParticipationId_LEA
			, ref.RefAcademicSubjectId
			, refpl.RefProgressLevelId
		FROM Staging.ProgramParticipationNorD stp
		JOIN @NewLEAOrganizationPersonRoleNoD nop 
			ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleId_Program_LEA
		JOIN Staging.SourceSystemReferenceData rd 
			ON rd.InputCode = stp.ProgressLevel_Reading 
			AND rd.TableName = 'RefProgressLevel'
		JOIN dbo.RefProgressLevel refpl 
			ON refpl.Code = rd.OutputCode
		JOIN Staging.AssessmentResult ar 
			ON ar.Student_Identifier_State = stp.Student_Identifier_State
		LEFT JOIN dbo.RefAcademicSubject ref 
			on ref.Description = RTRIM(LTRIM(ar.AssessmentAcademicSubject))
		LEFT JOIN dbo.ProgramParticipationNeglectedProgressLevel pl 
			ON pl.PersonProgramParticipationId = stp.PersonProgramParticipationId_LEA
			AND pl.RefAcademicSubjectId = @RefAcademicSubject_ELAId
		WHERE pl.ProgramParticipationNeglectedProgressLevelId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationNeglectedProgressLevel', NULL, 'S11EC350'
	END CATCH

	--------------------------------------------------------------
	----Update School NorD fields for the Student 
	--------------------------------------------------------------

	BEGIN TRY
		-- Update the existing school student K12StudentAcademicRecord
		-- The reason is that the generate migrate procedures use the OrganizationPersonRoleId and not using the OrganizationPersonRoleId with program organization Id.
		Update ar
		SET DiplomaOrCredentialAwardDate = stp.DiplomaCredentialAwardDate
			,RefHighSchoolDiplomaTypeId = 
			CASE
				WHEN stp.Outcome = 'EARNDIPL' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00806')
				WHEN stp.Outcome = 'EARNEGED' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00816')
			END 
			, RefPsEnrollmentActionId = act.RefPsEnrollmentActionId
		FROM Staging.ProgramParticipationNorD stp
		JOIN dbo.OrganizationPersonRole op 
			ON stp.PersonID = op.PersonId 
			AND stp.OrganizationID_School = op.OrganizationId
		JOIN dbo.K12StudentAcademicRecord ar 
			ON ar.OrganizationPersonRoleId = op.OrganizationPersonRoleId
	--	JOIN @NewOrganizationPersonRoleNoD nop ON nop.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleID_Program
		LEFT JOIN dbo.K12StudentAcademicRecord k12 
			ON k12.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_Program_School
		LEFT JOIN [dbo].[RefHighSchoolDiplomaType] t 
			ON t.Code = stp.Outcome
		LEFT JOIN dbo.RefPsEnrollmentAction act 
			ON act.Code = stp.Outcome
		WHERE stp.Outcome IN ('EARNDIPL', 'EARNEGED') 

		-- FS083 Diploma/Credential (Expanded)
		INSERT INTO dbo.K12StudentAcademicRecord (
			OrganizationPersonRoleId
			,DiplomaOrCredentialAwardDate
			,RefHighSchoolDiplomaTypeId
			,RefPsEnrollmentActionId
		) 
		SELECT 
			stp.OrganizationPersonRoleID_Program_School
			,stp.DiplomaCredentialAwardDate
			,CASE
				WHEN stp.Outcome = 'EARNDIPL' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00806')
				WHEN stp.Outcome = 'EARNEGED' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00816')
			END
			, act.RefPsEnrollmentActionId
		FROM Staging.ProgramParticipationNorD stp
		JOIN @NewLEAOrganizationPersonRoleNoD nop 
			ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_Program_School
		LEFT JOIN dbo.K12StudentAcademicRecord  k12		
			ON k12.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_Program_School
		LEFT JOIN dbo.RefHighSchoolDiplomaType t 
			ON t.Code = stp.Outcome
		LEFT JOIN dbo.RefPsEnrollmentAction act 
			ON act.Code = stp.Outcome
		WHERE stp.Outcome IN ('EARNDIPL', 'EARNEGED') AND k12.RefHighSchoolDiplomaTypeId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentAcademicRecord', NULL, 'S11EC360'
	END CATCH

	--BEGIN TRY
	--	-- populate ADVTRAIN for new records
	--	--INSERT INTO dbo.PsStudentEnrollment (
			--OrganizationPersonRoleId
			--, EntryDateIntoPostSecondary)
	--	--SELECT stp.OrganizationPersonRoleID_Program_School
			--, stp.AdvancedTrainingEnrollmentDate
	--	--FROM Staging.ProgramParticipationNorD stp
	--	--JOIN @NewOrganizationPersonRoleNoD nop 
	--	--	ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleId_Program_School
	--	--WHERE stp.AdvancedTrainingEnrollmentDate IS NOT NULL
	--END TRY

	--BEGIN CATCH 
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PsStudentEnrollment', NULL, 'S11EC210'
	--END CATCH

	-- populate EMPLOYMENT for new records
	BEGIN TRY
		INSERT INTO dbo.WorkforceEmploymentQuarterlyData (
			OrganizationPersonRoleId
			, RefEmployedAfterExitId
		)
		SELECT stp.OrganizationPersonRoleId_Program_School
			, @RefEmployedAfterExitId
		FROM Staging.ProgramParticipationNorD stp
		JOIN @NewSchoolOrganizationPersonRoleNoD nop 
			ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleId_Program_School
		LEFT JOIN dbo.WorkforceEmploymentQuarterlyData wf 
			ON wf.OrganizationPersonRoleId = OrganizationPersonRoleId_Program_School
			AND wf.RefEmployedAfterExitId = @RefEmployedAfterExitId
		WHERE stp.Outcome = 'OBTAINEMP' AND wf.OrganizationPersonRoleId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.WorkforceEmploymentQuarterlyData', NULL, 'S11EC370'
	END CATCH


	-- populate POSTSEC for new records
	BEGIN TRY
		INSERT INTO dbo.WorkforceProgramParticipation (
			PersonProgramParticipationId
			, RefWfProgramParticipationId
		)
		SELECT stp.PersonProgramParticipationId_School
			, @RefWfProgramParticipationId
		FROM Staging.ProgramParticipationNorD stp
		JOIN @NewLEAOrganizationPersonRoleNoD nop 
			ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleId_Program_School
		LEFT JOIN dbo.WorkforceProgramParticipation wfpp 
			ON wfpp.PersonProgramParticipationId = stp.PersonProgramParticipationId_School
			AND wfpp.RefWfProgramParticipationId = @RefWfProgramParticipationId
		WHERE stp.Outcome = 'POSTSEC'
			AND wfpp.PersonProgramParticipationId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.WorkforceProgramParticipation', NULL, 'S11EC380'
	END CATCH

	-- Populate Progresslevel-Math
	BEGIN TRY
		INSERT INTO [dbo].[ProgramParticipationNeglectedProgressLevel] (
			[PersonProgramParticipationId]
			,[RefAcademicSubjectId]
			,[RefProgressLevelId]
		)
		SELECT stp.PersonProgramParticipationId_School
			, @RefAcademicSubject_MathId
			, refpl.RefProgressLevelId
		FROM Staging.ProgramParticipationNorD stp
		JOIN @NewSchoolOrganizationPersonRoleNoD nop 
			ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleId_Program_School
		JOIN Staging.SourceSystemReferenceData rd 
			ON rd.InputCode = stp.ProgressLevel_Math 
			AND rd.TableName = 'RefProgressLevel'
		JOIN dbo.RefProgressLevel refpl 
			ON refpl.Code = rd.OutputCode
		LEFT JOIN dbo.ProgramParticipationNeglectedProgressLevel pl 
			ON pl.PersonProgramParticipationId = stp.PersonProgramParticipationId_School
			AND pl.RefAcademicSubjectId = @RefAcademicSubject_MathId
		WHERE pl.ProgramParticipationNeglectedProgressLevelId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationNeglectedProgressLevel', NULL, 'S11EC390'
	END CATCH

	-- Populate Progresslevel-ELA
	BEGIN TRY
		INSERT INTO [dbo].[ProgramParticipationNeglectedProgressLevel] (
			[PersonProgramParticipationId]
			,[RefAcademicSubjectId]
			,[RefProgressLevelId]
		)
		SELECT stp.PersonProgramParticipationId_School
			, ref.RefAcademicSubjectId
			, refpl.RefProgressLevelId
		FROM Staging.ProgramParticipationNorD stp
		JOIN @NewSchoolOrganizationPersonRoleNoD nop 
			ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleId_Program_School
		JOIN Staging.SourceSystemReferenceData rd 
			ON rd.InputCode = stp.ProgressLevel_Reading 
			AND rd.TableName = 'RefProgressLevel'
		JOIN dbo.RefProgressLevel refpl 
			ON refpl.Code = rd.OutputCode
		JOIN Staging.AssessmentResult ar 
			ON ar.Student_Identifier_State = stp.Student_Identifier_State
		LEFT JOIN dbo.RefAcademicSubject ref 
			on ref.Description = RTRIM(LTRIM(ar.AssessmentAcademicSubject))
		LEFT JOIN dbo.ProgramParticipationNeglectedProgressLevel pl 
			ON pl.PersonProgramParticipationId = stp.PersonProgramParticipationId_School
			AND pl.RefAcademicSubjectId = @RefAcademicSubject_ELAId
		WHERE pl.ProgramParticipationNeglectedProgressLevelId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationNeglectedProgressLevel', NULL, 'S11EC400'
	END CATCH

	set nocount off;

END







/*
	BEGIN TRY
		-- Update the existing school student K12StudentAcademicRecord
		-- The reason is that the generate migrate procedures use the OrganizationPersonRoleId and not using the OrganizationPersonRoleId with program organization Id.
		Update ar
		SET DiplomaOrCredentialAwardDate = stp.DiplomaCredentialAwardDate
			,RefHighSchoolDiplomaTypeId = 
			CASE
				WHEN stp.Outcome = 'EARNDIPL' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00806')
				WHEN stp.Outcome = 'EARNEGED' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00816')
			END 
			, RefPsEnrollmentActionId = act.RefPsEnrollmentActionId
		FROM Staging.ProgramParticipationNorD stp
		JOIN dbo.OrganizationPersonRole op 
			ON stp.PersonID = op.PersonId AND stp.OrganizationID_School = op.OrganizationId
		JOIN dbo.K12StudentAcademicRecord ar ON  ar.OrganizationPersonRoleId = op.OrganizationPersonRoleId
	--	JOIN @NewOrganizationPersonRoleNoD nop ON nop.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleID_Program
		LEFT JOIN dbo.K12StudentAcademicRecord  k12 ON k12.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleID_Program
		LEFT JOIN [dbo].[RefHighSchoolDiplomaType] t ON t.Code = stp.Outcome
		LEFT JOIN dbo.RefPsEnrollmentAction act ON act.Code = stp.Outcome
		WHERE stp.Outcome IN ('EARNDIPL', 'EARNEGED') 

		-- FS083 Diploma/Credential (Expanded)
		INSERT INTO dbo.K12StudentAcademicRecord 
		(
			OrganizationPersonRoleId
			,DiplomaOrCredentialAwardDate
			,RefHighSchoolDiplomaTypeId
			,RefPsEnrollmentActionId
		) 
		SELECT 
			stp.LEAOrganizationPersonRoleID_Program
			,stp.DiplomaCredentialAwardDate
			,CASE
				WHEN stp.Outcome = 'EARNDIPL' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00806')
				WHEN stp.Outcome = 'EARNEGED' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00816')
			END
			, act.RefPsEnrollmentActionId
		FROM Staging.ProgramParticipationNorD stp
		JOIN @NewOrganizationPersonRoleNoD nop ON nop.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleID_Program
		LEFT JOIN dbo.K12StudentAcademicRecord  k12 ON k12.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleID_Program
		LEFT JOIN [dbo].[RefHighSchoolDiplomaType] t ON t.Code = stp.Outcome
		LEFT JOIN dbo.RefPsEnrollmentAction act ON act.Code = stp.Outcome
		WHERE stp.Outcome IN ('EARNDIPL', 'EARNEGED') AND k12.RefHighSchoolDiplomaTypeId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentAcademicRecord', NULL, 'S11EC210'
	END CATCH

	--BEGIN TRY
	--	-- populate ADVTRAIN for new records
	--	--INSERT INTO dbo.PsStudentEnrollment (OrganizationPersonRoleId, EntryDateIntoPostSecondary)
	--	--SELECT stp.OrganizationPersonRoleID_CTEProgram, stp.AdvancedTrainingEnrollmentDate
	--	--FROM Staging.ProgramParticipationNorD stp
	--	--JOIN @NewOrganizationPersonRoleNoD nop 
	--	--	ON nop.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleId_Program
	--	--WHERE stp.AdvancedTrainingEnrollmentDate IS NOT NULL
	--END TRY

	--BEGIN CATCH 
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PsStudentEnrollment', NULL, 'S11EC210'
	--END CATCH

	/*
		Staging.[Migrate_Data_ETL_IMPLEMENTATION_STEP11_ProgramParticipationNorD_EncapsulatedCode] 2018
	*/


	-- populate EMPLOYMENT for new records
	DECLARE @RefEmployedAfterExitId INT
	SELECT @RefEmployedAfterExitId = (SELECT RefEmployedAfterExitId FROM dbo.RefEmployedAfterExit
		WHERE dbo.RefEmployedAfterExit.Code = 'Yes')		-- Code = 'Yes'

	BEGIN TRY
		INSERT INTO dbo.WorkforceEmploymentQuarterlyData (OrganizationPersonRoleId, RefEmployedAfterExitId)
		SELECT stp.LEAOrganizationPersonRoleId_Program, @RefEmployedAfterExitId
		FROM Staging.ProgramParticipationNorD stp
		JOIN @NewOrganizationPersonRoleNoD nop 
			ON nop.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleId_Program
		LEFT JOIN dbo.WorkforceEmploymentQuarterlyData wf 
			ON wf.OrganizationPersonRoleId = LEAOrganizationPersonRoleId_Program AND wf.RefEmployedAfterExitId = @RefEmployedAfterExitId
		WHERE stp.Outcome = 'OBTAINEMP' AND wf.OrganizationPersonRoleId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.WorkforceEmploymentQuarterlyData', NULL, 'S11EC220'
	END CATCH


	-- populate POSTSEC for new records
	DECLARE @RefWfProgramParticipationId INT
	SELECT @RefWfProgramParticipationId = (SELECT RefWfProgramParticipationId FROM dbo.RefWfProgramParticipation
		WHERE dbo.RefWfProgramParticipation.Code = '06')		-- Code = 'Adult Education and Literacy'

	BEGIN TRY
		INSERT INTO dbo.WorkforceProgramParticipation (PersonProgramParticipationId, RefWfProgramParticipationId)
			SELECT stp.PersonProgramParticipationId, @RefWfProgramParticipationId
			FROM Staging.ProgramParticipationNorD stp
			JOIN @NewOrganizationPersonRoleNoD nop 
				ON nop.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleId_Program
			LEFT JOIN dbo.WorkforceProgramParticipation wfpp 
				ON wfpp.PersonProgramParticipationId = stp.PersonProgramParticipationId 
				AND wfpp.RefWfProgramParticipationId = @RefWfProgramParticipationId
			WHERE stp.Outcome = 'POSTSEC'
				AND wfpp.PersonProgramParticipationId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.WorkforceProgramParticipation', NULL, 'S11EC230'
	END CATCH

	-- Populate Progresslevel-Math
	DECLARE @RefAcademicSubject_MathId INT
	SELECT @RefAcademicSubject_MathId = 
		(SELECT RefAcademicSubjectId FROM dbo.RefAcademicSubject WHERE Code = '01166')		-- Code = 'Mathematics'

	BEGIN TRY
		INSERT INTO [dbo].[ProgramParticipationNeglectedProgressLevel]
			(
			[PersonProgramParticipationId]
			,[RefAcademicSubjectId]
			,[RefProgressLevelId]
			)
		SELECT stp.PersonProgramParticipationId, @RefAcademicSubject_MathId, refpl.RefProgressLevelId
		FROM Staging.ProgramParticipationNorD stp
		JOIN @NewOrganizationPersonRoleNoD nop ON nop.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleId_Program
		JOIN Staging.[SourceSystemReferenceData] rd ON rd.InputCode = stp.ProgressLevel_Math AND rd.TableName = 'RefProgressLevel'
		JOIN [dbo].[RefProgressLevel] refpl ON refpl.Code = rd.OutputCode
		LEFT JOIN dbo.ProgramParticipationNeglectedProgressLevel pl 
			ON pl.PersonProgramParticipationId = stp.PersonProgramParticipationId 
			AND pl.RefAcademicSubjectId = @RefAcademicSubject_MathId
		WHERE pl.ProgramParticipationNeglectedProgressLevelId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationNeglectedProgressLevel', NULL, 'S11EC240'
	END CATCH

	-- Populate Progresslevel-ELA
	DECLARE @RefAcademicSubject_ELAId INT
	SELECT @RefAcademicSubject_ELAId = 
		(SELECT RefAcademicSubjectId FROM dbo.RefAcademicSubject WHERE Code = '13372')		-- Code = 'English'


	BEGIN TRY
		INSERT INTO [dbo].[ProgramParticipationNeglectedProgressLevel]
			(
			[PersonProgramParticipationId]
			,[RefAcademicSubjectId]
			,[RefProgressLevelId]
			)
		SELECT stp.PersonProgramParticipationId, ref.RefAcademicSubjectId, refpl.RefProgressLevelId
		FROM Staging.ProgramParticipationNorD stp
		JOIN @NewOrganizationPersonRoleNoD nop ON nop.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleId_Program
		JOIN Staging.[SourceSystemReferenceData] rd ON rd.InputCode = stp.ProgressLevel_Reading AND rd.TableName = 'RefProgressLevel'
		JOIN [dbo].[RefProgressLevel] refpl ON refpl.Code = rd.OutputCode
		JOIN [Staging].[AssessmentResult] ar ON ar.Student_Identifier_State = stp.Student_Identifier_State
		LEFT JOIN dbo.RefAcademicSubject ref on ref.Description = RTRIM(LTRIM(ar.AssessmentAcademicSubject))
		LEFT JOIN dbo.ProgramParticipationNeglectedProgressLevel pl 
			ON pl.PersonProgramParticipationId = stp.PersonProgramParticipationId 
			AND pl.RefAcademicSubjectId = @RefAcademicSubject_ELAId
		WHERE pl.ProgramParticipationNeglectedProgressLevelId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationNeglectedProgressLevel', NULL, 'S11EC250'
	END CATCH
*/