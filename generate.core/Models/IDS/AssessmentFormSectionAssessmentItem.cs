using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentFormSectionAssessmentItem
    {
        public int AssessmentFormSectionItemId { get; set; }
        public int SequenceNumber { get; set; }
        public int AssessmentFormSectionId { get; set; }
        public int AssessmentItemId { get; set; }

        public virtual AssessmentFormSection AssessmentFormSection { get; set; }
        public virtual AssessmentItem AssessmentItem { get; set; }
    }
}
