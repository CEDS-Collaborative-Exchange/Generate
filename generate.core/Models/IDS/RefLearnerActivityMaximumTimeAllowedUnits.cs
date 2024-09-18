using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefLearnerActivityMaximumTimeAllowedUnits
    {
        public RefLearnerActivityMaximumTimeAllowedUnits()
        {
            LearnerActivity = new HashSet<LearnerActivity>();
        }

        public int RefLearnerActivityMaximumTimeAllowedUnitsId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<LearnerActivity> LearnerActivity { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
