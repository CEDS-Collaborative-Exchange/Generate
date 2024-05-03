CREATE VIEW app.CategoryCodeOptionsByReportAndYear
WITH SCHEMABINDING
AS
    SELECT 
        o.CategoryOptionCode,
        c.CategoryCode,
		cs.CategorySetCode,
        cs.SubmissionYear,
		cs.TableTypeId,
		tt.TableTypeAbbrv,
		gr.ReportCode
	FROM app.GenerateReports gr 
    JOIN app.CategorySets cs 
		ON cs.GenerateReportId = gr.GenerateReportId 
		AND gr.IsActive = 1 
		AND gr.GenerateReportTypeId = 3
    JOIN app.CategorySet_Categories csc 
		ON csc.CategorySetId = cs.CategorySetId
    JOIN app.Categories c 
		ON c.CategoryId = csc.CategoryId
    JOIN app.CategoryOptions o 
		ON o.CategoryId = c.CategoryId 
		AND cs.CategorySetId = o.CategorySetId
	JOIN app.TableTypes tt
		ON cs.TableTypeId = tt.TableTypeId
	WHERE cs.OrganizationLevelId = 1
		AND cs.TableTypeId IS NOT NULL
	
GO


CREATE UNIQUE CLUSTERED INDEX iux_CategoryCodeOptionsByReportAndYear
ON app.CategoryCodeOptionsByReportAndYear (ReportCode, SubmissionYear, CategorySetCode, TableTypeId, CategoryCode, CategoryOptionCode);

CREATE NONCLUSTERED INDEX ix_CategoryCodeOptionsByReportAndYear_ReportCode_SubmissionYear_CategoryCode
ON app.CategoryCodeOptionsByReportAndYear (ReportCode, SubmissionYear, TableTypeAbbrv, CategoryCode);