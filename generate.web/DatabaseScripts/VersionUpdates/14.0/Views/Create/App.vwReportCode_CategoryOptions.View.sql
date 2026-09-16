CREATE VIEW [App].[vwReportCode_CategoryOptions]
AS
SELECT [ReportCode] = agr.ReportCode
	,[FileSubmissionDescription] = afs.FileSubmissionDescription
	,[OrganizationLevelId] = afs.OrganizationLevelId
	,[SubmissionYear] = afs.SubmissionYear
	,[CategorySetCode] = acs.CategorySetCode
	,[CategorySetName] = acs.CategorySetName
	,[EdFactsTableTypeGroupId] = acs.EdFactsTableTypeGroupId
	--,acs.OrganizationLevelId
	--,acs.SubmissionYear
	,[EdFactsTableTypeId] = acs.EdFactsTableTypeId
	--,att.EdFactsTableTypeId
	,[TableTypeAbbrv] = att.TableTypeAbbrv
	,[TableTypeName] = att.TableTypeName
	,[CategoryCode] = ac.CategoryCode
	,[CategoryName] = ac.CategoryName
	,[EdFactsCategoryId] = ac.EdFactsCategoryId
	,[CategoryOptionCode] = aco.CategoryOptionCode
	,[CategoryOptionName] = aco.CategoryOptionName
	,[EdFactsCategoryCodeId] = aco.EdFactsCategoryCodeId
FROM App.GenerateReports agr
INNER JOIN App.FileSubmissions afs ON agr.GenerateReportId = afs.GenerateReportId --OrganizationLevelId,SubmissionYear
INNER JOIN App.CategorySets acs ON agr.GenerateReportId = acs.GenerateReportId --OrganizationLevelId, TableTypeID, SubmissionYear EdFactsTableTypeID, EdFactsTableTypeGroupID
									AND afs.SubmissionYear = acs.SubmissionYear
									AND afs.OrganizationLevelId = acs.OrganizationLevelId
left join app.tabletypes att on acs.TableTypeId = att.TableTypeId
INNER JOIN App.CategorySet_Categories acsc ON acs.CategorySetId = acsc.CategorySetId
INNER JOIN App.Categories ac ON acsc.CategoryId = ac.CategoryId
INNER JOIN App.CategoryOptions aco ON acsc.CategoryId = aco.CategoryId --EdFactsCategoryCodeId
									AND acsc.CategorySetId = aco.CategorySetId
