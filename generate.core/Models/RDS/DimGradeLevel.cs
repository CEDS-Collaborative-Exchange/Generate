using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimGradeLevel
    {
        public int DimGradeLevelId { get; set; }


        public int? GradeLevelId { get; set; }
        public string GradeLevelCode { get; set; }
        public string GradeLevelDescription { get; set; }
        public string GradeLevelEdFactsCode { get; set; }


        public List<FactK12StudentAssessment> FactStudentAssessments { get; set; }

        public List<FactK12StudentCount> FactStudentCounts { get; set; }
        public List<BridgeLeaGradeLevel> BridgeLeaGradeLevel { get; set; }

    }
}
