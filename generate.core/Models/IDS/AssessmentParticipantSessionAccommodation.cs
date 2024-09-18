using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentParticipantSessionAccommodation
    {
        public int AssessmentParticipantSessionAccommodationId { get; set; }
        public int AssessmentParticipantSessionId { get; set; }
        public int RefAssessmentAccommodationTypeId { get; set; }
        public int? RefAssessmentAccommodationCategoryId { get; set; }

        public virtual AssessmentParticipantSession AssessmentParticipantSession { get; set; }
        public virtual RefAssessmentAccommodationCategory RefAssessmentAccommodationCategory { get; set; }
        public virtual RefAssessmentAccommodationType RefAssessmentAccommodationType { get; set; }
    }
}
