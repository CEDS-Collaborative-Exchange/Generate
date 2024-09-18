using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonCareerEducationPlan
    {
        public int PersonCareerEducationPlanId { get; set; }
        public int PersonId { get; set; }
        public DateTime? LastUpdated { get; set; }
        public int? RefCareerEducationPlanTypeId { get; set; }
        public bool? ProfessionalDevelopmentPlanApprovedBySupervisor { get; set; }
        public DateTime? ProfessionalDevelopmentPlanCompletion { get; set; }
        public bool? TuitionFunded { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefCareerEducationPlanType RefCareerEducationPlanType { get; set; }
    }
}
