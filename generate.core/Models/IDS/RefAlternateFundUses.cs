using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAlternateFundUses
    {
        public RefAlternateFundUses()
        {
            K12seaAlternateFundUse = new HashSet<K12seaAlternateFundUse>();
        }

        public int RefAlternateFundUsesId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12seaAlternateFundUse> K12seaAlternateFundUse { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
