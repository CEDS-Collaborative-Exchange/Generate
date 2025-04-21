Update r set ReportCode = 
    CASE 
        WHEN CHARINDEX('c', ReportCode) = 1 
        THEN STUFF(ReportCode, CHARINDEX('c', ReportCode), 1, '')
        ELSE ReportCode
    END 
FROM app.GenerateReports r
where CHARINDEX('c', ReportCode) = 1 and ReportCode not in ('cohortgraduationrate')

Update r set ReportShortName = 
    CASE 
        WHEN CHARINDEX('c', ReportShortName) = 1 
        THEN STUFF(ReportShortName, CHARINDEX('c', ReportShortName), 1, '')
        ELSE ReportShortName
    END 
FROM app.GenerateReports r
where CHARINDEX('c', ReportShortName) = 1 and ReportCode not in ('cohortgraduationrate')

 Update r set ControlTypeName = 
    CASE 
        WHEN CHARINDEX('c', ControlTypeName) = 1 
        THEN STUFF(ControlTypeName, CHARINDEX('c', ControlTypeName), 1, '')
        ELSE ControlTypeName
    END 
FROM app.GenerateReportControlType r
where CHARINDEX('c', ControlTypeName) = 1 and ControlTypeName not in ('CCDSchool', 'CharterSchool', 'CohortGradRate')

Update f set f.ReportColumn = d.DimensionFieldName
from app.FileColumns f
inner join app.Dimensions d on f.DimensionId = d.DimensionId
where f.DimensionId is not null

Update app.FileColumns set ReportColumn = 'StateANSICode' Where ColumnName = 'FIPSStateCode'
Update app.FileColumns set ReportColumn = 'OrganizationName' Where ColumnName IN ('StateAgencyName', 'LEAName', 'SchoolName')
Update app.FileColumns set ReportColumn = 'STATEPOVERTYDESIGNATION' Where ColumnName = 'PovertyQuart'
Update app.FileColumns set ReportColumn = 'Website' Where ColumnName like '%webaddress'
Update app.FileColumns set ReportColumn = 'Telephone' Where ColumnName like '%phonenumber'
Update app.FileColumns set ReportColumn = 'MailingAddressStreet' Where ColumnName = 'MailingAddress1'
Update app.FileColumns set ReportColumn = 'MailingAddressApartmentRoomOrSuiteNumber' Where ColumnName = 'MailingAddress2'
Update app.FileColumns set ReportColumn = 'MailingCity' Where ColumnName = 'MailingAddressCity'
Update app.FileColumns set ReportColumn = 'MailingPostalStateCode' Where ColumnName = 'MailingAddressState'
Update app.FileColumns set ReportColumn = 'MailingZipcode' Where ColumnName = 'MailingAddressPostalCode'
Update app.FileColumns set ReportColumn = 'MailingZipcodePlus4' Where ColumnName = 'MailingAddressPostalCode2'
Update app.FileColumns set ReportColumn = 'PhysicalAddressStreet' Where ColumnName = 'LocationAddress1'
Update app.FileColumns set ReportColumn = 'PhysicalAddressApartmentRoomOrSuiteNumber' Where ColumnName = 'LocationAddress2'
Update app.FileColumns set ReportColumn = 'PhysicalAddressCity' Where ColumnName = 'LocationCity'
Update app.FileColumns set ReportColumn = 'PhysicalAddressState' Where ColumnName = 'LocationPostalStateCode'
Update app.FileColumns set ReportColumn = 'PhysicalAddressPostalCode' Where ColumnName = 'LocationZipcode'
Update app.FileColumns set ReportColumn = 'PhysicalAddressPostalCode2' Where ColumnName = 'LocationZipcodePlus4'

Update fc set fc.ReportColumn = 'ParentOrganizationStateId'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where Organizationlevelid = 3 and fc.ColumnName = 'StateLEAIDNumber' and f.FactReportTableName like '%Organization%'

Update fc set fc.ReportColumn = 'ParentOrganizationIdentifierSea'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where Organizationlevelid = 3 and fc.ColumnName = 'StateLEAIDNumber' and f.FactReportTableName not like '%Organization%'

Update fc set fc.ReportColumn = 'OrganizationStateId'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where Organizationlevelid <> 3 and fc.ColumnName = 'StateLEAIDNumber' and f.FactReportTableName like '%Organization%'

Update fc set fc.ReportColumn = 'OrganizationIdentifierSea'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where Organizationlevelid <> 3 and fc.ColumnName = 'StateLEAIDNumber' and f.FactReportTableName not like '%Organization%'

Update fc set fc.ReportColumn = 'ParentOrganizationNcesId'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where Organizationlevelid = 3 and fc.ColumnName = 'NCESLEAIDNumber' and f.FactReportTableName like '%Organization%'

Update fc set fc.ReportColumn = 'ParentOrganizationIdentifierNces'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where Organizationlevelid = 3 and fc.ColumnName = 'NCESLEAIDNumber' and f.FactReportTableName not like '%Organization%'


Update fc set fc.ReportColumn = 'OrganizationNcesId'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where Organizationlevelid <> 3 and fc.ColumnName = 'NCESLEAIDNumber' and f.FactReportTableName like '%Organization%'

Update fc set fc.ReportColumn = 'OrganizationIdentifierNces'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where Organizationlevelid <> 3 and fc.ColumnName = 'NCESLEAIDNumber' and f.FactReportTableName not like '%Organization%'

Update fc set fc.ReportColumn = 'OrganizationNcesId'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where fc.ColumnName = 'NCESSchoolIDNumber' and f.FactReportTableName like '%Organization%'

Update fc set fc.ReportColumn = 'OrganizationIdentifierNces'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where fc.ColumnName = 'NCESSchoolIDNumber' and f.FactReportTableName not like '%Organization%'

Update app.FileColumns set ReportColumn = 'OutOfStateIndicator' Where ColumnName = 'OutOfStateInd'
Update app.FileColumns set ReportColumn = 'SupervisoryUnionIdentificationNumber' Where ColumnName = 'SupervisoryUnion'
Update app.FileColumns set ReportColumn = 'OperationalStatusId' Where ColumnName IN ('LEASysOpStatus', 'SchoolSysOpStatus')
Update app.FileColumns set ReportColumn = 'UpdatedOperationalStatusId' Where ColumnName IN ('LEAOpStatus', 'SchoolOpStatus')
Update app.FileColumns set ReportColumn = 'CharterLeaStatus' Where ColumnName = 'ChrtSchoolLEAStatusID'
Update app.FileColumns set ReportColumn = 'CharterSchoolAuthorizerIdPrimary' Where ColumnName = 'CharterSchoolAuthorizerPrimary'
Update app.FileColumns set ReportColumn = 'CharterSchoolAuthorizerIdSecondary' Where ColumnName = 'CharterSchoolAuthorizerAdditional'
Update app.FileColumns set ReportColumn = 'PriorStateLEAID' Where ColumnName = 'PriorLeaStateIdentifier'
Update app.FileColumns set ReportColumn = 'PriorStateSchoolID' Where ColumnName = 'PriorSchoolStateIdentifier'
Update app.FileColumns set ReportColumn = 'StatusEffectiveDate' Where ColumnName = 'EffectiveDate'

Update fc set fc.ReportColumn = 'OrganizationStateId'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where fc.ColumnName = 'StateSchoolIDNumber' and f.FactReportTableName like '%Organization%'

Update fc set fc.ReportColumn = 'OrganizationIdentifierSea'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where fc.ColumnName = 'StateSchoolIDNumber' and f.FactReportTableName not like '%Organization%'

Update fc set fc.ReportColumn = f.FactFieldName
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where fc.ColumnName IN ('Amount', 'MigrantStuEligibleRSY')

Update fc set fc.ReportColumn = 'StudentRate'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where fc.ColumnName IN ('Amount', 'MigrantStuEligibleRSY') and ReportCode IN ('c150')

Update fc set fc.ReportColumn = 'INDICATORSTATUS'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where fc.ColumnName IN ('Amount', 'MigrantStuEligibleRSY') and ReportCode IN ('c199','c200','c201','c202','c206')

Update fc set fc.ReportColumn = 'FederalFundAllocated'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where fc.ColumnName IN ('Amount', 'MigrantStuEligibleRSY') and ReportCode IN ('c035')

Update app.FileColumns set ReportColumn = 'IMPROVEMENTSTATUS' Where ColumnName = 'ImprovementStatus'
Update app.FileColumns set ReportColumn = 'POSTSECONDARYENROLLMENTSTATUS' Where ColumnName = 'PSEnrollActionID'
Update app.FileColumns set ReportColumn = 'HOMELESSPRIMARYNIGHTTIMERESIDENCE' Where ColumnName = 'PrimeNightResidenceID'


Update fc set fc.ReportColumn = 'HOMELESSNESSSTATUS'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where fc.ColumnName IN ('HomelessStatusID') and ReportCode IN ('c037')

Update fc set fc.ReportColumn = 'HOMELESSUNACCOMPANIEDYOUTHSTATUS'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where fc.ColumnName IN ('HomelessStatusID') and ReportCode NOT IN ('c037')

Update app.FileColumns set ReportColumn = 'PERSISTENTLYDANGEROUSSTATUS' Where ColumnName = 'PersistDangerStatus'
Update app.FileColumns set ReportColumn = 'DISCIPLINEMETHODFORFIREARMSINCIDENTS' Where ColumnName = 'FireArmIncResultID'
Update app.FileColumns set ReportColumn = 'IDEADISCIPLINEMETHODFORFIREARMSINCIDENTS' Where ColumnName = 'FireArmIncResultIDEAID'
Update app.FileColumns set ReportColumn = 'GRADELEVEL' Where ColumnName = 'GradeLevelID'
Update app.FileColumns set ReportColumn = 'FIREARMTYPE' Where ColumnName = 'WeaponTypeID'
Update app.FileColumns set ReportColumn = 'PROFICIENCYSTATUS' Where ColumnName IN ('ProficiencyStatusID', 'EnglishProficiencyLevelID')
Update app.FileColumns set ReportColumn = 'SCHOOLIMPROVEMENTFUNDS' Where ColumnName = 'ImpFundAllocA'
Update app.FileColumns set ReportColumn = 'McKinneyVentoSubgrantRecipient' Where ColumnName = 'MVSubGStatusID'
Update app.FileColumns set ReportColumn = 'GunFreeStatus' Where ColumnName = 'GFSAReportStatus'
Update app.FileColumns set ReportColumn = 'COHORTSTATUS' Where ColumnName = 'CohortStatusID'
Update app.FileColumns set ReportColumn = 'STATEDEFINEDSTATUSCODE' Where ColumnName = 'StateDefinedStatusName'
Update app.FileColumns set ReportColumn = 'FederalProgramCode' Where ColumnName = 'CFDAID'
Update app.FileColumns set ReportColumn = 'FederalFundAllocationType' Where ColumnName = 'AllocationTypeID'
Update app.FileColumns set ReportColumn = 'STATEDEFINEDCUSTOMINDICATORCODE' Where ColumnName = 'IndicatorTypeID'
Update app.FileColumns set ReportColumn = 'ComprehensiveAndTargetedSupportCode' Where ColumnName = 'ComprehensiveTargetedSupportSchTypeID'
Update app.FileColumns set ReportColumn = 'ComprehensiveSupportCode' Where ColumnName = 'ComprehensiveSupportIdentificationTypeID'
Update app.FileColumns set ReportColumn = 'TargetedSupportCode' Where ColumnName = 'TargetedSupportIdentificationTypeID'
Update app.FileColumns set ReportColumn = 'AdditionalTargetedSupportandImprovementCode' Where ColumnName = 'AddlTrgtSupImprvmntID'
Update app.FileColumns set ReportColumn = 'ComprehensiveSupportImprovementCode' Where ColumnName = 'CompSupImprvmntID'
Update app.FileColumns set ReportColumn = 'TargetedSupportImprovementCode' Where ColumnName = 'TrgtSupImprvmntID'
Update app.FileColumns set ReportColumn = 'AppropriationMethodCode' Where ColumnName = 'SteAprptnMthdsID'
Update app.FileColumns set ReportColumn = 'TITLEIIILANGUAGEINSTRUCTION' Where ColumnName = 'LanguageInstrTypeID'
Update app.FileColumns set ReportColumn = 'SPECIALEDUCATIONAGEGROUPTAUGHT' Where ColumnName = 'AgeGroupID'
Update app.FileColumns set ReportColumn = 'TITLE1SCHOOLSTATUS' Where ColumnName = 'TitleISchoolStatus'

Update fc set fc.ReportColumn = 'IDEAINDICATOR'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where fc.ColumnName IN ('DisabilityStatusID') and ReportCode IN ('c118','c144','c141','c175','c178','c179','c185','c188','c189','c040')


Update app.FileColumns set ReportColumn = 'REAPAlternativeFundingStatus' Where ColumnName = 'REAPAltFundInd'

Update fc set fc.ReportColumn = 'PROGRESSACHIEVINGENGLISHLANGUAGE'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where fc.ColumnName IN ('Amount') and ReportCode IN ('c205')

Update app.FileColumns set ReportColumn = 'OrganizationName' Where ColumnName = 'CharterAuthorizerName'
Update app.FileColumns set ReportColumn = 'OrganizationName' Where ColumnName = 'CharterMngmtOrgName'
Update app.FileColumns set ReportColumn = 'ManagementOrganizationType' Where ColumnName = 'CharterMngmtOrgType'
Update app.FileColumns set ReportColumn = 'OrganizationStateId' Where ColumnName = 'CharterMngmtOrgEmpIdNum'
Update app.FileColumns set ReportColumn = 'OrganizationStateId' Where ColumnName = 'CharterAuthorizerStateNumber'

Update app.FileColumns set ReportColumn = 'CharterSchoolAuthorizerType' Where ColumnName = 'CharterAuthorizerType'
Update app.FileColumns set ReportColumn = 'CHARTERSCHOOLMANAGERORGANIZATION' Where ColumnName = 'ManagementOrganizationEIN'
Update app.FileColumns set ReportColumn = 'CHARTERSCHOOLUPDATEDMANAGERORGANIZATION' Where ColumnName = 'ManagementOrgEINUpdated'
Update app.FileColumns set ReportColumn = 'CharterSchoolContractIdNumber' Where ColumnName = 'CharterContractIDNumber'


--set the new DimFactTypes FactTypeLabel column value
	IF COL_LENGTH('RDS.DimFactTypes', 'FactTypeLabel') IS NOT NULL
	BEGIN

		update rds.dimFactTypes
		set FactTypeLabel = 'Child Count'
		where FactTypeCode = 'childcount';

		update rds.dimFactTypes
		set FactTypeLabel = 'Exiting'
		where FactTypeCode = 'exiting';

		update rds.dimFactTypes
		set FactTypeLabel = 'Membership'
		where FactTypeCode = 'membership';

		update rds.dimFactTypes
		set FactTypeLabel = 'Dropout'
		where FactTypeCode = 'dropout';

		update rds.dimFactTypes
		set FactTypeLabel = 'Graduates/Completers'
		where FactTypeCode = 'graduatescompleters';

		update rds.dimFactTypes
		set FactTypeLabel = 'Title III English Learner Students - October'
		where FactTypeCode = 'titleIIIELOct';

		update rds.dimFactTypes
		set FactTypeLabel = 'Title III English Learner Students - School Year'
		where FactTypeCode = 'titleIIIELSY';

		update rds.dimFactTypes
		set FactTypeLabel = 'Title I'
		where FactTypeCode = 'titleI';

		update rds.dimFactTypes
		set FactTypeLabel = 'Migrant Education Program'
		where FactTypeCode = 'migranteducationprogram';

		update rds.dimFactTypes
		set FactTypeLabel = 'Immigrant'
		where FactTypeCode = 'immigrant';

		update rds.dimFactTypes
		set FactTypeLabel = 'Neglected or Delinquent'
		where FactTypeCode = 'neglectedordelinquent';

		update rds.dimFactTypes
		set FactTypeLabel = 'Chronic Absenteeism'
		where FactTypeCode = 'chronic';

		update rds.dimFactTypes
		set FactTypeLabel = 'Graduation Rate'
		where FactTypeCode = 'graduationrate';

		update rds.dimFactTypes
		set FactTypeLabel = 'High School Graduates Postsecondary Enrollment'
		where FactTypeCode = 'hsgradpsenroll';

		update rds.dimFactTypes
		set FactTypeLabel = 'Assessment'
		where FactTypeCode = 'assessment';

		update rds.dimFactTypes
		set FactTypeLabel = 'Staff'
		where FactTypeCode = 'staff';

		update rds.dimFactTypes
		set FactTypeLabel = 'Directory'
		where FactTypeCode = 'directory';

		update rds.dimFactTypes
		set FactTypeLabel = 'Discipline'
		where FactTypeCode = 'discipline';

		update rds.dimFactTypes
		set FactTypeLabel = 'Comprehensive Support and Targeted Support Identification'
		where FactTypeCode = 'compsupport';

		update rds.DimFactTypes
		set FactTypeCode = 'chronicabsenteeism'
			, FactTypeLabel = 'Chronic Absenteeism'
		where DimFactTypeId = 17;

		update rds.DimFactTypes
		set FactTypeLabel = 'Homeless'
		where DimFactTypeId = 16;

	END
