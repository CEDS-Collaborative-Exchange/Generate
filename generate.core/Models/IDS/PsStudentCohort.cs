using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsStudentCohort
    {
        public int OrganizationPersonRoleId { get; set; }
        public string CohortGraduationYear { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
    }
}
