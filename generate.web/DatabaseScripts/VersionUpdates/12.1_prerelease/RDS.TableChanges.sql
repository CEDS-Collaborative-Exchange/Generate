    IF COL_LENGTH('RDS.FactK12StudentAssessments', 'PrimaryDisabilityTypeId') IS NULL
    BEGIN
        ALTER TABLE RDS.FactK12StudentAssessments ADD PrimaryDisabilityTypeId int not null default(-1)
    END