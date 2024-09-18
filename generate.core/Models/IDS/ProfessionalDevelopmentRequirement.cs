using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ProfessionalDevelopmentRequirement
    {
        public ProfessionalDevelopmentRequirement()
        {
            ProfessionalDevelopmentActivity = new HashSet<ProfessionalDevelopmentActivity>();
            StaffProfessionalDevelopmentActivity = new HashSet<StaffProfessionalDevelopmentActivity>();
        }

        public int ProfessionalDevelopmentRequirementId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public decimal? RequiredTrainingClockHours { get; set; }
        public int? CompetencySetId { get; set; }

        public virtual ICollection<ProfessionalDevelopmentActivity> ProfessionalDevelopmentActivity { get; set; }
        public virtual ICollection<StaffProfessionalDevelopmentActivity> StaffProfessionalDevelopmentActivity { get; set; }
        public virtual CompetencySet CompetencySet { get; set; }
        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
    }
}
