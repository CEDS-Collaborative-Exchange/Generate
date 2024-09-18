using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefPreKeligibleAgesNonIdea
    {
        public RefPreKeligibleAgesNonIdea()
        {
            K12leaPreKeligibleAgesIdea = new HashSet<K12leaPreKeligibleAgesIdea>();
        }

        public int RefPreKeligibleAgesNonIdeaid { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12leaPreKeligibleAgesIdea> K12leaPreKeligibleAgesIdea { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
