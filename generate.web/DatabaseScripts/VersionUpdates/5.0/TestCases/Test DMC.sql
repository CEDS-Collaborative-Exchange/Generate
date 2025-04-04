PRINT 'Install test scripts'
GO

-- Install Tests
:r "C:\Repos\generate\generate.web\DatabaseScripts\TestCases\RUN DMC.sql"
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.DimK12Schools_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.DimK12Students_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.DimLeas_TestCase.StoredProcedure.sql
GO
--:r C:\Repos\generate\generate.web\DatabaseScripts\TestCasesApp.DimSeas_TestCase.StoredProcedure.sql --Needs work
--GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS002_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS005_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS006_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS007_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS009_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS029_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS070_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS088_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS089_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS099_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS112_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS116_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS141_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS143_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS144_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS175_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS178_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS179_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS185_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS188_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS189_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS194_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.FS212_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.General_TestCase.StoredProcedure.sql
GO
:r C:\Repos\generate\generate.web\DatabaseScripts\TestCases\App.zz_DimK12Schools_Charter_NA_TestCase.StoredProcedure.sql
GO

PRINT 'Update Toggle'
DECLARE @SchoolYear SMALLINT = 2022
update App.ToggleResponses set ResponseValue = '10/01/' + CAST(@SchoolYear - 1 AS VARCHAR) where ToggleResponseId = 1

DECLARE  @DimSchoolYearId INT
SELECT @DimSchoolYearId = DimSchoolYearId FROM RDS.DimSchoolYears WHERE SchoolYear = @SchoolYear
UPDATE [RDS].[DimSchoolYearDataMigrationTypes] SET IsSelected = 0 
UPDATE [RDS].[DimSchoolYearDataMigrationTypes] SET IsSelected = 1 WHERE DimSchoolYearId = @DimSchoolYearId

---- Load the IDS & RDS
PRINT 'Run DMC'
EXEC [Staging].[RUN_DMC] @SchoolYear
-- Execution time to this point: 3:53:00 - Nearly 4 hours on my machine


-- Leave out FS009 because the test will run it for you

PRINT 'RDS migration for Child Count (FS002, FS089)'
UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('C002','C089')
EXEC RDS.Create_Reports 'childcount', 0, 'studentcounts' -- FS002, FS089 
-- Execution time: 2 minutes
--PRINT 'RDS migration for Child Count (C141)' -- No WORKING test for FS116
----UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('C141')
--EXEC RDS.Create_Reports 'titleIIIELOct', 0, 'studentcounts' -- FS116, FS141
-- Execution time: 15 seconds - No records created
PRINT 'RDS migration for Child Count (FS194)'
UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('C194')
EXEC RDS.Create_Reports 'homeless', 0, 'studentcounts' -- FS194, No tests yet for FS118
-- Execution time: Instant - No records created
PRINT 'RDS migration for Child Count (C005,C006,C007,C088,C143,C144)'
UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('C005','C006','C007','C088','C143','C144')
EXEC RDS.Create_Reports 'submission', 0, 'disciplinecounts' -- FS005, FS006, FS007, FS086, FS088, FS143, FS144
-- Execution time: 2 minutes - No recors created
PRINT 'RDS migration for Child Count (C175,C178,C179,C185,C188,C189)'
UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('C175','C178','C179','C185','C188','C189')
EXEC RDS.Create_Reports 'submission', 0, 'studentassessments' -- FS175, FS178, FS179, FS185, FS188, FS189, No tests yet for FS113, FS125, FS126, FS139, FS137, FS050, FS142, FS157
-- Execution time -- ERROR with debug table - table name too long
PRINT 'RDS migration for Personnel (C070,C099,C112)'
UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('C070','C099','C112')
EXEC RDS.Create_Reports 'submission', 0, 'personnelcounts' -- FS070, FS099, FS112, no tests yet for FS059, FS067, FS203
-- Execution time -- ERROR "Invalud column name "DimStudentId" for FS070 Line 1334
PRINT 'RDS migration for Directry (C029)'
UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ('C029')
EXEC RDS.Create_Reports 'submission', 0, 'organizationcounts' -- FS029, no tests yet for FS039, FS129, FS130, FS193, FS190, FS196, FS197, FS198, FS103, FS131, FS205, FS206, FS170, FS035, FS207
-- Execution time

--EXEC RDS.Create_Reports 'studentcounts', 0, 'specedexit' -- FS009 - The test runs this code for you
--EXEC RDS.Create_Reports 'studentcounts', 0, 'cte' -- No tests yet 
--EXEC RDS.Create_Reports 'studentcounts', 0, 'membership' -- No tests yet for FS033 and FS052
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
PRINT 'End-to-End Test for FS002'
EXEC App.FS002_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS005'
EXEC App.FS005_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS006'
EXEC App.FS006_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS007'
EXEC App.FS007_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS009'
EXEC App.FS009_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS029'
EXEC App.FS029_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS070'
EXEC App.FS070_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS088'
EXEC App.FS088_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS089'
EXEC App.FS089_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS099'
EXEC App.FS099_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS112'
EXEC App.FS112_TestCase							@SchoolYear
--PRINT 'End-to-End Test for FS116'
--EXEC App.FS116_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS141'
EXEC App.FS141_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS143'
EXEC App.FS143_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS144'
EXEC App.FS144_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS175'
EXEC App.FS175_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS178'
EXEC App.FS178_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS179'
EXEC App.FS179_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS185'
EXEC App.FS185_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS188'
EXEC App.FS188_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS189'
EXEC App.FS189_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS194'
EXEC App.FS194_TestCase							@SchoolYear
PRINT 'End-to-End Test for FS212'
EXEC App.FS212_TestCase							@SchoolYear
PRINT 'End-to-End Test for zz_DimK12Schools_Charter_NA_TestCase'
EXEC App.zz_DimK12Schools_Charter_NA_TestCase	@SchoolYear