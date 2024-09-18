using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefIndividualizedProgramTransitionType
    {
        public RefIndividualizedProgramTransitionType()
        {
            IndividualizedProgram = new HashSet<IndividualizedProgram>();
        }

        public int RefIndividualizedProgramTransitionTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<IndividualizedProgram> IndividualizedProgram { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
