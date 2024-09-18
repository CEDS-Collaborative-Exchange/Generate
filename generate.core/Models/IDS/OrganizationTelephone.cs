using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationTelephone
    {
        public int OrganizationTelephoneId { get; set; }
        public int OrganizationId { get; set; }
        public string TelephoneNumber { get; set; }
        public bool PrimaryTelephoneNumberIndicator { get; set; }
        public int? RefInstitutionTelephoneTypeId { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefInstitutionTelephoneType RefInstitutionTelephoneType { get; set; }
    }
}
