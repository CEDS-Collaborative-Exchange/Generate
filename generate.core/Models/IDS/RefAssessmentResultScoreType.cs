using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentResultScoreType
    {
        public RefAssessmentResultScoreType()
        {
            AssessmentResult = new HashSet<AssessmentResult>();
        }

        public int RefAssessmentResultScoreTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentResult> AssessmentResult { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
