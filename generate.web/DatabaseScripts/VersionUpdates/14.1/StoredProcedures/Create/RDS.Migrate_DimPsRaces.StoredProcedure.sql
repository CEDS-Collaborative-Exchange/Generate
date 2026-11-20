CREATE PROCEDURE [RDS].[Migrate_DimPsRaces]
	@factTypeCode AS VARCHAR(50),
	@studentDates AS RDS.PsStudentDateTableType READONLY,
	@studentOrganizations AS RDS.PsStudentOrganizationTableType READONLY,
	@dataCollectionid AS INT = NULL,
	@useCutOffDate AS BIT = 0, 
	@loadAllForDataCollection AS BIT
AS
BEGIN

	SET NOCOUNT ON;

	SELECT DISTINCT
		  d.DimPsStudentId
		, o.DimPsInstitutionId
		, o.DimAcademicTermDesignatorId
		, ISNULL(race.DimRaceId, -1) AS DimRaceId
		, ISNULL(race.RaceCode, 'MISSING') AS RaceCode
		, ISNULL(pdr.RecordStartDateTime, ISNULL(pd.RecordStartDateTime, d.RecordStartDatetime)) AS RaceRecordStartDate
		, pdr.RecordEndDateTime AS RaceRecordEndDate
	FROM @studentDates d 
	INNER JOIN @studentOrganizations o
		ON d.DimPsStudentId = o.DimPsStudentId
		AND d.PersonId = o.PersonId
	LEFT JOIN dbo.PersonDemographicRace pdr 
		ON d.PersonId = pdr.PersonId
		AND pdr.RecordStartDateTime <=
			CASE
				WHEN @useCutOffDate = 0 THEN ISNULL(d.RecordEndDatetime,getdate())
				ELSE d.CountDate
			END 
		AND (
			pdr.RecordEndDateTime >=
				CASE
					WHEN @useCutOffDate = 0 THEN d.RecordStartDatetime
					ELSE d.CountDate
				END 
		OR pdr.RecordEndDateTime IS NULL)
		AND (@dataCollectionId IS NULL 
			OR pdr.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.PersonDetail pd
		ON d.PersonId = pd.PersonId
		AND (@loadAllForDataCollection = 1
			OR (pd.RecordStartDateTime <=
					CASE
						WHEN @useCutOffDate = 0 THEN d.RecordEndDatetime
						ELSE d.CountDate
					END 
				AND (
					pd.RecordEndDateTime >=
						CASE
							WHEN @useCutOffDate = 0 THEN d.RecordStartDatetime
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
			AND race.RaceCode = 'HispanicorLatinoEthnicity')

	SET NOCOUNT OFF;

END

