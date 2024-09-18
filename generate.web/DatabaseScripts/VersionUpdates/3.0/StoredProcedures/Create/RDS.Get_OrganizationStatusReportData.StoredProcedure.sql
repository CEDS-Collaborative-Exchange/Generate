CREATE PROCEDURE [RDS].[Get_OrganizationStatusReportData]
	@reportCode as varchar(50),
    @reportLevel as varchar(50),
    @reportYear as varchar(50),
    @categorySetCode as varchar(50),
	@flag AS bit = 0
AS
BEGIN

	declare @reportAbbrv as varchar(50)

	select TOP 1 @reportAbbrv =  tt.TableTypeAbbrv 
	from app.GenerateReports r
	inner join app.GenerateReport_TableType rt on r.GenerateReportId = rt.GenerateReportId
	inner join app.TableTypes tt on rt.TableTypeId = tt.TableTypeId
	where r.reportcode = @reportCode

	SELECT CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationId ASC) AS INT) as FactOrganizationStatusCountReportDtoId,@reportAbbrv as TableTypeAbbrv,                     
		organizationInfo.* from
		(select  distinct	
			@reportCode as ReportCode, 
			@reportYear as ReportYear,
			@reportLevel as ReportLevel,
			NULL as CategorySetCode, 
			NULL as Categories,
			case 
					when RACE = 'AmericanIndianorAlaskaNative' then 'MAN'
					when RACE = 'Asian' then 'MA'
					when RACE = 'BlackorAfricanAmerican' then 'MB'
					when RACE = 'NativeHawaiianorOtherPacificIslander' then 'MNP'
					when RACE = 'TwoorMoreRaces' then 'MM'
					when RACE = 'HI' then 'MHL'
					when RACE = 'White' then 'MW'
					else 'MISSING'
			end as RACE,
			DISABILITY,
			LEPSTATUS,
			ECODISSTATUS,
			INDICATORSTATUS,
			STATEDEFINEDSTATUSCODE,
			StateANSICode,
			StateCode,
			StateName,
			OrganizationId,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId,
			OrganizationStatusCount,
			STATEDEFINEDCUSTOMINDICATORCODE,
			INDICATORSTATUSTYPECODE
		from rds.FactOrganizationStatusCountReports fact
		where reportcode = @reportCode and ReportLevel = @reportLevel 
		and ReportYear = @reportYear and [CategorySetCode] = isnull(@categorySetCode,CategorySetCode)
		) organizationInfo
		

END