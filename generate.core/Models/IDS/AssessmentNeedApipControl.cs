using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentNeedApipControl
    {
        public int AssessmentNeedApipControlId { get; set; }
        public int AssessmentPersonalNeedsProfileControlId { get; set; }
        public string AssessmentNeedTimeMultiplier { get; set; }
        public string LineReaderHighlightColor { get; set; }
        public string OverlayColor { get; set; }
        public string BackgroundColor { get; set; }
        public int? RefAssessmentNeedIncreasedWhitespacingTypeId { get; set; }

        public virtual AssessmentPersonalNeedsProfileControl AssessmentPersonalNeedsProfileControl { get; set; }
        public virtual RefAssessmentNeedIncreasedWhitespacingType RefAssessmentNeedIncreasedWhitespacingType { get; set; }
    }
}
