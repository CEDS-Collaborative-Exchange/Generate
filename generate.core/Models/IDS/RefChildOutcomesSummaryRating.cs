using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefChildOutcomesSummaryRating
    {
        public RefChildOutcomesSummaryRating()
        {
            ElchildOutcomeSummaryCosratingA = new HashSet<ElchildOutcomeSummary>();
            ElchildOutcomeSummaryCosratingB = new HashSet<ElchildOutcomeSummary>();
            ElchildOutcomeSummaryCosratingC = new HashSet<ElchildOutcomeSummary>();
        }

        public int RefChildOutcomesSummaryRatingId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ElchildOutcomeSummary> ElchildOutcomeSummaryCosratingA { get; set; }
        public virtual ICollection<ElchildOutcomeSummary> ElchildOutcomeSummaryCosratingB { get; set; }
        public virtual ICollection<ElchildOutcomeSummary> ElchildOutcomeSummaryCosratingC { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
