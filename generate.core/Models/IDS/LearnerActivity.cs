using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class LearnerActivity
    {
        public LearnerActivity()
        {
            LearnerActivityLearningResource = new HashSet<LearnerActivityLearningResource>();
        }

        public int LearnerActivityId { get; set; }
        public int PersonId { get; set; }
        public int? AssessmentRegistrationId { get; set; }
        public int? CourseSectionId { get; set; }
        public int? OrganizationCalendarSessionId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Prerequisite { get; set; }
        public int? RefLearnerActivityTypeId { get; set; }
        public string RubricUrl { get; set; }
        public DateTime? CreationDate { get; set; }
        public decimal? MaximumTimeAllowed { get; set; }
        public int? RefLearnerActivityMaximumTimeAllowedUnitsId { get; set; }
        public DateTime? DueDate { get; set; }
        public TimeSpan? DueTime { get; set; }
        public decimal? MaximumAttemptsAllowed { get; set; }
        public int? RefLearnerActivityAddToGradeBookFlagId { get; set; }
        public DateTime? ReleaseDate { get; set; }
        public decimal? Weight { get; set; }
        public decimal? PossiblePoints { get; set; }
        public int? RefLanguageId { get; set; }
        public int? AssignedByPersonId { get; set; }
        public int? SchoolOrganizationId { get; set; }
        public int? LeaOrganizationId { get; set; }

        public virtual ICollection<LearnerActivityLearningResource> LearnerActivityLearningResource { get; set; }
        public virtual AssessmentRegistration AssessmentRegistration { get; set; }
        public virtual Person AssignedByPerson { get; set; }
        public virtual CourseSection CourseSection { get; set; }
        public virtual Organization LeaOrganization { get; set; }
        public virtual OrganizationCalendarSession OrganizationCalendarSession { get; set; }
        public virtual Person Person { get; set; }
        public virtual RefLearnerActivityMaximumTimeAllowedUnits RefLearnerActivityMaximumTimeAllowedUnits { get; set; }
        public virtual RefLearnerActivityType RefLearnerActivityType { get; set; }
        public virtual Organization SchoolOrganization { get; set; }
    }
}
