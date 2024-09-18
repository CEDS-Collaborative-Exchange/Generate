using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12titleIiilanguageInstruction
    {
        public int K12titleIiilanguageInstructionId { get; set; }
        public int OrganizationId { get; set; }
        public int RefTitleIiilanguageInstructionProgramTypeId { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefTitleIiilanguageInstructionProgramType RefTitleIiilanguageInstructionProgramType { get; set; }
    }
}
