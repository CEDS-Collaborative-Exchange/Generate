using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElfacilityLicensing
    {
        public int ElfacilityLicensingId { get; set; }
        public int OrganizationId { get; set; }
        public int? RefElfacilityLicensingStatusId { get; set; }
        public int? StateLicensedFacilityCapacity { get; set; }
        public DateTime? InitialLicensingDate { get; set; }
        public DateTime? ContinuingLicenseDate { get; set; }
        public int? RefLicenseExemptId { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefElfacilityLicensingStatus RefElfacilityLicensingStatus { get; set; }
        public virtual RefLicenseExempt RefLicenseExempt { get; set; }
    }
}
