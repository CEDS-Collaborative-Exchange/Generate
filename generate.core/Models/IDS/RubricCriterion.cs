using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RubricCriterion
    {
        public RubricCriterion()
        {
            RubricCriterionLevel = new HashSet<RubricCriterionLevel>();
        }

        public int RubricCriterionId { get; set; }
        public string Category { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public decimal? Weight { get; set; }
        public int? Position { get; set; }
        public int RubricId { get; set; }

        public virtual ICollection<RubricCriterionLevel> RubricCriterionLevel { get; set; }
        public virtual Rubric Rubric { get; set; }
    }
}
