using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefLeaFundsTransferType
    {
        public RefLeaFundsTransferType()
        {          
            K12FederalFundAllocation = new HashSet<K12FederalFundAllocation>();
        }

        public int RefLeaFundsTransferTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }
        public virtual ICollection<K12FederalFundAllocation> K12FederalFundAllocation { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
