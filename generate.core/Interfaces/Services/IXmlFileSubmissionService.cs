using System.Collections.Generic;
using generate.core.Models.App;
using System.Threading.Tasks;
using generate.core.ViewModels.App;
using generate.core.Dtos.App;
using generate.shared.Utilities;
using System.Dynamic;

namespace generate.core.Interfaces.Services
{
    public interface IXmlFileSubmissionService
    {
        string GetFileDescription(string reportTypeCode, string reportCode, string reportLevel, string reportYear);
        FileSubmission GetFileSubmission(string reportTypeCode, string reportCode, string reportLevel, string reportYear);
        List<FileSubmissionColumnDto> GetFileSubmissionColumns(FileSubmission submission);
        string getXmlContent(string reportTypeCode, string reportCode, string reportLevel, string reportYear, string fileFormatType, string fileName, List<FileSubmissionColumnDto> columns, List<ExpandoObject> data);
     
    }
}
