CREATE PROCEDURE [RDS].[Migrate_DimSchoolYears_Organizations]
	@organizationType as varchar(10)
AS
BEGIN

	IF @organizationType = 'SEA'
	BEGIN
		select distinct	s.DimSeaId, s.SeaIdentifierState, d.DimSchoolYearId
		from rds.DimSeas s
		CROSS JOIN rds.DimSchoolYears d
		inner join rds.DimSchoolYearDataMigrationTypes dd on dd.DimSchoolYearId = d.DimSchoolYearId
		inner join rds.DimDataMigrationTypes b on b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
		where d.DimSchoolYearId <> -1 and dd.IsSelected=1 and DataMigrationTypeCode= 'rds' and s.DimSeaId <> -1
		
	END
	ELSE IF @organizationType = 'LEA'
	BEGIN
		select 
				Lea.DimLeaId
			  , Lea.LeaIdentifierState
			  , d.DimSchoolYearId
			  , Lea.OperationalStatusEffectiveDate
		into #leas
		from rds.DimLeas Lea 
		inner JOIN rds.DimSchoolYears d
			ON Lea.OperationalStatusEffectiveDate BETWEEN DATEADD(DAY, 1, DATEFROMPARTS(d.SchoolYear, 7, 1)) 
				AND DATEFROMPARTS(d.SchoolYear + 1, 6, 30)
		inner join rds.DimSchoolYearDataMigrationTypes dd 
			on dd.DimSchoolYearId = d.DimSchoolYearId 
		inner join rds.DimDataMigrationTypes b 
			on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
		where d.DimSchoolYearId <> -1 
			and dd.IsSelected=1 
			and DataMigrationTypeCode= 'rds' 
			and Lea.DimLeaId <> -1	
			and Lea.LeaOperationalStatus <> 'MISSING'

		INSERT INTO #leas
		select 
				-1
			  , Lea.LeaIdentifierState
			  , d.DimSchoolYearId
			  , MAX(OperationalStatusEffectiveDate)
		from rds.DimLeas lea 
		inner JOIN rds.DimSchoolYears d
			on lea.OperationalStatusEffectiveDate <= DATEFROMPARTS(d.SchoolYear, 7, 1)
		inner join rds.DimSchoolYearDataMigrationTypes dd 
			on dd.DimSchoolYearId = d.DimSchoolYearId 
		inner join rds.DimDataMigrationTypes b 
			on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
		where d.DimSchoolYearId <> -1 
			and dd.IsSelected=1 
			and DataMigrationTypeCode= 'rds' 
			and lea.DimLeaID <> -1
		group by lea.LeaIdentifierState, d.DimSchoolYearId, lea.OperationalStatusEffectiveDate

		UPDATE #Leas
		SET DimLeaId = lea.DimLeaId
		FROM #Leas l
		JOIN rds.DimLeas lea
			ON l.LeaIdentifierState = lea.LeaIdentifierState
			AND l.OperationalStatusEffectiveDate = lea.OperationalStatusEffectiveDate
		WHERE l.DimLeaId = -1

		SELECT DimLeaId, LeaIdentifierState, DimSchoolYearId FROM #Leas ORDER BY LeaIdentifierState

		DROP TABLE #Leas
	END
	ELSE IF @organizationType = 'SCHOOL'
	BEGIN
		select 
				Sch.DimK12SchoolId
			  , Sch.SchoolIdentifierState
			  , d.DimSchoolYearId
			  , Sch.OperationalStatusEffectiveDate
		into #Schools
		from rds.DimK12Schools Sch 
		inner JOIN rds.DimSchoolYears d
			ON Sch.OperationalStatusEffectiveDate BETWEEN DATEADD(DAY, 1, DATEFROMPARTS(d.SchoolYear, 7, 1)) 
				AND DATEFROMPARTS(d.SchoolYear + 1, 6, 30)
		inner join rds.DimSchoolYearDataMigrationTypes dd 
			on dd.DimSchoolYearId = d.DimSchoolYearId 
		inner join rds.DimDataMigrationTypes b 
			on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
		Where Sch.DimK12SchoolId <> -1	
		and Sch.SchoolOperationalStatus <> 'MISSING'
		AND d.DimSchoolYearId <> -1 
		and dd.IsSelected = 1 
		and DataMigrationTypeCode= 'rds' 

		INSERT INTO #Schools
		select 
				-1
			  , Sch.SchoolIdentifierState
			  , d.DimSchoolYearId
			  , MAX(OperationalStatusEffectiveDate)
		from rds.DimK12Schools Sch 
		inner JOIN rds.DimSchoolYears d
			ON Sch.OperationalStatusEffectiveDate <= DATEFROMPARTS(d.SchoolYear, 6, 30)
		inner join rds.DimSchoolYearDataMigrationTypes dd 
			on dd.DimSchoolYearId = d.DimSchoolYearId 
		inner join rds.DimDataMigrationTypes b 
			on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
		Where Sch.DimK12SchoolID <> -1	
		and Sch.SchoolOperationalStatus <> 'MISSING'
		AND d.DimSchoolYearId <> -1 
		and dd.IsSelected = 1 
		and DataMigrationTypeCode= 'rds' 
		group by Sch.SchoolIdentifierState, d.DimSchoolYearId
		UPDATE #Schools
		SET DimK12SchoolId = sch.DimK12SchoolId
		FROM #Schools s
		JOIN rds.DimK12Schools sch
			ON s.SchoolIdentifierState = sch.SchoolIdentifierState
			AND s.OperationalStatusEffectiveDate = sch.OperationalStatusEffectiveDate
		WHERE s.DimK12SchoolId = -1

		SELECT DimK12SchoolId, SchoolIdentifierState, DimSchoolYearId FROM #Schools ORDER BY SchoolIdentifierState

		DROP TABLE #Schools
	END
END
