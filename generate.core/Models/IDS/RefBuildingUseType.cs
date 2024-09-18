using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefBuildingUseType
    {
        public RefBuildingUseType()
        {
            Facility = new HashSet<Facility>();
        }

        public int RefBuildingUseTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<Facility> Facility { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
