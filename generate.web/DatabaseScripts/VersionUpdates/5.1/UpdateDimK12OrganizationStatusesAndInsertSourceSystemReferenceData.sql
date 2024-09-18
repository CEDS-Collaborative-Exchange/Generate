-- Updates Required for Directory Staging to RDS Migration in Version 5.1

update RDS.DimK12OrganizationStatuses
set GunFreeSchoolsActReportingStatusCode = 'YesReportingOffenses'
where GunFreeSchoolsActReportingStatusCode = 'YESWITHREP'

update RDS.DimK12OrganizationStatuses
set GunFreeSchoolsActReportingStatusCode = 'YesNoReportedOffenses'
where GunFreeSchoolsActReportingStatusCode = 'YESWOREP'

-- INSERT SourceSystemReferenceData
if not exists (select 1 from Staging.SourceSystemReferenceData 
				where SchoolYear = 2022 and tablename = 'refReapAlternativeFundingStatus'
				and InputCode = 'NA' and OutputCode = 'NA')
		begin
			insert into Staging.SourceSystemReferenceData select 2022,'refReapAlternativeFundingStatus', NULL, 'NA', 'NA'
		end

if not exists (select 1 from Staging.SourceSystemReferenceData 
				where SchoolYear = 2022 and tablename = 'refReapAlternativeFundingStatus'
				and InputCode = 'NO' and OutputCode = 'NO')
		begin
			insert into Staging.SourceSystemReferenceData select 2022,'refReapAlternativeFundingStatus', NULL, 'NO', 'NO'
		end

if not exists (select 1 from Staging.SourceSystemReferenceData 
				where SchoolYear = 2022 and tablename = 'refReapAlternativeFundingStatus'
				and InputCode = 'YES' and OutputCode = 'YES')
		begin
			insert into Staging.SourceSystemReferenceData select 2022,'refReapAlternativeFundingStatus', NULL, 'YES', 'YES'
		end

if not exists (select 1 from Staging.SourceSystemReferenceData 
				where SchoolYear = 2022 and tablename = 'refStatePovertyDesignation'
				and InputCode = 'High' and OutputCode = 'High')
		begin
			insert into Staging.SourceSystemReferenceData select 2022,'refStatePovertyDesignation', NULL, 'High', 'High'
		end

if not exists (select 1 from Staging.SourceSystemReferenceData 
				where SchoolYear = 2022 and tablename = 'refStatePovertyDesignation'
				and InputCode = 'Low' and OutputCode = 'Low')
		begin
			insert into Staging.SourceSystemReferenceData select 2022,'refStatePovertyDesignation', NULL, 'Low', 'Low'
		end

if not exists (select 1 from Staging.SourceSystemReferenceData 
				where SchoolYear = 2022 and tablename = 'refStatePovertyDesignation'
				and InputCode = 'Neither' and OutputCode = 'Neither')
		begin
			insert into Staging.SourceSystemReferenceData select 2022,'refStatePovertyDesignation', NULL, 'Neither', 'Neither'
		end
