using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Models.App
{
    public class FileSubmission
    {
        public int FileSubmissionId { get; set; }
        public int? GenerateReportId { get; set; }
        public GenerateReport GenerateReport { get; set; }
        public int? OrganizationLevelId { get; set; }
        public OrganizationLevel OrganizationLevel { get; set; }
        public string FileSubmissionDescription { get; set; }
        public string SubmissionYear { get; set; }
        public List<FileSubmission_FileColumn> FileSubmission_FileColumns { get; set; }
    }
}
