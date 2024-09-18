using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ProgramParticipationTitleIiilep
    {
        public int? RefTitleIiiaccountabilityId { get; set; }
        public int? RefTitleIiilanguageInstructionProgramTypeId { get; set; }
        public int PersonProgramParticipationId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public int ProgramParticipationTitleIiiLepId { get; set; }

        public virtual PersonProgramParticipation PersonProgramParticipation { get; set; }
        public virtual RefTitleIiiaccountability RefTitleIiiaccountability { get; set; }
        public virtual RefTitleIiilanguageInstructionProgramType RefTitleIiilanguageInstructionProgramType { get; set; }
    }
}
