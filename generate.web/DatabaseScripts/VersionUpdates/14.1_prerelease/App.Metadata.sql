-- App metadata updates for release 14.1
-- Add release-specific metadata changes in this file.

print 'App.Metadata.sql executed for 14.1.'

declare @toggleSectionId as int
SELECT @toggleSectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'CERTIF'
Update app.ToggleQuestions set ToggleSectionId = @toggleSectionId where EmapsQuestionAbbrv = 'DEFEXCERT'

SELECT @toggleSectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'CERT'
delete from app.ToggleSections where ToggleSectionId = @toggleSectionId

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
