using generate.core.Models.App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;


namespace generate.core.Dtos.App
{
    public class FileSubmissionDto
    {
        public int FileSubmissionId { get; set; }
        public string FileSubmissionDescription { get; set; }
        public int GenerateReportId { get; set; }
        public int OrganizationLevelId { get; set; }
        public int SubmissionYear { get; set; }
        public GenerateReportDto Report { get; set; }
        public OrganizationLevel OrganizationLevel { get; set; }

    }
}
