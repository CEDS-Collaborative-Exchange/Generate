using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefWeaponType
    {
        public RefWeaponType()
        {
            Incident = new HashSet<Incident>();
        }

        public int RefWeaponTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<Incident> Incident { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
