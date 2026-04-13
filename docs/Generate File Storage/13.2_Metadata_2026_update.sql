update m2026
set m2026.FileSubmissionDescription = m2025.FileSubmissionDescription
from app.FileSubmissions as m2026
inner join app.FileSubmissions as m2025
	on m2025.GenerateReportId = m2026.GenerateReportId
	and m2025.OrganizationLevelId = m2026.OrganizationLevelId
	and m2025.SubmissionYear = 2025
where m2026.SubmissionYear = 2026;