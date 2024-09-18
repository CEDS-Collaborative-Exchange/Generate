using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12studentCourseSection
    {
        public K12studentCourseSection()
        {
            K12studentCourseSectionMark = new HashSet<K12studentCourseSectionMark>();
            TeacherStudentDataLinkExclusion = new HashSet<TeacherStudentDataLinkExclusion>();
        }

        public int OrganizationPersonRoleId { get; set; }
        public int? RefCourseRepeatCodeId { get; set; }
        public int? RefCourseSectionEnrollmentStatusTypeId { get; set; }
        public int? RefCourseSectionEntryTypeId { get; set; }
        public int? RefCourseSectionExitTypeId { get; set; }
        public int? RefExitOrWithdrawalStatusId { get; set; }
        public int? RefGradeLevelWhenCourseTakenId { get; set; }
        public string GradeEarned { get; set; }
        public string GradeValueQualifier { get; set; }
        public decimal? NumberOfCreditsAttempted { get; set; }
        public int? RefCreditTypeEarnedId { get; set; }
        public int? RefAdditionalCreditTypeId { get; set; }
        public int? RefPreAndPostTestIndicatorId { get; set; }
        public int? RefProgressLevelId { get; set; }
        public int? RefCourseGpaApplicabilityId { get; set; }
        public decimal? NumberOfCreditsEarned { get; set; }
        public bool? TuitionFunded { get; set; }

        public virtual ICollection<K12studentCourseSectionMark> K12studentCourseSectionMark { get; set; }
        public virtual ICollection<TeacherStudentDataLinkExclusion> TeacherStudentDataLinkExclusion { get; set; }
        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefAdditionalCreditType RefAdditionalCreditType { get; set; }
        public virtual RefCourseGpaApplicability RefCourseGpaApplicability { get; set; }
        public virtual RefCourseRepeatCode RefCourseRepeatCode { get; set; }
        public virtual RefCourseSectionEnrollmentStatusType RefCourseSectionEnrollmentStatusType { get; set; }
        public virtual RefCourseSectionEntryType RefCourseSectionEntryType { get; set; }
        public virtual RefCourseSectionExitType RefCourseSectionExitType { get; set; }
        public virtual RefCreditTypeEarned RefCreditTypeEarned { get; set; }
        public virtual RefExitOrWithdrawalStatus RefExitOrWithdrawalStatus { get; set; }
        public virtual RefGradeLevel RefGradeLevelWhenCourseTaken { get; set; }
        public virtual RefPreAndPostTestIndicator RefPreAndPostTestIndicator { get; set; }
        public virtual RefProgressLevel RefProgressLevel { get; set; }
    }
}
