using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefEmploymentLocation
    {
        public RefEmploymentLocation()
        {
            QuarterlyEmploymentRecord = new HashSet<QuarterlyEmploymentRecord>();
        }

        public int RefEmploymentLocationId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<QuarterlyEmploymentRecord> QuarterlyEmploymentRecord { get; set; }
    }
}
