using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.core.Models.App;
using generate.core.Interfaces.Services;
using System.Linq.Expressions;
using generate.core.Models.IDS;
using System.Threading.Tasks;
using Microsoft.Extensions.PlatformAbstractions;
using generate.core.ViewModels.App;
using generate.core.Dtos.App;
using System.Text;
using generate.shared.Utilities;
using generate.core.Interfaces.Repositories.App;

namespace generate.infrastructure.Services
{
    public class FileSubmissionService: IFileSubmissionService
    {
        private readonly IAppRepository _appRepository;
        
        public FileSubmissionService(
            IAppRepository appRepository
            ) 
        {
            _appRepository = appRepository;
        }

        public string GetFileDescription(string reportTypeCode, string reportCode, string reportLevel, string reportYear)
        {

            GenerateReport report = _appRepository.Find<GenerateReport>(r => r.GenerateReportType.ReportTypeCode == reportTypeCode
             && r.ReportCode == reportCode
             && r.GenerateReport_OrganizationLevels.Count(l => l.OrganizationLevel.LevelCode == reportLevel) == 1, 0, 1)
             .FirstOrDefault();

            OrganizationLevel level = _appRepository.Find<OrganizationLevel>(f => f.LevelCode == reportLevel).FirstOrDefault();

            return _appRepository.Find<FileSubmission>(f => f.GenerateReportId == report.GenerateReportId
                                                                && f.OrganizationLevelId == level.OrganizationLevelId
                                                                && f.SubmissionYear == reportYear, 0, 1).FirstOrDefault().FileSubmissionDescription;

        }

       public FileSubmission GetFileSubmission(string reportTypeCode, string reportCode, string reportLevel, string reportYear)
        {
            List<FileSubmissionColumnDto> results = new List<FileSubmissionColumnDto>();

            GenerateReport report = _appRepository.Find<GenerateReport>(r => r.GenerateReportType.ReportTypeCode == reportTypeCode
              && r.ReportCode == reportCode
              && r.GenerateReport_OrganizationLevels.Count(l => l.OrganizationLevel.LevelCode == reportLevel) == 1, 0, 1)
              .FirstOrDefault();

            if (report == null)
            {
                return null;
            }

            OrganizationLevel level = _appRepository.Find<OrganizationLevel>(f => f.LevelCode == reportLevel).FirstOrDefault();

            FileSubmission fileRecord = _appRepository.Find<FileSubmission>(f => f.GenerateReportId == report.GenerateReportId
                                                                && f.OrganizationLevelId == level.OrganizationLevelId
                                                                && f.SubmissionYear == reportYear, 0, 1, s => s.FileSubmission_FileColumns).FirstOrDefault();

            return fileRecord;
        }

        public List<FileSubmissionColumnDto> GetFileSubmissionColumns(FileSubmission submission)
        {
            List<FileSubmissionColumnDto> results = new List<FileSubmissionColumnDto>();

            foreach (FileSubmission_FileColumn fileColumn in submission.FileSubmission_FileColumns.OrderBy(x => x.SequenceNumber))
            {

                FileColumn column = _appRepository.Find<FileColumn>(c => c.FileColumnId == fileColumn.FileColumnId, 0, 1, c => c.Dimension).FirstOrDefault();

                FileSubmissionColumnDto columnDto = new FileSubmissionColumnDto()
                {
                    FileColumnId = fileColumn.FileColumnId,
                    ColumnName = column.ColumnName,
                    ColumnLength = column.ColumnLength,
                    DataType = column.DataType,
                    DisplayName = column.DisplayName,
                    XMLElementName = column.XMLElementName,
                    SequenceNumber = fileColumn.SequenceNumber,
                    StartPosition = fileColumn.StartPosition,
                    EndPosition = fileColumn.EndPosition,
                    IsOptional = fileColumn.IsOptional

                };
                if (column.Dimension != null)
                {
                    if (column.Dimension.DimensionFieldName != null)
                    {
                        columnDto.ReportField = column.Dimension.DimensionFieldName.ToUpper();
                    }
                }

                if (column.DataType.ToLower() != "control character")
                {
                    results.Add(columnDto);
                }

            }

            return results;

        }

       public string GetSubmissionRow(List<string> rowData ,string fileFormatType, List<FileSubmissionColumnDto> columns)
        {
            string row = string.Empty;
            switch (fileFormatType)
            {
                case "csv":
                    row = string.Join(",", rowData);
                    break;
                case "tab":
                    row = string.Join("\t", rowData);
                    break;
                case "txt":
                    row = GetFixedWidthRow(rowData, columns);
                    break;
                default:
                    throw new Exception("File Type not supported");
            }

            return row;
        }

        public string GetFileHeader(string reportTypeCode, string reportCode, string reportLevel, string reportYear, string fileFormatType, string fileName, int totalCount)
        {
            List<string> headerData = new List<string>();
            string fileDescription = GetFileDescription(reportTypeCode, reportCode, reportLevel, reportYear);
            string fileIdentifier = reportCode + "-" + DateTime.Now.ToString("MMddyyyy") + "-" + DateTime.Now.ToString("HHmm", System.Globalization.DateTimeFormatInfo.InvariantInfo);

            int submissionYear = Convert.ToInt32(reportYear);
            string reportingPeriod = (submissionYear - 1).ToString() + "-" + submissionYear.ToString();

            headerData.Add(fileDescription);
            headerData.Add(totalCount.ToString());
            headerData.Add(fileName);
            headerData.Add(fileIdentifier);
            headerData.Add(reportingPeriod);

            FileSubmission fileRecord = _appRepository.Find<FileSubmission>(f => f.FileSubmissionDescription == "HEADER"
                                                               , 0, 1, s => s.FileSubmission_FileColumns).FirstOrDefault();

            List<FileSubmissionColumnDto> headerColumns = GetFileSubmissionColumns(fileRecord); 

            return GetSubmissionRow(headerData, fileFormatType, headerColumns);
        }

        public string GetContentType(string fileFormatType) {

            string contentType = string.Empty;

            switch (fileFormatType)
            {
                case "csv":
                    contentType = "text/csv";
                    break;
                case "txt":
                    contentType = "text/csv";
                    break;
                case "tab":
                    contentType = "text/csv";
                    break;
                default:
                    throw new Exception("File Type not supported");
            }

            return contentType;
        }

        public string GetFixedWidthRow(List<string> rowData, List<FileSubmissionColumnDto> columns)
        {
            StringBuilder fixedWidthRecord = new StringBuilder();
            int i = 0;
            columns.ForEach(s => {
                if(i < rowData.Count) //"columns" posibilly contains an extra "Filter" column, so the "rowData" length may be less than columns' length.
                {
                    int length = (s.EndPosition - s.StartPosition) + 1;
                    fixedWidthRecord.AppendFixed(length, rowData[i]);
                }
                ++i;
            });
            
            return fixedWidthRecord.ToString();
        }

    }
}
