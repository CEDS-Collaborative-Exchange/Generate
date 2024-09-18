using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAeSpecialProgramType
    {
        public RefAeSpecialProgramType()
        {
            ProgramParticipationAe = new HashSet<ProgramParticipationAe>();
        }

        public int RefAeSpecialProgramTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ProgramParticipationAe> ProgramParticipationAe { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
