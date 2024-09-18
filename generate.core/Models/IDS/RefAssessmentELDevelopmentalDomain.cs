using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentEldevelopmentalDomain
    {
        public RefAssessmentEldevelopmentalDomain()
        {
            AssessmentEldevelopmentalDomain = new HashSet<AssessmentEldevelopmentalDomain>();
            AssessmentSubtestEldevelopmentalDomain = new HashSet<AssessmentSubtestEldevelopmentalDomain>();
        }

        public int RefAssessmentEldevelopmentalDomainId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentEldevelopmentalDomain> AssessmentEldevelopmentalDomain { get; set; }
        public virtual ICollection<AssessmentSubtestEldevelopmentalDomain> AssessmentSubtestEldevelopmentalDomain { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
