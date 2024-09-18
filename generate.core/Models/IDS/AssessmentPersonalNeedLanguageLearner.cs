using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentPersonalNeedLanguageLearner
    {
        public int AssessmentPersonalNeedLanguageLearnerId { get; set; }
        public int AssessmentNeedsProfileContentId { get; set; }
        public bool? AssignedSupport { get; set; }
        public bool? ActivateByDefault { get; set; }
        public int RefAssessmentNeedsProfileContentLanguageLearnerTypeId { get; set; }

        public virtual AssessmentPersonalNeedsProfileContent AssessmentNeedsProfileContent { get; set; }
        public virtual RefAssessmentNeedLanguageLearnerType RefAssessmentNeedsProfileContentLanguageLearnerType { get; set; }
    }
}
