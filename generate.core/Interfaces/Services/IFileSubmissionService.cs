using System.Collections.Generic;
using generate.core.Models.App;
using System.Threading.Tasks;
using generate.core.ViewModels.App;
using generate.core.Dtos.App;

namespace generate.core.Interfaces.Services
{
    public interface IFileSubmissionService
    {
        string GetFileDescription(string reportTypeCode, string reportCode, string reportLevel, string reportYear);
        FileSubmission GetFileSubmission(string reportTypeCode, string reportCode, string reportLevel, string reportYear);
        List<FileSubmissionColumnDto> GetFileSubmissionColumns(FileSubmission submission);
        string GetSubmissionRow(List<string> rowData, string fileFormatType, List<FileSubmissionColumnDto> column);
        string GetFileHeader(string reportTypeCode, string reportCode, string reportLevel, string reportYear, string fileFormatType, string fileName, int totalCount);
        string GetContentType(string fileFormatType);
        string GetFixedWidthRow(List<string> rowData, List<FileSubmissionColumnDto> column);
    }
}
