using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentRegistrationAccommodation
    {
        public int AssessmentRegistrationAccommodationId { get; set; }
        public int AssessmentRegistrationId { get; set; }
        public int RefAssessmentAccommodationTypeId { get; set; }
        public string OtherDescription { get; set; }
        public int? RefAssessmentAccommodationCategoryId { get; set; }

        public virtual AssessmentRegistration AssessmentRegistration { get; set; }
        public virtual RefAssessmentAccommodationCategory RefAssessmentAccommodationCategory { get; set; }
        public virtual RefAssessmentAccommodationType RefAssessmentAccommodationType { get; set; }
    }
}
