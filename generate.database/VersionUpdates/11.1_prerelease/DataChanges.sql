-- Correct two values in app.ToggleSections
-- Have to do it twice to get around the unique constraint
update app.ToggleSections set EmapsSurveySectionAbbrv = 'CERTIF1' where SectionTitle = 'Certificates'
update app.ToggleSections set EmapsSurveySectionAbbrv = 'MINAGE1' where SectionTitle = 'Regular High School Diplomas'
update app.ToggleSections set EmapsSurveySectionAbbrv = 'CERTIF' where SectionTitle = 'Certificates'
update app.ToggleSections set EmapsSurveySectionAbbrv = 'MINAGE' where SectionTitle = 'Regular High School Diplomas'

