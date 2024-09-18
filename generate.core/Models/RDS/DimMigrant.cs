using System;
using System.Collections.Generic;


namespace generate.core.Models.RDS
{
    public partial class DimMigrant
    {

        public int DimMigrantId { get; set; }

        public string ContinuationOfServicesReasonCode { get; set; }
        public string ContinuationOfServicesReasonDescription { get; set; }
        public string ContinuationOfServicesReasonEdFactsCode { get; set; }

        public string MigrantPrioritizedForServicesCode { get; set; }
        public string MigrantPrioritizedForServicesDescription { get; set; }
        public string MigrantPrioritizedForServicesEdFactsCode { get; set; }

        public string MepServicesTypeCode { get; set; }
        public string MepServicesTypeDescription { get; set; }
        public string MepServicesTypeEdFactsCode { get; set; }

        public string ConsolidatedMepFundsStatusCode { get; set; }
        public string ConsolidatedMepFundsStatusDescription { get; set; }
        public string ConsolidatedMepFundsStatusEdFactsCode { get; set; }

        public string MepEnrollmentTypeCode { get; set; }
        public string MepEnrollmentTypeDescription { get; set; }
        public string MepEnrollmentTypeEdFactsCode { get; set; }

        public List<FactK12StudentCount> FactK12StudentCounts { get; set; }

    }
}
