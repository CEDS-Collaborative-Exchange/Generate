using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentResult_PerformanceLevel
    {
        public int AssessmentResult_PerformanceLevelId { get; set; }
        public int AssessmentResultId { get; set; }
        public int AssessmentPerformanceLevelId { get; set; }

        public virtual AssessmentPerformanceLevel AssessmentPerformanceLevel { get; set; }
        public virtual AssessmentResult AssessmentResult { get; set; }
    }
}
