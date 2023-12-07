/*  This script must be run from 192.168.51.53 */

DECLARE @GenerateReport VARCHAR(5)
DECLARE @SubmissionYear SMALLINT = 2023

CREATE TABLE #fileSpecs
(
	fileSpec nvarchar(10)
)

CREATE TABLE #metadata
(
	  fileSpec nvarchar(5)
	, dataType nvarchar(10)
	, insertScript nvarchar(MAX)
)

insert into #fileSpecs (fileSpec) values ('c002')
insert into #fileSpecs (fileSpec) values ('c005')
insert into #fileSpecs (fileSpec) values ('c006')
insert into #fileSpecs (fileSpec) values ('c007')
insert into #fileSpecs (fileSpec) values ('c009')
insert into #fileSpecs (fileSpec) values ('c029')
insert into #fileSpecs (fileSpec) values ('c032')
insert into #fileSpecs (fileSpec) values ('c033')
insert into #fileSpecs (fileSpec) values ('c035')
insert into #fileSpecs (fileSpec) values ('c037')
insert into #fileSpecs (fileSpec) values ('c039')
insert into #fileSpecs (fileSpec) values ('c040')
insert into #fileSpecs (fileSpec) values ('c045')
insert into #fileSpecs (fileSpec) values ('c050')
insert into #fileSpecs (fileSpec) values ('c052')
insert into #fileSpecs (fileSpec) values ('c059')
insert into #fileSpecs (fileSpec) values ('c067')
insert into #fileSpecs (fileSpec) values ('c070')
insert into #fileSpecs (fileSpec) values ('c086')
insert into #fileSpecs (fileSpec) values ('c088')
insert into #fileSpecs (fileSpec) values ('c089')
insert into #fileSpecs (fileSpec) values ('c099')
insert into #fileSpecs (fileSpec) values ('c112')
insert into #fileSpecs (fileSpec) values ('c118')
insert into #fileSpecs (fileSpec) values ('c126')
insert into #fileSpecs (fileSpec) values ('c129')
insert into #fileSpecs (fileSpec) values ('c130')
insert into #fileSpecs (fileSpec) values ('c137')
insert into #fileSpecs (fileSpec) values ('c138')
insert into #fileSpecs (fileSpec) values ('c141')
insert into #fileSpecs (fileSpec) values ('c143')
insert into #fileSpecs (fileSpec) values ('c144')
insert into #fileSpecs (fileSpec) values ('c163')
insert into #fileSpecs (fileSpec) values ('c175')
insert into #fileSpecs (fileSpec) values ('c178')
insert into #fileSpecs (fileSpec) values ('c179')
insert into #fileSpecs (fileSpec) values ('c185')
insert into #fileSpecs (fileSpec) values ('c188')
insert into #fileSpecs (fileSpec) values ('c189')
insert into #fileSpecs (fileSpec) values ('c190')
insert into #fileSpecs (fileSpec) values ('c194')
insert into #fileSpecs (fileSpec) values ('c196')
insert into #fileSpecs (fileSpec) values ('c197')
insert into #fileSpecs (fileSpec) values ('c198')
insert into #fileSpecs (fileSpec) values ('c203')
insert into #fileSpecs (fileSpec) values ('c206')
insert into #fileSpecs (fileSpec) values ('c207')
insert into #fileSpecs (fileSpec) values ('c210')
insert into #fileSpecs (fileSpec) values ('c211')
insert into #fileSpecs (fileSpec) values ('c212')



DECLARE report_cursor CURSOR FOR 
select fileSpec from #fileSpecs 
order by fileSpec

OPEN report_cursor
FETCH NEXT FROM report_cursor INTO @GenerateReport 

WHILE @@FETCH_STATUS = 0
BEGIN
	print @GenerateReport

	IF(@GenerateReport IN ('C029', 'C039', 'C190', 'C196', 'C163', 'C206')) BEGIN

		INSERT INTO #metadata
		SELECT DISTINCT @GenerateReport, 'Options', 'INSERT INTO APP.CategorySets VALUES (''' + ISNULL(ACS.CATEGORYSETCODE, 'NULL') + ''', ''' + ISNULL(ACS.CATEGORYSETNAME, 'NULL') + ''', ' + ISNULL(CAST(ACS.CATEGORYSETSEQUENCE AS VARCHAR), 'NULL') + ', ' + ISNULL(CAST(ACS.EDFACTSTABLETYPEGROUPID AS VARCHAR), 'NULL') + ', ' + ISNULL(CAST(ACS.EXCLUDEONFILTER AS VARCHAR), 'NULL') + ', ' + ISNULL(CAST(ACS.GENERATEREPORTID AS VARCHAR), 'NULL') + ', ' + ISNULL(CAST(ACS.INCLUDEONFILTER AS VARCHAR), 'NULL') + ', ' + ISNULL(CAST(ACS.ORGANIZATIONLEVELID AS VARCHAR), 'NULL') + ', ' + CAST(@SubmissionYear AS VARCHAR) + ', ' + ISNULL(CAST(ACS.TABLETYPEID AS VARCHAR), 'NULL') + ', ''' + ISNULL(ACS.VIEWDEFINITION, 'NULL') + ''', ' + ISNULL(CAST(ACS.EDFACTSTABLETYPEID AS VARCHAR), 'NULL') + ')'
		FROM APP.GENERATEREPORTS AGR
		JOIN APP.CATEGORYSETS ACS
			ON AGR.GENERATEREPORTID = ACS.GENERATEREPORTID
		JOIN APP.FILESUBMISSIONS AFS
			ON AGR.GENERATEREPORTID = AFS.GENERATEREPORTID
			AND ACS.SUBMISSIONYEAR = AFS.SUBMISSIONYEAR
		LEFT JOIN APP.CATEGORYSET_CATEGORIES ACSC
			ON ACS.CATEGORYSETID = ACSC.CATEGORYSETID
		LEFT JOIN APP.CATEGORIES AC
			ON ACSC.CATEGORYID = AC.CATEGORYID
		LEFT JOIN APP.CATEGORYOPTIONS ACO
			ON AC.CATEGORYID = ACO.CATEGORYOPTIONID
		WHERE AGR.REPORTCODE = @GenerateReport
			AND ACS.SUBMISSIONYEAR = @SubmissionYear - 1

		INSERT INTO #metadata
		SELECT DISTINCT @GenerateReport, 'Options', 'INSERT INTO APP.FileSubmissions VALUES (''' + ISNULL(AFS.FILESUBMISSIONDESCRIPTION, 'NULL') + ''', ' + ISNULL(CAST(AFS.GENERATEREPORTID AS VARCHAR), 'NULL') + ', ' + ISNULL(CAST(AFS.ORGANIZATIONLEVELID AS VARCHAR), 'NULL') + ', ' + CAST(@SubmissionYear AS VARCHAR) + ')' 
		FROM APP.GENERATEREPORTS AGR
		JOIN APP.CATEGORYSETS ACS
			ON AGR.GENERATEREPORTID = ACS.GENERATEREPORTID
		JOIN APP.FILESUBMISSIONS AFS
			ON AGR.GENERATEREPORTID = AFS.GENERATEREPORTID
			AND ACS.SUBMISSIONYEAR = AFS.SUBMISSIONYEAR
		LEFT JOIN APP.CATEGORYSET_CATEGORIES ACSC
			ON ACS.CATEGORYSETID = ACSC.CATEGORYSETID
		LEFT JOIN APP.CATEGORIES AC
			ON ACSC.CATEGORYID = AC.CATEGORYID
		LEFT JOIN APP.CATEGORYOPTIONS ACO
			ON AC.CATEGORYID = ACO.CATEGORYOPTIONID
		WHERE AGR.REPORTCODE = @GenerateReport
			AND ACS.SUBMISSIONYEAR = @SubmissionYear - 1

	END ELSE BEGIN

		EXEC [EDENDB_dbo_Generate_ExportMetadata_OneFile] @GenerateReport, @SubmissionYear		

		INSERT INTO #metadata
		SELECT @GenerateReport, 'Options', 'INSERT INTO [App].[vwReportCode_CategoryOptions] VALUES (''' + ReportCode + ''', ''' + FileSubmissionDescription + ''', ' + OrganizationLevelId + ', ' + SubmissionYear + ', ''' + REPLACE(CategorySetCode, 'EUT', 'TOT') + ''', ''' + REPLACE(CategorySetName, 'Education Unit Total', 'Total of the Education Unit') + ''', ' + EdFactsTableTypeGroupId + ', ' + EdFactsTableTypeId + ', ''' + TableTypeAbbrv + ''', ''' + TableTypeName + ''', ''' + CategoryCode + ''', ''' + CategoryName + ''', ' + EdFactsCategoryId + ', ''' + CategoryOptionCode + ''', ''' + CategoryOptionName + ''', ' + EdFactsCategoryCodeId + ')'
		FROM [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.GenerateOptions g
		WHERE g.SubmissionYear = @SubmissionYear
			AND g.ReportCode = @GenerateReport
	END 

	INSERT INTO #metadata
	SELECT @GenerateReport, 'Columns', 'INSERT INTO [App].[vwReportCode_FileColumns] VALUES (' + ISNULL(ColumnLength, 'NULL') + ', ''' + ISNULL(ColumnName, 'NULL') + ''', NULL, ''' + ISNULL(DisplayName, 'NULL') + ''', ''' + ISNULL(XMLElementName, 'NULL') + ''', ''' + ISNULL(DataType, 'NULL') + ''', ' + ISNULL(EndPosition,'NULL') + ', ' + ISNULL(IsOptional, 'NULL') + ', ' + ISNULL(SequenceNumber, 'NULL') + ', ' + ISNULL(StartPosition, 'NULL') + ', ' + ISNULL(SubmissionYear, 'NULL') + ', ' + ISNULL(OrganizationLevelId, 'NULL') + ', ''' +  ISNULL(ReportCode, 'NULL') + ''')'
	FROM [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.GenerateColumns g
	WHERE g.SubmissionYear = @SubmissionYear
		AND g.ReportCode = @GenerateReport


	FETCH NEXT FROM report_cursor INTO @GenerateReport
END

CLOSE report_cursor
DEALLOCATE report_cursor


INSERT INTO #metadata SELECT fileSpec, dataType, REPLACE(insertScript, '*', '1') FROM #metadata WHERE insertScript LIKE '%*%'
INSERT INTO #metadata SELECT fileSpec, dataType, REPLACE(insertScript, '*', '2') FROM #metadata WHERE insertScript LIKE '%*%'
INSERT INTO #metadata SELECT fileSpec, dataType, REPLACE(insertScript, '*', '3') FROM #metadata WHERE insertScript LIKE '%*%'
DELETE FROM #metadata WHERE insertScript LIKE '%*%'

SELECT * FROM #metadata ORDER BY fileSpec, dataType DESC, insertScript

DROP TABLE #fileSpecs
DROP TABLE #metadata
