using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonAssessmentPersonalNeedsProfile
    {
        public int PersonAssessmentPersonalNeedsProfileId { get; set; }
        public int PersonId { get; set; }
        public int AssessmentPersonalNeedsProfileId { get; set; }

        public virtual AssessmentPersonalNeedsProfile AssessmentPersonalNeedsProfile { get; set; }
        public virtual Person Person { get; set; }
    }
}
