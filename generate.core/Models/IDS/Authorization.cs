using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Authorization
    {
        public int AuthorizationId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public int? ApplicationId { get; set; }
        public string ApplicationRoleName { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }

        public virtual Application Application { get; set; }
        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
    }
}
