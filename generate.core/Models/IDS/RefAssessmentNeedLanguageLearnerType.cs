using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentNeedLanguageLearnerType
    {
        public RefAssessmentNeedLanguageLearnerType()
        {
            AssessmentPersonalNeedLanguageLearner = new HashSet<AssessmentPersonalNeedLanguageLearner>();
        }

        public int RefAssessmentNeedLanguageLearnerTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentPersonalNeedLanguageLearner> AssessmentPersonalNeedLanguageLearner { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
