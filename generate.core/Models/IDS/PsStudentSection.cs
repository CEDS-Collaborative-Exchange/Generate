using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsStudentSection
    {
        public int OrganizationPersonRoleId { get; set; }
        public string CourseOverrideSchool { get; set; }
        public bool? DegreeApplicability { get; set; }
        public string AcademicGrade { get; set; }
        public decimal? NumberOfCreditsEarned { get; set; }
        public decimal? QualityPointsEarned { get; set; }
        public int? RefCourseRepeatCodeId { get; set; }
        public int? RefCourseAcademicGradeStatusCodeId { get; set; }

        public virtual PsStudentCourseSectionMark PsStudentCourseSectionMark { get; set; }
        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefCourseAcademicGradeStatusCode RefCourseAcademicGradeStatusCode { get; set; }
        public virtual RefCourseRepeatCode RefCourseRepeatCode { get; set; }
    }
}
