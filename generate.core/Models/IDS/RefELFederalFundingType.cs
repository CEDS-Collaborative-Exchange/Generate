using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefElfederalFundingType
    {
        public RefElfederalFundingType()
        {
            Elenrollment = new HashSet<Elenrollment>();
            ElorganizationFunds = new HashSet<ElorganizationFunds>();
        }

        public int RefElfederalFundingTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<Elenrollment> Elenrollment { get; set; }
        public virtual ICollection<ElorganizationFunds> ElorganizationFunds { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
