using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentNeedIncreasedWhitespacingType
    {
        public RefAssessmentNeedIncreasedWhitespacingType()
        {
            AssessmentNeedApipControl = new HashSet<AssessmentNeedApipControl>();
        }

        public int RefAssessmentNeedIncreasedWhitespacingTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentNeedApipControl> AssessmentNeedApipControl { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
