CREATE PROCEDURE [RDS].[Migrate_DimDates_Organizations]
	@organizationType as varchar(10)
AS
BEGIN

	IF @organizationType = 'SEA'
	BEGIN
		select distinct	s.DimSeaId, s.SeaStateIdentifier, d.DimDateId
		from rds.DimSeas s
		CROSS JOIN rds.DimDates d
		inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId 
		inner join rds.DimDataMigrationTypes b on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
		where d.DimDateId <> -1 and dd.IsSelected=1 and DataMigrationTypeCode= 'rds' and s.DimSeaId <> -1
		
	END
	ELSE IF @organizationType = 'LEA'
	BEGIN
		select 
				Lea.DimLeaId
			  , Lea.LeaStateIdentifier
			  , d.DimDateId
			  , Lea.OperationalStatusEffectiveDate
		into #leas
		from rds.DimLeas Lea 
		inner JOIN rds.DimDates d
			ON Lea.OperationalStatusEffectiveDate BETWEEN DATEADD(DAY, 1, DATEFROMPARTS(d.[Year], 7, 1)) 
				AND DATEFROMPARTS(d.[Year] + 1, 6, 30)
		inner join rds.DimDateDataMigrationTypes dd 
			on dd.DimDateId=d.DimDateId 
		inner join rds.DimDataMigrationTypes b 
			on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
		where d.DimDateId <> -1 
			and dd.IsSelected=1 
			and DataMigrationTypeCode= 'rds' 
			and Lea.DimLeaId <> -1	
			and Lea.LeaOperationalStatus <> 'MISSING'

		INSERT INTO #leas
		select 
				-1
			  , Lea.LeaStateIdentifier
			  , d.DimDateId
			  , MAX(OperationalStatusEffectiveDate)
		from rds.DimLeas lea 
		inner JOIN rds.DimDates d
			on lea.OperationalStatusEffectiveDate <= DATEFROMPARTS(d.[Year], 7, 1)
		inner join rds.DimDateDataMigrationTypes dd 
			on dd.DimDateId=d.DimDateId 
		inner join rds.DimDataMigrationTypes b 
			on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
		where d.DimDateId <> -1 
			and dd.IsSelected=1 
			and DataMigrationTypeCode= 'rds' 
			and lea.DimLeaID <> -1
		group by lea.LeaStateIdentifier, d.DimDateId, lea.OperationalStatusEffectiveDate

		UPDATE #Leas
		SET DimLeaId = lea.DimLeaId
		FROM #Leas l
		JOIN rds.DimLeas lea
			ON l.LeaStateIdentifier = lea.LeaStateIdentifier
			AND l.OperationalStatusEffectiveDate = lea.OperationalStatusEffectiveDate
		WHERE l.DimLeaId = -1

		SELECT DimLeaId, LeaStateIdentifier, DimDateId FROM #Leas ORDER BY LeaStateIdentifier

		DROP TABLE #Leas
	END
	ELSE IF @organizationType = 'SCHOOL'
	BEGIN
		select 
				Sch.DimSchoolId
			  , Sch.SchoolStateIdentifier
			  , d.DimDateId
			  , Sch.OperationalStatusEffectiveDate
		into #Schools
		from rds.DimSchools Sch 
		inner JOIN rds.DimDates d
			ON Sch.OperationalStatusEffectiveDate BETWEEN DATEADD(DAY, 1, DATEFROMPARTS(d.[Year], 7, 1)) 
				AND DATEFROMPARTS(d.[Year] + 1, 6, 30)
		inner join rds.DimDateDataMigrationTypes dd 
			on dd.DimDateId=d.DimDateId 
		inner join rds.DimDataMigrationTypes b 
			on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
		Where Sch.DimSchoolId <> -1	
		and Sch.SchoolOperationalStatus <> 'MISSING'
		AND d.DimDateId <> -1 
		and dd.IsSelected = 1 
		and DataMigrationTypeCode= 'rds' 

		INSERT INTO #Schools
		select 
				-1
			  , Sch.SchoolStateIdentifier
			  , d.DimDateId
			  , MAX(OperationalStatusEffectiveDate)
		from rds.DimSchools Sch 
		inner JOIN rds.DimDates d
			ON Sch.OperationalStatusEffectiveDate <= DATEFROMPARTS(d.[Year], 6, 30)
		inner join rds.DimDateDataMigrationTypes dd 
			on dd.DimDateId=d.DimDateId 
		inner join rds.DimDataMigrationTypes b 
			on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
		Where Sch.DimSchoolID <> -1	
		and Sch.SchoolOperationalStatus <> 'MISSING'
		AND d.DimDateId <> -1 
		and dd.IsSelected = 1 
		and DataMigrationTypeCode= 'rds' 
		group by Sch.SchoolStateIdentifier, d.DimDateId

		UPDATE #Schools
		SET DimSchoolId = sch.DimSchoolId
		FROM #Schools s
		JOIN rds.DimSchools sch
			ON s.SchoolStateIdentifier = sch.SchoolStateIdentifier
			AND s.OperationalStatusEffectiveDate = sch.OperationalStatusEffectiveDate
		WHERE s.DimSchoolId = -1

		SELECT DimSchoolId, SchoolStateIdentifier, DimDateId FROM #Schools ORDER BY SchoolStateIdentifier

		DROP TABLE #Schools
	END
END
