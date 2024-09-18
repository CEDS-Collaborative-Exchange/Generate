using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentResultDataType
    {
        public RefAssessmentResultDataType()
        {
            AssessmentResult = new HashSet<AssessmentResult>();
        }

        public int RefAssessmentResultDataTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentResult> AssessmentResult { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
