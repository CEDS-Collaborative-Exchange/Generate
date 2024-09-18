using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Achievement
    {
        public Achievement()
        {
            AchievementEvidence = new HashSet<AchievementEvidence>();
        }

        public int AchievementId { get; set; }
        public int PersonId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Category { get; set; }
        public string CategorySystem { get; set; }
        public string ImageUrl { get; set; }
        public string Criteria { get; set; }
        public string CriteriaUrl { get; set; }
        public int? CompetencySetId { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string AwardIssuerName { get; set; }
        public string AwardIssuerOriginUrl { get; set; }

        public virtual ICollection<AchievementEvidence> AchievementEvidence { get; set; }
        public virtual CompetencySet CompetencySet { get; set; }
        public virtual Person Person { get; set; }
    }
}
