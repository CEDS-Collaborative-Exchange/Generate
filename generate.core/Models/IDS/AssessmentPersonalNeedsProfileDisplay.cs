using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentPersonalNeedsProfileDisplay
    {
        public AssessmentPersonalNeedsProfileDisplay()
        {
            AssessmentNeedApipDisplay = new HashSet<AssessmentNeedApipDisplay>();
            AssessmentNeedBraille = new HashSet<AssessmentNeedBraille>();
            AssessmentNeedScreenEnhancement = new HashSet<AssessmentNeedScreenEnhancement>();
            AssessmentPersonalNeedScreenReader = new HashSet<AssessmentPersonalNeedScreenReader>();
        }

        public int AssessmentPersonalNeedsProfileDisplayId { get; set; }
        public int AssessmentPersonalNeedsProfileId { get; set; }

        public virtual ICollection<AssessmentNeedApipDisplay> AssessmentNeedApipDisplay { get; set; }
        public virtual ICollection<AssessmentNeedBraille> AssessmentNeedBraille { get; set; }
        public virtual ICollection<AssessmentNeedScreenEnhancement> AssessmentNeedScreenEnhancement { get; set; }
        public virtual ICollection<AssessmentPersonalNeedScreenReader> AssessmentPersonalNeedScreenReader { get; set; }
        public virtual AssessmentPersonalNeedsProfile AssessmentPersonalNeedsProfile { get; set; }
    }
}
