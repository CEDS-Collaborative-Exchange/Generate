using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefTitleIiiaccountability
    {
        public RefTitleIiiaccountability()
        {
            ProgramParticipationTitleIiilep = new HashSet<ProgramParticipationTitleIiilep>();
        }

        public int RefTitleIiiaccountabilityId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ProgramParticipationTitleIiilep> ProgramParticipationTitleIiilep { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
