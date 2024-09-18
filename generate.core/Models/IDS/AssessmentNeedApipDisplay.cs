using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentNeedApipDisplay
    {
        public int AssessmentNeedApipDisplayId { get; set; }
        public int AssessmentPersonalNeedsProfileDisplayId { get; set; }
        public bool? MaskingAssignedSupportIndicator { get; set; }
        public bool? MaskingActivateByDefaultIndicator { get; set; }
        public int? RefAssessmentNeedMaskingTypeId { get; set; }
        public bool? EncouragementAssignedSupportIndicator { get; set; }
        public bool? EncouragementActivateByDefaultIndicator { get; set; }
        public string EncouragementTextMessagingString { get; set; }
        public string EncouragementSoundFileUrl { get; set; }

        public virtual AssessmentPersonalNeedsProfileDisplay AssessmentPersonalNeedsProfileDisplay { get; set; }
        public virtual RefAssessmentNeedMaskingType RefAssessmentNeedMaskingType { get; set; }
    }
}
