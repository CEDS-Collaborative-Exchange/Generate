using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentNeedBrailleMarkType
    {
        public RefAssessmentNeedBrailleMarkType()
        {
            AssessmentNeedBraille = new HashSet<AssessmentNeedBraille>();
        }

        public int RefAssessmentNeedBrailleMarkTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentNeedBraille> AssessmentNeedBraille { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
