using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentItemRubricCriterionResult
    {
        public int AssessmentItemResponseId { get; set; }
        public int RubricCriterionLevelId { get; set; }

        public virtual AssessmentItemResponse AssessmentItemResponse { get; set; }
        public virtual RubricCriterionLevel RubricCriterionLevel { get; set; }
    }
}
