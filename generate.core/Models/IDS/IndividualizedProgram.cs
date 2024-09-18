using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class IndividualizedProgram
    {
        public IndividualizedProgram()
        {
            ElchildIndividualizedProgram = new HashSet<ElchildIndividualizedProgram>();
            ElchildTransitionPlan = new HashSet<ElchildTransitionPlan>();
        }

        public int IndividualizedProgramId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public int? RefIndividualizedProgramDateType { get; set; }
        public DateTime? IndividualizedProgramDate { get; set; }
        public int? NonInclusionMinutesPerWeek { get; set; }
        public int? InclusionMinutesPerWeek { get; set; }
        public int? RefIndividualizedProgramTransitionTypeId { get; set; }
        public int? RefIndividualizedProgramTypeId { get; set; }
        public DateTime? ServicePlanDate { get; set; }
        public int? RefIndividualizedProgramLocationId { get; set; }
        public string ServicePlanMeetingParticipants { get; set; }
        public string ServicePlanSignedBy { get; set; }
        public DateTime? ServicePlanSignatureDate { get; set; }
        public DateTime? ServicePlanReevaluationDate { get; set; }
        public int? RefStudentSupportServiceTypeId { get; set; }

        public virtual ICollection<ElchildIndividualizedProgram> ElchildIndividualizedProgram { get; set; }
        public virtual ICollection<ElchildTransitionPlan> ElchildTransitionPlan { get; set; }
        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefIndividualizedProgramDateType RefIndividualizedProgramDateTypeNavigation { get; set; }
        public virtual RefIndividualizedProgramLocation RefIndividualizedProgramLocation { get; set; }
        public virtual RefIndividualizedProgramTransitionType RefIndividualizedProgramTransitionType { get; set; }
        public virtual RefIndividualizedProgramType RefIndividualizedProgramType { get; set; }
        public virtual RefStudentSupportServiceType RefStudentSupportServiceType { get; set; }
    }
}
