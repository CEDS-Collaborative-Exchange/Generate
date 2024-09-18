using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentFormAssessmentFormSection
    {
        public int AssessmentFormAssessmentFormSectionId { get; set; }
        public int AssessmentFormId { get; set; }
        public int AssessmentFormSectionId { get; set; }
        public int? SequenceNumber { get; set; }

        public virtual AssessmentForm AssessmentForm { get; set; }
        public virtual AssessmentFormSection AssessmentFormSection { get; set; }
    }
}
