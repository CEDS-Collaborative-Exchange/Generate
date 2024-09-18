using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElchildHealth
    {
        public int PersonId { get; set; }
        public DateTime? WellChildScreeningReceivedDate { get; set; }
        public int? RefScheduledWellChildScreeningId { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefScheduledWellChildScreening RefScheduledWellChildScreening { get; set; }
    }
}
