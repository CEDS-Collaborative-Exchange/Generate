SET NOCOUNT ON;

EXEC App.Rollover_Previous_Year_Metadata 'c129' , 2022, 2023
EXEC App.Rollover_Previous_Year_Metadata 'c130' , 2022, 2023
EXEC App.Rollover_Previous_Year_Metadata 'c190' , 2022, 2023
EXEC App.Rollover_Previous_Year_Metadata 'c197' , 2022, 2023
EXEC App.Rollover_Previous_Year_Metadata 'c198' , 2022, 2023
EXEC App.Rollover_Previous_Year_Metadata 'c207' , 2022, 2023
EXEC App.Rollover_Previous_Year_Metadata 'c211' , 2022, 2023

EXEC App.Rollover_Previous_Year_Metadata 'c035' , 2019, 2020
EXEC App.Rollover_Previous_Year_Metadata 'c035' , 2020, 2021
EXEC App.Rollover_Previous_Year_Metadata 'c035' , 2021, 2022



-- Delete all 2024 metadata
delete co
from app.CategorySets cs 
inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
inner join app.Categories c on csc.CategoryId = c.CategoryId
inner join app.CategoryOptions co on cs.CategorySetId = co.CategorySetId and co.CategoryId = c.CategoryId
where SubmissionYear = 2024

delete csc
from app.CategorySets cs 
inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
inner join app.Categories c on csc.CategoryId = c.CategoryId
where SubmissionYear = 2024

delete from app.CategorySets where SubmissionYear = 2024

delete fsfc
from app.FileSubmission_FileColumns fsfc
inner join app.FileSubmissions fs on fs.FileSubmissionId = fsfc.FileSubmissionId
where fs.SubmissionYear = '2024'

delete from app.FileSubmissions where SubmissionYear = '2024'

DECLARE @reportCode VARCHAR(5)

DECLARE csy CURSOR FOR
        SELECT distinct agr.ReportCode
        FROM App.FileSubmissions fs
		JOIN App.GenerateReports agr
			ON fs.GenerateReportId = agr.GenerateReportId
        WHERE SubmissionYear = 2023
            AND ReportCode IN (
                 'c002','c029','c005','c006','c007','c070'
                ,'c086','c088','c099','c112','c143','c144'
                ,'c033','c035','c039','c045'
				,'c050','c052','c054','c059'
				,'c067','c089','c116','c118'
				,'c121','c126','c129'
				,'c130','c137','c138','c139'
				,'c141','c145','c165'
				,'c170','c175','c178','c179'
				,'c185','c188','c189'
				,'c190','c194','c195','c196','c197','c198'
				,'c203','c207','c210','c211'
            )
        ORDER BY agr.ReportCode

    SET @reportCode = NULL
    OPEN csy
    FETCH NEXT FROM csy INTO @reportCode

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC App.Rollover_Previous_Year_Metadata @reportCode , 2023, 2024
    
        FETCH NEXT FROM csy INTO @reportCode
    END

    CLOSE csy
    DEALLOCATE csy