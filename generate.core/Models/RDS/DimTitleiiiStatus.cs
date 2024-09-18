using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public class DimTitleIIIStatus
    {
        public int DimTitleIIIStatusId { get; set; }
        public string TitleIIIAccountabilityProgressStatusCode { get; set; }
        public string TitleIIIAccountabilityProgressStatusDescription { get; set; }
        public string TitleIIIAccountabilityProgressStatusEdFactsCode { get; set; }

        public string FormerEnglishLearnerYearStatusCode { get; set; }
        public string FormerEnglishLearnerYearStatusDescription { get; set; }
        public string FormerEnglishLearnerYearStatusEdFactsCode { get; set; }

        public string TitleIIILanguageInstructionCode { get; set; }
        public string TitleIIILanguageInstructionDescription { get; set; }
        public string TitleIIILanguageInstructionEdFactsCode { get; set; }


        public string ProficiencyStatusCode { get; set; }
        public string ProficiencyStatusDescription { get; set; }
        public string ProficiencyStatusEdFactsCode { get; set; }

        //public int? AssessedFirstTimeId { get; set; }
        //public string AssessedFirstTimeCode { get; set; }
        //public string AssessedFirstTimeDescription { get; set; }
        //public string AssessedFirstTimeEdFactsCode { get; set; }

        public List<FactK12StudentCount> FactK12StudentCounts { get; set; }
        public List<FactK12StaffCount> FactK12StaffCounts { get; set; }
        public List<FactK12StudentAssessment> FactK12StudentAssessments { get; set; }

    }
}
