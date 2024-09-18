using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElorganizationFunds
    {
        public int OrganizationId { get; set; }
        public int? RefElfederalFundingTypeId { get; set; }
        public int? RefEllocalRevenueSourceId { get; set; }
        public int? RefElotherFederalFundingSourcesId { get; set; }
        public int? RefElstateRevenueSourceId { get; set; }
        public int? RefBillableBasisTypeId { get; set; }
        public int? RefReimbursementTypeId { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefBillableBasisType RefBillableBasisType { get; set; }
        public virtual RefElfederalFundingType RefElfederalFundingType { get; set; }
        public virtual RefEllocalRevenueSource RefEllocalRevenueSource { get; set; }
        public virtual RefElotherFederalFundingSources RefElotherFederalFundingSources { get; set; }
        public virtual RefElstateRevenueSource RefElstateRevenueSource { get; set; }
        public virtual RefReimbursementType RefReimbursementType { get; set; }
    }
}
