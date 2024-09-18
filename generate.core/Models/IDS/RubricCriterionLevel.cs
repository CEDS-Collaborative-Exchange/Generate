using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RubricCriterionLevel
    {
        public RubricCriterionLevel()
        {
            AssessmentItemRubricCriterionResult = new HashSet<AssessmentItemRubricCriterionResult>();
            AssessmentResultRubricCriterionResult = new HashSet<AssessmentResultRubricCriterionResult>();
        }

        public int RubricCriterionLevelId { get; set; }
        public string Description { get; set; }
        public string Quality { get; set; }
        public decimal? Score { get; set; }
        public string Feedback { get; set; }
        public int? Position { get; set; }
        public int RubricCriterionId { get; set; }

        public virtual ICollection<AssessmentItemRubricCriterionResult> AssessmentItemRubricCriterionResult { get; set; }
        public virtual ICollection<AssessmentResultRubricCriterionResult> AssessmentResultRubricCriterionResult { get; set; }
        public virtual RubricCriterion RubricCriterion { get; set; }
    }
}
