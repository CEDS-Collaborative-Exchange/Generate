Update app.FileColumns set ReportColumn = 'StateANSICode' Where ColumnName = 'FIPSStateCode'
Update app.FileColumns set ReportColumn = 'OrganizationName' Where ColumnName IN ('StateAgencyName', 'LEAName', 'SchoolName')
Update app.FileColumns set ReportColumn = 'STATEPOVERTYDESIGNATION' Where ColumnName = 'PovertyQuart'
Update app.FileColumns set ReportColumn = 'Website' Where ColumnName like '%webaddress'
Update app.FileColumns set ReportColumn = 'Telephone' Where ColumnName like '%phonenumber'
Update app.FileColumns set ReportColumn = 'MailingAddressStreet' Where ColumnName = 'MailingAddress1'
Update app.FileColumns set ReportColumn = 'MailingAddressApartmentRoomOrSuiteNumber' Where ColumnName = 'MailingAddress2'
Update app.FileColumns set ReportColumn = 'MailingCity' Where ColumnName = 'MailingAddressCity'
Update app.FileColumns set ReportColumn = 'MailingPostalStateCode' Where ColumnName = 'MailingAddressState'
Update app.FileColumns set ReportColumn = 'MailingZipcode' Where ColumnName = 'MailingAddressPostalCode'
Update app.FileColumns set ReportColumn = 'MailingZipcodePlus4' Where ColumnName = 'MailingAddressPostalCode2'
Update app.FileColumns set ReportColumn = 'PhysicalAddressStreet' Where ColumnName = 'LocationAddress1'
Update app.FileColumns set ReportColumn = 'PhysicalAddressApartmentRoomOrSuiteNumber' Where ColumnName = 'LocationAddress2'
Update app.FileColumns set ReportColumn = 'PhysicalAddressCity' Where ColumnName = 'LocationCity'
Update app.FileColumns set ReportColumn = 'PhysicalAddressState' Where ColumnName = 'LocationPostalStateCode'
Update app.FileColumns set ReportColumn = 'PhysicalAddressPostalCode' Where ColumnName = 'LocationZipcode'
Update app.FileColumns set ReportColumn = 'PhysicalAddressPostalCode2' Where ColumnName = 'LocationZipcodePlus4'

Update fc set fc.ReportColumn = 'ParentOrganizationStateId'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where Organizationlevelid = 3 and fc.ColumnName = 'StateLEAIDNumber' and f.FactReportTableName like '%Organization%'

Update fc set fc.ReportColumn = 'ParentOrganizationIdentifierSea'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where Organizationlevelid = 3 and fc.ColumnName = 'StateLEAIDNumber' and f.FactReportTableName not like '%Organization%'

Update fc set fc.ReportColumn = 'OrganizationStateId'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where Organizationlevelid <> 3 and fc.ColumnName = 'StateLEAIDNumber' and f.FactReportTableName like '%Organization%'

Update fc set fc.ReportColumn = 'OrganizationIdentifierSea'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where Organizationlevelid <> 3 and fc.ColumnName = 'StateLEAIDNumber' and f.FactReportTableName not like '%Organization%'

Update fc set fc.ReportColumn = 'ParentOrganizationNcesId'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where Organizationlevelid = 3 and fc.ColumnName = 'NCESLEAIDNumber' and f.FactReportTableName like '%Organization%'

Update fc set fc.ReportColumn = 'ParentOrganizationIdentifierNces'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where Organizationlevelid = 3 and fc.ColumnName = 'NCESLEAIDNumber' and f.FactReportTableName not like '%Organization%'


Update fc set fc.ReportColumn = 'OrganizationNcesId'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where Organizationlevelid <> 3 and fc.ColumnName = 'NCESLEAIDNumber' and f.FactReportTableName like '%Organization%'

Update fc set fc.ReportColumn = 'OrganizationIdentifierNces'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where Organizationlevelid <> 3 and fc.ColumnName = 'NCESLEAIDNumber' and f.FactReportTableName not like '%Organization%'

Update fc set fc.ReportColumn = 'OrganizationNcesId'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where fc.ColumnName = 'NCESSchoolIDNumber' and f.FactReportTableName like '%Organization%'

Update fc set fc.ReportColumn = 'OrganizationIdentifierNces'
from app.FileSubmissions fs
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
inner join app.FactTables f on r.FactTableId = f.FactTableId
where fc.ColumnName = 'NCESSchoolIDNumber' and f.FactReportTableName not like '%Organization%'

