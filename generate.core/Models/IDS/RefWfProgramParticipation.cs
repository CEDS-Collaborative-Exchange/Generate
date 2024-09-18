using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefWfProgramParticipation
    {
        public RefWfProgramParticipation()
        {
            WorkforceProgramParticipation = new HashSet<WorkforceProgramParticipation>();
        }

        public int RefWfProgramParticipationId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<WorkforceProgramParticipation> WorkforceProgramParticipation { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
