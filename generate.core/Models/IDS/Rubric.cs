using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Rubric
    {
        public Rubric()
        {
            AssessmentItem = new HashSet<AssessmentItem>();
            RubricCriterion = new HashSet<RubricCriterion>();
        }

        public int RubricId { get; set; }
        public string Identifier { get; set; }
        public string Title { get; set; }
        public string UrlReference { get; set; }
        public string Description { get; set; }

        public virtual ICollection<AssessmentItem> AssessmentItem { get; set; }
        public virtual ICollection<RubricCriterion> RubricCriterion { get; set; }
    }
}
