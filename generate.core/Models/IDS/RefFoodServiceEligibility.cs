using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefFoodServiceEligibility
    {
        public RefFoodServiceEligibility()
        {
            K12studentEnrollment = new HashSet<K12studentEnrollment>();
        }

        public int RefFoodServiceEligibilityId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdiction { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12studentEnrollment> K12studentEnrollment { get; set; }
        public virtual Organization RefJurisdictionNavigation { get; set; }
    }
}
