CREATE PROCEDURE [RDS].[Migrate_DimK12Races]
	@factTypeCode AS VARCHAR(50),
	@studentDates AS RDS.K12StudentDateTableType READONLY,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionid AS INT = NULL,
	@useCutOffDate AS BIT = 0,
	@loadAllForDataCollection AS BIT = 0
AS
BEGIN

	SET NOCOUNT ON;
										
	DECLARE @missingDimRaceId AS INT
	SELECT @missingDimRaceId = DimRaceId FROM rds.DimRaces WHERE RaceCode = 'MISSING'
				
	DECLARE @TwoorMoreRacesDimRaceId AS INT
	SELECT @TwoorMoreRacesDimRaceId = DimRaceId FROM rds.DimRaces WHERE RaceCode = 'TwoorMoreRaces'
	

	-- Data Population
	IF(@factTypeCode = 'datapopulation')
	BEGIN

		SELECT DISTINCT
			  d.DimK12StudentId
			, d.DimCountDateId
			, so.DimLeaId
			, so.DimK12SchoolId
			, race.DimRaceId
			, CASE
			  	WHEN race.DimRaceId IS NULL THEN 'MISSING'
			  	ELSE race.RaceCode
			  END AS RaceCode
			, ISNULL(pdr.RecordStartDateTime, ISNULL(pd.RecordStartDateTime, d.SessionBeginDate)) AS RaceRecordStartDate
			, pdr.RecordEndDateTime AS RaceRecordEndDate
		FROM @studentDates d 
		JOIN @studentOrganizations so
			ON d.PersonId = so.PersonId
		LEFT JOIN dbo.PersonDemographicRace pdr 
			ON d.PersonId = pdr.PersonId
			AND (@loadAllForDataCollection = 1
				OR (pdr.RecordStartDateTime <=
					CASE
						WHEN @useCutOffDate = 0 THEN d.SessionEndDate
						ELSE d.CountDate
					END 
				AND (
					pdr.RecordEndDateTime >=
						CASE
							WHEN @useCutOffDate = 0 THEN d.SessionBeginDate
							ELSE d.CountDate
						END 
				OR pdr.RecordEndDateTime IS NULL)))
			AND (@dataCollectionId IS NULL 
				OR pdr.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.PersonDetail pd
			ON d.PersonId = pd.PersonId
			AND (@loadAllForDataCollection = 1
				OR (pd.RecordStartDateTime <=
					CASE
						WHEN @useCutOffDate = 0 THEN d.SessionEndDate
						ELSE d.CountDate
					END 
				AND (
					pd.RecordEndDateTime >=
						CASE
							WHEN @useCutOffDate = 0 THEN d.SessionBeginDate
							ELSE d.CountDate
						END 
				OR pd.RecordEndDateTime IS NULL)))
			AND (@dataCollectionId IS NULL 
				OR pd.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.RefRace rr 
			ON pdr.RefRaceId = rr.RefRaceId
		LEFT JOIN rds.DimRaces race 
			ON rr.Code = race.RaceCode 
			OR (pd.HispanicLatinoEthnicity = 1 
				AND race.RaceCode = 'HispanicLatinoEthnicity')

	END
	ELSE IF(@factTypeCode = 'reporting')
	BEGIN
				
		SELECT DISTINCT
			  d.DimK12StudentId
			, d.DimCountDateId
			, so.DimLeaId
			, so.DimK12SchoolId
			, race.DimRaceId
			, race.RaceCode
			, ISNULL(pdr.RecordStartDateTime, ISNULL(pd.RecordStartDateTime, d.SessionBeginDate)) AS RaceRecordStartDate
			, pdr.RecordEndDateTime AS RaceRecordEndDate
		FROM @studentDates d 
		JOIN @studentOrganizations so
			ON d.PersonId = so.PersonId
		JOIN dbo.OrganizationPersonRole opr
			ON d.PersonId = opr.PersonId
		JOIN dbo.PersonDemographicRace pdr 
			ON d.PersonId = pdr.PersonId
			AND (@loadAllForDataCollection = 1
				OR (pdr.RecordStartDateTime <=
					CASE
						WHEN @useCutOffDate = 0 THEN d.SessionEndDate
						ELSE d.CountDate
					END 
				AND (
					pdr.RecordEndDateTime >=
						CASE
							WHEN @useCutOffDate = 0 THEN d.SessionBeginDate
							ELSE d.CountDate
						END 
				OR pdr.RecordEndDateTime IS NULL)))
			AND (@dataCollectionId IS NULL 
				OR pdr.DataCollectionId = @dataCollectionId)	
		JOIN dbo.RefRace rr 
			ON pdr.RefRaceId = rr.RefRaceId
		JOIN dbo.PersonDetail pd
			ON d.PersonId = pd.PersonId
			AND (@loadAllForDataCollection = 1
				OR (pd.RecordStartDateTime <=
					CASE
						WHEN @useCutOffDate = 0 THEN d.SessionEndDate
						ELSE d.CountDate
					END 
				AND (
					pd.RecordEndDateTime >=
						CASE
							WHEN @useCutOffDate = 0 THEN d.SessionBeginDate
							ELSE d.CountDate
						END 
				OR pd.RecordEndDateTime IS NULL)))
			AND (@dataCollectionId IS NULL 
				OR pd.DataCollectionId = @dataCollectionId)	
		JOIN rds.DimRaces race 
			ON rr.Code = race.RaceCode
			OR (pd.HispanicLatinoEthnicity = 1 
				AND race.RaceCode = 'HispanicorLatinoEthnicity')
		ORDER BY d.DimK12StudentId 
		
	END
	ELSE 
	BEGIN
				
		SELECT DISTINCT
			  d.DimK12StudentId
			, d.DimCountDateId
			, so.DimLeaId
			, so.DimK12SchoolId
			, race.DimRaceId
			, race.RaceCode
			, ISNULL(pdr.RecordStartDateTime, ISNULL(pd.RecordStartDateTime, d.SessionBeginDate)) AS RaceRecordStartDate
			, pdr.RecordEndDateTime AS RaceRecordEndDate
		FROM @studentDates d 
		JOIN @studentOrganizations so
			ON d.PersonId = so.PersonId
		LEFT JOIN (
				SELECT d2.PersonId, count(1) AS RaceCount
				FROM @studentDates d2
				LEFT JOIN dbo.PersonDemographicRace pdr2
					ON d2.PersonId = pdr2.PersonId
					AND pdr2.RecordStartDateTime <=
						CASE
							WHEN @useCutOffDate = 0 THEN d2.SessionEndDate
							ELSE d2.CountDate
						END 
					AND (
						pdr2.RecordEndDateTime >=
							CASE
								WHEN @useCutOffDate = 0 THEN d2.SessionBeginDate
								ELSE d2.CountDate
							END 
					OR pdr2.RecordEndDateTime IS NULL)
					AND (@dataCollectionId IS NULL 
						OR pdr2.DataCollectionId = @dataCollectionId)	
				GROUP BY d2.PersonId
				) AS rc
				ON d.PersonId = rc.PersonId
		LEFT JOIN dbo.PersonDemographicRace pdr 
			ON d.PersonId = pdr.PersonId
			AND pdr.RecordStartDateTime <=
				CASE
					WHEN @useCutOffDate = 0 THEN d.SessionEndDate
					ELSE d.CountDate
				END 
			AND (
				pdr.RecordEndDateTime >=
					CASE
						WHEN @useCutOffDate = 0 THEN d.SessionBeginDate
						ELSE d.CountDate
					END 
			OR pdr.RecordEndDateTime IS NULL)
			AND (@dataCollectionId IS NULL 
				OR pdr.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.PersonDetail pd
			ON d.PersonId = pd.PersonId
			AND pd.RecordStartDateTime <=
				CASE
					WHEN @useCutOffDate = 0 THEN d.SessionEndDate
					ELSE d.CountDate
				END 
			AND (
				pd.RecordEndDateTime >=
					CASE
						WHEN @useCutOffDate = 0 THEN d.SessionBeginDate
						ELSE d.CountDate
					END 
			OR pd.RecordEndDateTime IS NULL)
			AND (@dataCollectionId IS NULL 
				OR pd.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.RefRace rr 
			ON pdr.RefRaceId = rr.RefRaceId
		join rds.DimRaces race
			on ((pd.HispanicLatinoEthnicity = 1 
				and race.RaceCode = 'HispanicorLatinoEthnicity')
			or (pd.HispanicLatinoEthnicity = 0 
				and rc.RaceCount = 1 
					and (race.RaceCode = rr.Code)) 
			or (pd.HispanicLatinoEthnicity = 0 
				and rc.RaceCount > 1 
				and race.DimRaceId = @TwoorMoreRacesDimRaceId))
		ORDER BY d.DimK12StudentId 

	END



	SET NOCOUNT OFF;

END

