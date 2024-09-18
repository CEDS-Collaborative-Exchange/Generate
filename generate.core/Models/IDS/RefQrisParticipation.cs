using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefQrisParticipation
    {
        public RefQrisParticipation()
        {
            ElqualityRatingImprovement = new HashSet<ElqualityRatingImprovement>();
        }

        public int RefQrisParticipationId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ElqualityRatingImprovement> ElqualityRatingImprovement { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
