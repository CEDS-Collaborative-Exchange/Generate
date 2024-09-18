using System;
using System.Collections.Generic;


namespace generate.core.Models.RDS
{
    public partial class DimK12OrganizationStatus
    {
        public int DimK12OrganizationStatusId { get; set; }

        public string ReapAlternativeFundingStatusCode { get; set; }
        public string ReapAlternativeFundingStatusDescription { get; set; }
        public string ReapAlternativeFundingStatusEdFactsCode { get; set; }

        public string GunFreeSchoolsActReportingStatusCode { get; set; }
        public string GunFreeSchoolsActReportingStatusDescription { get; set; }
        public string GunFreeSchoolsActReportingStatusEdFactsCode { get; set; }


        public string HighSchoolGraduationRateIndicatorStatusCode { get; set; }
        public string HighSchoolGraduationRateIndicatorStatusDescription { get; set; }
        public string HighSchoolGraduationRateIndicatorStatusEdFactsCode { get; set; }
        
        public List<FactOrganizationCount> FactOrganizationCounts { get; set; }

    }
}
