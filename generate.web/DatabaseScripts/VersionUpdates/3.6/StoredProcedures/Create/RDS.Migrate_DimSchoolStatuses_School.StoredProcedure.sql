CREATE PROCEDURE [RDS].[Migrate_DimSchoolStatuses_School]
	@OrganizationDates as [RDS].[SchoolDateTableType] READONLY
AS
BEGIN

declare @schoolIdentifierTypeId as int
declare @schoolSEAIdentificationSystemId as int

declare @programTypeId as int 
select @programTypeId = RefProgramTypeId from ods.RefProgramType where code = '04928'

declare @sharedTimeStatusId as int
select @sharedTimeStatusId = RefOrganizationIndicatorId from ods.RefOrganizationIndicator where code = 'SharedTime'


declare @VirtualStatusId as int
select @VirtualStatusId = RefOrganizationIndicatorId from ods.RefOrganizationIndicator where code = 'Virtual'



declare @OrganizationTypeId as int	
	select @OrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'SEA'

--Magnet Status

declare @magnetStatusQuery as table (		
		schoolOrgId int,
		DimCountDateId int,
		MagnetStatusCode varchar(50)
	)


select @schoolIdentifierTypeId = RefOrganizationIdentifierTypeId
from ods.RefOrganizationIdentifierType
where [Code] = '001073'

select @schoolSEAIdentificationSystemId = RefOrganizationIdentificationSystemId
from ods.RefOrganizationIdentificationSystem
where [Code] = 'SEA'
and RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId

insert into @magnetStatusQuery 
(
		schoolOrgId,
		DimCountDateId,
		MagnetStatusCode 
)

select
		sd.DimSchoolId,
		sd.DimCountDateId,		
		isnull(m.Code,'MISSING')
FROM
ods.K12SchoolStatus schStatus
inner join ods.RefMagnetSpecialProgram m on m.RefMagnetSpecialProgramId = schStatus.RefMagnetSpecialProgramId
inner join ods.K12School sch on sch.K12SchoolId = schStatus.K12SchoolId
inner join ods.OrganizationIdentifier oi on oi.OrganizationId = sch.OrganizationId 
				and oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
inner join rds.DimSchools s on s.SchoolStateIdentifier = oi.Identifier
inner join @OrganizationDates sd on s.DimSchoolId = sd.DimSchoolId


---State povertyDesignation
declare @StatePovertyDesignationQuery as table (		
		schoolOrgId int,
		DimCountDateId int,
		StatePovertyDesignationCode varchar(50)
	)

insert into @StatePovertyDesignationQuery 
(
		schoolOrgId,
		DimCountDateId,
		StatePovertyDesignationCode 
)

select
		sd.DimSchoolId,
		sd.DimCountDateId,		
		case when m.Code = 'HighQuartile' THEN 'HIGH' 
			 when m.Code = 'LowQuartile' THEN 'LOW' 
			 when m.Code = 'Neither' THEN 'NEITHER'     			
			 else isnull(m.Code,'MISSING')
	    END
FROM ods.K12School sch 
inner join ods.RefStatePovertyDesignation m on m.RefStatePovertyDesignationId = sch.RefStatePovertyDesignationId
inner join ods.OrganizationIdentifier oi on oi.OrganizationId = sch.OrganizationId 
				and oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
inner join rds.DimSchools s on s.SchoolStateIdentifier = oi.Identifier
inner join @OrganizationDates sd on s.DimSchoolId = sd.DimSchoolId

---State english proficiency
declare @ProgressAchievingEnglishLanguageQuery as table (		
		schoolOrgId int,
		DimCountDateId int,
		ProgressAchievingEnglishLanguageCode varchar(50),
		SchoolStateStatusCode varchar(50)
	)

insert into @ProgressAchievingEnglishLanguageQuery 
(
		schoolOrgId,
		DimCountDateId,
		ProgressAchievingEnglishLanguageCode,
		SchoolStateStatusCode
)

		select distinct
		sd.DimSchoolId,
		sd.DimCountDateId,		
		ISNULL(refProgress.Code,'MISSING') as ProgressAchievingEnglishLanguageCode,
		ISNULL(k12schoolStatus.ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatus, 'MISSING') as SchoolStateStatusCode
FROM ods.K12School sch 
inner join ods.K12SchoolStatus k12schoolStatus on k12schoolStatus.K12schoolId=sch.K12schoolId
left join ods.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus refProgress on refProgress.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId=k12schoolStatus.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId
inner join ods.OrganizationIdentifier oi on oi.OrganizationId = sch.OrganizationId 
				and oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
inner join rds.DimSchools s on s.SchoolStateIdentifier = oi.Identifier
inner join @OrganizationDates sd on s.DimSchoolId = sd.DimSchoolId



declare @NSLPStatusQuery as table (		
		schoolOrgId int,
		DimCountDateId int,
		NSLPStatusCode varchar(50)
	)

insert into @NSLPStatusQuery 
(
		schoolOrgId,
		DimCountDateId,
		NSLPStatusCode 
)

select sd.DimSchoolId,
		sd.DimCountDateId,		
		isnull(m.Code,'MISSING') 

 from  ods.K12SchoolStatus schStatus 
inner join ods.RefNSLPStatus m on m.RefNSLPStatusId = schStatus.RefNSLPStatusId
inner join ods.K12School sch on sch.K12SchoolId = schStatus.K12SchoolId
inner join ods.OrganizationIdentifier oi on oi.OrganizationId = sch.OrganizationId 
				and oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
inner join rds.DimSchools s on s.SchoolStateIdentifier = oi.Identifier
inner join @OrganizationDates sd on s.DimSchoolId = sd.DimSchoolId

-- SchoolImprovementStatusStatus

declare @ImprovementStatusQuery as table (		
		schoolOrgId int,
		DimCountDateId int,
		ImprovementStatusCode varchar(50)
	)

insert into @ImprovementStatusQuery 
(
		schoolOrgId,
		DimCountDateId,
		ImprovementStatusCode 
)

select sd.DimSchoolId,
		sd.DimCountDateId,	
		case when m.Code = 'CorrectiveAction' THEN 'CORRACT' 
			 when m.Code = 'Year1' THEN 'IMPYR1' 
			 when m.Code = 'Year2' THEN 'IMPYR2' 
			 when m.Code = 'Planning' THEN 'RESTRPLAN' 
			 when m.Code = 'Restructuring' THEN 'RESTR' 
			 when m.Code = 'NA' THEN 'NA'
			 when m.Code = 'FS' THEN 'FOCUS'
			 when m.Code = 'PS' THEN 'PRIORITY'
			 when m.Code = 'NFPS' THEN 'NOTPRFOC'        			
			 else isnull(m.Code,'MISSING')
	end 	
	

 from  ods.K12SchoolStatus schStatus 
inner join ods.RefSchoolImprovementStatus m on m.RefSchoolImprovementStatusId = schStatus.RefSchoolImprovementStatusId
inner join ods.K12School sch on sch.K12SchoolId = schStatus.K12SchoolId
inner join ods.OrganizationIdentifier oi on oi.OrganizationId = sch.OrganizationId 
				and oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
inner join rds.DimSchools s on s.SchoolStateIdentifier = oi.Identifier
inner join @OrganizationDates sd on s.DimSchoolId = sd.DimSchoolId

-- SchoolImprovementStatusStatus

declare @SchoolDangerousStatusQuery as table (		
		schoolOrgId int,
		DimCountDateId int,
		DangerousStatusCode varchar(50)
	)

insert into @SchoolDangerousStatusQuery 
(
		schoolOrgId,
		DimCountDateId,
		DangerousStatusCode 
)

select sd.DimSchoolId,
		sd.DimCountDateId,		
		isnull(m.Code,'MISSING') 

 from  ods.K12SchoolStatus schStatus 
inner join ods.RefSchoolDangerousStatus m on m.RefSchoolDangerousStatusId = schStatus.RefSchoolDangerousStatusId
inner join ods.K12School sch on sch.K12SchoolId = schStatus.K12SchoolId
inner join ods.OrganizationIdentifier oi on oi.OrganizationId = sch.OrganizationId 
				and oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
inner join rds.DimSchools s on s.SchoolStateIdentifier = oi.Identifier
inner join @OrganizationDates sd on s.DimSchoolId = sd.DimSchoolId


--TODO SharedTime and Virtual


declare @VirtualSchoolStatusQuery as table (  
 schoolOrgId int,
 DimCountDateId int,
 VirtualStatusCode varchar(50)
)
insert into @VirtualSchoolStatusQuery 
(
 schoolOrgId,
 DimCountDateId,
 VirtualStatusCode 
)
select sd.DimSchoolId,sd.DimCountDateId, isnull(v.Code,'MISSING') 
from  ods.K12SchoolStatus schStatus 
inner join ods.K12School sch on sch.K12SchoolId = schStatus.K12SchoolId
inner join ods.RefVirtualSchoolStatus v on v.RefVirtualSchoolStatusId = schStatus.RefVirtualSchoolStatusId
inner join ods.OrganizationIdentifier oi on oi.OrganizationId = sch.OrganizationId 
				and oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
inner join rds.DimSchools s on s.SchoolStateIdentifier = oi.Identifier
inner join @OrganizationDates sd on s.DimSchoolId = sd.DimSchoolId


declare @SharedTimeStatusQuery as table (		
		schoolOrgId int,
		DimCountDateId int,
		SharedTimeStatusCode varchar(50)
	)
insert into @SharedTimeStatusQuery 
(
		schoolOrgId,
		DimCountDateId,
		SharedTimeStatusCode 
)
select

	sd.DimSchoolId,
	sd.DimCountDateId,
	isnull(oi.IndicatorValue,'MISSING')

 from  ods.Organization o
	inner join ods.OrganizationIndicator oi on oi.OrganizationId = o.OrganizationId
	inner join ods.RefOrganizationIndicator roi on oi.RefOrganizationIndicatorId = roi.RefOrganizationIndicatorId	
	inner join ods.OrganizationIdentifier id on id.OrganizationId = o.OrganizationId 
				and id.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
	inner join rds.DimSchools s on s.SchoolStateIdentifier = id.Identifier
	inner join @OrganizationDates sd on s.DimSchoolId = sd.DimSchoolId
	where oi.RefOrganizationIndicatorId = @sharedTimeStatusId



select  org.DimCountDateId,
		org.DimSchoolId ,
		org.SchoolOrganizationId,		
		nslp.NSLPStatusCode,
		mag.MagnetStatusCode,
		vsq.VirtualStatusCode,
		stq.SharedTimeStatusCode,
		isq.ImprovementStatusCode,
		sdq.DangerousStatusCode,
		spd.StatePovertyDesignationCode,
		pael.ProgressAchievingEnglishLanguageCode,
		pael.SchoolStateStatusCode
	from @OrganizationDates org
	left join @NSLPStatusQuery	nslp on nslp.DimCountDateId = org.DimCountDateId and nslp.schoolOrgId = org.DimSchoolId
	left join @magnetStatusQuery mag on mag.DimCountDateId = org.DimCountDateId and mag.schoolOrgId = org.DimSchoolId
	left join @SharedTimeStatusQuery stq on stq.DimCountDateId = org.DimCountDateId and stq.schoolOrgId = org.DimSchoolId
	left join @VirtualSchoolStatusQuery vsq on vsq.DimCountDateId = org.DimCountDateId and vsq.schoolOrgId = org.DimSchoolId
	left join @ImprovementStatusQuery isq on isq.DimCountDateId =org.DimCountDateId and isq.schoolOrgId =org.DimSchoolId
	left join @SchoolDangerousStatusQuery sdq on sdq.DimCountDateId =org.DimCountDateId and sdq.schoolOrgId =org.DimSchoolId
	left join @StatePovertyDesignationQuery spd on spd.DimCountDateId =org.DimCountDateId and spd.schoolOrgId =org.DimSchoolId
	LEFT JOIN @ProgressAchievingEnglishLanguageQuery pael on pael.DimCountDateId =org.DimCountDateId and pael.schoolOrgId =org.DimSchoolId

END
