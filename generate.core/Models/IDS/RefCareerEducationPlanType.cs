using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCareerEducationPlanType
    {
        public RefCareerEducationPlanType()
        {
            PersonCareerEducationPlan = new HashSet<PersonCareerEducationPlan>();
        }

        public int RefCareerEducationPlanTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonCareerEducationPlan> PersonCareerEducationPlan { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
