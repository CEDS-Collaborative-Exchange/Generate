
alter table RDS.FactK12StudentCounts
drop constraint [DF_FactK12StudentCounts_IeuId]

if exists (
SELECT * 
FROM sys.indexes 
WHERE name='IXFK_FactK12StudentCounts_IeuId' AND object_id = OBJECT_ID('RDS.FActK12StudentCounts')
)
drop index IXFK_FactK12StudentCounts_IeuId on RDS.FActK12StudentCounts


IF (OBJECT_ID('RDS.FK_FactK12StudentCounts_IeuId', 'F') IS NOT NULL)
BEGIN
   ALTER TABLE RDS.FActK12StudentCounts DROP CONSTRAINT FK_FactK12StudentCounts_IeuId
END


-- Temporarily dropping this until the DimK12StudentStatus table is fully populated
IF (OBJECT_ID('RDS.FK_FactK12StudentCounts_K12StudentStatusId', 'F') IS NOT NULL)
BEGIN
   ALTER TABLE RDS.FactK12StudentCounts DROP CONSTRAINT FK_FactK12StudentCounts_K12StudentStatusId
END
