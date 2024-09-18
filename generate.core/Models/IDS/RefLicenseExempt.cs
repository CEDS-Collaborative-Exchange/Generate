using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefLicenseExempt
    {
        public RefLicenseExempt()
        {
            ElfacilityLicensing = new HashSet<ElfacilityLicensing>();
            ElprogramLicensing = new HashSet<ElprogramLicensing>();
        }

        public int RefLicenseExemptId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ElfacilityLicensing> ElfacilityLicensing { get; set; }
        public virtual ICollection<ElprogramLicensing> ElprogramLicensing { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
