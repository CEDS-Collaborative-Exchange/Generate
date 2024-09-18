using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentParticipantSession
    {
        public AssessmentParticipantSession()
        {
            AssessmentItemResponse = new HashSet<AssessmentItemResponse>();
            AssessmentParticipantSessionAccommodation = new HashSet<AssessmentParticipantSessionAccommodation>();
            AssessmentSessionStaffRole = new HashSet<AssessmentSessionStaffRole>();
        }

        public int AssessmentParticipantSessionId { get; set; }
        public DateTime? ActualStartDateTime { get; set; }
        public DateTime? ActualEndDateTime { get; set; }
        public string TimeAssessed { get; set; }
        public int? RefAssessmentPlatformTypeId { get; set; }
        public string DeliveryDeviceDetails { get; set; }
        public string SecurityIssue { get; set; }
        public int? RefAssessmentSessionSpecialCircumstanceTypeId { get; set; }
        public string SpecialEventDescription { get; set; }
        public int? LocationId { get; set; }
        public int? RefLanguageId { get; set; }
        public int? AssessmentFormSectionId { get; set; }
        public int AssessmentSessionId { get; set; }
        public int? AssessmentRegistrationId { get; set; }
        public string AssessmentParticipantSessionDatabaseName { get; set; }
        public string AssessmentParticipantSessionGuid { get; set; }

        public virtual ICollection<AssessmentItemResponse> AssessmentItemResponse { get; set; }
        public virtual ICollection<AssessmentParticipantSessionAccommodation> AssessmentParticipantSessionAccommodation { get; set; }
        public virtual ICollection<AssessmentSessionStaffRole> AssessmentSessionStaffRole { get; set; }
        public virtual AssessmentFormSection AssessmentFormSection { get; set; }
        public virtual AssessmentRegistration AssessmentRegistration { get; set; }
        public virtual AssessmentSession AssessmentSession { get; set; }
        public virtual Location Location { get; set; }
        public virtual RefAssessmentPlatformType RefAssessmentPlatformType { get; set; }
        public virtual RefAssessmentSessionSpecialCircumstanceType RefAssessmentSessionSpecialCircumstanceType { get; set; }
        public virtual RefLanguage RefLanguage { get; set; }
    }
}
