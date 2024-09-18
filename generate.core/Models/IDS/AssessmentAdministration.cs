using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentAdministration
    {
        public AssessmentAdministration()
        {
            AssessmentAdministrationOrganization = new HashSet<AssessmentAdministrationOrganization>();
            AssessmentAssessmentAdministration = new HashSet<AssessmentAssessmentAdministration>();
            AssessmentRegistration = new HashSet<AssessmentRegistration>();
            AssessmentSession = new HashSet<AssessmentSession>();
        }

        public int AssessmentAdministrationId { get; set; }
        public int? AssessmentId { get; set; }
        public string Name { get; set; }
        public string Code { get; set; }
        public DateTime? StartDate { get; set; }
        public TimeSpan? StartTime { get; set; }
        public DateTime? FinishDate { get; set; }
        public TimeSpan? FinishTime { get; set; }
        public int? RefAssessmentReportingMethodId { get; set; }
        public bool? AssessmentSecureIndicator { get; set; }
        public string AssessmentAdministrationPeriodDescription { get; set; }

        public virtual ICollection<AssessmentAdministrationOrganization> AssessmentAdministrationOrganization { get; set; }
        public virtual ICollection<AssessmentAssessmentAdministration> AssessmentAssessmentAdministration { get; set; }
        public virtual ICollection<AssessmentRegistration> AssessmentRegistration { get; set; }
        public virtual ICollection<AssessmentSession> AssessmentSession { get; set; }
        public virtual RefAssessmentReportingMethod RefAssessmentReportingMethod { get; set; }
    }
}
