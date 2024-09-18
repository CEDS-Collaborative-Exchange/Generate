using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentNeedMaskingType
    {
        public RefAssessmentNeedMaskingType()
        {
            AssessmentNeedApipDisplay = new HashSet<AssessmentNeedApipDisplay>();
        }

        public int RefAssessmentNeedMaskingTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentNeedApipDisplay> AssessmentNeedApipDisplay { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
