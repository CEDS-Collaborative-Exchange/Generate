using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefProfessionalDevelopmentFinancialSupport
    {
        public RefProfessionalDevelopmentFinancialSupport()
        {
            ProfessionalDevelopmentActivity = new HashSet<ProfessionalDevelopmentActivity>();
            StaffProfessionalDevelopmentActivity = new HashSet<StaffProfessionalDevelopmentActivity>();
        }

        public int RefProfessionalDevelopmentFinancialSupportId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ProfessionalDevelopmentActivity> ProfessionalDevelopmentActivity { get; set; }
        public virtual ICollection<StaffProfessionalDevelopmentActivity> StaffProfessionalDevelopmentActivity { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
