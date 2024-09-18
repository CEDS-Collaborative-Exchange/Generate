using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Course
    {
        public Course()
        {
            CourseSection = new HashSet<CourseSection>();
            ProfessionalDevelopmentActivity = new HashSet<ProfessionalDevelopmentActivity>();
        }

        public int OrganizationId { get; set; }
        public string Description { get; set; }
        public string SubjectAbbreviation { get; set; }
        public string ScedsequenceOfCourse { get; set; }
        public int? InstructionalMinutes { get; set; }
        public int? RefCourseLevelCharacteristicsId { get; set; }
        public int? RefCourseCreditUnitId { get; set; }
        public decimal? CreditValue { get; set; }
        public int? RefInstructionLanguage { get; set; }
        public string CertificationDescription { get; set; }
        public int? RefCourseApplicableEducationLevelId { get; set; }

        public virtual ICollection<CourseSection> CourseSection { get; set; }
        public virtual CteCourse CteCourse { get; set; }
        public virtual K12course K12course { get; set; }
        public virtual ICollection<ProfessionalDevelopmentActivity> ProfessionalDevelopmentActivity { get; set; }
        public virtual PsCourse PsCourse { get; set; }
        public virtual Organization Organization { get; set; }
        public virtual RefCourseApplicableEducationLevel RefCourseApplicableEducationLevel { get; set; }
        public virtual RefCourseCreditUnit RefCourseCreditUnit { get; set; }
        public virtual RefCourseLevelCharacteristic RefCourseLevelCharacteristics { get; set; }
        public virtual RefLanguage RefInstructionLanguageNavigation { get; set; }
    }
}
