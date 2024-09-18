using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefProgramSponsorType
    {
        public RefProgramSponsorType()
        {
            StaffCredential = new HashSet<StaffCredential>();
        }

        public int RefProgramSponsorTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdiction { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<StaffCredential> StaffCredential { get; set; }
        public virtual Organization RefJurisdictionNavigation { get; set; }
    }
}
