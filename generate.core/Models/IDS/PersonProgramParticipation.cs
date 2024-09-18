using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonProgramParticipation
    {
        public PersonProgramParticipation()
        {
            ProgramParticipationAe = new HashSet<ProgramParticipationAe>();
            ProgramParticipationCte = new HashSet<ProgramParticipationCte>();
            ProgramParticipationFoodService = new HashSet<ProgramParticipationFoodService>();
            ProgramParticipationMigrant = new HashSet<ProgramParticipationMigrant>();
            ProgramParticipationNeglected = new HashSet<ProgramParticipationNeglected>();
            ProgramParticipationSpecialEducation = new HashSet<ProgramParticipationSpecialEducation>();
            ProgramParticipationTeacherPrep = new HashSet<ProgramParticipationTeacherPrep>();
            ProgramParticipationTitleIiilep = new HashSet<ProgramParticipationTitleIiilep>();
        }

        public int OrganizationPersonRoleId { get; set; }
        public int? RefParticipationTypeId { get; set; }
        public int? RefProgramExitReasonId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public int PersonProgramParticipationId { get; set; }

        public virtual ICollection<ProgramParticipationAe> ProgramParticipationAe { get; set; }
        public virtual ICollection<ProgramParticipationCte> ProgramParticipationCte { get; set; }
        public virtual ICollection<ProgramParticipationFoodService> ProgramParticipationFoodService { get; set; }
        public virtual ICollection<ProgramParticipationMigrant> ProgramParticipationMigrant { get; set; }
        public virtual ICollection<ProgramParticipationNeglected> ProgramParticipationNeglected { get; set; }
        public virtual ICollection<ProgramParticipationSpecialEducation> ProgramParticipationSpecialEducation { get; set; }
        public virtual ICollection<ProgramParticipationTeacherPrep> ProgramParticipationTeacherPrep { get; set; }
        public virtual ProgramParticipationTitleI ProgramParticipationTitleI { get; set; }
        public virtual ICollection<ProgramParticipationTitleIiilep> ProgramParticipationTitleIiilep { get; set; }
        public virtual WorkforceProgramParticipation WorkforceProgramParticipation { get; set; }
        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefParticipationType RefParticipationType { get; set; }
        public virtual RefProgramExitReason RefProgramExitReason { get; set; }
    }
}
