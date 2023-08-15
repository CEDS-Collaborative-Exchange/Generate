CREATE PROCEDURE [RDS].[Migrate_DimOrganizationStatuses_School]
	 @organizationDates as [RDS].[SchoolDateTableType]  READONLY
AS
BEGIN

	-- School Identifer
	declare @schoolIdentifierTypeId as int
	select @schoolIdentifierTypeId = RefOrganizationIdentifierTypeId
	from ods.RefOrganizationIdentifierType
	where [Code] = '001073'
	
	--School State Identifer
	declare @schoolSEAIdentificationSystemId as int
	select @schoolSEAIdentificationSystemId = RefOrganizationIdentificationSystemId
	from ods.RefOrganizationIdentificationSystem
	where [Code] = 'SEA'
	and RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId

SELECT 
 ds.DimSchoolId,
 DimCountDateId,
 'MISSING' as REAPAlternativeFundingStatusCode,
case when gunFree.Code = 'YesReportingOffenses'	THEN 'YESWITHREP' 
			 when gunFree.Code = 'YesNoReportedOffenses'	THEN 'YESWOREP'
			 when gunFree.Code = 'No'	THEN 'No' 
			 when gunFree.Code ='NA' then 'NA' 
			 else 'MISSING' END as 'GunFreeStatusCode',

case when refHighSchoolGraduation.Code is null then 'MISSING'
			  when refHighSchoolGraduation.Code ='MetGoal'  then 'STTDEF'
			  when refHighSchoolGraduation.Code ='TooFewStudents'  then 'TOOFEW'
			  when refHighSchoolGraduation.Code ='NoStudents'  then 'NOSTUDENTS'
			 END as 'GraduationRateCode',
 'MISSING' as McKinneyVentoSubgrantRecipient
from @organizationDates d
inner join rds.DimSchools ds on ds.DimSchoolId = d.DimSchoolId
and ds.RecordStartDateTime <= d.SubmissionYearEndDate 
and ((ds.RecordEndDateTime >= d.SubmissionYearStartDate) OR ds.RecordEndDateTime IS NULL)
left join ods.OrganizationIdentifier oi on ds.SchoolStateIdentifier = oi.Identifier
		and oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
left join ods.OrganizationFederalAccountability fa on oi.OrganizationId = fa.OrganizationId
left join ods.RefGunFreeSchoolsActReportingStatus gunFree on gunFree.RefGunFreeSchoolsActStatusReportingId = fa.RefGunFreeSchoolsActStatusReportingId
left join ods.RefHighSchoolGraduationRateIndicator refHighSchoolGraduation on refHighSchoolGraduation.RefHSGraduationRateIndicatorId = fa.RefHighSchoolGraduationRateIndicator
left join 
		(
			select oc.OrganizationId, reapAlt.Code, s.BeginDate, s.EndDate from ods.OrganizationCalendar oc
			inner join ods.OrganizationCalendarSession s on s.OrganizationCalendarId = oc.OrganizationCalendarId
			inner join ods.RefSessionType rst on rst.RefSessionTypeId = s.RefSessionTypeId and rst.Code='FullSchoolYear'
			inner join ods.K12FederalFundAllocation k12federalFund on k12federalFund.OrganizationCalendarSessionId = s.OrganizationCalendarSessionId 
			left join ods.RefReapAlternativeFundingStatus reapAlt on reapAlt.RefReapAlternativeFundingStatusId=k12federalFund.RefReapAlternativeFundingStatusId										
		) reap on reap.OrganizationId =  oi.OrganizationId
		and reap.BeginDate between d.SubmissionYearStartDate and d.SubmissionYearEndDate

END