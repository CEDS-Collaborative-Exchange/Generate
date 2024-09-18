using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentEldevelopmentalDomain
    {
        public int AssessmentEldevelopmentalDomainId { get; set; }
        public int AssessmentId { get; set; }
        public int RefAssessmentEldevelopmentalDomainId { get; set; }

        public virtual Assessment Assessment { get; set; }
        public virtual RefAssessmentEldevelopmentalDomain RefAssessmentEldevelopmentalDomain { get; set; }
    }
}
