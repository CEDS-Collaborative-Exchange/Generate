using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentPersonalNeedsProfile
    {
        public AssessmentPersonalNeedsProfile()
        {
            AssessmentPersonalNeedsProfileContent = new HashSet<AssessmentPersonalNeedsProfileContent>();
            AssessmentPersonalNeedsProfileControl = new HashSet<AssessmentPersonalNeedsProfileControl>();
            AssessmentPersonalNeedsProfileDisplay = new HashSet<AssessmentPersonalNeedsProfileDisplay>();
            AssessmentPersonalNeedsProfileScreenEnhancement = new HashSet<AssessmentPersonalNeedsProfileScreenEnhancement>();
            PersonAssessmentPersonalNeedsProfile = new HashSet<PersonAssessmentPersonalNeedsProfile>();
        }

        public int AssessmentPersonalNeedsProfileId { get; set; }
        public string AssessmentNeedType { get; set; }
        public bool? AssignedSupportFlag { get; set; }
        public bool? ActivateByDefault { get; set; }

        public virtual ICollection<AssessmentPersonalNeedsProfileContent> AssessmentPersonalNeedsProfileContent { get; set; }
        public virtual ICollection<AssessmentPersonalNeedsProfileControl> AssessmentPersonalNeedsProfileControl { get; set; }
        public virtual ICollection<AssessmentPersonalNeedsProfileDisplay> AssessmentPersonalNeedsProfileDisplay { get; set; }
        public virtual ICollection<AssessmentPersonalNeedsProfileScreenEnhancement> AssessmentPersonalNeedsProfileScreenEnhancement { get; set; }
        public virtual ICollection<PersonAssessmentPersonalNeedsProfile> PersonAssessmentPersonalNeedsProfile { get; set; }
    }
}
