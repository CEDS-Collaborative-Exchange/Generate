using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentSubtestAssessmentItem
    {
        public int AssessmentSubtestItemId { get; set; }
        public int AssessmentSubtestId { get; set; }
        public int AssessmentItemId { get; set; }
        public decimal? ItemWeightCorrect { get; set; }
        public decimal? ItemWeightIncorrect { get; set; }
        public decimal? ItemWeightNotAttempted { get; set; }

        public virtual AssessmentItem AssessmentItem { get; set; }
        public virtual AssessmentSubtest AssessmentSubtest { get; set; }
    }
}
