using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefBarrierToEducatingHomeless
    {
        public RefBarrierToEducatingHomeless()
        {
            K12leaFederalReporting = new HashSet<K12leaFederalReporting>();
        }

        public int RefBarrierToEducatingHomelessId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12leaFederalReporting> K12leaFederalReporting { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
