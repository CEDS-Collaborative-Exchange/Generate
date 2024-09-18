using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefFinancialAidApplicationType
    {
        public RefFinancialAidApplicationType()
        {
            FinancialAidApplication = new HashSet<FinancialAidApplication>();
        }

        public int RefFinancialAidApplicationTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<FinancialAidApplication> FinancialAidApplication { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
