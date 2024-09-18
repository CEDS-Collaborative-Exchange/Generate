using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefTitleIindicator
    {
        public RefTitleIindicator()
        {
            ProgramParticipationTitleI = new HashSet<ProgramParticipationTitleI>();
        }

        public int RefTitleIindicatorId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ProgramParticipationTitleI> ProgramParticipationTitleI { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
