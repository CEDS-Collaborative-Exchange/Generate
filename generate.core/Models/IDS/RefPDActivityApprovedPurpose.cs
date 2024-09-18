using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefPdactivityApprovedPurpose
    {
        public RefPdactivityApprovedPurpose()
        {
            ProfessionalDevelopmentActivity = new HashSet<ProfessionalDevelopmentActivity>();
        }

        public int RefPdactivityApprovedForId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ProfessionalDevelopmentActivity> ProfessionalDevelopmentActivity { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
