using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefTransferOutIndicator
    {
        public RefTransferOutIndicator()
        {
            PsstudentProgram = new HashSet<PsstudentProgram>();
        }

        public int RefTransferOutIndicatorId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsstudentProgram> PsstudentProgram { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
