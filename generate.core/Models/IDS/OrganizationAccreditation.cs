using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationAccreditation
    {
        public int OrganizationAccreditationId { get; set; }
        public int OrganizationId { get; set; }
        public bool? AccreditationStatus { get; set; }
        public int? RefAccreditationAgencyId { get; set; }
        public DateTime? AccreditationAwardDate { get; set; }
        public DateTime? AccreditationExpirationDate { get; set; }
        public DateTime? SeekingAccreditationDate { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefAccreditationAgency RefAccreditationAgency { get; set; }
    }
}
