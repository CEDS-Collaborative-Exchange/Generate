using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RoleAttendanceEvent
    {
        public int RoleAttendanceEventId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public DateTime Date { get; set; }
        public int? RefAttendanceEventTypeId { get; set; }
        public int? RefAttendanceStatusId { get; set; }
        public int? RefAbsentAttendanceCategoryId { get; set; }
        public int? RefPresentAttendanceCategoryId { get; set; }
        public int? RefLeaveEventTypeId { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefAbsentAttendanceCategory RefAbsentAttendanceCategory { get; set; }
        public virtual RefAttendanceEventType RefAttendanceEventType { get; set; }
        public virtual RefAttendanceStatus RefAttendanceStatus { get; set; }
        public virtual RefLeaveEventType RefLeaveEventType { get; set; }
        public virtual RefPresentAttendanceCategory RefPresentAttendanceCategory { get; set; }
    }
}
