using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElchildOutcomeSummary
    {
        public int PersonId { get; set; }
        public bool? CosprogressAindicator { get; set; }
        public bool? CosprogressBindicator { get; set; }
        public bool? CosprogressCindicator { get; set; }
        public int? CosratingAid { get; set; }
        public int? CosratingBid { get; set; }
        public int? CosratingCid { get; set; }

        public virtual RefChildOutcomesSummaryRating CosratingA { get; set; }
        public virtual RefChildOutcomesSummaryRating CosratingB { get; set; }
        public virtual RefChildOutcomesSummaryRating CosratingC { get; set; }
        public virtual Person Person { get; set; }
    }
}
