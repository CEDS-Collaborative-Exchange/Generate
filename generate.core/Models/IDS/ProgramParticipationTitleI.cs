using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ProgramParticipationTitleI
    {
        public int PersonProgramParticipationId { get; set; }
        public int? RefTitleIindicatorId { get; set; }

        public virtual PersonProgramParticipation PersonProgramParticipation { get; set; }
        public virtual RefTitleIindicator RefTitleIindicator { get; set; }
    }
}
