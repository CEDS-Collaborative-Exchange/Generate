using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefUscitizenshipStatus
    {
        public RefUscitizenshipStatus()
        {
            PersonDetail = new HashSet<PersonDetail>();
        }

        public int RefUscitizenshipStatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonDetail> PersonDetail { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
