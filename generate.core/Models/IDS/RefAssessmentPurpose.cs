using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentPurpose
    {
        public RefAssessmentPurpose()
        {
            Assessment = new HashSet<Assessment>();
            AssessmentRegistration = new HashSet<AssessmentRegistration>();
            AssessmentSubtest = new HashSet<AssessmentSubtest>();
        }

        public int RefAssessmentPurposeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<Assessment> Assessment { get; set; }
        public virtual ICollection<AssessmentRegistration> AssessmentRegistration { get; set; }
        public virtual ICollection<AssessmentSubtest> AssessmentSubtest { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
