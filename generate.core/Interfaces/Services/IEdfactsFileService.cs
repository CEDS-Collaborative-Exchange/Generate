using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Dynamic;
using generate.core.Dtos.App;
using generate.core.Models.RDS;
using generate.core.Dtos.RDS;

namespace generate.core.Interfaces.Services
{
    public interface IEdfactsFileService
    {
        List<ExpandoObject> GetStudentCountData(string reportCode, string reportTypeCode, string reportLevel, string reportYear, List<FileSubmissionColumnDto> fileSubmissioncolumns);
        List<ExpandoObject> GetSubmissionData(List<ExpandoObject> dataRows, List<FileSubmissionColumnDto> fileSubmissioncolumns);
        (IEnumerable<MembershipReportDto>, int) GetMembershipStudentCountData(string reportCode, string reportTypeCode, string reportLevel, string reportYear, List<FileSubmissionColumnDto> fileSubmissioncolumns, int startRecord, int numberOfRecords);
    }
}
