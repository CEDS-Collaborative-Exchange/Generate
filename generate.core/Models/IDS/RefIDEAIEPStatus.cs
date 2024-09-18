using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefIdeaiepstatus
    {
        public RefIdeaiepstatus()
        {
            ElchildIndividualizedProgram = new HashSet<ElchildIndividualizedProgram>();
        }

        public int RefIdeaiepstatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ElchildIndividualizedProgram> ElchildIndividualizedProgram { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
