using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefDisabilityDeterminationSourceType
    {
        public RefDisabilityDeterminationSourceType()
        {
            PersonDisability = new HashSet<PersonDisability>();
        }

        public int RefDisabilityDeterminationSourceTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonDisability> PersonDisability { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
