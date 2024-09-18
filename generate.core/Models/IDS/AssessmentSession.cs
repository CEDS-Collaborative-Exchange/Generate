using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentSession
    {
        public AssessmentSession()
        {
            AssessmentParticipantSession = new HashSet<AssessmentParticipantSession>();
            AssessmentSessionStaffRole = new HashSet<AssessmentSessionStaffRole>();
        }

        public int AssessmentSessionId { get; set; }
        public int? AssessmentAdministrationId { get; set; }
        public DateTime? ScheduledStartDateTime { get; set; }
        public DateTime? ScheduledEndDateTime { get; set; }
        public DateTime? ActualStartDateTime { get; set; }
        public DateTime? ActualEndDateTime { get; set; }
        public TimeSpan? AllottedTime { get; set; }
        public int? RefAssessmentSessionTypeId { get; set; }
        public string SecurityIssue { get; set; }
        public int? RefAssessmentSessionSpecialCircumstanceTypeId { get; set; }
        public string SpecialEventDescription { get; set; }
        public string Location { get; set; }
        public int? OrganizationId { get; set; }
        public int? LeaOrganizationId { get; set; }
        public int? SchoolOrganizationId { get; set; }

        public virtual ICollection<AssessmentParticipantSession> AssessmentParticipantSession { get; set; }
        public virtual ICollection<AssessmentSessionStaffRole> AssessmentSessionStaffRole { get; set; }
        public virtual AssessmentAdministration AssessmentAdministration { get; set; }
        public virtual Organization LeaOrganization { get; set; }
        public virtual Organization Organization { get; set; }
        public virtual RefAssessmentSessionSpecialCircumstanceType RefAssessmentSessionSpecialCircumstanceType { get; set; }
        public virtual RefAssessmentSessionType RefAssessmentSessionType { get; set; }
        public virtual Organization SchoolOrganization { get; set; }
    }
}
