using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentPersonalNeedsProfileScreenEnhancement
    {
        public AssessmentPersonalNeedsProfileScreenEnhancement()
        {
            AssessmentNeedScreenEnhancement = new HashSet<AssessmentNeedScreenEnhancement>();
        }

        public int AssessmentPersonalNeedsProfileScreenEnhancementId { get; set; }
        public int AssessmentPersonalNeedsProfileId { get; set; }

        public virtual ICollection<AssessmentNeedScreenEnhancement> AssessmentNeedScreenEnhancement { get; set; }
        public virtual AssessmentPersonalNeedsProfile AssessmentPersonalNeedsProfile { get; set; }
    }
}
