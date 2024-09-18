using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PdactivityEducationLevel
    {
        public int PdactivityEducationLevelId { get; set; }
        public int ProfessionalDevelopmentActivityId { get; set; }
        public int RefPdactivityEducationLevelsAddressedId { get; set; }

        public virtual ProfessionalDevelopmentActivity ProfessionalDevelopmentActivity { get; set; }
    }
}
