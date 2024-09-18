using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12organizationStudentResponsibility
    {
        public int K12organizationStudentResponsibilityId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public int RefK12responsibilityTypeId { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefK12responsibilityType RefK12responsibilityType { get; set; }
    }
}
