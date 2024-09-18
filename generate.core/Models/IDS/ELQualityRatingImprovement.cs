using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElqualityRatingImprovement
    {
        public int ElqualityRatingImprovementId { get; set; }
        public int OrganizationId { get; set; }
        public int? NumberQrisLevels { get; set; }
        public DateTime? QrisAwardDate { get; set; }
        public DateTime? QrisexpirationDate { get; set; }
        public int? RefQrisParticipationId { get; set; }
        public string QrisScore { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefQrisParticipation RefQrisParticipation { get; set; }
    }
}
