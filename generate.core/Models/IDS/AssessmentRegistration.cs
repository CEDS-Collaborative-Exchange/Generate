using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentRegistration
    {
        public AssessmentRegistration()
        {
            AssessmentParticipantSession = new HashSet<AssessmentParticipantSession>();
            AssessmentRegistrationAccommodation = new HashSet<AssessmentRegistrationAccommodation>();
            AssessmentResult = new HashSet<AssessmentResult>();
            LearnerActivity = new HashSet<LearnerActivity>();
        }

        public int AssessmentRegistrationId { get; set; }
        public DateTime? CreationDate { get; set; }
        public int? DaysOfInstructionPriorToAssessment { get; set; }
        public DateTime? ScorePublishDate { get; set; }
        public string TestAttemptIdentifier { get; set; }
        public bool? RetestIndicator { get; set; }
        public int? CourseSectionId { get; set; }
        public int? RefAssessmentParticipationIndicatorId { get; set; }
        public string TestingIndicator { get; set; }
        public int? RefAssessmentPurposeId { get; set; }
        public int? RefAssessmentReasonNotTestedId { get; set; }
        public int? RefAssessmentReasonNotCompletingId { get; set; }
        public int? RefGradeLevelToBeAssessedId { get; set; }
        public int? RefGradeLevelWhenAssessedId { get; set; }
        public int PersonId { get; set; }
        public int AssessmentFormId { get; set; }
        public int? OrganizationId { get; set; }
        public int? SchoolOrganizationId { get; set; }
        public int? LeaOrganizationId { get; set; }
        public int? AssessmentAdministrationId { get; set; }
        public int? AssignedByPersonId { get; set; }
        public DateTime? AssessmentRegistrationCompletionStatusDateTime { get; set; }
        public int? RefAssessmentRegistrationCompletionStatusId { get; set; }
        public bool? StateFullAcademicYear { get; set; }
        public bool? LeafullAcademicYear { get; set; }
        public bool? SchoolFullAcademicYear { get; set; }

        public virtual ICollection<AssessmentParticipantSession> AssessmentParticipantSession { get; set; }
        public virtual ICollection<AssessmentRegistrationAccommodation> AssessmentRegistrationAccommodation { get; set; }
        public virtual ICollection<AssessmentResult> AssessmentResult { get; set; }
        public virtual ICollection<LearnerActivity> LearnerActivity { get; set; }
        public virtual AssessmentAdministration AssessmentAdministration { get; set; }
        public virtual AssessmentForm AssessmentForm { get; set; }
        public virtual Person AssignedByPerson { get; set; }
        public virtual CourseSection CourseSection { get; set; }
        public virtual Organization LeaOrganization { get; set; }
        public virtual Organization Organization { get; set; }
        public virtual Person Person { get; set; }
        public virtual RefAssessmentParticipationIndicator RefAssessmentParticipationIndicator { get; set; }
        public virtual RefAssessmentPurpose RefAssessmentPurpose { get; set; }
        public virtual RefAssessmentReasonNotCompleting RefAssessmentReasonNotCompleting { get; set; }
        public virtual RefAssessmentReasonNotTested RefAssessmentReasonNotTested { get; set; }
        public virtual RefAssessmentRegistrationCompletionStatus RefAssessmentRegistrationCompletionStatus { get; set; }
        public virtual RefGradeLevel RefGradeLevelToBeAssessed { get; set; }
        public virtual RefGradeLevel RefGradeLevelWhenAssessed { get; set; }
        public virtual Organization SchoolOrganization { get; set; }
    }
}
