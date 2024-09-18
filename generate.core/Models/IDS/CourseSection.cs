using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class CourseSection
    {
        public CourseSection()
        {
            AssessmentRegistration = new HashSet<AssessmentRegistration>();
            CourseSectionAssessmentReporting = new HashSet<CourseSectionAssessmentReporting>();
            CourseSectionLocation = new HashSet<CourseSectionLocation>();
            CourseSectionSchedule = new HashSet<CourseSectionSchedule>();
            LearnerActivity = new HashSet<LearnerActivity>();
        }

        public int OrganizationId { get; set; }
        public decimal? AvailableCarnegieUnitCredit { get; set; }
        public int? RefCourseSectionDeliveryModeId { get; set; }
        public int? RefSingleSexClassStatusId { get; set; }
        public decimal? TimeRequiredForCompletion { get; set; }
        public int CourseId { get; set; }
        public int? RefAdditionalCreditTypeId { get; set; }
        public int? RefInstructionLanguageId { get; set; }
        public bool? VirtualIndicator { get; set; }
        public int? OrganizationCalendarSessionId { get; set; }
        public int? RefCreditTypeEarnedId { get; set; }
        public string RelatedLearningStandards { get; set; }
        public int? RefAdvancedPlacementCourseCodeId { get; set; }
        public int? MaximumCapacity { get; set; }

        public virtual ICollection<AssessmentRegistration> AssessmentRegistration { get; set; }
        public virtual ICollection<CourseSectionAssessmentReporting> CourseSectionAssessmentReporting { get; set; }
        public virtual ICollection<CourseSectionLocation> CourseSectionLocation { get; set; }
        public virtual ICollection<CourseSectionSchedule> CourseSectionSchedule { get; set; }
        public virtual ICollection<LearnerActivity> LearnerActivity { get; set; }
        public virtual PsSection PsSection { get; set; }
        public virtual Course Course { get; set; }
        public virtual OrganizationCalendarSession OrganizationCalendarSession { get; set; }
        public virtual Organization Organization { get; set; }
        public virtual RefAdvancedPlacementCourseCode RefAdvancedPlacementCourseCode { get; set; }
        public virtual RefCourseSectionDeliveryMode RefCourseSectionDeliveryMode { get; set; }
        public virtual RefCreditTypeEarned RefCreditTypeEarned { get; set; }
        public virtual RefLanguage RefInstructionLanguage { get; set; }
        public virtual RefSingleSexClassStatus RefSingleSexClassStatus { get; set; }
    }
}
