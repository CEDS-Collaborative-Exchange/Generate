using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class TeacherStudentDataLinkExclusion
    {
        public int TeacherStudentDataLinkExclusionId { get; set; }
        public int StudentOrganizationPersonRoleId { get; set; }
        public int K12staffAssignmentId { get; set; }

        public virtual K12staffAssignment K12staffAssignment { get; set; }
        public virtual K12studentCourseSection StudentOrganizationPersonRole { get; set; }
    }
}
