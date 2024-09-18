using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ProgramParticipationFoodService
    {
        public int ProgramParticipationFoodServiceId { get; set; }
        public int PersonProgramParticipationId { get; set; }
        public int RefSchoolFoodServiceProgramId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }

        public virtual PersonProgramParticipation PersonProgramParticipation { get; set; }
        public virtual RefSchoolFoodServiceProgram RefSchoolFoodServiceProgram { get; set; }
    }
}
