using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefFinancialAidAwardType
    {
        public RefFinancialAidAwardType()
        {
            FinancialAidAward = new HashSet<FinancialAidAward>();
        }

        public int RefFinancialAidAwardTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<FinancialAidAward> FinancialAidAward { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
