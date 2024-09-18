using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RoleAttendance
    {
        public int RoleAttendanceId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public decimal? NumberOfDaysInAttendance { get; set; }
        public decimal? NumberOfDaysAbsent { get; set; }
        public decimal? AttendanceRate { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
    }
}
