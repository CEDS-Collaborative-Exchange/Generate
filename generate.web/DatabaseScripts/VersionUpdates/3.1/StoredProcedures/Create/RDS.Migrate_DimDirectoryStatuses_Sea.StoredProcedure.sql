CREATE PROCEDURE [RDS].[Migrate_DimDirectoryStatuses_Sea]
	@organizationDates as [RDS].[SeaDateTableType] READONLY
	
AS
BEGIN


declare @ReconstitutedStatus as table (		
		organizationId int,
		DimCountDateId int,
		ReconstitutedStatusCode varchar(50)
	)

insert into @ReconstitutedStatus 
(
		organizationId,
		DimCountDateId,
		ReconstitutedStatusCode 
)

SELECT 
 OrganizationId,
 DimCountDateId,
 isnull(r.Code, 'MISSING')
from @organizationDates o
inner join ods.OrganizationFederalAccountability fa on o.DimSeaId = fa.OrganizationFederalAccountabilityId
inner join ods.RefReconstitutedStatus r on r.RefReconstitutedStatusId = fa.RefReconstitutedStatusId


declare @OperationalStatus as table (		
		organizationId int,
		DimCountDateId int,
		OperationalStatusCode varchar(50)
	)

insert into @OperationalStatus
(
		organizationId,
		DimCountDateId,
		OperationalStatusCode 
)

SELECT 
 OrganizationId,
 DimCountDateId,
 isnull(s.Code, 'MISSING')
from @organizationDates o
inner join ods.OrganizationOperationalStatus op on op.OrganizationId = o.DimSeaId
inner join ods.RefOperationalStatus s on op.RefOperationalStatusId = s.RefOperationalStatusId



select
	   d.DimSeaId,
	   d.DimCountDateId,
	   'MISSING' as CharterLeaStatusCode,
	   'MISSING' as CharterSchoolStatusCode,
	   r.ReconstitutedStatusCode,
	   o.OperationalStatusCode			
	from @organizationDates d
	inner join @ReconstitutedStatus r on r.organizationId = d.DimSeaId and r.DimCountDateId = d.DimCountDateId
	inner join @OperationalStatus o on o.organizationId = d.DimSeaId and o.DimCountDateId = d.DimCountDateId
END