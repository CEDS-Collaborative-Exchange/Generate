using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ProgramParticipationNeglected
    {
        public int PersonProgramParticipationId { get; set; }
        public int? RefNeglectedProgramTypeId { get; set; }
        public bool? AchievementIndicator { get; set; }
        public bool? OutcomeIndicator { get; set; }
        public bool? ObtainedEmployment { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public int ProgramParticipationNeglectedId { get; set; }
        public virtual PersonProgramParticipation PersonProgramParticipation { get; set; }
        public virtual RefNeglectedProgramType RefNeglectedProgramType { get; set; }
    }
}
