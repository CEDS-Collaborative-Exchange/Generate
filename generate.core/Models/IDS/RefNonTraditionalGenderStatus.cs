using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefNonTraditionalGenderStatus
    {
        public RefNonTraditionalGenderStatus()
        {
            ProgramParticipationCte = new HashSet<ProgramParticipationCte>();
        }

        public int RefNonTraditionalGenderStatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ProgramParticipationCte> ProgramParticipationCte { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
