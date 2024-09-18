using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElchildServicesApplication
    {
        public int OrganizationPersonRoleId { get; set; }
        public string ElapplicationIdentifier { get; set; }
        public DateTime? ApplicationDate { get; set; }
        public string ElenrollmentApplicationDocumentIdentifier { get; set; }
        public string ElenrollmentApplicationDocumentName { get; set; }
        public string ElenrollmentApplicationDocumentType { get; set; }
        public bool? ElapplicationRequiredDocument { get; set; }
        public DateTime? ElenrollmentApplicationVerificationDate { get; set; }
        public string ElenrollmentApplicationVerificationReasonType { get; set; }
        public string SitePreferenceRank { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
    }
}
