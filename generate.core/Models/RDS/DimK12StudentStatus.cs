using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimK12StudentStatus
    {

        public int DimK12StudentStatusId { get; set; }

        public int? HighSchoolDiplomaTypeId { get; set; }
        public string HighSchoolDiplomaTypeCode { get; set; }
        public string HighSchoolDiplomaTypeDescription { get; set; }
        public string HighSchoolDiplomaTypeEdFactsCode { get; set; }

        public int? MobilityStatus12moId { get; set; }
        public string MobilityStatus12moCode { get; set; }
        public string MobilityStatus12moDescription { get; set; }
        public string MobilityStatus12moEdFactsCode { get; set; }

        public int? MobilityStatus36moId { get; set; }
        public string MobilityStatus36moCode { get; set; }
        public string MobilityStatus36moDescription { get; set; }
        public string MobilityStatus36moEdFactsCode { get; set; }

        public int? MobilityStatusSYId { get; set; }
        public string MobilityStatusSYCode { get; set; }
        public string MobilityStatusSYDescription { get; set; }
        public string MobilityStatusSYEdFactsCode { get; set; }


        public int? ReferralStatusId { get; set; }
        public string ReferralStatusCode { get; set; }
        public string ReferralStatusDescription { get; set; }
        public string ReferralStatusEdFactsCode { get; set; }


        public int? PlacementStatusId { get; set; }
        public string PlacementStatusCode { get; set; }
        public string PlacementStatusDescription { get; set; }
        public string PlacementStatusEdFactsCode { get; set; }

        public int? PlacementTypeId { get; set; }
        public string PlacementTypeCode { get; set; }
        public string PlacementTypeDescription { get; set; }
        public string PlacementTypeEdFactsCode { get; set; }

        public int? NSLPDirectCertificationIndicatorId { get; set; }
        public string NSLPDirectCertificationIndicatorCode { get; set; }
        public string NSLPDirectCertificationIndicatorDescription { get; set; }
        public string NSLPDirectCertificationIndicatorEdFactsCode { get; set; }


        public List<FactK12StudentCount> FactStudentCounts { get; set; }

        public List<FactK12StudentAssessment> FactStudentAssessments { get; set; }

    }
}
