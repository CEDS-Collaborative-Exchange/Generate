using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefPrekindergartenEligibility
    {
        public RefPrekindergartenEligibility()
        {
            K12leaPreKeligibility = new HashSet<K12leaPreKeligibility>();
        }

        public int RefPrekindergartenEligibilityId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12leaPreKeligibility> K12leaPreKeligibility { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
