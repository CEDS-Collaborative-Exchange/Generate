using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAeStaffClassification
    {
        public RefAeStaffClassification()
        {
            AeStaff = new HashSet<AeStaff>();
        }

        public int RefAeStaffClassificationId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AeStaff> AeStaff { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
