using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class LearningGoal
    {
        public int LearningGoalId { get; set; }
        public string Description { get; set; }
        public string SuccessCriteria { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? PersonId { get; set; }
        public int? CompetencySetId { get; set; }

        public virtual CompetencySet CompetencySet { get; set; }
        public virtual Person Person { get; set; }
    }
}
