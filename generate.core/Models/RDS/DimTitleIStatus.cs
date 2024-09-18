using System;
using System.Collections.Generic;


namespace generate.core.Models.RDS
{
    public partial class DimTitleIStatus
    {
        public int DimTitleIStatusId { get; set; }

        public string TitleISchoolStatusCode { get; set; }
        public string TitleISchoolStatusDescription { get; set; }
        public string TitleISchoolStatusEdFactsCode { get; set; }


        public string TitleIInstructionalServicesCode { get; set; }
        public string TitleIInstructionalServicesDescription { get; set; }
        public string TitleIInstructionalServicesEdFactsCode { get; set; }

        public string TitleISupportServicesCode { get; set; }
        public string TitleISupportServicesDescription { get; set; }
        public string TitleISupportServicesEdFactsCode { get; set; }
        
        public string TitleIProgramTypeCode { get; set; }
        public string TitleIProgramTypeDescription { get; set; }
        public string TitleIProgramTypeEdFactsCode { get; set; }


        public List<FactK12StudentCount> FactK12StudentCounts { get; set; }
        public List<FactOrganizationCount> FactOrganizationCounts { get; set; }
        public List<FactK12StudentAssessment> FactK12StudentAssessments { get; set; }

    }
}
