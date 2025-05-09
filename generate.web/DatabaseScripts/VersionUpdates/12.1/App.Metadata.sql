DECLARE @GenerateReportId INT

SELECT @GenerateReportId =  [GenerateReportId]
FROM [App].[GenerateReports]
WHERE [ReportCode] = 'C059'

Update [App].[CategorySets]
Set [ViewDefinition] = REPLACE([ViewDefinition], 'k12staffclassification','k12STAFFCLASSIFICATION')
where CategorySetCode = 'CSA'
and ([OrganizationLevelId] = 1 or [OrganizationLevelId] = 2)
and [GenerateReportId] = @GenerateReportId


-- CIID-7191
-- Start of dbo.RefAssessmentTypeChildrenWithDisabilities
DECLARE @RefAssessmentTypeChildrenWithDisabilities table
(
	Code varchar(50),
	Description varchar(200),
	SortOrder int
)

DECLARE @Description varchar(100)

DECLARE @SortOrder INT
SET @SortOrder = 10

SET @Description ='Regular assessments based on grade-level achievement standards without accommodations'
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'REGASSWOACC', @Description, @SortOrder

SET @Description ='Regular assessments based on grade-level achievement standards with accommodations'
SET @SortOrder = @SortOrder + 1
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'REGASSWACC', @Description, @SortOrder

SET @Description ='Alternate assessments based on grade-level achievement standards'
SET @SortOrder = @SortOrder + 1
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'ALTASSGRADELVL', @Description, @SortOrder

SET @Description ='Alternate assessments based on modified achievement standards'
SET @SortOrder = @SortOrder + 1
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'ALTASSMODACH', @Description, @SortOrder

SET @Description ='Alternate assessments based on alternate achievement standards'
SET @SortOrder = @SortOrder + 1
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'ALTASSALTACH', @Description, @SortOrder

SET @Description ='Advanced assessment with accommodations'
SET @SortOrder = @SortOrder + 1
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'ADVASMTWACC', @Description, @SortOrder

SET @Description ='Advanced assessment without accommodations'
SET @SortOrder = @SortOrder + 1
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'ADVASMTWOACC', @Description, @SortOrder

SET @Description ='Innovative Assessment Demonstration Authority (IADA) pilot assessment with accommodations'
SET @SortOrder = @SortOrder + 1
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'IADAPLASMTWACC', @Description, @SortOrder

SET @Description ='Innovative Assessment Demonstration Authority (IADA) pilot assessment without accommodations'
SET @SortOrder = @SortOrder + 1
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'IADAPLASMTWOACC', @Description, @SortOrder

SET @Description ='High school regular assessment II, with accommodations'
SET @SortOrder = @SortOrder + 1
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'HSREGASMT2WACC', @Description, @SortOrder

SET @Description ='High school regular assessment II, without accommodations'
SET @SortOrder = @SortOrder + 1
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'HSREGASMT2WOACC', @Description, @SortOrder

SET @Description ='High school regular assessment III, with accommodations'
SET @SortOrder = @SortOrder + 1
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'HSREGASMT3WACC', @Description, @SortOrder

SET @Description ='HSREGASMT3WOACC'
SET @SortOrder = @SortOrder + 1
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'HSREGASMT3WOACC', @Description, @SortOrder

SET @Description =''
SET @SortOrder = @SortOrder + 1
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'HSREGASMTIWACC', @Description, @SortOrder

SET @Description ='High school regular assessment I, with accommodations'
SET @SortOrder = @SortOrder + 1
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'HSREGASMTIWOACC', @Description, @SortOrder

SET @Description ='Locally-selected nationally recognized high school assessment with accommodations'
SET @SortOrder = @SortOrder + 1
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'LSNRHSASMTWACC', @Description, @SortOrder

SET @Description ='Locally-selected nationally recognized high school assessment without accommodations'
SET @SortOrder = @SortOrder + 1
INSERT INTO @RefAssessmentTypeChildrenWithDisabilities SELECT 'LSNRHSASMTWOACC', @Description, @SortOrder

INSERT INTO [dbo].[RefAssessmentTypeChildrenWithDisabilities]
(
	[Code]
	,[Description]      
	,[Definition]
	,[SortOrder]
)
SELECT 	tref.Code, tref.Description, tref.Description, tref.SortOrder
FROM @RefAssessmentTypeChildrenWithDisabilities tref
LEFT JOIN [dbo].[RefAssessmentTypeChildrenWithDisabilities] ref ON ref.code = tref.Code
WHERE ref.RefAssessmentTypeChildrenWithDisabilitiesId IS NULL


-- End of dbo.RefAssessmentTypeChildrenWithDisabilities