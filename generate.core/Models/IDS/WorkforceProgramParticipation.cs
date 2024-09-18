using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class WorkforceProgramParticipation
    {
        public int PersonProgramParticipationId { get; set; }
        public int? RefWfProgramParticipationId { get; set; }
        public int? RefProfessionalTechnicalCredentialTypeId { get; set; }
        public string DiplomaOrCredentialAwardDate { get; set; }

        public virtual PersonProgramParticipation PersonProgramParticipation { get; set; }
        public virtual RefProfessionalTechnicalCredentialType RefProfessionalTechnicalCredentialType { get; set; }
        public virtual RefWfProgramParticipation RefWfProgramParticipation { get; set; }
    }
}
