using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class WorkforceEmploymentQuarterlyData
    {
        public int OrganizationPersonRoleId { get; set; }
        public int? RefEmployedWhileEnrolledId { get; set; }
        public int? RefEmployedAfterExitId { get; set; }
        public decimal? EmployedInMultipleJobsCount { get; set; }
        public bool? MilitaryEnlistmentAfterExit { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
    }
}
