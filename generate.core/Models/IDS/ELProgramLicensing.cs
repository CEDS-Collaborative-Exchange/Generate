using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElprogramLicensing
    {
        public int ElprogramLicensingId { get; set; }
        public int OrganizationId { get; set; }
        public int? RefElprogramLicenseStatusId { get; set; }
        public DateTime? InitialLicenseDate { get; set; }
        public DateTime? ContinuingLicenseDate { get; set; }
        public bool? LicenseSuspensionStatus { get; set; }
        public bool? LicenseRevocationStatus { get; set; }
        public int? NumberOfFatalities { get; set; }
        public int? NumberOfInjuries { get; set; }
        public int? RefLicenseExemptId { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefElprogramLicenseStatus RefElprogramLicenseStatus { get; set; }
        public virtual RefLicenseExempt RefLicenseExempt { get; set; }
    }
}
