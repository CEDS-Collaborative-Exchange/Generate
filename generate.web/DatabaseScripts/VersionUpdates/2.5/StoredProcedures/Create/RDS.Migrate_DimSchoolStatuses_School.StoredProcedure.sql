 CREATE PROCEDURE [RDS].[Migrate_DimSchoolStatuses_School]
	@OrganizationDates as [RDS].[SchoolDateTableType] READONLY
AS
BEGIN


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

insert into @magnetStatusQuery 
(
		schoolOrgId,
		DimCountDateId,
		MagnetStatusCode 
)

select
		sch.OrganizationId,
		sd.DimCountDateId,		
		isnull(m.Code,'MISSING')
FROM
ods.K12SchoolStatus schStatus
inner join ods.RefMagnetSpecialProgram m on m.RefMagnetSpecialProgramId = schStatus.RefMagnetSpecialProgramId
inner join ods.K12School sch on sch.K12SchoolId = schStatus.K12SchoolId
inner join @OrganizationDates sd on sd.SchoolOrganizationId = sch.OrganizationId


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
		sch.OrganizationId,
		sd.DimCountDateId,		
		case when m.Code = 'HighQuartile' THEN 'HIGH' 
			 when m.Code = 'LowQuartile' THEN 'LOW' 
			 when m.Code = 'Neither' THEN 'NEITHER'     			
			 else isnull(m.Code,'MISSING')
	    END
FROM ods.K12School sch 
inner join ods.RefStatePovertyDesignation m on m.RefStatePovertyDesignationId = sch.RefStatePovertyDesignationId
inner join @OrganizationDates sd on sd.SchoolOrganizationId = sch.OrganizationId

---State english proficiency
declare @ProgressAchievingEnglishLanguageQuery as table (		
		schoolOrgId int,
		DimCountDateId int,
		ProgressAchievingEnglishLanguageCode varchar(50)
	)

insert into @ProgressAchievingEnglishLanguageQuery 
(
		schoolOrgId,
		DimCountDateId,
		ProgressAchievingEnglishLanguageCode 
)

		select distinct
		sch.OrganizationId,
		sd.DimCountDateId,		
		case when m.Code = 'Met' THEN 'STTDEF' 
			 when m.Code = 'DidNotMeet' THEN 'TOOFEW' 
			 when m.Code = 'NoTitleIII' THEN 'NOSTUDENTS'  			
			 else isnull(m.Code,'MISSING')
	    END
FROM ods.K12School sch 
inner join ods.OrganizationRelationship orr on orr.Parent_OrganizationId=sch.OrganizationId
inner join @OrganizationDates sd on sd.SchoolOrganizationId = sch.OrganizationId 
inner join rds.DimDates dd on dd.DimDateId= sd.DimCountDateId
inner join ods.OrganizationDetail od on od.OrganizationId=sch.OrganizationId and (od.RecordStartDateTime is null and od.RecordEndDateTime is null 
																				or(od.RecordStartDateTime is not null and od.RecordEndDateTime is null and od.RecordStartDateTime<=dd.DateValue)
																				or(od.RecordStartDateTime is not null and od.RecordEndDateTime is not null and od.RecordStartDateTime<=dd.DateValue and od.RecordEndDateTime>=dd.DateValue)
																				or(od.RecordStartDateTime is null and od.RecordEndDateTime is not null and od.RecordEndDateTime>=dd.DateValue))
inner join ods.OrganizationProgramType opt on opt.OrganizationId=orr.OrganizationId and (opt.RecordStartDateTime is null and opt.RecordEndDateTime is null 
																						or(opt.RecordStartDateTime is not null and opt.RecordEndDateTime is null and opt.RecordStartDateTime<=dd.DateValue)
																						or(opt.RecordStartDateTime is not null and opt.RecordEndDateTime is not null and opt.RecordStartDateTime<=dd.DateValue and opt.RecordEndDateTime>=dd.DateValue)
																						or(opt.RecordStartDateTime is null and opt.RecordEndDateTime is not null and opt.RecordEndDateTime>=dd.DateValue))
																					and opt.RefProgramTypeId=@programTypeId
inner join ods.OrganizationFederalAccountability ofa on ofa.OrganizationId=sch.OrganizationId
inner join ods.RefAmaoAttainmentStatus m on m.RefAmaoAttainmentStatusId = ofa.AmaoAypProgressAttainmentLepStudents
inner join ods.OrganizationOperationalStatus oos on oos.OrganizationId=sch.OrganizationId
inner join Ods.RefOperationalStatus ros on ros.RefOperationalStatusId=oos.RefOperationalStatusId and ros.Code='open'
inner join ods.OrganizationPersonRole opr on opr.OrganizationId= orr.OrganizationId and (opr.EntryDate is null and opr.ExitDate is null 
																						or(opr.EntryDate is not null and opr.ExitDate is null and opr.EntryDate<=dd.DateValue)
																						or(opr.EntryDate is not null and opr.ExitDate is not null and opr.EntryDate<=dd.DateValue and opr.ExitDate>=dd.DateValue)
																						or(opr.EntryDate is null and opr.ExitDate is not null and opr.ExitDate>=dd.DateValue))

		



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

select sch.OrganizationId,
		sd.DimCountDateId,		
		isnull(m.Code,'MISSING') 

 from  ods.K12SchoolStatus schStatus 
inner join ods.RefNSLPStatus m on m.RefNSLPStatusId = schStatus.RefNSLPStatusId
inner join ods.K12School sch on sch.K12SchoolId = schStatus.K12SchoolId
inner join @OrganizationDates sd on sd.SchoolOrganizationId = sch.OrganizationId

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

select sch.OrganizationId,
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
inner join @OrganizationDates sd on sd.SchoolOrganizationId = sch.OrganizationId

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

select sch.OrganizationId,
		sd.DimCountDateId,		
		isnull(m.Code,'MISSING') 

 from  ods.K12SchoolStatus schStatus 
inner join ods.RefSchoolDangerousStatus m on m.RefSchoolDangerousStatusId = schStatus.RefSchoolDangerousStatusId
inner join ods.K12School sch on sch.K12SchoolId = schStatus.K12SchoolId
inner join @OrganizationDates sd on sd.SchoolOrganizationId = sch.OrganizationId


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

select
	sd.SchoolOrganizationId,
	sd.DimCountDateId,
	isnull(oi.IndicatorValue,'MISSING')
 from @OrganizationDates sd 	
	inner join ods.Organization o on o.OrganizationId = sd.SchoolOrganizationId
	inner join ods.OrganizationIndicator oi on oi.OrganizationId = o.OrganizationId
	inner join ods.RefOrganizationIndicator roi on oi.RefOrganizationIndicatorId = roi.RefOrganizationIndicatorId	
	Where oi.RefOrganizationIndicatorId = @VirtualStatusId


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

	sd.SchoolOrganizationId,
	sd.DimCountDateId,
	isnull(oi.IndicatorValue,'MISSING')

 from  @OrganizationDates sd
	inner join ods.Organization o on o.OrganizationId = sd.SchoolOrganizationId
	inner join ods.OrganizationIndicator oi on oi.OrganizationId = o.OrganizationId
	inner join ods.RefOrganizationIndicator roi on oi.RefOrganizationIndicatorId = roi.RefOrganizationIndicatorId	
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
		pael.ProgressAchievingEnglishLanguageCode
	from @OrganizationDates org
	left join @NSLPStatusQuery	nslp on nslp.DimCountDateId = org.DimCountDateId and nslp.schoolOrgId = org.SchoolOrganizationId
	left join @magnetStatusQuery mag on mag.DimCountDateId = org.DimCountDateId and mag.schoolOrgId = org.SchoolOrganizationId
	left join @SharedTimeStatusQuery stq on stq.DimCountDateId = org.DimCountDateId and stq.schoolOrgId = org.SchoolOrganizationId
	left join @VirtualSchoolStatusQuery vsq on vsq.DimCountDateId = org.DimCountDateId and vsq.schoolOrgId = org.SchoolOrganizationId
	left join @ImprovementStatusQuery isq on isq.DimCountDateId =org.DimCountDateId and isq.schoolOrgId =org.SchoolOrganizationId
	left join @SchoolDangerousStatusQuery sdq on sdq.DimCountDateId =org.DimCountDateId and sdq.schoolOrgId =org.SchoolOrganizationId
	left join @StatePovertyDesignationQuery spd on spd.DimCountDateId =org.DimCountDateId and spd.schoolOrgId =org.SchoolOrganizationId
	LEFT JOIN @ProgressAchievingEnglishLanguageQuery pael on pael.DimCountDateId =org.DimCountDateId and pael.schoolOrgId =org.SchoolOrganizationId
END
