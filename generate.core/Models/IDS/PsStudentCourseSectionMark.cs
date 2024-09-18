using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsStudentCourseSectionMark
    {
        public int OrganizationPersonRoleId { get; set; }
        public int? RefCourseAcademicGradeStatusCodeId { get; set; }
        public string CourseNarrativeExplanationGrade { get; set; }
        public string StudentCourseSectionGradeNarrative { get; set; }

        public virtual PsStudentSection OrganizationPersonRole { get; set; }
    }
}
