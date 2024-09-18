using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefIndividualizedProgramLocation
    {
        public RefIndividualizedProgramLocation()
        {
            IndividualizedProgram = new HashSet<IndividualizedProgram>();
        }

        public int RefIndividualizedProgramLocationId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<IndividualizedProgram> IndividualizedProgram { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
