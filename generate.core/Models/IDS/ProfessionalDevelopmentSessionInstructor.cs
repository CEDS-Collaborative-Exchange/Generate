using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ProfessionalDevelopmentSessionInstructor
    {
        public int ProfessionalDevelopmentSessionInstructorId { get; set; }
        public int ProfessionalDevelopmentSessionId { get; set; }
        public int OrganizationPersonRoleId { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual ProfessionalDevelopmentSession ProfessionalDevelopmentSession { get; set; }
    }
}
