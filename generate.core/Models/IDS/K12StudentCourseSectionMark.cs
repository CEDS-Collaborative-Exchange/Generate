using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12studentCourseSectionMark
    {
        public int K12studentCourseSectionMarkId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public string MarkingPeriodName { get; set; }
        public bool? FinalIndicator { get; set; }
        public string GradeEarned { get; set; }
        public string MidTermMark { get; set; }
        public string GradeValueQualifier { get; set; }
        public string StudentCourseSectionGradeNarrative { get; set; }

        public virtual K12studentCourseSection OrganizationPersonRole { get; set; }
    }
}
