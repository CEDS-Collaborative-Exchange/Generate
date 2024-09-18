using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class CompetencySet
    {
        public CompetencySet()
        {
            Achievement = new HashSet<Achievement>();
            CompetencyItemCompetencySet = new HashSet<CompetencyItemCompetencySet>();
            LearningGoal = new HashSet<LearningGoal>();
            ProfessionalDevelopmentRequirement = new HashSet<ProfessionalDevelopmentRequirement>();
            InverseChildOfCompetencySetNavigation = new HashSet<CompetencySet>();
        }

        public int CompetencySetId { get; set; }
        public int? ChildOfCompetencySet { get; set; }
        public int? RefCompletionCriteriaId { get; set; }
        public int? CompletionCriteriaThreshold { get; set; }

        public virtual ICollection<Achievement> Achievement { get; set; }
        public virtual ICollection<CompetencyItemCompetencySet> CompetencyItemCompetencySet { get; set; }
        public virtual ICollection<LearningGoal> LearningGoal { get; set; }
        public virtual ICollection<ProfessionalDevelopmentRequirement> ProfessionalDevelopmentRequirement { get; set; }
        public virtual CompetencySet ChildOfCompetencySetNavigation { get; set; }
        public virtual ICollection<CompetencySet> InverseChildOfCompetencySetNavigation { get; set; }
        public virtual RefCompetencySetCompletionCriteria RefCompletionCriteria { get; set; }
    }
}
