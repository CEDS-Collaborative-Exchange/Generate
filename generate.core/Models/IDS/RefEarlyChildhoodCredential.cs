using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefEarlyChildhoodCredential
    {
        public RefEarlyChildhoodCredential()
        {
            EarlyChildhoodCredential = new HashSet<EarlyChildhoodCredential>();
        }

        public int RefEarlyChildhoodCredentialId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<EarlyChildhoodCredential> EarlyChildhoodCredential { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
