--Update Rds.DimFactTypes to include missing files/correctly identify with the correct FactType
update rds.DimFactTypes
set FactTypeDescription = 'ASSESSMENT - 050,113,125,126,137,138,139,175,178,179,185,188,189,210,211,224,225'
where FactTypeCode = 'assessment'

update rds.DimFactTypes
set FactTypeDescription = 'ORGANIZATIONSTATUS - 199,200,201,202'
where FactTypeCode = 'organizationstatus'

update rds.DimFactTypes
set FactTypeDescription = 'TITLEI - 037,134,222'
where FactTypeCode = 'titleI'

update rds.DimFactTypes
set FactTypeDescription = 'MIGRANTEDUCATIONPROGRAM - 054,121,145,165'
where FactTypeCode = 'migranteducationprogram'

update rds.DimFactTypes
set FactTypeDescription = 'IMMIGRANT - '
where FactTypeCode = 'immigrant'

IF COL_LENGTH('RDS.FactK12StudentAssessments', 'AssessmentStatusId') IS NULL
BEGIN
  ALTER TABLE RDS.FactK12StudentAssessments ADD AssessmentStatusId int not null default(-1)
END