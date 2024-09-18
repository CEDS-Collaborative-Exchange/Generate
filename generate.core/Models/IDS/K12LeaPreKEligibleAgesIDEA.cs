using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12leaPreKeligibleAgesIdea
    {
        public int K12leapreKeligibleAgesIdeaid { get; set; }
        public int OrganizationId { get; set; }
        public int RefPreKeligibleAgesNonIdeaid { get; set; }

        public virtual K12lea Organization { get; set; }
        public virtual RefPreKeligibleAgesNonIdea RefPreKeligibleAgesNonIdea { get; set; }
    }
}
