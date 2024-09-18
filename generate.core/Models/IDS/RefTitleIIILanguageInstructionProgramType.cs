using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefTitleIiilanguageInstructionProgramType
    {
        public RefTitleIiilanguageInstructionProgramType()
        {
            K12titleIiilanguageInstruction = new HashSet<K12titleIiilanguageInstruction>();
            ProgramParticipationTitleIiilep = new HashSet<ProgramParticipationTitleIiilep>();
        }

        public int RefTitleIiilanguageInstructionProgramTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12titleIiilanguageInstruction> K12titleIiilanguageInstruction { get; set; }
        public virtual ICollection<ProgramParticipationTitleIiilep> ProgramParticipationTitleIiilep { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
