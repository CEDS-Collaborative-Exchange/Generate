using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentPerformanceLevel
    {
        public AssessmentPerformanceLevel()
        {
            AssessmentResultPerformanceLevel = new HashSet<AssessmentResult_PerformanceLevel>();
        }

        public int AssessmentPerformanceLevelId { get; set; }
        public string Identifier { get; set; }
        public int? AssessmentSubtestId { get; set; }
        public string ScoreMetric { get; set; }
        public string Label { get; set; }
        public string LowerCutScore { get; set; }
        public string UpperCutScore { get; set; }
        public string DescriptiveFeedback { get; set; }

        public virtual ICollection<AssessmentResult_PerformanceLevel> AssessmentResultPerformanceLevel { get; set; }
        public virtual AssessmentSubtest AssessmentSubtest { get; set; }
    }
}
