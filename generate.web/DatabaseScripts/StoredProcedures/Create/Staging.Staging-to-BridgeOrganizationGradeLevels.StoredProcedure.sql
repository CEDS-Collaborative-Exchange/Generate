CREATE PROCEDURE [Staging].[Staging-to-BridgeOrganizationGradeLevels]
	@dataCollectionName AS VARCHAR(50) = NULL,
	@runAsTest AS BIT 
AS 
BEGIN

	/*---------------------------------------------------------------------------------------------------
	NOTE: This SP has 3 steps:
		1. load the school grades offered based on staging.OrganizationGradeOffered
		2. roll the school grades offered up to create the LEA grades as it was done previously.
		3. check Staging.OrganizationGradeOffered to see if any rows were added for any LEAs.  If
		so, create the LEA grades for those, but only the ones loaded into Staging.  
		
		If the LEA is not specifically loaded in Staging, then the rolled up grades from the schools 
		will be loaded for the LEA.
	---------------------------------------------------------------------------------------------------*/
	SET NOCOUNT ON;

	BEGIN TRY

		--Set the variables needed for the SP
		DECLARE @SchoolYear int
		SELECT @SchoolYear = (	select sy.SchoolYear
								from rds.DimSchoolYearDataMigrationTypes dm
									inner join rds.dimschoolyears sy
										on dm.dimschoolyearid = sy.dimschoolyearid
								where IsSelected = 1
								and dm.DataMigrationTypeId = 3
							)

		DECLARE @SYEndDate DATE
		SELECT @SYEndDate = CAST('6/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)

		-- School Grade Levels
		CREATE TABLE #schoolgradeLevels (
			DimK12SchoolId INT
			, DimGradeLevelId INT
		)

		--Load the School grades into a CTE
		;WITH schoolgradeLevels as (
			SELECT distinct 
				rdks.DimK12SchoolId
				, rdgl.DimGradeLevelId 
			FROM rds.DimK12Schools rdks
			JOIN staging.OrganizationGradeOffered  sogo
				ON rdks.SchoolIdentifierSea = sogo.OrganizationIdentifier
				AND rdks.RecordStartDateTime = sogo.RecordStartDateTime
				-- Record Start/End Dates must match between Staging.K12Organization and Staging.OrganizationGradesOffered
				AND ISNULL(rdks.RecordEndDateTime, '01/01/1900') = ISNULL(sogo.RecordEndDateTime, isnull(rdks.RecordEndDateTime, '01/01/1900'))
				AND sogo.OrganizationType = 'K12School'
			JOIN rds.vwDimGradeLevels rdgl
				ON sogo.GradeOffered = rdgl.GradeLevelMap
				AND rdgl.GradeLevelTypeCode = '000131'
				and sogo.SchoolYear = rdgl.SchoolYear
		)

		--Using the temp table above, populate the school bridge table with the school grades
		MERGE rds.BridgeK12SchoolGradeLevels AS trgt
		USING schoolgradeLevels AS src
				ON trgt.K12SchoolId = src.DimK12SchoolId
				AND trgt.GradeLevelId = src.DimGradeLevelId
		WHEN NOT MATCHED THEN
		INSERT(K12SchoolId, GradeLevelId) values(src.DimK12SchoolId, src.DimGradeLevelId);


		--Start the LEA process by rolling up the School Grade Levels
		;WITH rolledUpLeaGrades as (
			SELECT DISTINCT
				rdl.DimLeaID
				, rdgl.DimGradeLevelId 
			FROM RDS.DimK12Schools rdks
			JOIN RDS.DimLeas rdl
				ON rdks.LeaIdentifierSea = rdl.LeaIdentifierSea
				AND rdks.RecordStartDateTime BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, @SYEndDate)
			JOIN Staging.K12Organization sko
				ON sko.LEAIdentifierSea = rdl.LeaIdentifierSea
				AND rdks.SchoolIdentifierSea = sko.SchoolIdentifierSea
			JOIN Staging.OrganizationGradeOffered sogo
				ON rdks.SchoolIdentifierSea = sogo.OrganizationIdentifier
			JOIN RDS.vwDimGradeLevels rdgl
				ON sogo.GradeOffered = rdgl.GradeLevelMap
				AND rdgl.GradeLevelTypeCode = '000131'
				AND rdgl.SchoolYear = sogo.SchoolYear	
		)

		--Using the CTE above, populate the LEA bridge table with the rolled up school grades
		MERGE rds.BridgeLeaGradeLevels AS trgt
		USING rolledUpLeaGrades AS src
			ON trgt.LeaId = src.DimLeaId
			AND trgt.GradeLevelId = src.DimGradeLevelId
		WHEN NOT MATCHED THEN
		INSERT (LeaId, GradeLevelId) VALUES (src.DimLeaID, src.DimGradeLevelId);

		--Check if there are any LEA grades loaded in Staging
		IF (SELECT count(*) FROM Staging.OrganizationGradeOffered WHERE OrganizationType = 'LEA' and SchoolYear = @SchoolYear) > 0
		BEGIN
			;WITH LeaGrades as (
				SELECT DISTINCT
					rdl.DimLeaID
					, rdgl.DimGradeLevelId 
				FROM RDS.DimLeas rdl
				JOIN Staging.K12Organization sko
					ON sko.LEAIdentifierSea = rdl.LeaIdentifierSea
					AND rdl.LeaIdentifierSea = sko.LeaIdentifierSea
				JOIN Staging.OrganizationGradeOffered sogo
					ON rdl.LeaIdentifierSea = sogo.OrganizationIdentifier
					AND sogo.OrganizationType = 'LEA'
				JOIN RDS.vwDimGradeLevels rdgl
					ON sogo.GradeOffered = rdgl.GradeLevelMap
					AND rdgl.GradeLevelTypeCode = '000131'
					AND rdgl.SchoolYear = sogo.SchoolYear	
			)

			--Using the LeaGrades CTE above, populate the LEA bridge table with grades specifically loaded in Staging
			MERGE rds.BridgeLeaGradeLevels AS trgt
			USING LeaGrades AS src
				ON trgt.LeaId = src.DimLeaId
				AND trgt.GradeLevelId = src.DimGradeLevelId
			WHEN NOT MATCHED THEN
				INSERT (LeaId, GradeLevelId) VALUES (src.DimLeaID, src.DimGradeLevelId);

		END

	END TRY
	BEGIN CATCH

		DECLARE @msg AS NVARCHAR(MAX)
		SET @msg = ERROR_MESSAGE()

		DECLARE @sev AS INT
		SET @sev = ERROR_SEVERITY()

		RAISERROR(@msg, @sev, 1)

	END CATCH

	SET NOCOUNT OFF;

END