using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentResultRubricCriterionResult
    {
        public int AssessmentResultRubricCriterionResultId { get; set; }
        public int AssessmentResultId { get; set; }
        public int RubricCriterionLevelId { get; set; }

        public virtual AssessmentResult AssessmentResult { get; set; }
        public virtual RubricCriterionLevel RubricCriterionLevel { get; set; }
    }
}
