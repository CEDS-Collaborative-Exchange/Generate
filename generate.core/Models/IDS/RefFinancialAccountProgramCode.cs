using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefFinancialAccountProgramCode
    {
        public RefFinancialAccountProgramCode()
        {
            FinancialAccount = new HashSet<FinancialAccount>();
        }

        public int RefFinancialAccountProgramCodeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<FinancialAccount> FinancialAccount { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
