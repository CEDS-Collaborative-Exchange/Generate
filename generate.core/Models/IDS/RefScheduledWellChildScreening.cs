using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefScheduledWellChildScreening
    {
        public RefScheduledWellChildScreening()
        {
            ElchildHealth = new HashSet<ElchildHealth>();
        }

        public int RefScheduledWellChildScreeningId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ElchildHealth> ElchildHealth { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
