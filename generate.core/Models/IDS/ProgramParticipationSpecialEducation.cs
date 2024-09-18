using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ProgramParticipationSpecialEducation
    {
        public int PersonProgramParticipationId { get; set; }
        public bool? AwaitingInitialIdeaevaluationStatus { get; set; }
        public int? RefIdeaeducationalEnvironmentEcid { get; set; }
        public int? RefIdeaedEnvironmentSchoolAgeId { get; set; }
        public decimal? SpecialEducationFte { get; set; }
        public int? RefSpecialEducationExitReasonId { get; set; }
        public DateTime? SpecialEducationServicesExitDate { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public int ProgramParticipationSpecialEducationId { get; set; }

        public virtual PersonProgramParticipation PersonProgramParticipation { get; set; }
        public virtual RefIdeaeducationalEnvironmentSchoolAge RefIdeaedEnvironmentSchoolAge { get; set; }
        public virtual RefIdeaeducationalEnvironmentEc RefIdeaeducationalEnvironmentEc { get; set; }
        public virtual RefSpecialEducationExitReason RefSpecialEducationExitReason { get; set; }
    }
}
