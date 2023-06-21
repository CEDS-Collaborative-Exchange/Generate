--Remove IEU constraints from FactK12StudentCounts
alter table RDS.FactK12StudentCounts
drop constraint [DF_FactK12StudentCounts_IeuId]

if exists (
   SELECT * 
   FROM sys.indexes 
   WHERE name = 'IXFK_FactK12StudentCounts_IeuId' AND object_id = OBJECT_ID('RDS.FactK12StudentCounts')
)
drop index IXFK_FactK12StudentCounts_IeuId on RDS.FactK12StudentCounts


IF (OBJECT_ID('RDS.FK_FactK12StudentCounts_IeuId', 'F') IS NOT NULL)
BEGIN
   ALTER TABLE RDS.FActK12StudentCounts DROP CONSTRAINT FK_FactK12StudentCounts_IeuId
END


--Remove IEU constraints from FactK12StudentDisciplines
-- alter table RDS.FactK12StudentDisciplines
-- drop constraint [DF_FactK12StudentDisciplines_IeuId]

if exists (
   SELECT * 
   FROM sys.indexes 
   WHERE name = 'IXFK_FactK12StudentDisciplines_IeuId' AND object_id = OBJECT_ID('RDS.FactK12StudentDisciplines')
)
drop index IXFK_FactK12StudentDisciplines_IeuId on RDS.FactK12StudentDisciplines


IF (OBJECT_ID('RDS.FK_FactK12StudentDisciplines_IeuId', 'F') IS NOT NULL)
BEGIN
   ALTER TABLE RDS.FactK12StudentDisciplines DROP CONSTRAINT FK_FactK12StudentDisciplines_IeuId
END

--Remove IEU constraints from FactK12StudentAssessments
alter table RDS.FactK12StudentAssessments
drop constraint [DF_FactK12StudentAssessments_IeuId]

if exists (
   SELECT * 
   FROM sys.indexes 
   WHERE name = 'IXFK_FactK12StudentAssessments_IeuId' AND object_id = OBJECT_ID('RDS.FactK12StudentAssessments')
)
drop index IXFK_FactK12StudentAssessments_IeuId on RDS.FactK12StudentAssessments


IF (OBJECT_ID('RDS.FK_FactK12StudentAssessments_IeuId', 'F') IS NOT NULL)
BEGIN
   ALTER TABLE RDS.FactK12StudentAssessments DROP CONSTRAINT FK_FactK12StudentAssessments_IeuId
END


-- Temporarily dropping this until the DimK12StudentStatus table is fully populated
IF (OBJECT_ID('RDS.FK_FactK12StudentCounts_K12StudentStatusId', 'F') IS NOT NULL)
BEGIN
   ALTER TABLE RDS.FactK12StudentCounts DROP CONSTRAINT FK_FactK12StudentCounts_K12StudentStatusId
END

