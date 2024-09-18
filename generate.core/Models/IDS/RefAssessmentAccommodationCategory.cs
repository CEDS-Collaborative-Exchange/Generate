using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentAccommodationCategory
    {
        public RefAssessmentAccommodationCategory()
        {
            AssessmentParticipantSessionAccommodation = new HashSet<AssessmentParticipantSessionAccommodation>();
            AssessmentRegistrationAccommodation = new HashSet<AssessmentRegistrationAccommodation>();
        }

        public int RefAssessmentAccommodationCategoryId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentParticipantSessionAccommodation> AssessmentParticipantSessionAccommodation { get; set; }
        public virtual ICollection<AssessmentRegistrationAccommodation> AssessmentRegistrationAccommodation { get; set; }
    }
}
