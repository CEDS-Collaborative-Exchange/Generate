SET NOCOUNT ON;

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

INSERT INTO APP.CategorySets VALUES ('CSA', 'Category Set A', NULL, 0, NULL, 39, NULL, 1, 2024, NULL, '{"showColumnTotals":0,"showRowTotals":0,"defaultFilterType":3,"fields":[{"binding":"organizationIdentifierSea","header":"SEA ID","dataType":1,"aggregate":1,"showAs":0,"descending":false,"format":"D","isContentHtml":false},{"binding":"organizationName","header":"SEA","dataType":1,"aggregate":0,"showAs":0,"descending":false,"format":"","width":250,"wordWrap":true,"isContentHtml":false},{"binding":"organizationCount","header":"Count","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n0","isContentHtml":false}],"rowFields":{"items":["SEA","SEA ID"]},"columnFields":{"items":[]},"filterFields":{"items":[]},"valueFields":{"items":["Count"]}}', NULL)
INSERT INTO APP.CategorySets VALUES ('CSA', 'Category Set A', NULL, 0, NULL, 39, NULL, 2, 2024, NULL, '{"showColumnTotals":0,"showRowTotals":0,"defaultFilterType":3,"fields":[{"binding":"organizationIdentifierSea","header":"LEA ID","dataType":1,"aggregate":1,"showAs":0,"descending":false,"format":"D","isContentHtml":false},{"binding":"organizationName","header":"LEA","dataType":1,"aggregate":0,"showAs":0,"descending":false,"format":"","width":250,"wordWrap":true,"isContentHtml":false},{"binding":"organizationCount","header":"Count","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n0","isContentHtml":false}],"rowFields":{"items":["LEA","LEA ID"]},"columnFields":{"items":[]},"filterFields":{"items":[]},"valueFields":{"items":["Count"]}}', NULL)
INSERT INTO APP.CategorySets VALUES ('CSA', 'Category Set A', NULL, 0, NULL, 39, NULL, 3, 2024, NULL, '{"showColumnTotals":0,"showRowTotals":0,"defaultFilterType":3,"fields":[{"binding":"organizationIdentifierSea","header":"School ID","dataType":1,"aggregate":2,"showAs":0,"descending":false,"format":"D","isContentHtml":false},{"binding":"organizationName","header":"School","dataType":1,"aggregate":0,"showAs":0,"descending":false,"format":"","width":250,"wordWrap":true,"isContentHtml":false},{"binding":"organizationCount","header":"Count","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n0","isContentHtml":false}],"rowFields":{"items":["School","School ID"]},"columnFields":{"items":[]},"filterFields":{"items":[]},"valueFields":{"items":["Count"]}}', NULL)
INSERT INTO APP.FileSubmissions VALUES ('LEA DIRECTORY INFO', 39, 2, 2024)
INSERT INTO APP.FileSubmissions VALUES ('SCHOOL DIRECTORY INFO', 39, 3, 2024)
INSERT INTO APP.FileSubmissions VALUES ('SEA DIRECTORY INFO', 39, 1, 2024)
INSERT INTO APP.CategorySets VALUES ('CSA', 'Category Set A', NULL, 0, NULL, 44, NULL, 2, 2024, NULL, '{"showColumnTotals":0,"showRowTotals":0,"defaultFilterType":3,"fields":[{"binding":"organizationIdentifierSea","header":"LEA ID","dataType":1,"aggregate":1,"showAs":0,"descending":false,"format":"D","isContentHtml":false},{"binding":"organizationName","header":"LEA","dataType":1,"aggregate":0,"showAs":0,"descending":false,"format":"","width":250,"wordWrap":true,"isContentHtml":false},{"binding":"organizationCount","header":"Count","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n0","isContentHtml":false}],"rowFields":{"items":["LEA","LEA ID"]},"columnFields":{"items":[]},"filterFields":{"items":[]},"valueFields":{"items":["Count"]}}', NULL)
INSERT INTO APP.CategorySets VALUES ('CSA', 'Category Set A', NULL, 0, NULL, 44, NULL, 3, 2024, NULL, '{"showColumnTotals":0,"showRowTotals":0,"defaultFilterType":3,"fields":[{"binding":"organizationIdentifierSea","header":"School ID","dataType":1,"aggregate":2,"showAs":0,"descending":false,"format":"D","isContentHtml":false},{"binding":"organizationName","header":"School","dataType":1,"aggregate":0,"showAs":0,"descending":false,"format":"","width":250,"wordWrap":true,"isContentHtml":false},{"binding":"organizationCount","header":"Count","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n0","isContentHtml":false}],"rowFields":{"items":["School","School ID"]},"columnFields":{"items":[]},"filterFields":{"items":[]},"valueFields":{"items":["Count"]}}', NULL)
INSERT INTO APP.FileSubmissions VALUES ('LEA GRADES OFFERED', 44, 2, 2024)
INSERT INTO APP.FileSubmissions VALUES ('SCHOOL GRADES OFFERED', 44, 3, 2024)
INSERT INTO APP.CategorySets VALUES ('CSA', 'Category Set A', NULL, 0, NULL, 78, NULL, 2, 2024, NULL, '{"showColumnTotals":0,"showRowTotals":0,"defaultFilterType":3,"fields":[{"binding":"organizationIdentifierSea","header":"LEA ID","dataType":1,"aggregate":1,"showAs":0,"descending":false,"format":"D","isContentHtml":false},{"binding":"organizationName","header":"LEA","dataType":1,"aggregate":0,"showAs":0,"descending":false,"format":"","width":250,"wordWrap":true,"isContentHtml":false},{"binding":"organizationCount","header":"Count","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n0","isContentHtml":false}],"rowFields":{"items":["LEA","LEA ID"]},"columnFields":{"items":[]},"filterFields":{"items":[]},"valueFields":{"items":["Count"]}}', NULL)
INSERT INTO APP.CategorySets VALUES ('CSA', 'Category Set A', NULL, 0, NULL, 78, NULL, 3, 2024, NULL, '{"showColumnTotals":0,"showRowTotals":0,"defaultFilterType":3,"fields":[{"binding":"organizationIdentifierSea","header":"School ID","dataType":1,"aggregate":2,"showAs":0,"descending":false,"format":"D","isContentHtml":false},{"binding":"organizationName","header":"School","dataType":1,"aggregate":0,"showAs":0,"descending":false,"format":"","width":250,"wordWrap":true,"isContentHtml":false},{"binding":"organizationCount","header":"Count","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n0","isContentHtml":false}],"rowFields":{"items":["School","School ID"]},"columnFields":{"items":[]},"filterFields":{"items":[]},"valueFields":{"items":["Count"]}}', NULL)
INSERT INTO APP.FileSubmissions VALUES ('LEA DISCIPLINE DATA', 78, 2, 2024)
INSERT INTO APP.FileSubmissions VALUES ('SCHOOL DISCIPLINE DATA', 78, 3, 2024)
INSERT INTO APP.CategorySets VALUES ('CSA', 'Category Set A', NULL, 0, NULL, 96, NULL, 1112, 2024, NULL, '{"showColumnTotals":0,"showRowTotals":0,"defaultFilterType":3,"fields":[{"binding":"organizationCount","header":"Count","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n0","isContentHtml":false}],"rowFields":{"items":[]},]},"columnFields":{"items":[]},"filterFields":{"items":[]},"valueFields":{"items":["Count"]}}', NULL)
INSERT INTO APP.FileSubmissions VALUES ('SEA CHARTER AUTHORIZER', 96, 1112, 2024)
INSERT INTO APP.CategorySets VALUES ('CSA', 'Category Set A', NULL, 0, NULL, 97, NULL, 1182, 2024, NULL, '{"showColumnTotals":0,"showRowTotals":0,"defaultFilterType":3,"fields":[{"binding":"organizationCount","header":"Count","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n0","isContentHtml":false}],"rowFields":{"items":[]},]},"columnFields":{"items":[]},"filterFields":{"items":[]},"valueFields":{"items":["Count"]}}', NULL)
INSERT INTO APP.FileSubmissions VALUES ('CHARTER MANAGE ORG', 97, 1182, 2024)
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (1, 'CarriageReturn/LineFeed', NULL, 'Carriage Return / Line Feed (CRLF)', '', 'Control Character', 301, 1, 11, 301, 2024, 3, 'c197')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (10, 'FileRecordNumber', NULL, 'File Record Number', '', 'Number', 10, 1, 1, 1, 2024, 3, 'c197')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (14, 'StateLEAIDNumber', NULL, 'LEA Identifier (State)', 'STATELEAIDNUMBER', 'String', 28, 1, 4, 15, 2024, 3, 'c197')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (2, 'FIPSStateCode', NULL, 'State Code', 'FIPSSTATECODE', 'String', 12, 1, 2, 11, 2024, 3, 'c197')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (2, 'StateAgencyNumber', NULL, 'State Agency Number', 'STATEAGENCYNUMBER', 'String', 14, 1, 3, 13, 2024, 3, 'c197')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (20, 'ManagementOrganizationEIN', NULL, 'Management organization EIN ', 'CHARTMANORGEIN', 'String', 80, 1, 8, 61, 2024, 3, 'c197')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (20, 'ManagementOrgEINUpdated', NULL, 'Management organization EIN updated  ', 'CHARTMANORGEINUPD', 'String', 100, 0, 9, 81, 2024, 3, 'c197')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (20, 'StateSchoolIDNumber', NULL, 'School Identifier (State)', 'STATESCHOOLIDNUMBER', 'String', 55, 1, 6, 36, 2024, 3, 'c197')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (200, 'Explanation', NULL, 'Explanation', 'EXPLANATION', 'String', 300, 0, 10, 101, 2024, 3, 'c197')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (5, 'NCESSchoolNumber', NULL, 'School Identifier (NCES)', 'NCESSCHOOLNUMBER', 'String', 60, 1, 7, 56, 2024, 3, 'c197')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (7, 'NCESLEAIDNumber', NULL, 'LEA Identifier (NCES)', 'DISTRICTNCESID', 'String', 35, 1, 5, 29, 2024, 3, 'c197')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (1, 'CarriageReturn/LineFeed', NULL, '', '', 'Control Character', 289, 1, 10, 289, 2024, 3, 'c198')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (10, 'CharterContractApprovalDate', NULL, 'Charter Contract Approval Date', 'CHARCONTAPPROVALDATE', 'String', 78, 1, 7, 69, 2024, 3, 'c198')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (10, 'CharterContractRenewalDate', NULL, 'Charter Contract Renewal Date', 'CHARCONTRENEWALDATE', 'String', 88, 1, 8, 79, 2024, 3, 'c198')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (10, 'FileRecordNumber', NULL, '', '', 'Number', 10, 1, 1, 1, 2024, 3, 'c198')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (14, 'StateLEAIDNumber', NULL, 'State LEA Identifier', 'STATELEAIDNUMBER', 'String', 28, 1, 4, 15, 2024, 3, 'c198')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (2, 'FIPSStateCode', NULL, 'State Code', 'FIPSSTATECODE', 'String', 12, 1, 2, 11, 2024, 3, 'c198')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (2, 'StateAgencyNumber', NULL, 'State Agency Number', 'STATEAGENCYIDNUMBER', 'String', 14, 1, 3, 13, 2024, 3, 'c198')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (20, 'CharterContractIDNumber', NULL, 'Charter Contract ID Number', 'CHARCONTRACTID', 'String', 68, 1, 6, 49, 2024, 3, 'c198')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (20, 'StateSchoolIDNumber', NULL, 'State School Identifier', 'STATESCHIDNUMBER', 'String', 48, 1, 5, 29, 2024, 3, 'c198')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (200, 'Explanation', NULL, 'Explanation', 'EXPLANATION', 'String', 288, 0, 9, 89, 2024, 3, 'c198')
INSERT INTO APP.CategorySets VALUES ('CategorySetA', 'Category Set A', NULL, 0, NULL, 109, NULL, 3, 2024, NULL, '{"showColumnTotals":0,"showRowTotals":0,"defaultFilterType":3,"fields":[{"binding":"organizationIdentifierSea","header":"School ID","dataType":1,"aggregate":2,"showAs":0,"descending":false,"format":"D","isContentHtml":false},{"binding":"organizationName","header":"School","dataType":1,"aggregate":0,"showAs":0,"descending":false,"format":"","width":250,"wordWrap":true,"isContentHtml":false},{"binding":"organizationCount","header":"Count","dataType":2,"aggregate":1,"showAs":0,"descending":false,"format":"n0","isContentHtml":false}],"rowFields":{"items":["School","School ID"]},"columnFields":{"items":[]},"filterFields":{"items":[]},"valueFields":{"items":["Count"]}}', NULL)
INSERT INTO APP.FileSubmissions VALUES ('SCH CSI TSI', 109, 3, 2024)
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (1, 'CarriageReturn/LineFeed', NULL, '', '', 'Control Character', 264, 1, 8, 264, 2024, 3, 'c207')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (10, 'FileRecordNumber', NULL, 'File Record Number', '', 'Number', 10, 1, 1, 1, 2024, 3, 'c207')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (14, 'StateLEAIDNumber', NULL, 'LEA Identifier (State)', 'STATELEAIDNUMBER', 'String', 28, 1, 4, 15, 2024, 3, 'c207')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (15, 'SteAprptnMthdsID', NULL, 'State Appropriation Methods', 'STEAPRPTNMTHDS', 'String', 63, 1, 6, 49, 2024, 3, 'c207')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (2, 'FIPSStateCode', NULL, 'State Code', 'FIPSSTATECODE', 'String', 12, 1, 2, 11, 2024, 3, 'c207')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (2, 'StateAgencyNumber', NULL, 'State Agency Number', 'STATEAGENCYNUMBER', 'String', 14, 1, 3, 13, 2024, 3, 'c207')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (20, 'StateSchoolIDNumber', NULL, 'School Identifier (State)', 'STATESCHOOLIDNUMBER', 'String', 48, 1, 5, 29, 2024, 3, 'c207')
INSERT INTO [App].[vwReportCode_FileColumns] VALUES (200, 'Explanation', NULL, 'Explanation', 'EXPLANATION', 'String', 263, 0, 7, 64, 2024, 3, 'c207')

DECLARE @reportCode VARCHAR(5)

DECLARE csy CURSOR FOR
        SELECT distinct agr.ReportCode
        FROM App.FileSubmissions fs
		JOIN App.GenerateReports agr
			ON fs.GenerateReportId = agr.GenerateReportId
        WHERE SubmissionYear = 2023
            AND ReportCode NOT IN (
                 'c029'
                ,'c039'
                ,'c197'
                ,'c198'
                ,'c207'
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