using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12studentSession
    {
        public int K12studentSessionId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public int? OrganizationCalendarSessionId { get; set; }
        public decimal? GradePointAverageGivenSession { get; set; }

        public virtual OrganizationCalendarSession OrganizationCalendarSession { get; set; }
        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
    }
}
