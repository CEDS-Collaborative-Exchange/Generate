-- App metadata updates for release 14.1
-- Add release-specific metadata changes in this file.

-- Defensive guard: the metadata update below assumes Staging.AssessmentResult already
-- carries EdFactsFormerEnglishLearnerYearStatus, added by 14.0's own Staging.TableChanges.sql.
-- A generate_14.0.bak snapshot taken before that script ran won't have it, which breaks
-- test-data generation (SqlBulkCopy) against a freshly-restored 14.1_prerelease database.
IF COL_LENGTH('Staging.AssessmentResult', 'EdFactsFormerEnglishLearnerYearStatus') IS NULL
BEGIN
	ALTER TABLE Staging.AssessmentResult
	ADD EdFactsFormerEnglishLearnerYearStatus VARCHAR (100) NULL;
END

print 'App.Metadata.sql executed for 14.1.'

-- declare @toggleSectionId as int
-- SELECT @toggleSectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'CERTIF'
-- Update app.ToggleQuestions set ToggleSectionId = @toggleSectionId where EmapsQuestionAbbrv = 'DEFEXCERT'

-- SET @toggleSectionId = 0

-- SELECT @toggleSectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'CERT'
-- delete from app.ToggleSections where ToggleSectionId = @toggleSectionId

Update app.ToggleSections set SectionTitle = 'Regular High School Diplomas' where EmapsSurveySectionAbbrv = 'CERTIF'

-- Repoint the 2026 PROFSTATUS category (EdFactsCategoryId 202) to the
-- ProficiencyStatus dimension sourced from DimTitleIIIStatuses, matching
-- the mapping already used by the pre-2026 PROFSTATUS category.
declare @profStatusCategoryId as int, @profStatusDimensionId as int

select @profStatusCategoryId = CategoryId
from app.Categories
where CategoryCode = 'PROFSTATUS' and EdFactsCategoryId = 202

select @profStatusDimensionId = d.DimensionId
from app.Dimensions d
inner join app.DimensionTables dt on d.DimensionTableId = dt.DimensionTableId
where d.DimensionFieldName = 'ProficiencyStatus' and dt.DimensionTableName = 'DimTitleIIIStatuses'

if @profStatusCategoryId is not null and @profStatusDimensionId is not null
begin
	Update app.Category_Dimensions set DimensionId = @profStatusDimensionId where CategoryId = @profStatusCategoryId
end


-- Repoint the FormerEnglishLearnerYearStatus dimension (used by category
-- MONLEPFORMER, EdFactsCategoryId 175) to source from DimAssessmentStatuses
-- instead of the legacy DimTitleIIIStatuses mapping. Staging.AssessmentResult
-- now carries EdFactsFormerEnglishLearnerYearStatus (CIID-7234), and
-- RDS.DimAssessmentStatuses/RDS.vwDimAssessmentStatuses were extended to
-- carry FormerEnglishLearnerYearStatusCode/Description/EdFactsCode to match.
declare @formerElYearStatusDimensionId as int, @assessmentStatusesTableId as int

select @formerElYearStatusDimensionId = DimensionId
from app.Dimensions
where DimensionFieldName = 'FormerEnglishLearnerYearStatus'

select @assessmentStatusesTableId = DimensionTableId
from app.DimensionTables
where DimensionTableName = 'DimAssessmentStatuses'

if @formerElYearStatusDimensionId is not null and @assessmentStatusesTableId is not null
begin
	Update app.Dimensions set DimensionTableId = @assessmentStatusesTableId where DimensionId = @formerElYearStatusDimensionId
end

-- Remove the deprecated combined Comprehensive and Targeted Support element.
-- It has been replaced by Comprehensive Support and Improvement, Targeted Support and Improvement,
-- and Additional Targeted Support and Improvement. The combined element was only used by the
-- 2019 C206 file specification.
declare @ctsCategories table (CategoryId int)

insert into @ctsCategories (CategoryId)
select CategoryId
from app.Categories
where CategoryCode in ('ComprehensiveTargetedSupportSchTypeID', 'COMPREHENSIVETARGETEDSUPPORTSCHTYPE')

declare @ctsDimensionId as int

select @ctsDimensionId = DimensionId
from app.Dimensions
where DimensionFieldName = 'ComprehensiveAndTargetedSupport'

delete ffc
from app.FileSubmission_FileColumns ffc
inner join app.FileColumns fc on ffc.FileColumnId = fc.FileColumnId
where fc.ReportColumn = 'ComprehensiveAndTargetedSupportCode'

delete from app.FileColumns where ReportColumn = 'ComprehensiveAndTargetedSupportCode'

delete from app.CategoryOptions where CategoryId in (select CategoryId from @ctsCategories)

delete from app.CategorySet_Categories where CategoryId in (select CategoryId from @ctsCategories)

delete from app.Category_Dimensions
where CategoryId in (select CategoryId from @ctsCategories)
	or DimensionId = @ctsDimensionId

delete from app.Categories where CategoryId in (select CategoryId from @ctsCategories)

delete from app.Dimensions where DimensionId = @ctsDimensionId

delete from Staging.SourceSystemReferenceData where TableName = 'RefComprehensiveAndTargetedSupport'

-- CIID-6916: Toggle category "CCD - Staff Category" with the question that controls whether
-- FS059 Staff FTE includes the Ungraded Teachers (UGTCH) permitted value. Per the FS059
-- file spec, a state that does not use ungraded teachers must not include UGTCH records.
-- RDS.Get_CountSQL reads the response by EmapsQuestionAbbrv 'CCDUNGRADEDTCH'.
declare @ccdStaffSectionTypeId as int, @ccdStaffParentSectionId as int, @ccdStaffSectionId as int

select @ccdStaffSectionTypeId = ToggleSectionTypeId from app.ToggleSectionTypes where EmapsSurveyTypeAbbrv = 'CCDSTAFF'
if @ccdStaffSectionTypeId is null
begin
	insert into app.ToggleSectionTypes (EmapsSurveyTypeAbbrv, SectionTypeName, SectionTypeSequence, SectionTypeShortName)
	values ('CCDSTAFF', 'CCD Staff Category', 3, 'CCD')
	set @ccdStaffSectionTypeId = SCOPE_IDENTITY()
end

select @ccdStaffParentSectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'CCDSTAFFPARENT'
if @ccdStaffParentSectionId is null
begin
	insert into app.ToggleSections (EmapsParentSurveySectionAbbrv, EmapsSurveySectionAbbrv, SectionName, SectionSequence, SectionTitle, ToggleSectionTypeId)
	values (NULL, 'CCDSTAFFPARENT', 'B2', 1150, 'Staff Category', @ccdStaffSectionTypeId)
	set @ccdStaffParentSectionId = SCOPE_IDENTITY()
end

select @ccdStaffSectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'CCDSTAFF'
if @ccdStaffSectionId is null
begin
	insert into app.ToggleSections (EmapsParentSurveySectionAbbrv, EmapsSurveySectionAbbrv, SectionName, SectionSequence, SectionTitle, ToggleSectionTypeId)
	values ('CCDSTAFFPARENT', 'CCDSTAFF', 'B21', 1151, 'Staff Category', @ccdStaffSectionTypeId)
	set @ccdStaffSectionId = SCOPE_IDENTITY()
end

if not exists (select 1 from app.ToggleQuestions where EmapsQuestionAbbrv = 'CCDUNGRADEDTCH')
begin
	insert into app.ToggleQuestions (EmapsQuestionAbbrv, ParentToggleQuestionId, QuestionSequence, QuestionText, ToggleQuestionTypeId, ToggleSectionId)
	values ('CCDUNGRADEDTCH', NULL, 1151, 'Are any teachers identified as teachers for ungraded classes?', 7, @ccdStaffSectionId)
end
