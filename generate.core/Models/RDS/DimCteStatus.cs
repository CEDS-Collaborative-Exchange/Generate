using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.RDS
{
    public partial class DimCteStatus
    {
        public int DimCteStatusId { get; set; }

        public int? CteProgramId { get; set; }
        public string CteProgramCode { get; set; }
        public string CteProgramDescription { get; set; }
        public string CteProgramEdFactsCode { get; set; }

        public int? SingleParentOrSinglePregnantWomanId { get; set; }
        public string SingleParentOrSinglePregnantWomanCode { get; set; }
        public string SingleParentOrSinglePregnantWomanDescription { get; set; }
        public string SingleParentOrSinglePregnantWomanEdFactsCode { get; set; }
               
        public int? CteAeDisplacedHomemakerIndicatorId { get; set; }
        public string CteAeDisplacedHomemakerIndicatorCode { get; set; }
        public string CteAeDisplacedHomemakerIndicatorDescription { get; set; }
        public string CteAeDisplacedHomemakerIndicatorEdFactsCode { get; set; }

        public int? CteGraduationRateInclusionId { get; set; }
        public string CteGraduationRateInclusionCode { get; set; }
        public string CteGraduationRateInclusionDescription { get; set; }
        public string CteGraduationRateInclusionEdFactsCode { get; set; }


        public int? CteNontraditionalGenderStatusId { get; set; }
        public string CteNontraditionalGenderStatusCode { get; set; }
        public string CteNontraditionalGenderStatusDescription { get; set; }
        public string CteNontraditionalGenderStatusEdFactsCode { get; set; }

        public int? RepresentationStatusId { get; set; }
        public string RepresentationStatusCode { get; set; }
        public string RepresentationStatusDescription { get; set; }
        public string RepresentationStatusEdFactsCode { get; set; }

        public int? LepPerkinsStatusId { get; set; }
        public string LepPerkinsStatusCode { get; set; }
        public string LepPerkinsStatusDescription { get; set; }
        public string LepPerkinsStatusEdFactsCode { get; set; }


        public List<FactK12StudentCount> FactStudentCounts { get; set; }

        public List<FactK12StudentAssessment> FactStudentAssessments { get; set; }
        public List<FactK12StudentDiscipline> FactStudentDisciplines { get; set; }
    }
}
