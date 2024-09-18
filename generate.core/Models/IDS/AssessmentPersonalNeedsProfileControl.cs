using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentPersonalNeedsProfileControl
    {
        public AssessmentPersonalNeedsProfileControl()
        {
            AssessmentNeedApipControl = new HashSet<AssessmentNeedApipControl>();
        }

        public int AssessmentPersonalNeedsProfileControlId { get; set; }
        public int AssessmentPersonalNeedsProfileId { get; set; }

        public virtual ICollection<AssessmentNeedApipControl> AssessmentNeedApipControl { get; set; }
        public virtual AssessmentPersonalNeedsProfile AssessmentPersonalNeedsProfile { get; set; }
    }
}
