using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefWageCollectionMethod
    {
        public RefWageCollectionMethod()
        {
            ElstaffEmployment = new HashSet<ElstaffEmployment>();
        }

        public int RefWageCollectionMethodId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ElstaffEmployment> ElstaffEmployment { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
