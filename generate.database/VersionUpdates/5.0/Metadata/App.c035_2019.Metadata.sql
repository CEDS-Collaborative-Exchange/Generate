/* FileBegins App.c035_2019.Metadata.sql */


SET NOCOUNT ON

BEGIN TRY

	BEGIN TRANSACTION

		-- Duplicate metadata was found for FS035 that's just different enough that t UX's don't catch it. 
		delete fsfc
		from app.FileColumns fc
		join app.FileSubmission_FileColumns fsfc
			on fc.FileColumnId = fsfc.FileColumnId
		join app.FileSubmissions fs
			on fsfc.FileSubmissionId = fs.FileSubmissionId
		join app.GenerateReports gr
			on fs.GenerateReportId = gr.GenerateReportId
		where reportcode = 'c035'
			and fs.SubmissionYear = '2019'

		delete fs
		from app.FileColumns fc
		join app.FileSubmission_FileColumns fsfc
			on fc.FileColumnId = fsfc.FileColumnId
		join app.FileSubmissions fs
			on fsfc.FileSubmissionId = fs.FileSubmissionId
		join app.GenerateReports gr
			on fs.GenerateReportId = gr.GenerateReportId
		where reportcode = 'c035'
			and fs.SubmissionYear = '2019'



		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.002','Adult Education State Grant Program','2068')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.010','Title I Grants to Local Education Agencies','876')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.011','Migrant Education - Basic State Grant Program','877')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.013','Title I Program for Neglected and Delinquent Children','878')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.027','Special Education - Grants to States','879')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.048','Career and Technical Education - Basic Grants to States','880')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.173','Special Education Preschool Grants','2119')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.196','Education for Homeless Children and Youth','884')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.282','Charter Schools Program','888')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.287','21st Century Community Learning Centers','889')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.323A','Special Education State Personnel Development Grants','9454')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.334S','GEARUP State Awards','8479')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.358','Rural Education Achievement Program','2161')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.365A','English Language Acquisition, State Grants','8350')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.367A','Supporting Effective Instruction State Grants','8481')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.371','Comprehensive Literacy Development Grants','2273')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.372','Statewide Longitudinal Data Systems','8426')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','LEA FEDERAL PROGRAMS','2','2019','CSA','Category Set A','20338','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.424','Student Support and Academic Enrichment Grants','9455')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','ALLOCTYPE','Funding Allocation Type','199','DISTNONLEA','Distributed to entities other than LEAs','8360')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','ALLOCTYPE','Funding Allocation Type','199','RETAINED','Retained by SEA for program administration, etc.','8358')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','ALLOCTYPE','Funding Allocation Type','199','TRANSFER','Transferred to another state-level agency','8359')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','ALLOCTYPE','Funding Allocation Type','199','UNALLOC','Unallocated or returned funds','8361')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.002','Adult Education State Grant Program','2068')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.010','Title I Grants to Local Education Agencies','876')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.011','Migrant Education - Basic State Grant Program','877')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.013','Title I Program for Neglected and Delinquent Children','878')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.027','Special Education - Grants to States','879')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.048','Career and Technical Education - Basic Grants to States','880')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.173','Special Education Preschool Grants','2119')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.196','Education for Homeless Children and Youth','884')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.282','Charter Schools Program','888')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.287','21st Century Community Learning Centers','889')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.323A','Special Education State Personnel Development Grants','9454')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.334S','GEARUP State Awards','8479')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.358','Rural Education Achievement Program','2161')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.365A','English Language Acquisition, State Grants','8350')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.367A','Supporting Effective Instruction State Grants','8481')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.371','Comprehensive Literacy Development Grants','2273')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.372','Statewide Longitudinal Data Systems','8426')
		INSERT INTO App.vwReportCode_CategoryOptions (
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
		VALUES ('c035','SEA FEDERAL PROGRAMS','1','2019','CSA','Category Set A','20337','9','FEDPROG','Federal Programs Funding Allocation Table','FEDPROG','Federal Program Code','94','84.424','Student Support and Academic Enrichment Grants','9455')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('1','CarriageReturn/LineFeed','','','Control Character','304','1','11','304','2019','1','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('1','CarriageReturn/LineFeed','','','Control Character','304','1','11','304','2019','2','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('10','AllocationTypeID','Funding Allocation Type','FUNDALLOCTYPE','String','103','1','9','94','2019','1','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('10','Amount','Full Dollar Amount','ALLOCATEDFUNDS','Number','93','1','8','84','2019','1','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('10','Amount','Full Dollar Amount','ALLOCATEDFUNDS','Number','93','1','8','84','2019','2','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('10','FileRecordNumber','','','Number','10','1','1','1','2019','1','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('10','FileRecordNumber','','','Number','10','1','1','1','2019','2','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('10','Filler4','','','String','103','1','9','94','2019','2','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('14','Filler2','','','String','28','1','4','15','2019','1','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('14','StateLEAIDNumber','State LEA ID Number','STATELEAIDNUMBER','String','28','1','4','15','2019','2','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('15','CFDAID','Federal Program Code','CFDAABBRV','String','83','1','7','69','2019','1','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('15','CFDAID','Federal Program Code','CFDAABBRV','String','83','1','7','69','2019','2','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('2','FIPSStateCode','FIPS','FIPSSTATECODE','String','12','1','2','11','2019','1','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('2','FIPSStateCode','FIPS','FIPSSTATECODE','String','12','1','2','11','2019','2','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('2','StateAgencyNumber','State Agency Number','STATEAGENCYNUMBER','String','14','1','3','13','2019','1','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('2','StateAgencyNumber','State Agency Number','STATEAGENCYNUMBER','String','14','1','3','13','2019','2','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('20','Filler3','','','String','48','1','5','29','2019','1','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('20','Filler3','','','String','48','1','5','29','2019','2','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('20','TableTypeAbbrv','Table Type Abbreviation','TYPEABBRV','String','68','1','6','49','2019','1','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('20','TableTypeAbbrv','Table Type Abbreviation','TYPEABBRV','String','68','1','6','49','2019','2','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('200','Explanation','Explanation','EXPLANATION','String','303','0','10','104','2019','1','c035')
		INSERT INTO App.vwReportCode_FileColumns (
			ColumnLength
			,ColumnName
			/*,DimensionId*/
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
		) 
		VALUES('200','Explanation','Explanation','EXPLANATION','String','303','0','10','104','2019','2','c035')


	COMMIT TRANSACTION


END TRY

begin catch

	IF @@TRANCOUNT > 0

	begin

		rollback transaction

	end

	declare @msg as nvarchar(max)

	set @msg = ERROR_MESSAGE()

	declare @sev as int

	set @sev = ERROR_SEVERITY()

	RAISERROR(@msg, @sev, 1)

end catch
