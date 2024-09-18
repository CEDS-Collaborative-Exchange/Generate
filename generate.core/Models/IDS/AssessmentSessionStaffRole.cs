using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentSessionStaffRole
    {
        public int AssessmentSessionStaffRoleId { get; set; }
        public int? RefAssessmentSessionStaffRoleTypeId { get; set; }
        public int PersonId { get; set; }
        public int? AssessmentSessionId { get; set; }
        public int? AssessmentParticipantSessionId { get; set; }

        public virtual AssessmentParticipantSession AssessmentParticipantSession { get; set; }
        public virtual AssessmentSession AssessmentSession { get; set; }
        public virtual Person Person { get; set; }
        public virtual RefAssessmentSessionStaffRoleType RefAssessmentSessionStaffRoleType { get; set; }
    }
}
