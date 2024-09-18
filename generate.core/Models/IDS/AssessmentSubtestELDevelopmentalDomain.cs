using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentSubtestEldevelopmentalDomain
    {
        public int AssessmentSubtestEldevelopmentalDomainId { get; set; }
        public int AssessmentSubtestId { get; set; }
        public int RefAssessmentEldevelopmentalDomainId { get; set; }

        public virtual AssessmentSubtest AssessmentSubtest { get; set; }
        public virtual RefAssessmentEldevelopmentalDomain RefAssessmentEldevelopmentalDomain { get; set; }
    }
}
