using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefTextComplexitySystem
    {
        public RefTextComplexitySystem()
        {
            AssessmentItem = new HashSet<AssessmentItem>();
        }

        public int RefTextComplexitySystemId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentItem> AssessmentItem { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
