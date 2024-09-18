using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ProgramParticipationNeglectedProgressLevel
    {
        public int ProgramParticipationNeglectedProgressLevelId { get; set; }
        public int PersonProgramParticipationId { get; set; }
        public int RefAcademicSubjectId { get; set; }
        public int RefProgressLevelId { get; set; }

        public virtual PersonProgramParticipation PersonProgramParticipation { get; set; }
        public virtual RefAcademicSubject RefAcademicSubject { get; set; }
        public virtual RefProgressLevel RefProgressLevel { get; set; }
    }
}
