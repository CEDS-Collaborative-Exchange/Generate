using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimAssessmentStatus
    {

        public int DimAssessmentStatusId { get; set; }
        public int? AssessedFirstTimeId { get; set; }
        public string AssessedFirstTimeCode { get; set; }
        public string AssessedFirstTimeDescription { get; set; }
        public string AssessedFirstTimeEdFactsCode { get; set; }

        public int? AssessmentProgressLevelId { get; set; }
        public string AssessmentProgressLevelCode { get; set; }
        public string AssessmentProgressLevelDescription { get; set; }
        public string AssessmentProgressLevelEdFactsCode { get; set; }

        public List<FactK12StudentCount> FactStudentCounts { get; set; }
        public List<FactK12StudentAssessment> FactStudentAssessments { get; set; }

    }
}
