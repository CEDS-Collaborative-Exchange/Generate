using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAePostsecondaryTransitionAction
    {
        public RefAePostsecondaryTransitionAction()
        {
            ProgramParticipationAe = new HashSet<ProgramParticipationAe>();
        }

        public int RefAePostsecondaryTransitionActionId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ProgramParticipationAe> ProgramParticipationAe { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
