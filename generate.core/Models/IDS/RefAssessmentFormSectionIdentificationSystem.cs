using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentFormSectionIdentificationSystem
    {
        public RefAssessmentFormSectionIdentificationSystem()
        {
            AssessmentFormSection = new HashSet<AssessmentFormSection>();
        }

        public int RefAssessmentFormSectionIdentificationSystemId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentFormSection> AssessmentFormSection { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
