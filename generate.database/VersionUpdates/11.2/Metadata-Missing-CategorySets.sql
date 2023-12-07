declare @generateReportId as INT
select @generateReportId = GenerateReportId from app.GenerateReports where ReportCode = 'C163'

IF NOT EXISTS(SELECT 1 FROM APP.CATEGORYSETS WHERE GENERATEREPORTID = @generateReportId 
                AND SUBMISSIONYEAR = 2022 AND OrganizationLevelId = 2)
BEGIN
    INSERT INTO APP.CategorySets VALUES ('CSA', 'Category Set A', NULL, 0, NULL, 78, NULL, 2, 2022, NULL, '{"showColumnTotals":0,"showRowTotals":0,"defaultFilterType":3,"fields":[{"binding":"organizationIdentifierSea","header":"LEA ID","dataType":1,"aggregate":1,"showAs":0,"descending":false,"format":"D","isContentHtml":false},{"binding":"organizationName","header":"LEA","dataType":1,"aggregate":0,"showAs":0,"descending":false,"format":"","width":250,"wordWrap":true,"isContentHtml":false},{"binding":"organizationCount","header":"Count","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n0","isContentHtml":false}],"rowFields":{"items":["LEA","LEA ID"]},"columnFields":{"items":[]},"filterFields":{"items":[]},"valueFields":{"items":["Count"]}}', NULL)
END

IF NOT EXISTS(SELECT 1 FROM APP.CATEGORYSETS WHERE GENERATEREPORTID = @generateReportId 
                AND SUBMISSIONYEAR = 2022 AND OrganizationLevelId = 3)
BEGIN
    INSERT INTO APP.CategorySets VALUES ('CSA', 'Category Set A', NULL, 0, NULL, 78, NULL, 3, 2022, NULL, '{"showColumnTotals":0,"showRowTotals":0,"defaultFilterType":3,"fields":[{"binding":"organizationIdentifierSea","header":"School ID","dataType":1,"aggregate":2,"showAs":0,"descending":false,"format":"D","isContentHtml":false},{"binding":"organizationName","header":"School","dataType":1,"aggregate":0,"showAs":0,"descending":false,"format":"","width":250,"wordWrap":true,"isContentHtml":false},{"binding":"organizationCount","header":"Count","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n0","isContentHtml":false}],"rowFields":{"items":["School","School ID"]},"columnFields":{"items":[]},"filterFields":{"items":[]},"valueFields":{"items":["Count"]}}', NULL)
END

IF NOT EXISTS(SELECT 1 FROM APP.FileSubmissions WHERE GENERATEREPORTID = @generateReportId 
                AND SUBMISSIONYEAR = '2022' AND OrganizationLevelId = 2)
BEGIN
    INSERT INTO APP.FileSubmissions VALUES ('LEA DISCIPLINE DATA', 78, 2, 2022)
END

IF NOT EXISTS(SELECT 1 FROM APP.FileSubmissions WHERE GENERATEREPORTID = @generateReportId 
                AND SUBMISSIONYEAR = '2022' AND OrganizationLevelId = 3)
BEGIN
    INSERT INTO APP.FileSubmissions VALUES ('SCHOOL DISCIPLINE DATA', 78, 3, 2022)
END

select @generateReportId = GenerateReportId from app.GenerateReports where ReportCode = 'C206'

IF NOT EXISTS(SELECT 1 FROM APP.CATEGORYSETS WHERE GENERATEREPORTID = @generateReportId AND SUBMISSIONYEAR = 2021)
BEGIN
    INSERT INTO APP.CategorySets VALUES ('CategorySetA', 'Category Set A', NULL, 0, NULL, 109, NULL, 3, 2021, NULL, '{"showColumnTotals":0,"showRowTotals":0,"defaultFilterType":3,"fields":[{"binding":"organizationIdentifierSea","header":"School ID","dataType":1,"aggregate":2,"showAs":0,"descending":false,"format":"D","isContentHtml":false},{"binding":"organizationName","header":"School","dataType":1,"aggregate":0,"showAs":0,"descending":false,"format":"","width":250,"wordWrap":true,"isContentHtml":false},{"binding":"comprehensivesupport","header":"Additional targeted support school not exiting suc","dataType":2,"aggregate":0,"showAs":0,"descending":false,"format":"n0","wordWrap":true,"isContentHtml":false},{"binding":"comprehensiveandtargetedsupport","header":"Comprehensive Support and Improvement","dataType":2,"aggregate":0,"showAs":0,"descending":false,"format":"n0","wordWrap":true,"isContentHtml":false},{"binding":"targetedsupport","header":"Additional targeted support and improvement school","dataType":2,"aggregate":0,"showAs":0,"descending":false,"format":"n0","wordWrap":true,"isContentHtml":false},{"binding":"organizationCount","header":"Count","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n0","isContentHtml":false}],"rowFields":{"items":["School","School ID","Comprehensive Support and Improvement"]},"columnFields":{"items":["Additional targeted support school not exiting suc","Additional targeted support and improvement school"]},"filterFields":{"items":[]},"valueFields":{"items":["Count"]}}', NULL)
END

IF NOT EXISTS(SELECT 1 FROM APP.CATEGORYSETS WHERE GENERATEREPORTID = @generateReportId AND SUBMISSIONYEAR = 2022)
BEGIN
    INSERT INTO APP.CategorySets VALUES ('CategorySetA', 'Category Set A', NULL, 0, NULL, 109, NULL, 3, 2022, NULL, '{"showColumnTotals":0,"showRowTotals":0,"defaultFilterType":3,"fields":[{"binding":"organizationIdentifierSea","header":"School ID","dataType":1,"aggregate":2,"showAs":0,"descending":false,"format":"D","isContentHtml":false},{"binding":"organizationName","header":"School","dataType":1,"aggregate":0,"showAs":0,"descending":false,"format":"","width":250,"wordWrap":true,"isContentHtml":false},{"binding":"comprehensivesupport","header":"Additional targeted support school not exiting suc","dataType":2,"aggregate":0,"showAs":0,"descending":false,"format":"n0","wordWrap":true,"isContentHtml":false},{"binding":"comprehensiveandtargetedsupport","header":"Comprehensive Support and Improvement","dataType":2,"aggregate":0,"showAs":0,"descending":false,"format":"n0","wordWrap":true,"isContentHtml":false},{"binding":"targetedsupport","header":"Additional targeted support and improvement school","dataType":2,"aggregate":0,"showAs":0,"descending":false,"format":"n0","wordWrap":true,"isContentHtml":false},{"binding":"organizationCount","header":"Count","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n0","isContentHtml":false}],"rowFields":{"items":["School","School ID","Comprehensive Support and Improvement"]},"columnFields":{"items":["Additional targeted support school not exiting suc","Additional targeted support and improvement school"]},"filterFields":{"items":[]},"valueFields":{"items":["Count"]}}', NULL)
END

IF NOT EXISTS(SELECT 1 FROM APP.FileSubmissions WHERE GENERATEREPORTID = @generateReportId AND SUBMISSIONYEAR = '2021')
BEGIN
    INSERT INTO APP.FileSubmissions VALUES ('SCH CSI TSI', 109, 3, 2021)
END


IF NOT EXISTS(SELECT 1 FROM APP.FileSubmissions WHERE GENERATEREPORTID = @generateReportId AND SUBMISSIONYEAR = '2022')
BEGIN
    INSERT INTO APP.FileSubmissions VALUES ('SCH CSI TSI', 109, 3, 2022)
END