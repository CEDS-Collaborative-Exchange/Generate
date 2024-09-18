using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12studentGraduationPlan
    {
        public int OrganizationPersonRoleId { get; set; }
        public int K12courseId { get; set; }
        public decimal? CreditsRequired { get; set; }
        public int? RefScedcourseSubjectAreaId { get; set; }
        public int? RefGradeLevelWhenCourseTakenId { get; set; }

        public virtual K12course K12course { get; set; }
        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefGradeLevel RefGradeLevelWhenCourseTaken { get; set; }
        public virtual RefScedcourseSubjectArea RefScedcourseSubjectArea { get; set; }
    }
}
