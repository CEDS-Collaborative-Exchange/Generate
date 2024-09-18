using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentPersonalNeedScreenReader
    {
        public int AssessmentPersonalNeedScreenReaderId { get; set; }
        public int AssessmentPersonalNeedsProfileDisplayId { get; set; }
        public int? RefAssessmentNeedUsageTypeId { get; set; }
        public int? SpeechRate { get; set; }
        public decimal? Pitch { get; set; }
        public decimal? Volume { get; set; }

        public virtual AssessmentPersonalNeedsProfileDisplay AssessmentPersonalNeedsProfileDisplay { get; set; }
        public virtual RefAssessmentNeedUsageType RefAssessmentNeedUsageType { get; set; }
    }
}
