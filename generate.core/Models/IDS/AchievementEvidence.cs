using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AchievementEvidence
    {
        public int AchievementEvidenceId { get; set; }
        public int? AchievementId { get; set; }
        public string Statement { get; set; }
        public int? AssessmentSubtestResultId { get; set; }

        public virtual Achievement Achievement { get; set; }
        public virtual AssessmentResult AssessmentSubtestResult { get; set; }
    }
}
