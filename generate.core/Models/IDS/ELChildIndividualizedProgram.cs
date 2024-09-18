using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElchildIndividualizedProgram
    {
        public int PersonId { get; set; }
        public int? RefIdeaiepstatusId { get; set; }
        public int? IndividualizedProgramId { get; set; }
        public int? RefIdeapartCeligibilityCategoryId { get; set; }

        public virtual IndividualizedProgram IndividualizedProgram { get; set; }
        public virtual Person Person { get; set; }
        public virtual RefIdeaiepstatus RefIdeaiepstatus { get; set; }
        public virtual RefIdeapartCeligibilityCategory RefIdeapartCeligibilityCategory { get; set; }
    }
}
