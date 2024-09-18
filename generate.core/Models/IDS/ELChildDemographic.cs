using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElchildDemographic
    {
        public int PersonId { get; set; }
        public DateTime? FosterCareStartDate { get; set; }
        public DateTime? FosterCareEndDate { get; set; }
        public bool? OtherRaceIndicator { get; set; }

        public virtual Person Person { get; set; }
    }
}
