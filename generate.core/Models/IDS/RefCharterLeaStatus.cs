using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCharterLeaStatus
    {
        public RefCharterLeaStatus()
        {
            K12lea = new HashSet<K12lea>();
        }

        public int RefCharterLeaStatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12lea> K12lea { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
