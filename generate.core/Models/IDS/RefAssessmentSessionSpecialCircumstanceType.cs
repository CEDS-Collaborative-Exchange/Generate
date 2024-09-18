using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentSessionSpecialCircumstanceType
    {
        public RefAssessmentSessionSpecialCircumstanceType()
        {
            AssessmentParticipantSession = new HashSet<AssessmentParticipantSession>();
            AssessmentSession = new HashSet<AssessmentSession>();
        }

        public int RefAssessmentSessionSpecialCircumstanceTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentParticipantSession> AssessmentParticipantSession { get; set; }
        public virtual ICollection<AssessmentSession> AssessmentSession { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
