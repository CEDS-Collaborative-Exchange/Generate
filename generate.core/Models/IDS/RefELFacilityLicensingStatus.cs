using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefElfacilityLicensingStatus
    {
        public RefElfacilityLicensingStatus()
        {
            ElfacilityLicensing = new HashSet<ElfacilityLicensing>();
        }

        public int RefElfacilityLicensingStatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ElfacilityLicensing> ElfacilityLicensing { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
