using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentNeedUsageType
    {
        public RefAssessmentNeedUsageType()
        {
            AssessmentNeedBraille = new HashSet<AssessmentNeedBraille>();
            AssessmentPersonalNeedScreenReader = new HashSet<AssessmentPersonalNeedScreenReader>();
        }

        public int RefAssessmentNeedUsageTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentNeedBraille> AssessmentNeedBraille { get; set; }
        public virtual ICollection<AssessmentPersonalNeedScreenReader> AssessmentPersonalNeedScreenReader { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
