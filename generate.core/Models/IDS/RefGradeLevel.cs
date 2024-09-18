using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefGradeLevel
    {
        public RefGradeLevel()
        {
            AssessmentLevelsForWhichDesigned = new HashSet<AssessmentLevelsForWhichDesigned>();
            AssessmentRegistrationRefGradeLevelToBeAssessed = new HashSet<AssessmentRegistration>();
            AssessmentRegistrationRefGradeLevelWhenAssessed = new HashSet<AssessmentRegistration>();
            AssessmentSubtestLevelsForWhichDesigned = new HashSet<AssessmentSubtestLevelsForWhichDesigned>();
            K12schoolGradeOffered = new HashSet<K12schoolGradeOffered>();
            K12studentCourseSection = new HashSet<K12studentCourseSection>();
            K12studentEnrollmentRefEntryGradeLevel = new HashSet<K12studentEnrollment>();
            K12studentEnrollmentRefExitGradeLevelNavigation = new HashSet<K12studentEnrollment>();
            K12studentGraduationPlan = new HashSet<K12studentGraduationPlan>();
        }

        public int RefGradeLevelId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public int? RefGradeLevelTypeId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentLevelsForWhichDesigned> AssessmentLevelsForWhichDesigned { get; set; }
        public virtual ICollection<AssessmentRegistration> AssessmentRegistrationRefGradeLevelToBeAssessed { get; set; }
        public virtual ICollection<AssessmentRegistration> AssessmentRegistrationRefGradeLevelWhenAssessed { get; set; }
        public virtual ICollection<AssessmentSubtestLevelsForWhichDesigned> AssessmentSubtestLevelsForWhichDesigned { get; set; }
        public virtual ICollection<K12schoolGradeOffered> K12schoolGradeOffered { get; set; }
        public virtual ICollection<K12studentCourseSection> K12studentCourseSection { get; set; }
        public virtual ICollection<K12studentEnrollment> K12studentEnrollmentRefEntryGradeLevel { get; set; }
        public virtual ICollection<K12studentEnrollment> K12studentEnrollmentRefExitGradeLevelNavigation { get; set; }
        public virtual ICollection<K12studentGraduationPlan> K12studentGraduationPlan { get; set; }
        public virtual RefGradeLevelType RefGradeLevelType { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
