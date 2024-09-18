using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12leaPreKeligibility
    {
        public int K12leapreKeligibilityId { get; set; }
        public int OrganizationId { get; set; }
        public int RefPrekindergartenEligibilityId { get; set; }

        public virtual K12lea Organization { get; set; }
        public virtual RefPrekindergartenEligibility RefPrekindergartenEligibility { get; set; }
    }
}
