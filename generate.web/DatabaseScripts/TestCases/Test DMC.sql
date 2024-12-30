PRINT 'Install test scripts'

PRINT 'Update Toggle'
DECLARE @SchoolYear SMALLINT = 2024
update App.ToggleResponses set ResponseValue = '10/01/' + CAST(@SchoolYear - 1 AS VARCHAR) where ToggleResponseId = 1

DECLARE  @DimSchoolYearId INT
SELECT @DimSchoolYearId = DimSchoolYearId FROM RDS.DimSchoolYears WHERE SchoolYear = @SchoolYear
UPDATE [RDS].[DimSchoolYearDataMigrationTypes] SET IsSelected = 0 
UPDATE [RDS].[DimSchoolYearDataMigrationTypes] SET IsSelected = 1 WHERE DimSchoolYearId = @DimSchoolYearId

--Run any setup needed before executing the migrations
PRINT 'pre DMC'
EXEC [Staging].[pre_DMC] @SchoolYear

---- Load the IDS & RDS
PRINT 'Run DMC'
EXEC [Staging].[RUN_DMC] @SchoolYear
-- Execution time to this point: 3:53:00 - Nearly 4 hours on my machine


-- Leave out FS009 because the test will run it for you

PRINT 'RDS migration for Child Count (C002, C089)'
UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('C002','C089')
EXEC RDS.Create_Reports 'childcount', 0 -- FS002, FS089 
-- Execution time: 2 minutes

PRINT 'RDS migration for EL Enrolled (C141)' -- 
UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('C141')
EXEC RDS.Create_Reports 'titleIIIELOct', 0 -- FS141
-- Execution time: 35 seconds

-- PRINT 'RDS migration for Child Count (C116)' -- No WORKING test for FS116
-- UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('C116')
-- EXEC RDS.Create_Reports 'titleIIIELSY', 0 -- FS116
-- Execution time: 

PRINT 'RDS migration for Homeless (C118, C194)'
UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('C118','C194')
EXEC RDS.Create_Reports 'homeless', 0 -- FS194
-- Execution time: 2 minutes

PRINT 'RDS migration for Discipline (C005,C006,C007,C086,C088,C143,C144)'
UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('C005','C006','C007','C086','C088','C143','C144')
EXEC RDS.Create_Reports 'discipline', 0 -- FS005, FS006, FS007, FS086, FS088, FS143, FS144
-- Execution time: 12:22

PRINT 'RDS migration for Assessments (C175,C178,C179,C185,C188,C189, C224, C225)'
UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('C175','C178','C179','C185','C188','C189')
EXEC RDS.Create_Reports 'assessment', 0 -- FS175, FS178, FS179, FS185, FS188, FS189, No tests yet for FS113, FS125, FS126, FS139, FS137, FS050, FS142, FS157
-- Execution time: 17:39

PRINT 'RDS migration for Staff (C070,C099,C112)'
UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('C070','C099','C112')
EXEC RDS.Create_Reports 'staff', 0 -- FS070, FS099, FS112, no tests yet for FS059, FS067, FS203
-- Execution time: :19

PRINT 'RDS migration for Directory (C029, C039)'
UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('C029', 'C039')
EXEC RDS.Create_OrganizationReportData 'C029', 0 -- FS029, no tests yet for FS039, FS129, FS130, FS193, FS190, FS196, FS197, FS198, FS103, FS131, FS205, FS206, FS170, FS035, FS207
EXEC RDS.Create_OrganizationReportData 'C039', 0 -- There is no test for 039 but it is needed for other migrations
-- Execution time: Instant

--EXEC RDS.Create_Reports 'studentcounts', 0, 'specedexit' -- FS009 - The test runs this code for you
--EXEC RDS.Create_Reports 'studentcounts', 0, 'cte' -- No tests yet 
PRINT 'RDS migration for Personnel (C033,C052)'
UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('c033','c052')
EXEC RDS.Create_ReportData 'C033', 'membership', 0
EXEC RDS.Create_ReportData 'C052', 'membership', 0
-- Execution time: 8:16

PRINT 'RDS migration for Membership (C226)'
UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('c226')

--PRINT 'RDS migration for Membership (C210)'
--UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('c210')

-------------------------------------------------------------------- 
--These are the report migrations using the new method
-------------------------------------------------------------------- 
-- PRINT 'Report migration for NeglectedOrDelinquent (C218, C219, C220, C221)'
-- UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('C218', 'C219', 'C220', 'C221')



-- 		exec [RDS].[Insert_CountsIntoReportTable]
-- 				@ReportCode  = 'C218',
-- 				@SubmissionYear = @SchoolYear, 
-- 				@ReportTableName =  'ReportEdFactsK12StudentCounts',
-- 				@IdentifierToCount = 'K12StudentStudentIdentifierState',
-- 				@CountColumn = 'StudentCount',
-- 				@IsDistinctCount  = 1

-- 		exec [RDS].[Insert_CountsIntoReportTable]
-- 				@ReportCode  = 'C219',
-- 				@SubmissionYear = @SchoolYear, 
-- 				@ReportTableName =  'ReportEdFactsK12StudentCounts',
-- 				@IdentifierToCount = 'K12StudentStudentIdentifierState',
-- 				@CountColumn = 'StudentCount',
-- 				@IsDistinctCount  = 1

-- 		exec [RDS].[Insert_CountsIntoReportTable]
-- 				@ReportCode  = 'C220',
-- 				@SubmissionYear = @SchoolYear, 
-- 				@ReportTableName =  'ReportEdFactsK12StudentCounts',
-- 				@IdentifierToCount = 'K12StudentStudentIdentifierState',
-- 				@CountColumn = 'StudentCount',
-- 				@IsDistinctCount  = 1

-- 		exec [RDS].[Insert_CountsIntoReportTable]
-- 				@ReportCode  = 'C221',
-- 				@SubmissionYear = @SchoolYear, 
-- 				@ReportTableName =  'ReportEdFactsK12StudentCounts',
-- 				@IdentifierToCount = 'K12StudentStudentIdentifierState',
-- 				@CountColumn = 'StudentCount',
-- 				@IsDistinctCount  = 1

  		exec [RDS].[Insert_CountsIntoReportTable]
  				@ReportCode  = '226',
  				@SubmissionYear = @SchoolYear, 
  				@ReportTableName =  'ReportEdFactsK12StudentCounts',
  				@IdentifierToCount = 'K12StudentStudentIdentifierState',
  				@CountColumn = 'StudentCount',
  				@IsDistinctCount  = 1
		
		exec [RDS].[Insert_CountsIntoReportTable]
  				@ReportCode  = '222',
  				@SubmissionYear = @SchoolYear, 
  				@ReportTableName =  'ReportEdFactsK12StudentCounts',
  				@IdentifierToCount = 'K12StudentStudentIdentifierState',
  				@CountColumn = 'StudentCount',
  				@IsDistinctCount  = 1

        -- 		exec [RDS].[Insert_CountsIntoReportTable]
-- 				@ReportCode  = 'C210',
-- 				@SubmissionYear = @SchoolYear, 
-- 				@ReportTableName =  'ReportEdFactsK12StudentCounts',
-- 				@IdentifierToCount = 'K12StudentStudentIdentifierState',
-- 				@CountColumn = 'StudentCount',
-- 				@IsDistinctCount  = 1

--EXEC RDS.Create_Reports 'studentcounts', 0, 'dropout' -- No tests yet FS032
--EXEC RDS.Create_Reports 'studentcounts', 0, 'grad' -- No tests yet FS040
--EXEC RDS.Create_Reports 'studentcounts', 0, 'grad' -- No tests yet FS040, FS045


--EXEC RDS.Create_Reports 'studentcounts', 0, 'titleIIIELSY' -- No tests yet for FS204
--EXEC RDS.Create_Reports 'studentcounts', 0, 'titleI' -- No tests yet for FS037, FS134
--EXEC RDS.Create_Reports 'studentcounts', 0, 'mep' -- No tests yet for FS054, FS121, FS122, FS145
--EXEC RDS.Create_Reports 'studentcounts', 0, 'immigrant' -- No tests yet for FS165
--EXEC RDS.Create_Reports 'studentcounts', 0, 'nord' -- No tests yet for FS119, FS127, FS180, FS181
--EXEC RDS.Create_Reports 'studentcounts', 0, 'chronic' -- No tests yet for FS195
--EXEC RDS.Create_Reports 'studentcounts', 0, 'gradrate' -- No tests yet for FS150, FS151
--EXEC RDS.Create_Reports 'studentcounts', 0, 'hsgradenroll' -- No tests yet for FS160
--EXEC RDS.Create_Reports 'organizationstatuscounts', 0, 'organizationstatus' -- no tests yet for FS199, FS200, FS201, FS202

PRINT 'End-to-End Test for DimK12Students'
EXEC App.DimK12Students_TestCase
PRINT 'End-to-End Test for FS029'
EXEC App.FS029_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS002'
EXEC App.FS002_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS089'
EXEC App.FS089_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS009'
EXEC App.FS009_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS005'
EXEC App.FS005_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS006'
EXEC App.FS006_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS007'
EXEC App.FS007_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS088'
EXEC App.FS088_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS143'
EXEC App.FS143_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS144'
EXEC App.FS144_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS070'
EXEC App.FS070_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS099'
EXEC App.FS099_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS112'
EXEC App.FS112_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS175'
EXEC App.FS17x_TestCase							@SchoolYear, 'FS175'
PRINT 'End-to-End Test for FS178'
EXEC App.FS17x_TestCase							@SchoolYear, 'FS178'
PRINT 'End-to-End Test for FS179'
EXEC App.FS17x_TestCase							@SchoolYear, 'FS179'
PRINT 'End-to-End Test for FS185'
EXEC App.FS18x_TestCase							@SchoolYear, 'FS185'
PRINT 'End-to-End Test for FS188'
EXEC App.FS18x_TestCase							@SchoolYear, 'FS188'
PRINT 'End-to-End Test for FS189'
EXEC App.FS18x_TestCase							@SchoolYear, 'FS189'
PRINT 'End-to-End Test for FS033'
EXEC App.FS033_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS052'
EXEC App.FS052_TestCase							@SchoolYear
-- PRINT 'End-to-End Test for FS116'
-- EXEC App.FS116_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS118'
EXEC App.FS118_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS141'
EXEC App.FS141_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS194'
EXEC App.FS194_TestCase							@SchoolYear
--PRINT 'End-to-End Test for FS212'
--EXEC App.FS212_TestCase							@SchoolYear
--PRINT 'End-to-End Test for zz_DimK12Schools_Charter_NA_TestCase'
--EXEC App.zz_DimK12Schools_Charter_NA_TestCase	@SchoolYear

-------------------------------------------------------------------- 
--These are the tests using the new method
-------------------------------------------------------------------- 
   --PRINT 'End-to-End Test for FS210'
   --EXEC Staging.RunEndToEndTest	 'C210', @SchoolYear, 'ReportEdFactsK12StudentCounts', 'StudentIdentifierState', 'StudentCount', 1
--PRINT 'End-to-End Test for FS218'
-- EXEC Staging.RunEndToEndTest	 'C218', @SchoolYear, 'ReportEdFactsK12StudentCounts', 'StudentIdentifierState', 'StudentCount', 1
-- PRINT 'End-to-End Test for FS219'
-- EXEC Staging.RunEndToEndTest	 'C219', @SchoolYear, 'ReportEdFactsK12StudentCounts', 'StudentIdentifierState', 'StudentCount', 1
-- PRINT 'End-to-End Test for FS220'
-- EXEC Staging.RunEndToEndTest	 'C220', @SchoolYear, 'ReportEdFactsK12StudentCounts', 'StudentIdentifierState', 'StudentCount', 1
-- PRINT 'End-to-End Test for FS221'
-- EXEC Staging.RunEndToEndTest	 'C221', @SchoolYear, 'ReportEdFactsK12StudentCounts', 'StudentIdentifierState', 'StudentCount', 1
-- PRINT 'End-to-End Test for FS224'
-- EXEC Staging.RunEndToEndTest	 'C224', @SchoolYear, 'ReportEdFactsK12StudentAssessments', 'StudentIdentifierState', 'StudentCount', 1
-- PRINT 'End-to-End Test for FS225'
-- EXEC Staging.RunEndToEndTest	 'C225', @SchoolYear, 'ReportEdFactsK12StudentAssessments', 'StudentIdentifierState', 'StudentCount', 1
   PRINT 'End-to-End Test for FS226'
   EXEC Staging.RunEndToEndTest	 '226', @SchoolYear, 'ReportEdFactsK12StudentAssessments', 'StudentIdentifierState', 'StudentCount', 1
  PRINT 'End-to-End Test for FS226'
   EXEC Staging.RunEndToEndTest	 '222', @SchoolYear, 'ReportEdFactsK12StudentCounts', 'StudentIdentifierState', 'StudentCount', 1

