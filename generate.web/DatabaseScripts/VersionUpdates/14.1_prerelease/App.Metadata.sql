-- App metadata updates for release 14.1
-- Add release-specific metadata changes in this file.

print 'App.Metadata.sql executed for 14.1.'

declare @toggleSectionId as int
SELECT @toggleSectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'CERTIF'
Update app.ToggleQuestions set ToggleSectionId = @toggleSectionId where EmapsQuestionAbbrv = 'DEFEXCERT'

SELECT @toggleSectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'CERT'
delete from app.ToggleSections where ToggleSectionId = @toggleSectionId
