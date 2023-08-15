



CREATE PROCEDURE [RDS].[Migrate_DimOrganizationStatuses_School]
	 @organizationDates as [RDS].[SchoolDateTableType]  READONLY
AS
BEGIN

SELECT 
 ds.DimSchoolId,
 DimCountDateId,

case when gunFree.Code = 'YesReportingOffenses'	THEN 'YESWITHREP' 
			 when gunFree.Code = 'YesNoReportedOffenses'	THEN 'YESWOREP'
			 when gunFree.Code = 'No'	THEN 'No' 
			 when gunFree.Code ='NA' then 'NA' 
			 else 'MISSING' END as 'GunFreeStatusCode',

case when refHighSchoolGraduation.Code is null then 'MISSING'
			  when refHighSchoolGraduation.Code ='MetGoal'  then 'STTDEF'
			  when refHighSchoolGraduation.Code ='TooFewStudents'  then 'TOOFEW'
			  when refHighSchoolGraduation.Code ='NoStudents'  then 'NOSTUDENTS'
			 END as 'GraduationRateCode'
from @organizationDates d
inner join rds.DimSchools ds on ds.DimSchoolId = d.DimSchoolId
left join ods.OrganizationFederalAccountability fa on ds.SchoolOrganizationId = fa.OrganizationId
left join ods.RefGunFreeSchoolsActReportingStatus gunFree on gunFree.RefGunFreeSchoolsActStatusReportingId = fa.RefGunFreeSchoolsActStatusReportingId
left join ods.RefHighSchoolGraduationRateIndicator refHighSchoolGraduation on refHighSchoolGraduation.RefHSGraduationRateIndicatorId = fa.RefHighSchoolGraduationRateIndicator
left join 
		(
			select oc.OrganizationId, reapAlt.Code from ods.OrganizationCalendar oc
			inner join ods.OrganizationCalendarSession s on s.OrganizationCalendarId = oc.OrganizationCalendarId
			inner join ods.RefSessionType rst on rst.RefSessionTypeId = s.RefSessionTypeId and rst.Code='FullSchoolYear'
			inner join ods.K12FederalFundAllocation k12federalFund on k12federalFund.OrganizationCalendarSessionId = s.OrganizationCalendarSessionId 
			left join ods.RefReapAlternativeFundingStatus reapAlt on reapAlt.RefReapAlternativeFundingStatusId=k12federalFund.RefReapAlternativeFundingStatusId										
		) reap on reap.OrganizationId =  ds.SchoolOrganizationId

END

