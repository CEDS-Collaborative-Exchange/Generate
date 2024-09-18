using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class CompetencyItemCompetencySet
    {
        public int CompetencyItemCompetencySetId { get; set; }
        public int LearningStandardItemId { get; set; }
        public int CompetencySetId { get; set; }

        public virtual CompetencySet CompetencySet { get; set; }
        public virtual LearningStandardItem LearningStandardItem { get; set; }
    }
}
