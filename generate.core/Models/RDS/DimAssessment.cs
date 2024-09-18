using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimAssessment
    {
        public int DimAssessmentId { get; set; }


        public int? AssessmentSubjectId { get; set; }
        public string AssessmentSubjectCode { get; set; }
        public string AssessmentSubjectDescription { get; set; }
        public string AssessmentSubjectEdFactsCode { get; set; }

        public int? AssessmentTypeId { get; set; }
        public string AssessmentTypeCode { get; set; }
        public string AssessmentTypeDescription { get; set; }
        public string AssessmentTypeEdFactsCode { get; set; }

        
        public int? PerformanceLevelId { get; set; }
        public string PerformanceLevelCode { get; set; }
        public string PerformanceLevelDescription { get; set; }
        public string PerformanceLevelEdFactsCode { get; set; }

        public int? ParticipationStatusId { get; set; }
        public string ParticipationStatusCode { get; set; }
        public string ParticipationStatusDescription { get; set; }
        public string ParticipationStatusEdFactsCode { get; set; }


        public int? SeaFullYearStatusId { get; set; }
        public string SeaFullYearStatusCode { get; set; }
        public string SeaFullYearStatusDescription { get; set; }
        public string SeaFullYearStatusEdFactsCode { get; set; }

        public int? LeaFullYearStatusId { get; set; }
        public string LeaFullYearStatusCode { get; set; }
        public string LeaFullYearStatusDescription { get; set; }
        public string LeaFullYearStatusEdFactsCode { get; set; }
        
        public int? SchFullYearStatusId { get; set; }
        public string SchFullYearStatusCode { get; set; }
        public string SchFullYearStatusDescription { get; set; }
        public string SchFullYearStatusEdFactsCode { get; set; }

        public int? AssessmentTypeAdministeredToEnglishLearnersId { get; set; }
        public string AssessmentTypeAdministeredToEnglishLearnersEdFactsCode { get; set; }
        public string AssessmentTypeAdministeredToEnglishLearnersDescription { get; set; }
        public string AssessmentTypeAdministeredToEnglishLearnersCode { get; set; }

        public List<FactK12StudentCount> FactStudentCounts { get; set; }
        public List<FactK12StudentAssessment> FactStudentAssessments { get; set; }

    }
}
