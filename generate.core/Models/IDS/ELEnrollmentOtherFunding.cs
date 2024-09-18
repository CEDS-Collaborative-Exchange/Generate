using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElenrollmentOtherFunding
    {
        public int ElenrollmentOtherFundingId { get; set; }
        public int PersonId { get; set; }
        public int RefElotherFederalFundingSourcesId { get; set; }

        public virtual Person Person { get; set; }
    }
}
