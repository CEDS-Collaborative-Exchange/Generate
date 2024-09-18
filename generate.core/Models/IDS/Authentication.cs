using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Authentication
    {
        public int AuthenticationId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public string IdentityProviderName { get; set; }
        public string IdentityProviderUri { get; set; }
        public string LoginIdentifier { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
    }
}
