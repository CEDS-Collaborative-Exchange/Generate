using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCommunityBasedType
    {
        public RefCommunityBasedType()
        {
            EarlyChildhoodProgramTypeOffered = new HashSet<EarlyChildhoodProgramTypeOffered>();
        }

        public int RefCommunityBasedTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<EarlyChildhoodProgramTypeOffered> EarlyChildhoodProgramTypeOffered { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
