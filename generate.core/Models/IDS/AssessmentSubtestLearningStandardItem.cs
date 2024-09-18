using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentSubtestLearningStandardItem
    {
        public int AssessmentSubTestLearningStandardItemId { get; set; }
        public int AssessmentSubtestId { get; set; }
        public int LearningStandardItemId { get; set; }

        public virtual AssessmentSubtest AssessmentSubtest { get; set; }
        public virtual LearningStandardItem LearningStandardItem { get; set; }
    }
}
