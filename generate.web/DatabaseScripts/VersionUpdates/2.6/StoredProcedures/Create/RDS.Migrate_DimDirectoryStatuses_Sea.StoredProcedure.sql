



CREATE PROCEDURE [RDS].[Migrate_DimDirectoryStatuses_Sea]
	@organizationDates as [RDS].[SeaDateTableType] READONLY
	
AS
BEGIN



declare @CharterLeaStatus as table (		
		organizationId int,
		DimCountDateId int,
		CharterLeaStatusCode varchar(50)
	)

insert into @CharterLeaStatus 
(
		organizationId,
		DimCountDateId,
		CharterLeaStatusCode 
)

SELECT
 
 OrganizationId,
 DimCountDateId,
 case when l.CharterSchoolIndicator is null then 'MISSING'
			 when l.CharterSchoolIndicator = 1 then 'YES'
			 When l.CharterSchoolIndicator = 0 then 'NO'
		END as 'CharterLeaStatusCode'
from @organizationDates o
inner join ods.K12Lea l on o.DimSeaId = l.OrganizationId


declare @CharterSchoolStatus as table (		
		organizationId int,
		DimCountDateId int,
		CharterSchoolStatusCode varchar(50)
	)

insert into @CharterSchoolStatus 
(
		organizationId,
		DimCountDateId,
		CharterSchoolStatusCode 
)

SELECT
 
 OrganizationId,
 DimCountDateId,
 case when s.CharterSchoolIndicator is null then 'MISSING'
			 when s.CharterSchoolIndicator = 1 then 'YES'
			 When s.CharterSchoolIndicator = 0 then 'NO'
		END as 'CharterSchoolStatusCode'
from @organizationDates o
inner join ods.K12School s on o.DimSeaId = s.OrganizationId


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
	   l.CharterLeaStatusCode,
	   s.CharterSchoolStatusCode,
	   r.ReconstitutedStatusCode,
	   o.OperationalStatusCode			
	from @organizationDates d
	inner join @CharterLeaStatus l on d.DimSeaId = l.organizationId and d.DimCountDateId = l.DimCountDateId
	inner join @CharterSchoolStatus s on s.organizationId =d.DimSeaId and s.DimCountDateId = d.DimCountDateId
	inner join @ReconstitutedStatus r on r.organizationId = d.DimSeaId and s.DimCountDateId = d.DimCountDateId
	inner join @OperationalStatus o on o.organizationId = d.DimSeaId and o.DimCountDateId = d.DimCountDateId
END

