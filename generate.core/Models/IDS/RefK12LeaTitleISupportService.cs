using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefK12leaTitleIsupportService
    {
        public RefK12leaTitleIsupportService()
        {
            K12leaTitleIsupportService = new HashSet<K12leaTitleIsupportService>();
        }

        public int RefK12leatitleIsupportServiceId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12leaTitleIsupportService> K12leaTitleIsupportService { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
