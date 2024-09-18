using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimK12SchoolStatus
    {
        public int DimK12SchoolStatusId { get; set; }

        public string SharedTimeIndicatorCode { get; set; }
        public string SharedTimeIndicatorDescription { get; set; }
        public string SharedTimeIndicatorEdFactsCode { get; set; }


        public string MagnetOrSpecialProgramEmphasisSchoolCode { get; set; }
        public string MagnetOrSpecialProgramEmphasisSchoolDescription { get; set; }
        public string MagnetOrSpecialProgramEmphasisSchoolEdFactsCode { get; set; }

        public string NslpStatusCode { get; set; }
        public string NslpStatusDescription { get; set; }
        public string NslpStatusEdFactsCode { get; set; }


        public string VirtualSchoolStatusCode { get; set; }
        public string VirtualSchoolStatusDescription { get; set; }
        public string VirtualSchoolStatusEdFactsCode { get; set; }

        public string PersistentlyDangerousStatusCode { get; set; }
        public string PersistentlyDangerousStatusDescription { get; set; }
        public string PersistentlyDangerousStatusEdFactsCode { get; set; }

        public string SchoolImprovementStatusCode { get; set; }
        public string SchoolImprovementStatusDescription { get; set; }
        public string SchoolImprovementStatusEdFactsCode { get; set; }

        public string StatePovertyDesignationCode { get; set; }
        public string StatePovertyDesignationDescription { get; set; }
        public string StatePovertyDesignationEdFactsCode { get; set; }

        public string ProgressAchievingEnglishLanguageCode { get; set; }
        public string ProgressAchievingEnglishLanguageDescription { get; set; }
        public string ProgressAchievingEnglishLanguageEdFactsCode { get; set; }

		public List<FactOrganizationCount> FactOrganizationCounts { get; set; }
    }
}
