using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefPdactivityLevel
    {
        public RefPdactivityLevel()
        {
            ProfessionalDevelopmentActivity = new HashSet<ProfessionalDevelopmentActivity>();
        }

        public int RefPdactivityLevelId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ProfessionalDevelopmentActivity> ProfessionalDevelopmentActivity { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
