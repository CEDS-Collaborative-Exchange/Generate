using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElqualityInitiative
    {
        public int ElqualityInitiativeId { get; set; }
        public int OrganizationId { get; set; }
        public string MaximumScore { get; set; }
        public string MinimumScore { get; set; }
        public string ScoreLevel { get; set; }
        public bool? ParticipationIndicator { get; set; }
        public DateTime? ParticipationStartDate { get; set; }
        public DateTime? ParticipationEndDate { get; set; }

        public virtual Organization Organization { get; set; }
    }
}
