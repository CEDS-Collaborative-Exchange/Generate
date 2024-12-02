
CREATE VIEW app.CategoryCodeOptionsByReportAndYear
WITH SCHEMABINDING
AS
    SELECT DISTINCT
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
	LEFT JOIN app.GenerateReport_TableType grtt
		on gr.GenerateReportId = grtt.GenerateReportId
	JOIN app.TableTypes tt
		ON cs.TableTypeId = tt.TableTypeId
			OR grtt.TableTypeId = tt.TableTypeId
	


