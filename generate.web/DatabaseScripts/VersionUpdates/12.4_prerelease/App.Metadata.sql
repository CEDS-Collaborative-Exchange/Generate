
Update r set ReportCode = 
    CASE 
        WHEN CHARINDEX('c', ReportCode) = 1 
        THEN STUFF(ReportCode, CHARINDEX('c', ReportCode), 1, '')
        ELSE ReportCode
    END 
FROM app.GenerateReports r
where CHARINDEX('c', ReportCode) = 1 and ReportCode not in ('cohortgraduationrate')

Update r set ReportShortName = 
    CASE 
        WHEN CHARINDEX('c', ReportShortName) = 1 
        THEN STUFF(ReportShortName, CHARINDEX('c', ReportShortName), 1, '')
        ELSE ReportShortName
    END 
FROM app.GenerateReports r
where CHARINDEX('c', ReportShortName) = 1 and ReportCode not in ('cohortgraduationrate')
